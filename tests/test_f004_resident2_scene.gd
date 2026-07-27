extends SceneTree

const Resident2Config = preload("res://scripts/town/f004_resident2_config.gd")
const Resident2Model = preload("res://scripts/town/f004_resident2_model.gd")
const Resident2Text = preload("res://scripts/town/f004_resident2_text.gd")
const Resident2Save = preload("res://scripts/town/f004_resident2_save.gd")
const Resident2View = preload("res://scripts/town/f004_resident2_view.gd")

const TEST_SAVE_PATH := "user://city_of_animals_f004_resident2_test.json"
const EVIDENCE_DIR := "res://output/runtime/F004-RESIDENT.2"
const CAPTURE_FLAG := "--f004-resident2-capture"


func _initialize() -> void:
	call_deferred("_start")


func _start() -> void:
	var result: int = await _run()
	quit(result)


func _run() -> int:
	var config = Resident2Config.load_default()
	if not _expect(config.is_valid(), "F004.2 configuration validates: %s" % "; ".join(config.errors)):
		return 1
	if not _expect(config.grid_rows().size() == 18, "Spatial catalog contains all initial and buildable footprints."):
		return 1
	if not _expect(config.buildable_rows().size() == 4, "Scale-out slice exposes exactly four low-frequency placements."):
		return 1
	if not _expect(config.approved_asset_ids().size() == 12, "Runtime uses eight F004.2 assets plus four shared approved assets."):
		return 1
	if not _expect(config.footprint_size("road_life_b") == Vector2i(1, 1), "Road life point uses the minimum 1x1 unit."):
		return 1
	if not _expect(config.footprint_size("resident_house_b") == Vector2i(2, 2), "Second resident house is 2x2."):
		return 1
	if not _expect(config.footprint_size("dairy_pasture") == Vector2i(3, 3), "Dairy pasture is 3x3."):
		return 1
	if not _expect(config.footprint_size("creamery") == Vector2i(2, 2), "Creamery is 2x2."):
		return 1
	for asset_id in config.approved_asset_ids():
		var asset_path: String = config.asset_path(asset_id)
		if not _expect(FileAccess.file_exists(asset_path), "Approved runtime asset exists: %s" % asset_id):
			return 1
		if not _expect(not asset_path.contains("/source/") and not asset_path.contains("/qa/") and not asset_path.contains("candidate"), "Runtime path excludes candidate and review assets: %s" % asset_id):
			return 1

	var model = Resident2Model.new(config)
	if not _expect(model.coins == 400, "Initial coins come from f004_resident2_visuals.csv."):
		return 1
	var overlap_result: Dictionary = model.placement_check("road_life_b", Vector2i(2, 3))
	if not _expect(not bool(overlap_result.get("valid", true)) and str(overlap_result.get("reason", "")) == "invalid_overlap", "Occupied 1x1 cells are rejected with overlap feedback."):
		return 1
	var bounds_result: Dictionary = model.placement_check("dairy_pasture", Vector2i(9, 9))
	if not _expect(not bool(bounds_result.get("valid", true)) and str(bounds_result.get("reason", "")) == "invalid_bounds", "Footprints outside the 10x10 town boundary are rejected."):
		return 1
	var road_result: Dictionary = model.placement_check("resident_house_b", Vector2i(7, 1))
	if not _expect(not bool(road_result.get("valid", true)) and str(road_result.get("reason", "")) == "invalid_road", "Buildings without a connected entrance road are rejected."):
		return 1
	if not _place_default(model, config, "road_life_b"):
		return 1
	if not _place_default(model, config, "resident_house_b"):
		return 1
	if not _place_default(model, config, "dairy_pasture"):
		return 1
	if not _place_default(model, config, "creamery"):
		return 1
	if not _expect(model.all_required_placed() and model.coins == 125, "Four configured costs settle once and complete the ordered neighborhood."):
		return 1

	model.tick(1.5)
	if not _expect(model.truck_state == "waiting", "World vehicle arrives and waits without opening an order menu."):
		return 1
	if not _expect(model.invite_bear() and model.bear_invited and model.coins == 95, "Bear invitation consumes configured resources once and creates a visible resident."):
		return 1
	if not _expect(model.assign_dairy_job() and model.bear_state == "walking_to_pasture", "One long-term assignment starts autonomous road travel."):
		return 1
	if not _expect(model.set_road_blocked("road_mid_b", true), "A real occupied road cell can be closed."):
		return 1
	if not _expect(model.bear_state == "blocked" and model.blocked_reason == "road", "Route loss interrupts the resident without losing the assignment."):
		return 1
	if not _expect(model.set_road_blocked("road_mid_b", false), "Closed road can be reopened."):
		return 1
	if not _expect(model.bear_state == "walking_to_pasture", "Reopening the road resumes the interrupted trip."):
		return 1
	model.tick(3.0)
	if not _expect(model.bear_state == "feeding", "Bear reaches the 3x3 pasture and starts animal care."):
		return 1

	var save_service = Resident2Save.new(TEST_SAVE_PATH)
	save_service.remove()
	model.tick(0.45)
	if not _expect(save_service.save_model(model) == OK, "Mid-task resident progress saves."):
		return 1
	var resumed_model = Resident2Model.new(config)
	var load_result: Dictionary = save_service.load_into(resumed_model)
	if not _expect(bool(load_result.get("loaded", false)) and resumed_model.bear_state == "feeding", "Interrupted resident work restores to the saved behavior state."):
		return 1
	if not _expect(resumed_model.work_remaining > 0.0 and resumed_model.work_remaining < 1.2, "Task checkpoint resumes instead of restarting."):
		return 1
	save_service.remove()

	model.tick(1.0)
	if not _expect(model.bear_state == "milking" and model.cow_state == "cared", "Feed completion automatically advances to milking."):
		return 1
	model.tick(1.7)
	if not _expect(model.bear_state == "walking_to_creamery" and model.carried_item == "milk_can", "Milk becomes a visible carried good on the road."):
		return 1
	model.tick(1.5)
	if not _expect(model.bear_state == "processing" and model.creamery_input == 1, "Bear reaches the creamery and starts processing."):
		return 1
	model.tick(1.9)
	if not _expect(model.bear_state == "walking_to_truck" and model.carried_item == "dairy_crate", "Creamery produces one order crate and starts autonomous delivery."):
		return 1
	model.set_loading_capacity(0)
	model.tick(1.5)
	if not _expect(model.bear_state == "blocked" and model.blocked_reason == "loading" and model.carried_item == "dairy_crate", "Blocked loading preserves the order crate."):
		return 1
	model.set_loading_capacity(1)
	if not _expect(model.bear_state == "loading", "Restoring capacity resumes the loading checkpoint."):
		return 1
	var coins_before_order: int = model.coins
	model.tick(1.1)
	if not _expect(model.order_complete and model.order_loaded == 1 and model.truck_state == "departing", "Loading atomically completes the world order and starts vehicle departure."):
		return 1
	if not _expect(model.coins - coins_before_order == 120, "Configured order reward settles exactly once."):
		return 1
	model.tick(5.0)
	if not _expect(model.truck_state == "settled" and model.bear_state == "life_idle" and model.rabbit_state == "life_idle", "Vehicle leaves and both residents return to visible town life."):
		return 1
	var settled_coins: int = model.coins
	model.tick(10.0)
	if not _expect(model.coins == settled_coins, "Completed order cannot reward twice."):
		return 1

	DirAccess.remove_absolute(ProjectSettings.globalize_path(Resident2Text.PREFERENCE_PATH))
	var chinese_text = Resident2Text.new()
	if not _expect(chinese_text.is_valid() and chinese_text.locale == "zh-CN", "First launch defaults to Simplified Chinese."):
		return 1
	if not _expect(chinese_text.text("town_name") != "town_name", "Chinese player-facing locale resolves from the catalog."):
		return 1
	chinese_text.set_locale("en")
	chinese_text.set_reduced_motion(true)
	var persisted_text = Resident2Text.new()
	if not _expect(persisted_text.locale == "en" and persisted_text.reduced_motion, "English and reduced-motion preferences persist."):
		return 1
	DirAccess.remove_absolute(ProjectSettings.globalize_path(Resident2Text.PREFERENCE_PATH))

	var viewport := SubViewport.new()
	viewport.size = Vector2i(720, 1280)
	viewport.render_target_update_mode = SubViewport.UPDATE_ALWAYS
	get_root().add_child(viewport)
	var view = Resident2View.new()
	view.disable_persistence = true
	view.disable_audio = true
	viewport.add_child(view)
	view.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	await process_frame
	await process_frame
	var snapshot: Dictionary = view.debug_snapshot()
	print("F004_RESIDENT2_VIEW_SNAPSHOT: %s" % JSON.stringify(snapshot))
	if not _expect(bool(snapshot.get("runtime_ready", false)) and bool(snapshot.get("config_valid", false)), "Real F004.2 entry view initializes at 720x1280."):
		return 1
	if not _expect(int(snapshot.get("asset_count", 0)) == 12 and not bool(snapshot.get("candidate_asset_leak", true)), "Runtime loads only the twelve approved/shared asset paths."):
		return 1
	if not _expect(view.debug_target_at_design(Vector2(670, 52)) == "settings", "Settings touch target remains reachable at the target resolution."):
		return 1
	var capture_enabled := CAPTURE_FLAG in OS.get_cmdline_user_args()
	if capture_enabled:
		DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(EVIDENCE_DIR))
		if not _expect(_save_capture(viewport, "01-default-neighborhood.png"), "Default 720x1280 frame saves."):
			return 1

	view.debug_activate_target("panel:build")
	view.debug_activate_target("build:road_life_b")
	view.debug_activate_target("grid:2:3")
	await process_frame
	if not _expect(str(view.debug_snapshot().get("placement_reason", "")) == "invalid_overlap", "Runtime placement interaction exposes overlap feedback."):
		return 1
	if capture_enabled:
		_save_capture(viewport, "02-invalid-overlap.png")
	view.debug_activate_target("grid:5:3")
	await process_frame
	if not _expect(bool(view.debug_snapshot().get("placement_valid", false)), "Runtime placement ghost becomes valid on the configured 1x1 cell."):
		return 1
	if capture_enabled:
		_save_capture(viewport, "03-valid-road-footprint.png")
	view.debug_activate_target("panel:confirm")
	if not _runtime_place(view, "resident_house_b", Vector2i(6, 1)):
		return 1
	if not _runtime_place(view, "dairy_pasture", Vector2i(1, 5)):
		return 1
	if not _runtime_place(view, "creamery", Vector2i(6, 5)):
		return 1
	await process_frame
	if not _expect(bool(view.debug_snapshot().get("required_placed", false)), "Runtime interaction builds the complete ordered footprint set."):
		return 1
	view.debug_model().tick(1.5)
	view.debug_activate_target("panel:invite")
	await process_frame
	if not _expect(bool(view.debug_snapshot().get("bear_invited", false)), "Runtime CTA invites the second resident."):
		return 1
	if capture_enabled:
		_save_capture(viewport, "04-neighborhood-invited.png")
	view.debug_activate_target("panel:assign")
	view.debug_model().set_road_blocked("road_mid_b", true)
	await process_frame
	if not _expect(str(view.debug_snapshot().get("bear_state", "")) == "blocked", "Runtime exposes the road interruption state."):
		return 1
	if capture_enabled:
		_save_capture(viewport, "05-road-interrupted.png")
	view.debug_model().set_road_blocked("road_mid_b", false)
	view.debug_model().tick(3.0)
	await process_frame
	if capture_enabled:
		_save_capture(viewport, "06-pasture-work.png")
	view.debug_model().tick(1.3)
	view.debug_model().tick(1.7)
	view.debug_model().tick(1.5)
	await process_frame
	if capture_enabled:
		_save_capture(viewport, "07-creamery-work.png")
	view.debug_model().tick(1.9)
	view.debug_model().set_loading_capacity(0)
	view.debug_model().tick(1.5)
	await process_frame
	if not _expect(str(view.debug_snapshot().get("bear_state", "")) == "blocked", "Runtime keeps the visible dairy crate during a loading interruption."):
		return 1
	if capture_enabled:
		_save_capture(viewport, "08-loading-blocked.png")
	view.debug_model().set_loading_capacity(1)
	view.debug_model().tick(1.1)
	await process_frame
	if not _expect(bool(view.debug_snapshot().get("order_complete", false)), "Runtime completes the second world vehicle order."):
		return 1
	if capture_enabled:
		_save_capture(viewport, "09-vehicle-departing.png")
	view.debug_model().tick(5.0)
	await process_frame
	if not _expect(str(view.debug_snapshot().get("bear_state", "")) == "life_idle" and str(view.debug_snapshot().get("rabbit_state", "")) == "life_idle", "Runtime returns two residents to a shared life state."):
		return 1
	if capture_enabled:
		_save_capture(viewport, "10-two-residents-life.png")
	view.debug_activate_target("settings")
	view.debug_activate_target("panel:lang:en")
	view.debug_activate_target("panel:motion")
	await process_frame
	if not _expect(str(view.debug_snapshot().get("locale", "")) == "en" and bool(view.debug_snapshot().get("reduced_motion", false)), "Runtime settings switch to English and reduced motion."):
		return 1
	if capture_enabled:
		_save_capture(viewport, "11-settings-en-reduced.png")
		var sample_start := Time.get_ticks_usec()
		for _frame in range(180):
			await process_frame
		var sample_seconds := float(Time.get_ticks_usec() - sample_start) / 1000000.0
		var measured_fps := 180.0 / maxf(sample_seconds, 0.001)
		if not _expect(_save_runtime_metrics(measured_fps, 180, view.debug_snapshot()), "Runtime metrics save beside player-view captures."):
			return 1

	view.shutdown_audio()
	viewport.queue_free()
	await process_frame
	DirAccess.remove_absolute(ProjectSettings.globalize_path(Resident2Text.PREFERENCE_PATH))
	print("F004_RESIDENT2_TESTS_PASSED")
	return 0


func _place_default(model, config, object_id: String) -> bool:
	if not _expect(model.select_placement(object_id), "Placement becomes selectable in unlock order: %s" % object_id):
		return false
	var expected_origin: Vector2i = config.default_origin(object_id)
	if not _expect(model.update_placement(expected_origin), "Configured origin is legal: %s" % object_id):
		return false
	if not _expect(model.confirm_placement(), "Placement settles once: %s" % object_id):
		return false
	return true


func _runtime_place(view, object_id: String, origin: Vector2i) -> bool:
	view.debug_activate_target("panel:build")
	view.debug_activate_target("build:%s" % object_id)
	view.debug_activate_target("grid:%d:%d" % [origin.x, origin.y])
	if not _expect(bool(view.debug_snapshot().get("placement_valid", false)), "Runtime placement is legal: %s" % object_id):
		return false
	view.debug_activate_target("panel:confirm")
	return _expect(view.debug_model().placements.has(object_id), "Runtime confirms placement: %s" % object_id)


func _save_capture(viewport: SubViewport, filename: String) -> bool:
	var image := viewport.get_texture().get_image()
	if image == null or image.is_empty():
		return false
	var path := "%s/%s" % [EVIDENCE_DIR, filename]
	return image.save_png(ProjectSettings.globalize_path(path)) == OK


func _save_runtime_metrics(measured_fps: float, measured_frames: int, snapshot: Dictionary) -> bool:
	var metrics := {
		"captured_at_utc": Time.get_datetime_string_from_system(true),
		"engine": Engine.get_version_info(),
		"viewport": {"width": 720, "height": 1280},
		"measured_fps": snappedf(measured_fps, 0.01),
		"measured_frames": measured_frames,
		"engine_fps_at_capture": Performance.get_monitor(Performance.TIME_FPS),
		"static_memory_bytes": Performance.get_monitor(Performance.MEMORY_STATIC),
		"node_count": Performance.get_monitor(Performance.OBJECT_NODE_COUNT),
		"render_objects_in_frame": Performance.get_monitor(Performance.RENDER_TOTAL_OBJECTS_IN_FRAME),
		"approved_asset_count": snapshot.get("asset_count", 0),
		"candidate_asset_leak": snapshot.get("candidate_asset_leak", true),
		"capture_path": "normal Godot render path; SubViewport UPDATE_ALWAYS",
		"reduced_motion_checked": snapshot.get("reduced_motion", false),
		"locale_checked": snapshot.get("locale", ""),
	}
	var file := FileAccess.open("%s/runtime-metrics.json" % EVIDENCE_DIR, FileAccess.WRITE)
	if file == null:
		return false
	file.store_string(JSON.stringify(metrics, "\t") + "\n")
	file.close()
	return true


func _expect(condition: bool, message: String) -> bool:
	if condition:
		print("PASS: %s" % message)
		return true
	push_error("FAIL: %s" % message)
	return false
