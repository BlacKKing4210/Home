#!/usr/bin/env python3
"""Deterministic ART-003 preparation for CityOfAnimals F003-FARM.2."""

from __future__ import annotations

import argparse
import hashlib
import json
from collections import deque
from pathlib import Path

import numpy as np
from PIL import Image, ImageDraw, ImageFont


PROJECT_ROOT = Path(__file__).resolve().parents[4]
ART_ROOT = PROJECT_ROOT / "output" / "art" / "ART-003-FARM2"
REVIEW_DIR = ART_ROOT / "review"
QA_DIR = ART_ROOT / "qa"
CANDIDATE_ROOT = PROJECT_ROOT / "assets" / "candidate" / "f003_farm2"
PREPARED_ROOT = CANDIDATE_ROOT / "prepared"

BOARD_SOURCES = {
    "A": {
        "path": Path(
            r"C:\Users\76398\.codex\generated_images\019f7f4f-493e-7b21-8766-e256e7641e7f"
            r"\exec-46192109-85ab-444c-a0c3-429caa3a3755.png"
        ),
        "sha256": "732DF4218000BE74F142907A9F8B65C26F631616FD8590742001884B7CFF8DD7",
    },
    "B": {
        "path": Path(
            r"C:\Users\76398\.codex\generated_images\019f7f4f-493e-7b21-8766-e256e7641e7f"
            r"\exec-d5ab13cf-72de-47f5-9583-e81660c34b7d.png"
        ),
        "sha256": "031DEFDA240C2609E730376FF55934A02D6142793622A1AFC89F4CC9EE5D30F7",
    },
    "C": {
        "path": Path(
            r"C:\Users\76398\.codex\generated_images\019f7f4f-493e-7b21-8766-e256e7641e7f"
            r"\exec-a6d4c21d-ca91-440b-9187-dc07e6a51403.png"
        ),
        "sha256": "74B4FA06E47191A05F7BDF8AB60F7719AE7F6A45219C0BC3796BFE603A175A84",
    },
    "D": {
        "path": Path(
            r"C:\Users\76398\.codex\generated_images\019f7f4f-493e-7b21-8766-e256e7641e7f"
            r"\exec-b8e58cf6-791c-439c-99bf-86c473a7abc9.png"
        ),
        "sha256": "55268CAF5756F5753B9A5B08DD521EBF0F52251352D2F528B347D13D5B6DF59B",
    },
}

ANIMAL_SOURCES = {
    "animal_chicken_v1": {
        "path": PROJECT_ROOT / "assets/candidate/style_reference/animals/chicken.png",
        "sha256": "C9CE96C9A2051CDF041713F27FD668A34C0593D846B0346E08708A3FE8A3D5FC",
    },
    "animal_cow_v1": {
        "path": PROJECT_ROOT / "assets/candidate/style_reference/animals/cow.png",
        "sha256": "08688726FD23E39DA6BA666B1024657715F3FE95F9D41A8014C55677AF260371",
    },
    "animal_pig_v1": {
        "path": PROJECT_ROOT / "assets/candidate/style_reference/animals/pig.png",
        "sha256": "46C1747CC75527BD5364B5C92718C63FE6044F98D11848135C780C5B011A0AE5",
    },
    "animal_bear_v1": {
        "path": PROJECT_ROOT / "assets/candidate/style_reference/animals/bear.png",
        "sha256": "ACA7D5C74B4E0CBB12BB920413E563B0BCEB191710877FE68252EDE8FBCE4778",
    },
    "animal_rabbit_v1": {
        "path": PROJECT_ROOT / "assets/candidate/style_reference/animals/rabbit.png",
        "sha256": "18A95BCBBEAD2C3A6178B0F084FDA97FEA8A7BB22E9BEBF88CB3C4C1BD50F64D",
    },
}

ASSETS = [
    ("R1C1", "plot_wheat_ready_v1", "A", [40, 150, 350, 450]),
    ("R1C2", "plot_clover_ready_v1", "A", [345, 175, 685, 455]),
    ("R1C3", "plot_sunflower_ready_v1", "A", [650, 115, 1055, 475]),
    ("R1C4", "plot_carrot_ready_v1", "A", [1025, 115, 1530, 490]),
    ("R1C5", "orchard_apple_v1", "A", [25, 430, 545, 925]),
    ("R2C1", "plot_tea_bush_v1", "A", [515, 480, 1005, 925]),
    ("R2C2", "building_feedworks_v1", "A", [975, 420, 1530, 935]),
    ("R2C3", "pen_sheep_v1", "B", [40, 115, 470, 495]),
    ("R2C4", "building_chicken_coop_v1", "B", [465, 115, 895, 500]),
    ("R2C5", "pen_pig_v1", "B", [200, 470, 745, 900]),
    ("R3C1", "building_granary_v1", "B", [755, 170, 1520, 865]),
    ("R3C2", "building_dairy_v1", "C", [130, 85, 480, 410]),
    ("R3C3", "building_preserve_v1", "C", [535, 70, 895, 415]),
    ("R3C4", "building_textile_v1", "C", [1010, 35, 1510, 425]),
    ("R3C5", "building_juice_press_v1", "C", [180, 430, 625, 830]),
    ("R4C1", "building_bakery_industrial_v1", "C", [680, 365, 1475, 920]),
    ("R4C2", "building_chicken_coop_v2", "D", [10, 55, 505, 525]),
    ("R4C3", "building_storehouse_v1", "D", [470, 35, 1020, 525]),
    ("R4C4", "building_grainworks_v1", "D", [995, 25, 1530, 535]),
    ("R4C5", "building_bakery_shop_v1", "D", [145, 465, 725, 995]),
    ("R5C1", "building_roadside_market_v1", "D", [710, 460, 1370, 1005]),
    ("R5C2", "animal_chicken_v1", "animal", None),
    ("R5C3", "animal_cow_v1", "animal", None),
    ("R5C4", "animal_pig_v1", "animal", None),
    ("R5C5", "animal_bear_v1", "animal", None),
    ("R6C1", "animal_rabbit_v1", "animal", None),
]


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest().upper()


def font(size: int) -> ImageFont.FreeTypeFont | ImageFont.ImageFont:
    candidates = [
        Path(r"C:\Windows\Fonts\arial.ttf"),
        Path(r"C:\Windows\Fonts\segoeui.ttf"),
    ]
    for candidate in candidates:
        if candidate.exists():
            return ImageFont.truetype(str(candidate), size)
    return ImageFont.load_default()


def verify_sources() -> dict[str, dict]:
    evidence: dict[str, dict] = {}
    for board_id, source in BOARD_SOURCES.items():
        path = source["path"]
        actual_hash = sha256(path)
        if actual_hash != source["sha256"]:
            raise RuntimeError(f"Board {board_id} hash mismatch: {actual_hash}")
        with Image.open(path) as image:
            evidence[board_id] = {
                "path": str(path),
                "sha256": actual_hash,
                "size": list(image.size),
                "mode": image.mode,
            }
    for asset_id, source in ANIMAL_SOURCES.items():
        path = source["path"]
        actual_hash = sha256(path)
        if actual_hash != source["sha256"]:
            raise RuntimeError(f"Animal {asset_id} hash mismatch: {actual_hash}")
        with Image.open(path) as image:
            evidence[asset_id] = {
                "path": path.relative_to(PROJECT_ROOT).as_posix(),
                "sha256": actual_hash,
                "size": list(image.size),
                "mode": image.mode,
            }
    return evidence


def fit_contain(image: Image.Image, width: int, height: int, allow_upscale: bool) -> Image.Image:
    scale = min(width / image.width, height / image.height)
    if not allow_upscale:
        scale = min(scale, 1.0)
    size = (max(1, round(image.width * scale)), max(1, round(image.height * scale)))
    if size == image.size:
        return image.copy()
    return image.resize(size, Image.Resampling.LANCZOS)


def checkerboard(size: tuple[int, int], step: int = 24) -> Image.Image:
    image = Image.new("RGB", size, "#ECE8DE")
    draw = ImageDraw.Draw(image)
    for y in range(0, size[1], step):
        for x in range(0, size[0], step):
            if (x // step + y // step) % 2:
                draw.rectangle((x, y, x + step - 1, y + step - 1), fill="#C8C4BA")
    return image


def source_image(asset_id: str, source_kind: str, crop: list[int] | None) -> Image.Image:
    if source_kind == "animal":
        return Image.open(ANIMAL_SOURCES[asset_id]["path"]).convert("RGBA")
    board = Image.open(BOARD_SOURCES[source_kind]["path"]).convert("RGB")
    assert crop is not None
    return board.crop(tuple(crop)).convert("RGBA")


def keep_central_foreground_component(image: Image.Image) -> Image.Image:
    rgba = image.convert("RGBA")
    alpha = np.asarray(rgba.getchannel("A"), dtype=np.uint8)
    visible = np.argwhere(alpha > 0)
    if not len(visible):
        raise RuntimeError("No visible foreground component")
    center = np.array([alpha.shape[0] / 2.0, alpha.shape[1] / 2.0])
    seed_y, seed_x = visible[np.argmin(np.sum((visible - center) ** 2, axis=1))]
    foreground = alpha > 0
    kept = np.zeros_like(foreground)
    kept[int(seed_y), int(seed_x)] = True
    queue: deque[tuple[int, int]] = deque([(int(seed_y), int(seed_x))])
    height, width = foreground.shape
    while queue:
        y, x = queue.popleft()
        for next_y, next_x in ((y - 1, x), (y + 1, x), (y, x - 1), (y, x + 1)):
            if (
                0 <= next_y < height
                and 0 <= next_x < width
                and foreground[next_y, next_x]
                and not kept[next_y, next_x]
            ):
                kept[next_y, next_x] = True
                queue.append((next_y, next_x))
    output = np.asarray(rgba).copy()
    output[:, :, 3] = np.where(kept, alpha, 0).astype(np.uint8)
    return Image.fromarray(output, "RGBA")


def build_source_board() -> None:
    evidence = verify_sources()
    REVIEW_DIR.mkdir(parents=True, exist_ok=True)
    columns, rows = 5, 6
    cell_w, cell_h = 360, 330
    header_h = 112
    board = Image.new("RGB", (columns * cell_w, header_h + rows * cell_h), "#18292E")
    draw = ImageDraw.Draw(board)
    draw.text((40, 24), "ART-003 F003-FARM.2 SOURCE APPROVAL BOARD", font=font(34), fill="#FFF4D6")
    draw.text(
        (40, 70),
        "26 registered identities | planned split mask preview | labels outside image region",
        font=font(20),
        fill="#B9D7D4",
    )

    cell_records: list[dict] = []
    lookup = {cell: (asset_id, source_kind, crop) for cell, asset_id, source_kind, crop in ASSETS}
    for row in range(rows):
        for col in range(columns):
            cell = f"R{row + 1}C{col + 1}"
            x0 = col * cell_w
            y0 = header_h + row * cell_h
            draw.rectangle((x0 + 5, y0 + 5, x0 + cell_w - 5, y0 + cell_h - 5), fill="#F4F0E4")
            if cell not in lookup:
                draw.text((x0 + 116, y0 + 135), "RESERVED", font=font(19), fill="#8A8174")
                continue
            asset_id, source_kind, crop = lookup[cell]
            source = source_image(asset_id, source_kind, crop)
            if source_kind != "animal":
                source = keep_central_foreground_component(connected_background_alpha(source))
            preview = fit_contain(source, 320, 245, allow_upscale=False)
            matte = checkerboard((320, 245), 20).convert("RGBA")
            px = (320 - preview.width) // 2
            py = (245 - preview.height) // 2
            matte.alpha_composite(preview, (px, py))
            board.paste(matte.convert("RGB"), (x0 + 20, y0 + 20))
            draw.text((x0 + 18, y0 + 276), cell, font=font(18), fill="#7A3E1B")
            draw.text((x0 + 84, y0 + 276), asset_id, font=font(17), fill="#152A30")
            cell_records.append(
                {
                    "cell": cell,
                    "asset_id": asset_id,
                    "source_kind": source_kind,
                    "source_path": evidence[source_kind if source_kind != "animal" else asset_id]["path"],
                    "source_sha256": evidence[source_kind if source_kind != "animal" else asset_id]["sha256"],
                    "crop_xyxy": crop,
                }
            )

    board_path = REVIEW_DIR / "ART-003-FARM2-source-board.png"
    board.save(board_path, optimize=True)
    cell_map = {
        "schema_version": 1,
        "contract": "ART-003-FARM2-001",
        "state": "SOURCE_BOARD_GENERATED_PENDING_VISUAL_APPROVAL",
        "board_path": board_path.relative_to(PROJECT_ROOT).as_posix(),
        "board_sha256": sha256(board_path),
        "board_size": list(board.size),
        "layout": {"columns": columns, "rows": rows, "cell_width": cell_w, "cell_height": cell_h},
        "preview_method": "building planned mask: border_connected_teal_segmentation_v1 + central_component_v1",
        "registered_asset_count": len(cell_records),
        "reserved_cells": ["R6C2", "R6C3", "R6C4", "R6C5"],
        "sources": evidence,
        "cells": cell_records,
    }
    (ART_ROOT / "source-cell-map.json").write_text(
        json.dumps(cell_map, ensure_ascii=False, indent=2) + "\n", encoding="utf-8"
    )
    print(json.dumps({"board": str(board_path), "sha256": cell_map["board_sha256"], "assets": len(cell_records)}))


def connected_background_alpha(image: Image.Image) -> Image.Image:
    rgb = np.asarray(image.convert("RGB"), dtype=np.uint8)
    r = rgb[:, :, 0].astype(np.int16)
    g = rgb[:, :, 1].astype(np.int16)
    b = rgb[:, :, 2].astype(np.int16)
    candidate = (
        (r >= 25)
        & (r <= 135)
        & (g >= 80)
        & (g <= 185)
        & (b >= 100)
        & (b <= 200)
        & ((g - r) >= 10)
        & ((b - r) >= 18)
        & ((b - g) >= -5)
    )
    height, width = candidate.shape
    background = np.zeros((height, width), dtype=bool)
    queue: deque[tuple[int, int]] = deque()

    def enqueue(y: int, x: int) -> None:
        if candidate[y, x] and not background[y, x]:
            background[y, x] = True
            queue.append((y, x))

    for x in range(width):
        enqueue(0, x)
        enqueue(height - 1, x)
    for y in range(height):
        enqueue(y, 0)
        enqueue(y, width - 1)
    while queue:
        y, x = queue.popleft()
        if y:
            enqueue(y - 1, x)
        if y + 1 < height:
            enqueue(y + 1, x)
        if x:
            enqueue(y, x - 1)
        if x + 1 < width:
            enqueue(y, x + 1)

    relaxed = (
        (r < 185)
        & (g < 210)
        & (b < 225)
        & ((g - r) >= 4)
        & ((b - r) >= 10)
        & ((b - g) >= -12)
    )
    for _ in range(2):
        adjacent = np.zeros_like(background)
        adjacent[1:, :] |= background[:-1, :]
        adjacent[:-1, :] |= background[1:, :]
        adjacent[:, 1:] |= background[:, :-1]
        adjacent[:, :-1] |= background[:, 1:]
        background |= adjacent & relaxed

    alpha = np.where(background, 0, 255).astype(np.uint8)
    rgba = np.dstack((rgb, alpha))
    return Image.fromarray(rgba, "RGBA")


def normalize_sprite(image: Image.Image) -> tuple[Image.Image, list[int]]:
    rgba = image.convert("RGBA")
    bbox = rgba.getchannel("A").getbbox()
    if bbox is None:
        raise RuntimeError("No visible pixels after background removal")
    subject = rgba.crop(bbox)
    subject = fit_contain(subject, 448, 448, allow_upscale=False)
    canvas = Image.new("RGBA", (512, 512), (0, 0, 0, 0))
    x = (512 - subject.width) // 2
    y = 480 - subject.height
    if y < 32:
        raise RuntimeError(f"Subject violates top safe area: y={y}")
    canvas.alpha_composite(subject, (x, y))
    final_bbox = canvas.getchannel("A").getbbox()
    assert final_bbox is not None
    return canvas, list(final_bbox)


def output_record(asset_id: str, path: Path, source_kind: str, crop: list[int] | None) -> dict:
    with Image.open(path) as image:
        rgba = image.convert("RGBA")
        alpha = rgba.getchannel("A")
        bbox = alpha.getbbox()
        assert bbox is not None
        alpha_array = np.asarray(alpha)
        nontransparent = int(np.count_nonzero(alpha_array))
        corners = [alpha.getpixel((0, 0)), alpha.getpixel((511, 0)), alpha.getpixel((0, 511)), alpha.getpixel((511, 511))]
        return {
            "asset_id": asset_id,
            "source_kind": source_kind,
            "crop_xyxy": crop,
            "output_path": path.relative_to(PROJECT_ROOT).as_posix(),
            "sha256": sha256(path),
            "size": list(rgba.size),
            "mode": rgba.mode,
            "alpha_extrema": list(alpha.getextrema()),
            "transparent_corners": corners,
            "nontransparent_bbox": list(bbox),
            "nontransparent_pixel_count": nontransparent,
            "canvas_occupancy": round(nontransparent / (512 * 512), 6),
            "origin": [256, 480],
        }


def render_contact_sheet(records: list[dict], matte_kind: str, image_size: int, output_name: str) -> None:
    columns, rows = 5, 6
    cell_w = max(250, image_size + 44)
    cell_h = image_size + 70
    sheet = Image.new("RGB", (columns * cell_w, rows * cell_h), "#1E1E1E")
    draw = ImageDraw.Draw(sheet)
    for index, record in enumerate(records):
        row, col = divmod(index, columns)
        x0, y0 = col * cell_w, row * cell_h
        if matte_kind == "light":
            matte = Image.new("RGBA", (image_size, image_size), "#F7F2E8")
        elif matte_kind == "dark":
            matte = Image.new("RGBA", (image_size, image_size), "#26353B")
        else:
            matte = checkerboard((image_size, image_size), max(8, image_size // 10)).convert("RGBA")
        sprite = Image.open(PROJECT_ROOT / record["output_path"]).convert("RGBA")
        preview = fit_contain(sprite, image_size, image_size, allow_upscale=False)
        matte.alpha_composite(preview, ((image_size - preview.width) // 2, (image_size - preview.height) // 2))
        sheet.paste(matte.convert("RGB"), (x0 + 18, y0 + 12))
        draw.text((x0 + 14, y0 + image_size + 22), record["asset_id"], font=font(15), fill="#F5E9CC")
    sheet.save(QA_DIR / output_name, optimize=True)


def prepare_assets() -> None:
    evidence = verify_sources()
    cell_map_path = ART_ROOT / "source-cell-map.json"
    cell_map = json.loads(cell_map_path.read_text(encoding="utf-8"))
    board_path = PROJECT_ROOT / cell_map["board_path"]
    if sha256(board_path) != cell_map["board_sha256"]:
        raise RuntimeError("Frozen source board hash mismatch")
    if cell_map["registered_asset_count"] != len(ASSETS):
        raise RuntimeError("Frozen cell map does not match asset inventory")

    (PREPARED_ROOT / "buildings").mkdir(parents=True, exist_ok=True)
    (PREPARED_ROOT / "animals").mkdir(parents=True, exist_ok=True)
    QA_DIR.mkdir(parents=True, exist_ok=True)

    records: list[dict] = []
    for _, asset_id, source_kind, crop in ASSETS:
        source = source_image(asset_id, source_kind, crop)
        if source_kind == "animal":
            cleaned = source
            output_dir = PREPARED_ROOT / "animals"
        else:
            cleaned = keep_central_foreground_component(connected_background_alpha(source))
            output_dir = PREPARED_ROOT / "buildings"
        normalized, _ = normalize_sprite(cleaned)
        output_path = output_dir / f"{asset_id}.png"
        normalized.save(output_path, optimize=True)
        records.append(output_record(asset_id, output_path, source_kind, crop))

    runtime_roots = [
        PROJECT_ROOT / "project.godot",
        PROJECT_ROOT / "scenes",
        PROJECT_ROOT / "scripts",
        PROJECT_ROOT / "config",
        PROJECT_ROOT / "tests",
    ]
    runtime_hits: list[dict] = []
    needles = ["assets/candidate/f003_farm2", "ART-003-FARM2"]
    for root in runtime_roots:
        paths = [root] if root.is_file() else [p for p in root.rglob("*") if p.is_file()] if root.exists() else []
        for path in paths:
            try:
                text = path.read_text(encoding="utf-8")
            except (UnicodeDecodeError, OSError):
                continue
            for needle in needles:
                if needle in text:
                    runtime_hits.append({"path": path.relative_to(PROJECT_ROOT).as_posix(), "needle": needle})

    manifest = {
        "schema_version": 1,
        "contract": "ART-003-FARM2-001",
        "state": "PREPARED_CANDIDATE_NOT_RUNTIME",
        "source_board_sha256": cell_map["board_sha256"],
        "source_evidence": evidence,
        "output_rules": {
            "canvas": [512, 512],
            "mode": "RGBA",
            "safe_padding": 32,
            "alignment": "bottom_center",
            "origin": [256, 480],
            "upscale": False,
            "background_method": "border_connected_teal_segmentation_v1",
        },
        "asset_count": len(records),
        "runtime_reference_hits": runtime_hits,
        "assets": records,
    }
    manifest_text = json.dumps(manifest, ensure_ascii=False, indent=2) + "\n"
    (ART_ROOT / "split-manifest.json").write_text(manifest_text, encoding="utf-8")
    (CANDIDATE_ROOT / "ART-003-FARM2-manifest.json").write_text(manifest_text, encoding="utf-8")
    render_contact_sheet(records, "light", 220, "ART-003-FARM2-light.png")
    render_contact_sheet(records, "dark", 220, "ART-003-FARM2-dark.png")
    render_contact_sheet(records, "checker", 220, "ART-003-FARM2-checker.png")
    render_contact_sheet(records, "checker", 96, "ART-003-FARM2-96px.png")
    print(
        json.dumps(
            {
                "assets": len(records),
                "runtime_reference_hits": len(runtime_hits),
                "manifest": str(ART_ROOT / "split-manifest.json"),
            }
        )
    )


def verify_prepared() -> None:
    manifest = json.loads((ART_ROOT / "split-manifest.json").read_text(encoding="utf-8"))
    errors: list[str] = []
    for record in manifest["assets"]:
        path = PROJECT_ROOT / record["output_path"]
        if not path.exists():
            errors.append(f"missing:{record['asset_id']}")
            continue
        if sha256(path) != record["sha256"]:
            errors.append(f"hash:{record['asset_id']}")
        with Image.open(path) as image:
            if image.size != (512, 512) or image.mode != "RGBA":
                errors.append(f"format:{record['asset_id']}")
            alpha = image.getchannel("A")
            if any(alpha.getpixel(point) != 0 for point in [(0, 0), (511, 0), (0, 511), (511, 511)]):
                errors.append(f"corner:{record['asset_id']}")
    if manifest["runtime_reference_hits"]:
        errors.append("runtime_references")
    result = {"status": "PASS" if not errors else "FAIL", "asset_count": len(manifest["assets"]), "errors": errors}
    (ART_ROOT / "qa" / "verification.json").write_text(
        json.dumps(result, ensure_ascii=False, indent=2) + "\n", encoding="utf-8"
    )
    print(json.dumps(result))
    if errors:
        raise SystemExit(1)


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("command", choices=["source-board", "prepare", "verify"])
    args = parser.parse_args()
    if args.command == "source-board":
        build_source_board()
    elif args.command == "prepare":
        prepare_assets()
    else:
        verify_prepared()


if __name__ == "__main__":
    main()
