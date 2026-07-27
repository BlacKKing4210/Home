from __future__ import annotations

import argparse
import hashlib
import json
import math
import shutil
from collections import deque
from pathlib import Path

from PIL import Image, ImageDraw, ImageFont


ROOT = Path(__file__).resolve().parents[1]
RAW_SOURCE = ROOT / "source" / "F004-RESIDENT-SLICE.2-whole-set-board-raw.png"
SOURCE = ROOT / "source" / "F004-RESIDENT-SLICE.2-whole-set-board.png"
CANDIDATES = ROOT / "qa" / "candidates"
APPROVED = ROOT / "approved"
QA = ROOT / "qa"

ASSETS = [
    {
        "id": "resident_house_b",
        "column": 0,
        "row": 0,
        "logical_footprint": [2, 2],
        "pivot": [0.5, 0.93],
        "entrance_offset": [1, 2],
        "workpoint_offsets": [[1, 2]],
        "runtime_role": "resident-home",
    },
    {
        "id": "dairy_pasture",
        "column": 1,
        "row": 0,
        "logical_footprint": [3, 3],
        "pivot": [0.5, 0.93],
        "entrance_offset": [0, 3],
        "workpoint_offsets": [[0, 2], [1, 1], [2, 1]],
        "runtime_role": "dairy-pasture",
    },
    {
        "id": "creamery",
        "column": 2,
        "row": 0,
        "logical_footprint": [2, 2],
        "pivot": [0.5, 0.93],
        "entrance_offset": [1, 2],
        "workpoint_offsets": [[0, 1], [1, 1], [1, 2]],
        "runtime_role": "dairy-processing",
    },
    {
        "id": "road_life_tile",
        "column": 3,
        "row": 0,
        "logical_footprint": [1, 1],
        "pivot": [0.5, 0.72],
        "entrance_offset": [0, 0],
        "workpoint_offsets": [[1, 0]],
        "runtime_role": "road-life-point",
    },
    {
        "id": "dairy_order_truck",
        "column": 0,
        "row": 1,
        "logical_footprint": None,
        "pivot": [0.5, 0.86],
        "entrance_offset": None,
        "workpoint_offsets": [[-1, 0]],
        "runtime_role": "world-order-vehicle",
    },
    {
        "id": "dairy_goods_set",
        "column": 1,
        "row": 1,
        "logical_footprint": None,
        "pivot": [0.5, 0.90],
        "entrance_offset": None,
        "workpoint_offsets": [],
        "runtime_role": "carried-and-loaded-goods",
    },
    {
        "id": "resident_bear_dairy",
        "column": 2,
        "row": 1,
        "logical_footprint": None,
        "pivot": [0.5, 0.96],
        "entrance_offset": None,
        "workpoint_offsets": [],
        "runtime_role": "animal-resident",
    },
    {
        "id": "pasture_cow",
        "column": 3,
        "row": 1,
        "logical_footprint": None,
        "pivot": [0.5, 0.92],
        "entrance_offset": None,
        "workpoint_offsets": [],
        "runtime_role": "pasture-animal-not-resident",
    },
]


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        for chunk in iter(lambda: handle.read(1024 * 1024), b""):
            digest.update(chunk)
    return digest.hexdigest()


def is_magenta_background(red: int, green: int, blue: int) -> bool:
    return (
        red >= 125
        and blue >= 125
        and green <= 145
        and red >= green * 1.28 + 20
        and blue >= green * 1.28 + 20
        and abs(red - blue) <= 86
    )


def normalize_board(raw: Image.Image) -> tuple[Image.Image, int]:
    normalized = raw.convert("RGBA")
    pixels = normalized.load()
    changed = 0
    for y in range(normalized.height):
        for x in range(normalized.width):
            red, green, blue, alpha = pixels[x, y]
            if alpha > 0 and is_magenta_background(red, green, blue):
                pixels[x, y] = (255, 0, 255, 255)
                changed += 1
    return normalized, changed


def remove_magenta(image: Image.Image) -> Image.Image:
    rgba = image.convert("RGBA")
    pixels = rgba.load()
    for y in range(rgba.height):
        for x in range(rgba.width):
            red, green, blue, old_alpha = pixels[x, y]
            if old_alpha == 0:
                continue
            if red == 255 and green == 0 and blue == 255:
                pixels[x, y] = (0, 0, 0, 0)
                continue
            distance = ((255 - red) ** 2 + green**2 + (255 - blue) ** 2) ** 0.5
            if red > 160 and blue > 160 and green < 150 and abs(red - blue) < 90:
                if distance <= 46:
                    pixels[x, y] = (0, 0, 0, 0)
                    continue
                if distance < 132:
                    alpha = max(0.0, min(1.0, (distance - 46.0) / 86.0))
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


def keep_significant_components(image: Image.Image) -> tuple[Image.Image, list[int]]:
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
            queue: deque[tuple[int, int]] = deque([(x, y)])
            visited[index] = 1
            component: list[tuple[int, int]] = []
            while queue:
                current_x, current_y = queue.popleft()
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
                        queue.append((next_x, next_y))
            components.append(component)
    if not components:
        raise RuntimeError("asset cell has no visible component")
    sizes = sorted((len(component) for component in components), reverse=True)
    threshold = max(20, int(sizes[0] * 0.0007))
    keep: set[tuple[int, int]] = set()
    for component in components:
        if len(component) >= threshold:
            keep.update(component)
    output = image.copy()
    pixels = output.load()
    for y in range(height):
        for x in range(width):
            if (x, y) not in keep:
                red, green, blue, _ = pixels[x, y]
                pixels[x, y] = (red, green, blue, 0)
    return output, sizes


def tight_crop(image: Image.Image, margin: int = 16) -> Image.Image:
    bounds = image.getchannel("A").getbbox()
    if bounds is None:
        raise RuntimeError("asset cell became fully transparent")
    left = max(0, bounds[0] - margin)
    top = max(0, bounds[1] - margin)
    right = min(image.width, bounds[2] + margin)
    bottom = min(image.height, bounds[3] + margin)
    return image.crop((left, top, right, bottom))


def analyze_asset(
    image: Image.Image,
    board_bbox: tuple[int, int, int, int],
    component_pixels: int,
    board_gutter_px: float,
) -> dict[str, object]:
    alpha = image.getchannel("A")
    visible = 0
    magenta_contamination = 0
    semitransparent = 0
    for red, green, blue, value in image.get_flattened_data():
        if value <= 8:
            continue
        visible += 1
        if value < 248:
            semitransparent += 1
        if red > 165 and blue > 165 and green < 115 and abs(red - blue) < 90:
            magenta_contamination += 1
    return {
        "visible_pixels": visible,
        "semitransparent_pixels": semitransparent,
        "magenta_contamination_pixels": magenta_contamination,
        "magenta_contamination_ratio": round(magenta_contamination / max(1, visible), 8),
        "source_board_bbox": list(board_bbox),
        "board_gutter_px": round(board_gutter_px, 2),
        "component_pixels": component_pixels,
    }


def extract_asset_components(image: Image.Image) -> list[dict[str, object]]:
    alpha = image.getchannel("A")
    width, height = image.size
    source = alpha.load()
    visited = bytearray(width * height)
    components: list[dict[str, object]] = []
    for y in range(height):
        for x in range(width):
            index = y * width + x
            if visited[index] or source[x, y] <= 8:
                continue
            queue: deque[tuple[int, int]] = deque([(x, y)])
            visited[index] = 1
            count = 0
            min_x = max_x = x
            min_y = max_y = y
            sum_x = 0
            sum_y = 0
            while queue:
                current_x, current_y = queue.popleft()
                count += 1
                sum_x += current_x
                sum_y += current_y
                min_x = min(min_x, current_x)
                min_y = min(min_y, current_y)
                max_x = max(max_x, current_x)
                max_y = max(max_y, current_y)
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
                        queue.append((next_x, next_y))
            if count >= 5000:
                components.append(
                    {
                        "pixels": count,
                        "bbox": (min_x, min_y, max_x + 1, max_y + 1),
                        "centroid": (sum_x / count, sum_y / count),
                    }
                )
    if len(components) != 8:
        raise RuntimeError(f"expected exactly 8 significant board components, got {len(components)}")
    top = sorted(components[:], key=lambda component: component["centroid"][1])[:4]
    bottom = [component for component in components if component not in top]
    ordered = sorted(top, key=lambda component: component["centroid"][0])
    ordered.extend(sorted(bottom, key=lambda component: component["centroid"][0]))
    return ordered


def bbox_gutter(
    target: tuple[int, int, int, int],
    others: list[tuple[int, int, int, int]],
) -> float:
    left, top, right, bottom = target
    distances: list[float] = []
    for other_left, other_top, other_right, other_bottom in others:
        horizontal = max(other_left - right, left - other_right, 0)
        vertical = max(other_top - bottom, top - other_bottom, 0)
        distances.append(math.hypot(horizontal, vertical))
    return min(distances) if distances else float("inf")


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


def build_qa_board(processed: list[tuple[str, Image.Image]], approved: bool) -> Path:
    board = Image.new("RGBA", (1600, 920), (244, 238, 214, 255))
    draw = ImageDraw.Draw(board)
    font = ImageFont.load_default()
    status = "ASSET_SET_APPROVED" if approved else "WHOLE_SET_CANDIDATE / NOT_RUNTIME"
    draw.text((28, 20), f"F004-RESIDENT-SLICE.2 / {status}", fill=(36, 67, 76, 255), font=font)
    for index, (asset_id, image) in enumerate(processed):
        column = index % 4
        row = index // 4
        left = 20 + column * 395
        top = 58 + row * 412
        for checker_y in range(top, top + 350, 22):
            for checker_x in range(left, left + 372, 22):
                color = (
                    (232, 232, 226, 255)
                    if ((checker_x // 22) + (checker_y // 22)) % 2 == 0
                    else (207, 214, 207, 255)
                )
                draw.rectangle(
                    (checker_x, checker_y, checker_x + 21, checker_y + 21),
                    fill=color,
                )
        paste_contain(board, image, (left + 12, top + 10, left + 360, top + 328))
        draw.rounded_rectangle(
            (left, top, left + 372, top + 350),
            radius=12,
            outline=(36, 67, 76, 255),
            width=3,
        )
        draw.text((left + 8, top + 360), asset_id, fill=(36, 67, 76, 255), font=font)
    filename = (
        "F004-RESIDENT-SLICE.2-approved-alpha-board.png"
        if approved
        else "F004-RESIDENT-SLICE.2-candidate-alpha-board.png"
    )
    output = QA / filename
    board.save(output, optimize=True)
    return output


def build_mobile_readability_board(
    processed: list[tuple[str, Image.Image]],
    approved: bool,
) -> Path:
    board = Image.new("RGBA", (1600, 520), (244, 238, 214, 255))
    draw = ImageDraw.Draw(board)
    font = ImageFont.load_default()
    status = "APPROVED" if approved else "CANDIDATE / NOT_RUNTIME"
    draw.text(
        (28, 18),
        f"F004-RESIDENT-SLICE.2 / MOBILE READABILITY / 96px + 64px / {status}",
        fill=(36, 67, 76, 255),
        font=font,
    )
    for index, (asset_id, image) in enumerate(processed):
        column = index % 4
        row = index // 4
        left = 20 + column * 395
        top = 56 + row * 226
        draw.rounded_rectangle(
            (left, top, left + 372, top + 194),
            radius=12,
            fill=(226, 225, 211, 255),
            outline=(36, 67, 76, 255),
            width=3,
        )
        for thumb_index, target in enumerate((96, 64)):
            thumbnail = image.copy()
            thumbnail.thumbnail((target, target), Image.Resampling.LANCZOS)
            center_x = left + (110 if thumb_index == 0 else 258)
            x = center_x - thumbnail.width // 2
            y = top + 78 - thumbnail.height // 2
            board.alpha_composite(thumbnail, (x, y))
            draw.text(
                (center_x - 12, top + 142),
                f"{target}px",
                fill=(36, 67, 76, 255),
                font=font,
            )
        draw.text((left + 8, top + 170), asset_id, fill=(36, 67, 76, 255), font=font)
    filename = (
        "F004-RESIDENT-SLICE.2-approved-mobile-readability.png"
        if approved
        else "F004-RESIDENT-SLICE.2-candidate-mobile-readability.png"
    )
    output = QA / filename
    board.save(output, optimize=True)
    return output


def process_candidate() -> dict[str, object]:
    CANDIDATES.mkdir(parents=True, exist_ok=True)
    APPROVED.mkdir(parents=True, exist_ok=True)
    QA.mkdir(parents=True, exist_ok=True)
    if not RAW_SOURCE.exists():
        if not SOURCE.exists():
            raise FileNotFoundError(SOURCE)
        shutil.copy2(SOURCE, RAW_SOURCE)
    raw = Image.open(RAW_SOURCE).convert("RGBA")
    if raw.width < 1600 or raw.height < 800:
        raise RuntimeError(f"board resolution too small: {raw.size}")
    normalized, normalized_pixels = normalize_board(raw)
    normalized.save(SOURCE, optimize=True)

    cleaned_board = remove_magenta(normalized)
    components = extract_asset_components(cleaned_board)
    processed: list[tuple[str, Image.Image]] = []
    candidates: list[dict[str, object]] = []

    for definition, component in zip(ASSETS, components, strict=True):
        column = definition["column"]
        row = definition["row"]
        left, top, right, bottom = component["bbox"]
        margin = 16
        crop_box = (
            max(0, left - margin),
            max(0, top - margin),
            min(cleaned_board.width, right + margin),
            min(cleaned_board.height, bottom + margin),
        )
        cleaned = cleaned_board.crop(crop_box)
        other_bboxes = [
            candidate["bbox"]
            for candidate in components
            if candidate is not component
        ]
        gutter = bbox_gutter(component["bbox"], other_bboxes)
        analysis = analyze_asset(
            cleaned,
            component["bbox"],
            component["pixels"],
            gutter,
        )
        if analysis["board_gutter_px"] < 8:
            raise RuntimeError(f"{definition['id']} crosses or touches a neighboring board asset")
        if analysis["magenta_contamination_ratio"] > 0.0008:
            raise RuntimeError(f"{definition['id']} retains material magenta contamination")
        cropped = tight_crop(cleaned)
        output = CANDIDATES / f"{definition['id']}.png"
        cropped.save(output, optimize=True)
        processed.append((definition["id"], cropped))
        candidates.append(
            {
                "id": definition["id"],
                "path": output.relative_to(ROOT.parents[2]).as_posix(),
                "source_cell": {"column": column + 1, "row": row + 1},
                "width": cropped.width,
                "height": cropped.height,
                "sha256": sha256(output),
                "logical_footprint": definition["logical_footprint"],
                "pivot": definition["pivot"],
                "entrance_offset": definition["entrance_offset"],
                "workpoint_offsets": definition["workpoint_offsets"],
                "runtime_role": definition["runtime_role"],
                "analysis": analysis,
                "approved": False,
                "runtime_allowed": False,
            }
        )

    qa_path = build_qa_board(processed, approved=False)
    mobile_qa_path = build_mobile_readability_board(processed, approved=False)
    manifest = {
        "schema_version": 1,
        "asset_set": "F004-RESIDENT-SLICE.2",
        "status": "WHOLE_SET_CANDIDATE",
        "runtime_allowed": False,
        "source_board": {
            "raw_path": RAW_SOURCE.relative_to(ROOT.parents[2]).as_posix(),
            "raw_sha256": sha256(RAW_SOURCE),
            "path": SOURCE.relative_to(ROOT.parents[2]).as_posix(),
            "sha256": sha256(SOURCE),
            "width": normalized.width,
            "height": normalized.height,
            "grid": "4x2",
            "normalized_background_pixels": normalized_pixels,
        },
        "candidate_assets": candidates,
        "approved_assets": [],
        "qa_board": {
            "path": qa_path.relative_to(ROOT.parents[2]).as_posix(),
            "sha256": sha256(qa_path),
        },
        "mobile_readability_board": {
            "path": mobile_qa_path.relative_to(ROOT.parents[2]).as_posix(),
            "sha256": sha256(mobile_qa_path),
            "target_sizes_px": [96, 64],
        },
        "runtime_rule": (
            "WHOLE_SET_CANDIDATE and qa/candidates are NOT_RUNTIME. "
            "Only files copied into approved after an explicit zero-BLOCKER/MATERIAL review may be loaded."
        ),
    }
    (ROOT / "runtime-manifest.json").write_text(
        json.dumps(manifest, ensure_ascii=False, indent=2) + "\n",
        encoding="utf-8",
    )
    return manifest


def approve_candidate() -> dict[str, object]:
    manifest_path = ROOT / "runtime-manifest.json"
    manifest = json.loads(manifest_path.read_text(encoding="utf-8"))
    if manifest.get("status") != "WHOLE_SET_CANDIDATE":
        raise RuntimeError("candidate manifest is not awaiting approval")
    approved_assets: list[dict[str, object]] = []
    processed: list[tuple[str, Image.Image]] = []
    for candidate in manifest["candidate_assets"]:
        source = ROOT.parents[2] / candidate["path"]
        destination = APPROVED / source.name
        shutil.copy2(source, destination)
        approved = dict(candidate)
        approved["path"] = destination.relative_to(ROOT.parents[2]).as_posix()
        approved["sha256"] = sha256(destination)
        approved["approved"] = True
        approved["runtime_allowed"] = True
        approved_assets.append(approved)
        processed.append((approved["id"], Image.open(destination).convert("RGBA")))
    qa_path = build_qa_board(processed, approved=True)
    mobile_qa_path = build_mobile_readability_board(processed, approved=True)
    manifest["status"] = "ASSET_SET_APPROVED"
    manifest["runtime_allowed"] = True
    manifest["approved_assets"] = approved_assets
    manifest["qa_board"] = {
        "path": qa_path.relative_to(ROOT.parents[2]).as_posix(),
        "sha256": sha256(qa_path),
    }
    manifest["mobile_readability_board"] = {
        "path": mobile_qa_path.relative_to(ROOT.parents[2]).as_posix(),
        "sha256": sha256(mobile_qa_path),
        "target_sizes_px": [96, 64],
    }
    manifest["runtime_rule"] = (
        "Runtime may load only approved_assets with approved=true and runtime_allowed=true. "
        "Raw, source, QA and candidate paths remain NOT_RUNTIME."
    )
    manifest_path.write_text(
        json.dumps(manifest, ensure_ascii=False, indent=2) + "\n",
        encoding="utf-8",
    )
    return manifest


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--approve", action="store_true")
    args = parser.parse_args()
    manifest = approve_candidate() if args.approve else process_candidate()
    print(
        json.dumps(
            {
                "status": manifest["status"],
                "runtime_allowed": manifest["runtime_allowed"],
                "candidate_count": len(manifest["candidate_assets"]),
                "approved_count": len(manifest["approved_assets"]),
                "qa_board": manifest["qa_board"]["path"],
            },
            ensure_ascii=False,
        )
    )


if __name__ == "__main__":
    main()
