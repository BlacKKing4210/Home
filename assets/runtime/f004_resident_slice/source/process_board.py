from __future__ import annotations

import hashlib
import json
from pathlib import Path

from PIL import Image, ImageDraw, ImageFont


ROOT = Path(__file__).resolve().parents[1]
SOURCE = ROOT / "source" / "F004-RESIDENT-SLICE.1-whole-set-board.png"
APPROVED = ROOT / "approved"
QA = ROOT / "qa"

ASSETS = [
    ("resident_house", 0, 0),
    ("road_tile", 1, 0),
    ("wheat_field", 2, 0),
    ("workshop_granary", 0, 1),
    ("loading_yard", 1, 1),
    ("order_truck", 2, 1),
]


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        for chunk in iter(lambda: handle.read(1024 * 1024), b""):
            digest.update(chunk)
    return digest.hexdigest()


def remove_magenta(image: Image.Image) -> Image.Image:
    rgba = image.convert("RGBA")
    pixels = rgba.load()
    for y in range(rgba.height):
        for x in range(rgba.width):
            red, green, blue, old_alpha = pixels[x, y]
            if old_alpha == 0:
                continue
            magenta_dominant = (
                red >= 90
                and blue >= 90
                and red > green * 1.25 + 20
                and blue > green * 1.25 + 20
            )
            if magenta_dominant:
                pixels[x, y] = (0, 0, 0, 0)
                continue
            distance = ((255 - red) ** 2 + green**2 + (255 - blue) ** 2) ** 0.5
            if red > 165 and blue > 165 and green < 150:
                if distance <= 34:
                    pixels[x, y] = (0, 0, 0, 0)
                    continue
                if distance < 118:
                    alpha = max(0.0, min(1.0, (distance - 34.0) / 84.0))
                    if alpha <= 0.02:
                        pixels[x, y] = (0, 0, 0, 0)
                        continue
                    foreground_red = int(max(0, min(255, (red - (1.0 - alpha) * 255) / alpha)))
                    foreground_green = int(max(0, min(255, green / alpha)))
                    foreground_blue = int(max(0, min(255, (blue - (1.0 - alpha) * 255) / alpha)))
                    pixels[x, y] = (
                        foreground_red,
                        foreground_green,
                        foreground_blue,
                        int(old_alpha * alpha),
                    )
    return rgba


def keep_largest_component(image: Image.Image) -> Image.Image:
    alpha = image.getchannel("A")
    width, height = image.size
    source = alpha.load()
    visited = bytearray(width * height)
    components: list[list[tuple[int, int]]] = []
    for y in range(height):
        for x in range(width):
            index = y * width + x
            if visited[index] or source[x, y] <= 8:
                continue
            stack = [(x, y)]
            visited[index] = 1
            component: list[tuple[int, int]] = []
            while stack:
                current_x, current_y = stack.pop()
                component.append((current_x, current_y))
                for offset_y in (-1, 0, 1):
                    for offset_x in (-1, 0, 1):
                        if offset_x == 0 and offset_y == 0:
                            continue
                        next_x = current_x + offset_x
                        next_y = current_y + offset_y
                        if next_x < 0 or next_x >= width or next_y < 0 or next_y >= height:
                            continue
                        next_index = next_y * width + next_x
                        if visited[next_index] or source[next_x, next_y] <= 8:
                            continue
                        visited[next_index] = 1
                        stack.append((next_x, next_y))
            components.append(component)
    if not components:
        raise RuntimeError("asset cell has no visible component")
    largest = max(components, key=len)
    keep = set(largest)
    output = image.copy()
    pixels = output.load()
    for y in range(height):
        for x in range(width):
            if (x, y) not in keep:
                red, green, blue, _ = pixels[x, y]
                pixels[x, y] = (red, green, blue, 0)
    return output


def tight_crop(image: Image.Image, margin: int = 14) -> Image.Image:
    alpha = image.getchannel("A")
    bounds = alpha.getbbox()
    if bounds is None:
        raise RuntimeError("asset cell became fully transparent")
    left = max(0, bounds[0] - margin)
    top = max(0, bounds[1] - margin)
    right = min(image.width, bounds[2] + margin)
    bottom = min(image.height, bounds[3] + margin)
    return image.crop((left, top, right, bottom))


def paste_contain(canvas: Image.Image, image: Image.Image, box: tuple[int, int, int, int]) -> None:
    left, top, right, bottom = box
    max_width = right - left
    max_height = bottom - top
    scale = min(max_width / image.width, max_height / image.height)
    size = (max(1, int(image.width * scale)), max(1, int(image.height * scale)))
    resized = image.resize(size, Image.Resampling.LANCZOS)
    x = left + (max_width - size[0]) // 2
    y = top + (max_height - size[1]) // 2
    canvas.alpha_composite(resized, (x, y))


def main() -> None:
    APPROVED.mkdir(parents=True, exist_ok=True)
    QA.mkdir(parents=True, exist_ok=True)
    board = Image.open(SOURCE).convert("RGBA")
    if board.size != (1536, 1024):
        raise RuntimeError(f"expected 1536x1024 board, got {board.size}")

    cell_width = board.width // 3
    cell_height = board.height // 2
    manifest_assets = []
    processed = []
    for asset_id, column, row in ASSETS:
        cell = board.crop(
            (
                column * cell_width,
                row * cell_height,
                (column + 1) * cell_width,
                (row + 1) * cell_height,
            )
        )
        cleaned = tight_crop(keep_largest_component(remove_magenta(cell)))
        output = APPROVED / f"{asset_id}.png"
        cleaned.save(output, optimize=True)
        processed.append((asset_id, cleaned))
        manifest_assets.append(
            {
                "id": asset_id,
                "path": output.relative_to(ROOT.parent.parent.parent).as_posix(),
                "source_cell": {"column": column + 1, "row": row + 1},
                "width": cleaned.width,
                "height": cleaned.height,
                "sha256": sha256(output),
                "runtime_approved": True,
            }
        )

    qa = Image.new("RGBA", (1200, 840), (244, 238, 214, 255))
    draw = ImageDraw.Draw(qa)
    font = ImageFont.load_default()
    draw.text((28, 20), "F004-RESIDENT-SLICE.1 / ASSET_SET_APPROVED", fill=(36, 67, 76, 255), font=font)
    for index, (asset_id, image) in enumerate(processed):
        column = index % 3
        row = index // 3
        left = 24 + column * 392
        top = 62 + row * 378
        for checker_y in range(top, top + 320, 24):
            for checker_x in range(left, left + 360, 24):
                color = (232, 232, 226, 255) if ((checker_x // 24) + (checker_y // 24)) % 2 == 0 else (207, 214, 207, 255)
                draw.rectangle((checker_x, checker_y, checker_x + 23, checker_y + 23), fill=color)
        paste_contain(qa, image, (left + 10, top + 10, left + 350, top + 302))
        draw.rounded_rectangle((left, top, left + 360, top + 320), radius=12, outline=(36, 67, 76, 255), width=3)
        draw.text((left + 8, top + 330), asset_id, fill=(36, 67, 76, 255), font=font)
    qa_path = QA / "F004-RESIDENT-SLICE.1-approved-alpha-board.png"
    qa.save(qa_path, optimize=True)

    manifest = {
        "schema_version": 1,
        "asset_set": "F004-RESIDENT-SLICE.1",
        "status": "ASSET_SET_APPROVED",
        "source_board": {
            "path": SOURCE.relative_to(ROOT.parent.parent.parent).as_posix(),
            "width": board.width,
            "height": board.height,
            "sha256": sha256(SOURCE),
            "grid": "3x2",
        },
        "approved_assets": manifest_assets,
        "shared_project_asset": {
            "id": "resident_rabbit",
            "path": "assets/runtime/f003_farm2/animals/animal_rabbit_v1.png",
            "provenance": "project-owned accepted F003 runtime asset",
        },
        "qa_board": {
            "path": qa_path.relative_to(ROOT.parent.parent.parent).as_posix(),
            "sha256": sha256(qa_path),
        },
        "runtime_rule": "Only approved assets and the registered project-owned rabbit may be loaded by the F004 slice.",
    }
    (ROOT / "runtime-manifest.json").write_text(
        json.dumps(manifest, ensure_ascii=False, indent=2) + "\n",
        encoding="utf-8",
    )


if __name__ == "__main__":
    main()
