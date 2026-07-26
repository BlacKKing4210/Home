from __future__ import annotations

import argparse
import math
from pathlib import Path

from PIL import Image, ImageDraw


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--pages", required=True, type=Path)
    parser.add_argument("--output", required=True, type=Path)
    parser.add_argument("--per-sheet", type=int, default=3)
    args = parser.parse_args()

    page_paths = sorted(
        args.pages.glob("page-*.png"),
        key=lambda path: int(path.stem.split("-")[-1]),
    )
    if not page_paths:
        raise SystemExit("no rendered pages found")

    args.output.mkdir(parents=True, exist_ok=True)
    thumb_width = 500
    label_height = 38
    gutter = 20
    for sheet_index in range(math.ceil(len(page_paths) / args.per_sheet)):
        selected = page_paths[
            sheet_index * args.per_sheet : (sheet_index + 1) * args.per_sheet
        ]
        thumbs: list[tuple[Path, Image.Image]] = []
        for page_path in selected:
            page = Image.open(page_path).convert("RGB")
            thumb_height = round(page.height * thumb_width / page.width)
            page.thumbnail((thumb_width, thumb_height), Image.Resampling.LANCZOS)
            thumbs.append((page_path, page.copy()))

        canvas_width = len(thumbs) * thumb_width + (len(thumbs) + 1) * gutter
        canvas_height = max(image.height for _, image in thumbs) + label_height + 2 * gutter
        canvas = Image.new("RGB", (canvas_width, canvas_height), "white")
        draw = ImageDraw.Draw(canvas)
        for index, (page_path, image) in enumerate(thumbs):
            x = gutter + index * (thumb_width + gutter)
            y = gutter + label_height
            draw.text((x, gutter), page_path.stem.replace("page-", "Page "), fill="black")
            canvas.paste(image, (x, y))
        canvas.save(args.output / f"sheet-{sheet_index + 1:02d}.png")

    print(f"pages={len(page_paths)}")
    print(f"sheets={math.ceil(len(page_paths) / args.per_sheet)}")


if __name__ == "__main__":
    main()
