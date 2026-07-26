from __future__ import annotations

import argparse
import math
from pathlib import Path

import pypdfium2 as pdfium
from PIL import Image, ImageDraw


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--pdf", type=Path, required=True)
    parser.add_argument("--output-dir", type=Path, required=True)
    parser.add_argument("--scale", type=float, default=1.25)
    parser.add_argument("--per-sheet", type=int, default=4)
    args = parser.parse_args()

    args.output_dir.mkdir(parents=True, exist_ok=True)
    pages_dir = args.output_dir / "pages"
    pages_dir.mkdir(parents=True, exist_ok=True)

    pdf = pdfium.PdfDocument(str(args.pdf))
    page_paths: list[Path] = []
    for index in range(len(pdf)):
        bitmap = pdf[index].render(scale=args.scale)
        image = bitmap.to_pil().convert("RGB")
        output = pages_dir / f"page-{index + 1:03d}.png"
        image.save(output, optimize=True)
        page_paths.append(output)

    sample = Image.open(page_paths[0])
    page_width, page_height = sample.size
    gap = 24
    label_height = 34
    sheet_width = page_width * 2 + gap * 3
    sheet_height = (page_height + label_height) * 2 + gap * 3

    contact_paths: list[Path] = []
    for sheet_index in range(math.ceil(len(page_paths) / args.per_sheet)):
        canvas = Image.new("RGB", (sheet_width, sheet_height), "#d7e3df")
        draw = ImageDraw.Draw(canvas)
        group = page_paths[
            sheet_index * args.per_sheet : (sheet_index + 1) * args.per_sheet
        ]
        for slot, page_path in enumerate(group):
            image = Image.open(page_path).convert("RGB")
            row, column = divmod(slot, 2)
            x = gap + column * (page_width + gap)
            y = gap + row * (page_height + label_height + gap)
            canvas.paste(image, (x, y + label_height))
            page_number = sheet_index * args.per_sheet + slot + 1
            draw.text((x, y + 8), f"Page {page_number}", fill="#173c38")
        contact_path = args.output_dir / f"contact-{sheet_index + 1:02d}.png"
        canvas.save(contact_path, optimize=True)
        contact_paths.append(contact_path)

    print(
        {
            "page_count": len(page_paths),
            "contact_sheet_count": len(contact_paths),
            "output_dir": str(args.output_dir),
        }
    )


if __name__ == "__main__":
    main()
