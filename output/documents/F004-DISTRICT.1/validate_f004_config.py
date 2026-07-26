from __future__ import annotations

import csv
import hashlib
import json
import re
import sys
from collections import Counter, defaultdict
from datetime import datetime, timezone
from pathlib import Path


ROOT = Path(__file__).resolve().parents[3]
TABLES = ROOT / "config" / "tables"
MANIFEST_PATH = ROOT / "assets" / "runtime" / "f003_farm2" / "runtime-manifest.json"
REPORT_PATH = Path(__file__).with_name("f004-config-validation.json")

EXPECTED_HEADERS = {
    "f004_districts": [
        "id",
        "kind",
        "anchor_x",
        "anchor_y",
        "bounds_min_x",
        "bounds_min_y",
        "bounds_max_x",
        "bounds_max_y",
        "accent_key",
        "focus_site_id",
        "unlock_rule",
        "sort_order",
        "name_locale_key",
        "description_locale_key",
    ],
    "f004_sites": [
        "id",
        "district_id",
        "site_type",
        "world_x",
        "world_y",
        "footprint_w",
        "footprint_h",
        "asset_id",
        "content_id",
        "initial_state",
        "prerequisite_rule",
        "build_coin_cost",
        "build_items",
        "build_seconds",
        "sort_order",
        "name_locale_key",
        "description_locale_key",
    ],
    "f004_items": [
        "id",
        "category",
        "storage_type",
        "initial_amount",
        "market_coin_value",
        "seed_reserve",
        "icon_key",
        "name_locale_key",
    ],
    "f004_sources": [
        "id",
        "source_type",
        "site_id",
        "seed_item_id",
        "harvest_item_id",
        "grow_seconds",
        "plant_cost",
        "harvest_yield",
        "unlock_rule",
        "asset_id",
        "initial_state",
        "name_locale_key",
    ],
    "f004_animals": [
        "id",
        "site_id",
        "feed_item_id",
        "feed_cost",
        "output_item_id",
        "output_count",
        "duration_seconds",
        "animal_count",
        "animal_asset_id",
        "pen_asset_id",
        "name_locale_key",
    ],
    "f004_recipes": [
        "id",
        "machine_id",
        "input_items",
        "output_item_id",
        "output_count",
        "duration_seconds",
        "queue_slot",
        "unlock_rule",
        "name_locale_key",
    ],
    "f004_requests": [
        "id",
        "district_id",
        "objective_type",
        "requirements",
        "reward_coins",
        "reward_renown",
        "reward_items",
        "unlock_site_ids",
        "repeatable",
        "sort_order",
        "title_locale_key",
        "description_locale_key",
    ],
    "f004_locale": ["key", "zh-CN", "en"],
}


def load_csv(stem: str) -> tuple[list[str], list[dict[str, str]]]:
    path = TABLES / f"{stem}.csv"
    with path.open("r", encoding="utf-8-sig", newline="") as handle:
        reader = csv.DictReader(handle)
        return list(reader.fieldnames or []), list(reader)


def parse_pairs(value: str, label: str, errors: list[str]) -> dict[str, int]:
    result: dict[str, int] = {}
    if not value:
        return result
    for token in value.split(";"):
        parts = token.split(":")
        if len(parts) != 2 or not parts[0]:
            errors.append(f"{label}: invalid item pair '{token}'")
            continue
        try:
            count = int(parts[1])
        except ValueError:
            errors.append(f"{label}: invalid item count '{token}'")
            continue
        if count <= 0:
            errors.append(f"{label}: count must be positive in '{token}'")
        if parts[0] in result:
            errors.append(f"{label}: duplicate item '{parts[0]}'")
        result[parts[0]] = count
    return result


def parse_rule(value: str, label: str, errors: list[str]) -> list[tuple[str, str]]:
    if value in ("", "always"):
        return []
    dependencies: list[tuple[str, str]] = []
    for token in value.split("&"):
        goal_match = re.fullmatch(r"goal:([a-z0-9_]+)", token)
        site_match = re.fullmatch(r"site:([a-z0-9_]+):built", token)
        if goal_match:
            dependencies.append(("goal", goal_match.group(1)))
        elif site_match:
            dependencies.append(("site", site_match.group(1)))
        else:
            errors.append(f"{label}: invalid prerequisite token '{token}'")
    return dependencies


def require_ref(value: str, valid: set[str], label: str, errors: list[str]) -> None:
    if value and value not in valid:
        errors.append(f"{label}: unknown reference '{value}'")


def require_int(
    row: dict[str, str],
    field: str,
    label: str,
    errors: list[str],
    minimum: int | None = None,
) -> int:
    try:
        value = int(row[field])
    except (KeyError, ValueError):
        errors.append(f"{label}: '{field}' is not an integer")
        return 0
    if minimum is not None and value < minimum:
        errors.append(f"{label}: '{field}' must be >= {minimum}")
    return value


def find_cycle(graph: dict[str, set[str]]) -> list[str]:
    visiting: set[str] = set()
    visited: set[str] = set()
    stack: list[str] = []

    def visit(node: str) -> list[str]:
        if node in visiting:
            index = stack.index(node)
            return stack[index:] + [node]
        if node in visited:
            return []
        visiting.add(node)
        stack.append(node)
        for dependency in sorted(graph.get(node, set())):
            cycle = visit(dependency)
            if cycle:
                return cycle
        stack.pop()
        visiting.remove(node)
        visited.add(node)
        return []

    for node in sorted(graph):
        cycle = visit(node)
        if cycle:
            return cycle
    return []


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        for chunk in iter(lambda: handle.read(65536), b""):
            digest.update(chunk)
    return digest.hexdigest().upper()


def main() -> int:
    errors: list[str] = []
    warnings: list[str] = []
    tables: dict[str, list[dict[str, str]]] = {}
    table_hashes: dict[str, str] = {}

    for stem, expected_header in EXPECTED_HEADERS.items():
        header, rows = load_csv(stem)
        tables[stem] = rows
        path = TABLES / f"{stem}.csv"
        table_hashes[path.relative_to(ROOT).as_posix()] = sha256(path)
        if header != expected_header:
            errors.append(f"{stem}: header mismatch: {header}")

        key_field = "key" if stem == "f004_locale" else "id"
        keys = [row.get(key_field, "") for row in rows]
        duplicates = sorted(key for key, count in Counter(keys).items() if count > 1)
        if "" in keys:
            errors.append(f"{stem}: blank {key_field}")
        if duplicates:
            errors.append(f"{stem}: duplicate {key_field}: {duplicates}")

    _, f003_items = load_csv("f003_v2_items")
    _, f003_recipes = load_csv("f003_v2_recipes")
    _, f003_buildings = load_csv("f003_v2_buildings")
    _, f003_animals = load_csv("f003_v2_animals")
    _, world_rows = load_csv("f003_v2_world")

    world = {row["key"]: int(row["value"]) for row in world_rows}
    world_width = world["world_width"]
    world_height = world["world_height"]

    item_ids_f003 = {row["id"] for row in f003_items}
    item_ids_f004 = {row["id"] for row in tables["f004_items"]}
    item_ids = item_ids_f003 | item_ids_f004
    recipe_ids_f003 = {row["id"] for row in f003_recipes}
    recipe_ids_f004 = {row["id"] for row in tables["f004_recipes"]}
    building_ids_f003 = {row["id"] for row in f003_buildings}
    site_ids = {row["id"] for row in tables["f004_sites"]}
    machine_ids = building_ids_f003 | site_ids
    district_ids = {row["id"] for row in tables["f004_districts"]}
    goal_ids = {row["id"] for row in tables["f004_requests"]}
    source_ids = {row["id"] for row in tables["f004_sources"]}
    animal_ids = {row["id"] for row in tables["f004_animals"]}

    duplicate_items = sorted(item_ids_f003 & item_ids_f004)
    duplicate_recipes = sorted(recipe_ids_f003 & recipe_ids_f004)
    if duplicate_items:
        errors.append(f"f004_items: IDs collide with F003: {duplicate_items}")
    if duplicate_recipes:
        errors.append(f"f004_recipes: IDs collide with F003: {duplicate_recipes}")

    manifest = json.loads(MANIFEST_PATH.read_text(encoding="utf-8"))
    asset_ids = set(manifest["animal_assets"]) | set(manifest["building_assets"])

    locale_rows = tables["f004_locale"]
    locale_keys = {row["key"] for row in locale_rows}
    for row in locale_rows:
        if not row["zh-CN"].strip() or not row["en"].strip():
            errors.append(f"f004_locale:{row['key']}: zh-CN and en must both be nonblank")

    district_bounds: dict[str, tuple[int, int, int, int]] = {}
    dependency_graph: dict[str, set[str]] = defaultdict(set)

    for row in tables["f004_districts"]:
        label = f"f004_districts:{row['id']}"
        min_x = require_int(row, "bounds_min_x", label, errors, 0)
        min_y = require_int(row, "bounds_min_y", label, errors, 0)
        max_x = require_int(row, "bounds_max_x", label, errors, 0)
        max_y = require_int(row, "bounds_max_y", label, errors, 0)
        anchor_x = require_int(row, "anchor_x", label, errors, 0)
        anchor_y = require_int(row, "anchor_y", label, errors, 0)
        if not (min_x < max_x <= world_width and min_y < max_y <= world_height):
            errors.append(f"{label}: district bounds fall outside {world_width}x{world_height}")
        if not (min_x <= anchor_x <= max_x and min_y <= anchor_y <= max_y):
            errors.append(f"{label}: anchor lies outside its district bounds")
        district_bounds[row["id"]] = (min_x, min_y, max_x, max_y)
        require_ref(row["focus_site_id"], site_ids, f"{label}.focus_site_id", errors)
        for kind, dependency in parse_rule(row["unlock_rule"], f"{label}.unlock_rule", errors):
            valid = goal_ids if kind == "goal" else site_ids
            require_ref(dependency, valid, f"{label}.unlock_rule", errors)

    for row in tables["f004_sites"]:
        label = f"f004_sites:{row['id']}"
        require_ref(row["district_id"], district_ids, f"{label}.district_id", errors)
        require_ref(row["asset_id"], asset_ids, f"{label}.asset_id", errors)
        world_x = require_int(row, "world_x", label, errors, 0)
        world_y = require_int(row, "world_y", label, errors, 0)
        require_int(row, "footprint_w", label, errors, 1)
        require_int(row, "footprint_h", label, errors, 1)
        require_int(row, "build_coin_cost", label, errors, 0)
        require_int(row, "build_seconds", label, errors, 0)
        if not (0 <= world_x <= world_width and 0 <= world_y <= world_height):
            errors.append(f"{label}: world position falls outside {world_width}x{world_height}")
        if row["district_id"] in district_bounds:
            min_x, min_y, max_x, max_y = district_bounds[row["district_id"]]
            if not (min_x <= world_x <= max_x and min_y <= world_y <= max_y):
                errors.append(f"{label}: world position lies outside assigned district")
        for item_id in parse_pairs(row["build_items"], f"{label}.build_items", errors):
            require_ref(item_id, item_ids, f"{label}.build_items", errors)
        for kind, dependency in parse_rule(
            row["prerequisite_rule"], f"{label}.prerequisite_rule", errors
        ):
            valid = goal_ids if kind == "goal" else site_ids
            require_ref(dependency, valid, f"{label}.prerequisite_rule", errors)
            dependency_graph[f"site:{row['id']}"].add(f"{kind}:{dependency}")

        if row["site_type"] == "source":
            require_ref(row["content_id"], source_ids, f"{label}.content_id", errors)
        elif row["site_type"] == "animal_pen":
            require_ref(row["content_id"], animal_ids, f"{label}.content_id", errors)
        elif row["site_type"] == "machine":
            require_ref(row["content_id"], site_ids, f"{label}.content_id", errors)

    for goal_id in goal_ids:
        dependency_graph.setdefault(f"goal:{goal_id}", set())
    cycle = find_cycle(dependency_graph)
    if cycle:
        errors.append(f"prerequisite graph contains cycle: {' -> '.join(cycle)}")

    for row in tables["f004_sources"]:
        label = f"f004_sources:{row['id']}"
        if row["site_id"]:
            require_ref(row["site_id"], site_ids, f"{label}.site_id", errors)
        if row["seed_item_id"]:
            require_ref(row["seed_item_id"], item_ids, f"{label}.seed_item_id", errors)
        require_ref(row["harvest_item_id"], item_ids, f"{label}.harvest_item_id", errors)
        require_ref(row["asset_id"], asset_ids, f"{label}.asset_id", errors)
        require_int(row, "grow_seconds", label, errors, 1)
        require_int(row, "plant_cost", label, errors, 0)
        require_int(row, "harvest_yield", label, errors, 1)
        for kind, dependency in parse_rule(row["unlock_rule"], f"{label}.unlock_rule", errors):
            valid = goal_ids if kind == "goal" else site_ids
            require_ref(dependency, valid, f"{label}.unlock_rule", errors)

    for row in tables["f004_animals"]:
        label = f"f004_animals:{row['id']}"
        require_ref(row["site_id"], site_ids, f"{label}.site_id", errors)
        require_ref(row["feed_item_id"], item_ids, f"{label}.feed_item_id", errors)
        require_ref(row["output_item_id"], item_ids, f"{label}.output_item_id", errors)
        require_ref(row["animal_asset_id"], asset_ids, f"{label}.animal_asset_id", errors)
        require_ref(row["pen_asset_id"], asset_ids, f"{label}.pen_asset_id", errors)
        for field in ("feed_cost", "output_count", "duration_seconds", "animal_count"):
            require_int(row, field, label, errors, 1)

    consumer_counts: Counter[str] = Counter()
    for row in tables["f004_animals"]:
        consumer_counts[row["feed_item_id"]] += 1

    for row in tables["f004_recipes"]:
        label = f"f004_recipes:{row['id']}"
        require_ref(row["machine_id"], machine_ids, f"{label}.machine_id", errors)
        for item_id in parse_pairs(row["input_items"], f"{label}.input_items", errors):
            require_ref(item_id, item_ids, f"{label}.input_items", errors)
            consumer_counts[item_id] += 1
        require_ref(row["output_item_id"], item_ids, f"{label}.output_item_id", errors)
        for field in ("output_count", "duration_seconds", "queue_slot"):
            require_int(row, field, label, errors, 1)
        for kind, dependency in parse_rule(row["unlock_rule"], f"{label}.unlock_rule", errors):
            valid = goal_ids if kind == "goal" else site_ids
            require_ref(dependency, valid, f"{label}.unlock_rule", errors)

    build_costs: Counter[str] = Counter()
    for row in tables["f004_sites"]:
        build_costs.update(parse_pairs(row["build_items"], f"f004_sites:{row['id']}.build_items", errors))

    rewards: Counter[str] = Counter()
    for row in tables["f004_requests"]:
        label = f"f004_requests:{row['id']}"
        require_ref(row["district_id"], district_ids, f"{label}.district_id", errors)
        for item_id in parse_pairs(row["requirements"], f"{label}.requirements", errors):
            require_ref(item_id, item_ids, f"{label}.requirements", errors)
        reward_pairs = parse_pairs(row["reward_items"], f"{label}.reward_items", errors)
        for item_id in reward_pairs:
            require_ref(item_id, item_ids, f"{label}.reward_items", errors)
        rewards.update(reward_pairs)
        for site_id in filter(None, row["unlock_site_ids"].split(";")):
            require_ref(site_id, site_ids, f"{label}.unlock_site_ids", errors)
        require_int(row, "reward_coins", label, errors, 0)
        require_int(row, "reward_renown", label, errors, 0)

    initial_items = Counter({row["id"]: int(row["initial_amount"]) for row in f003_items})
    initial_items.update(
        {row["id"]: int(row["initial_amount"]) for row in tables["f004_items"]}
    )
    material_availability: dict[str, dict[str, int | bool]] = {}
    for material_id in ("timber_board", "smooth_stone"):
        available = initial_items[material_id] + rewards[material_id]
        cost = build_costs[material_id]
        material_availability[material_id] = {
            "initial": initial_items[material_id],
            "goal_rewards": rewards[material_id],
            "total_available": available,
            "total_build_cost": cost,
            "sufficient": available >= cost,
        }
        if available < cost:
            errors.append(
                f"material hardlock: {material_id} available {available}, build cost {cost}"
            )

    shared_route_counts = {
        item_id: consumer_counts[item_id]
        for item_id in ("sun_petal", "amber_apple", "root_carrot")
    }
    for item_id, count in shared_route_counts.items():
        if count < 2:
            errors.append(f"shared route: {item_id} has only {count} valid consumers")

    for stem, rows in tables.items():
        if stem == "f004_locale":
            continue
        for row in rows:
            label = f"{stem}:{row['id']}"
            for field, value in row.items():
                if field.endswith("locale_key"):
                    require_ref(value, locale_keys, f"{label}.{field}", errors)

    f003_interactive_buildings = sum(
        1 for row in f003_buildings if row["interactive"].lower() == "true"
    )
    functional_world_entries = f003_interactive_buildings + len(tables["f004_sites"])
    if functional_world_entries < 16:
        errors.append(
            f"world density contract: {functional_world_entries} functional entries, expected >= 16"
        )

    report = {
        "schema_version": 1,
        "feature": "F004-DISTRICT.1",
        "task_id": "F-004-DESIGN-001",
        "validated_at_utc": datetime.now(timezone.utc).isoformat(),
        "status": "PASS" if not errors else "FAIL",
        "world": {"width": world_width, "height": world_height},
        "counts": {
            "districts": len(tables["f004_districts"]),
            "sites": len(tables["f004_sites"]),
            "functional_world_entries": functional_world_entries,
            "items": len(tables["f004_items"]),
            "sources": len(tables["f004_sources"]),
            "animals": len(tables["f004_animals"]),
            "recipes": len(tables["f004_recipes"]),
            "goals": len(tables["f004_requests"]),
            "locale_keys": len(locale_keys),
        },
        "shared_route_counts": shared_route_counts,
        "material_availability": material_availability,
        "prerequisite_graph": {
            "status": "PASS" if not cycle else "FAIL",
            "nodes": len(dependency_graph),
            "cycle": cycle,
        },
        "runtime_manifest": {
            "path": MANIFEST_PATH.relative_to(ROOT).as_posix(),
            "asset_count": manifest["asset_count"],
            "sha256": sha256(MANIFEST_PATH),
        },
        "table_sha256": table_hashes,
        "warnings": warnings,
        "errors": errors,
    }
    REPORT_PATH.write_text(
        json.dumps(report, ensure_ascii=False, indent=2) + "\n", encoding="utf-8"
    )
    print(json.dumps(report, ensure_ascii=False, indent=2))
    return 0 if not errors else 1


if __name__ == "__main__":
    sys.exit(main())
