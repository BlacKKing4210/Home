extends SceneTree

const Farm2Config = preload("res://scripts/town/farm2_config.gd")
const Farm2Model = preload("res://scripts/town/farm2_model.gd")
const Farm2Text = preload("res://scripts/town/farm2_text.gd")
const Farm2Save = preload("res://scripts/town/farm2_save.gd")
const Farm2View = preload("res://scripts/town/farm2_view.gd")

const TEST_SAVE_PATH := "user://city_of_animals_farm2_test.json"
const CAPTURE_PATH := "res://output/runtime/F003-FARM2/iteration-a-main-map.png"
const EXPANDED_CAPTURE_PATH := "res://output/runtime/F003-FARM2/iteration-b-expanded-map.png"
const REQUEST_CAPTURE_PATH := "res://output/runtime/F003-FARM2/iteration-b-requests-panel.png"
const ACTIVE_CAPTURE_PATH := "res://output/runtime/F003-FARM2/iteration-c-active-production.png"
const SETTINGS_CAPTURE_PATH := "res://output/runtime/F003-FARM2/iteration-c-settings-en.png"
const VQ_DEFAULT_CAPTURE_PATH := "res://output/runtime/F003-VQ.1/vq-default.png"
const VQ_READY_CAPTURE_PATH := "res://output/runtime/F003-VQ.1/vq-ready.png"
const VQ_SUCCESS_CAPTURE_PATH := "res://output/runtime/F003-VQ.1/vq-harvest-success.png"
const VQ_SETTLE_CAPTURE_PATH := "res://output/runtime/F003-VQ.1/vq-harvest-settle.png"
const VQ_BLOCKED_CAPTURE_PATH := "res://output/runtime/F003-VQ.1/vq-granary-blocked.png"
const VQ_REDUCED_CAPTURE_PATH := "res://output/runtime/F003-VQ.1/vq-reduced-motion.png"


func _initialize() -> void:
	call_deferred("_start")


func _start() -> void:
	var result: int = await _run()
	quit(result)


func _run() -> int:
	var config = Farm2Config.load_default()
	if not _expect(config.is_valid(), "Nine FARM.2 configuration tables must validate: %s" % "; ".join(config.errors)):
		return 1
	if not _expect(config.rows("items").size() == 11, "Item table must expose eleven original MVP items."):
		return 1
	if not _expect(config.rows("buildings").size() >= 16, "Town content must expose at least sixteen configured buildings."):
		return 1
	if not _expect(config.world_int("world_width") == 1800 and config.world_int("world_height") == 1700, "World dimensions must come from CSV."):
		return 1

	var model = Farm2Model.new(config)
	if not _expect(model.plots.size() == 12, "Starter world must own twelve plots."):
		return 1
	if not _expect(model.amount_of("golden_sprig") == 12, "Starter Golden Sprig inventory must come from CSV."):
		return 1
	for index in range(12):
		if not _expect(model.plant_plot(index, "golden_sprig"), "Each of twelve plots must accept one starter seed."):
			return 1
	if not _expect(model.amount_of("golden_sprig") == 0, "Twelve starter plantings must consume exactly twelve seeds."):
		return 1
	if not _expect(not model.plant_plot(0, "golden_sprig"), "A planted plot cannot accept a thirteenth planting."):
		return 1
	model.tick(8.0)
	for index in range(12):
		if not _expect(model.harvest_plot(index), "Every mature plot must harvest when full yield fits."):
			return 1
	if not _expect(model.amount_of("golden_sprig") == 36, "Twelve harvests must yield 36 and net +24."):
		return 1
	if not _expect(model.storage_used("granary") == model.storage_capacity("granary"), "First crop cycle must reach the configured granary pressure point."):
		return 1

	var full_model = Farm2Model.new(config)
	if not _expect(full_model.plant_plot(0, "golden_sprig"), "Full-storage case must start a real crop."):
		return 1
	full_model.tick(8.0)
	for item in config.rows("items"):
		if config.text(item, "storage_type") == "granary":
			full_model.inventory[config.text(item, "id")] = 0
	full_model.inventory["golden_sprig"] = full_model.storage_capacity("granary")
	if not _expect(not full_model.harvest_plot(0), "Granary-full harvest must fail atomically."):
		return 1
	if not _expect(str(full_model.plots[0]["state"]) == "ready", "Rejected harvest must keep the crop ready."):
		return 1

	var production_model = Farm2Model.new(config)
	if not _expect(production_model.feed_animal("chicken"), "Chicken must accept configured feed."):
		return 1
	production_model.tick(18.0)
	if not _expect(production_model.collect_animal("chicken"), "Chicken product must be collected only after the timer."):
		return 1
	if not _expect(production_model.amount_of("spotted_egg") == 2, "Chicken output count must come from CSV."):
		return 1
	production_model.add_amount("leafy_feed", 1)
	if not _expect(production_model.feed_animal("cow"), "Cow must accept two configured feeds."):
		return 1
	production_model.tick(30.0)
	if not _expect(production_model.collect_animal("cow"), "Cow product must remain explicit-collection."):
		return 1
	if not _expect(production_model.amount_of("cloud_milk") == 2, "Cow output count must come from CSV."):
		return 1

	var grain_before := production_model.amount_of("golden_sprig")
	var egg_before := production_model.amount_of("spotted_egg")
	if not _expect(production_model.queue_recipe("hearth_loaf"), "Bakery must accept a valid first recipe."):
		return 1
	if not _expect(production_model.queue_recipe("hearth_loaf"), "Bakery must accept its second queue slot."):
		return 1
	var grain_after_two := production_model.amount_of("golden_sprig")
	var egg_after_two := production_model.amount_of("spotted_egg")
	if not _expect(grain_before - grain_after_two == 6 and egg_before - egg_after_two == 2, "Two queued recipes must deduct each input exactly once."):
		return 1
	if not _expect(not production_model.queue_recipe("hearth_loaf"), "Bakery must reject a third item when its queue is full."):
		return 1
	if not _expect(production_model.amount_of("golden_sprig") == grain_after_two and production_model.amount_of("spotted_egg") == egg_after_two, "Queue-full rejection must not deduct inputs."):
		return 1
	production_model.tick(35.0)
	if not _expect(production_model.machine_state("bakery") == "output_ready", "First bakery item must enter an output slot."):
		return 1
	production_model.tick(120.0)
	if not _expect(production_model.machine_state("bakery") == "output_ready", "Uncollected output must block the next queued item."):
		return 1
	if not _expect(production_model.collect_machine("bakery"), "Collecting output must start the next queued item."):
		return 1
	if not _expect(production_model.machine_state("bakery") == "processing", "Second queued item must start only after collection."):
		return 1
	production_model.tick(35.0)
	if not _expect(production_model.collect_machine("bakery") and production_model.amount_of("hearth_loaf") == 2, "Two explicit collections must produce two loaves."):
		return 1

	var request_model = Farm2Model.new(config)
	var request_snapshot: Dictionary = request_model.inventory.duplicate(true)
	if not _expect(not request_model.fulfill_request("garden_box"), "Multi-item request must reject any missing requirement."):
		return 1
	if not _expect(request_model.inventory == request_snapshot, "Failed request must not deduct partial inventory."):
		return 1
	request_model.add_amount("root_preserve", 1)
	if not _expect(request_model.fulfill_request("garden_box"), "Complete multi-item request must commit atomically."):
		return 1
	if not _expect(not bool(request_model.requests["garden_box"]["active"]), "Completed request must enter refresh state."):
		return 1
	request_model.tick(30.0)
	if not _expect(bool(request_model.requests["garden_box"]["active"]), "Request must return after its configured refresh."):
		return 1

	var market_model = Farm2Model.new(config)
	if not _expect(market_model.market_sell("root_carrot", 4), "Market may sell surplus above the seed reserve."):
		return 1
	if not _expect(not market_model.market_sell("root_carrot", 1), "Market must protect the configured seed reserve."):
		return 1

	var save_service = Farm2Save.new(TEST_SAVE_PATH)
	save_service.remove()
	production_model.coins += 17
	if not _expect(save_service.save_model(production_model) == OK, "FARM.2 save must write a versioned model."):
		return 1
	var loaded_model = Farm2Model.new(config)
	var load_result := save_service.load_into(loaded_model)
	if not _expect(bool(load_result.get("loaded", false)) and loaded_model.coins == production_model.coins, "Saved coins and state must reload."):
		return 1
	save_service.remove()

	var legacy_model = Farm2Model.new(config)
	var legacy_result := legacy_model.apply_save_data({"coins": 9, "renown": 2, "inventory": {"golden_sprig": -7}})
	if not _expect(bool(legacy_result.get("migrated", false)), "Schema-less FARM.1 save must use the migration path."):
		return 1
	if not _expect(legacy_model.amount_of("golden_sprig") >= config.number(config.record("items", "golden_sprig"), "seed_reserve"), "Migration must restore a safe seed floor."):
		return 1

	DirAccess.remove_absolute(ProjectSettings.globalize_path(Farm2Text.PREFERENCE_PATH))
	var chinese_text = Farm2Text.new()
	if not _expect(chinese_text.is_valid(), "Locale catalog must validate: %s" % "; ".join(chinese_text.errors)):
		return 1
	if not _expect(chinese_text.locale == "zh-CN", "First launch must default to Simplified Chinese."):
		return 1
	if not _expect(chinese_text.text("town_name") == "动物晴谷", "Chinese catalog must resolve player-facing text."):
		return 1
	chinese_text.set_locale("en")
	chinese_text.set_reduced_motion(true)
	var persisted_text = Farm2Text.new()
	if not _expect(persisted_text.locale == "en" and persisted_text.reduced_motion, "Language and reduced-motion selection must persist."):
		return 1
	DirAccess.remove_absolute(ProjectSettings.globalize_path(Farm2Text.PREFERENCE_PATH))

	var simulation_model = Farm2Model.new(config)
	for second in range(600):
		if not _expect(simulation_model.has_meaningful_action(), "Ten-minute simulation must retain a meaningful action at second %d." % second):
			return 1
		_simulation_step(simulation_model, config)
		simulation_model.tick(1.0)

	var evidence_viewport := SubViewport.new()
	evidence_viewport.size = Vector2i(720, 1280)
	evidence_viewport.render_target_update_mode = SubViewport.UPDATE_ALWAYS
	get_root().add_child(evidence_viewport)
	var farm_view = Farm2View.new()
	farm_view.disable_persistence = true
	evidence_viewport.add_child(farm_view)
	farm_view.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	await process_frame
	await process_frame
	var view_snapshot: Dictionary = farm_view.debug_snapshot()
	print("VIEW_SNAPSHOT: %s" % JSON.stringify(view_snapshot))
	if not _expect(bool(view_snapshot.get("runtime_ready", false)), "FARM.2 main view must initialise."):
		return 1
	if not _expect(int(view_snapshot.get("world_width", 0)) == 1800 and int(view_snapshot.get("world_height", 0)) == 1700, "Main view must expose the configured large world."):
		return 1
	if not _expect(int(view_snapshot.get("object_count", 0)) >= 28, "Main view must expose twelve plots and sixteen buildings."):
		return 1
	if not _expect(int(view_snapshot.get("runtime_texture_count", 0)) == 26, "Main view must load all twenty-six promoted runtime textures."):
		return 1
	if not _expect(farm_view.debug_pan_to(Vector2(9999.0, 9999.0)) == Vector2(1080.0, 540.0), "Camera pan must clamp to CSV maximums."):
		return 1
	if not _expect(farm_view.debug_pan_to(Vector2(-99.0, -99.0)) == Vector2.ZERO, "Camera pan must clamp to CSV minimums."):
		return 1
	farm_view.debug_pan_to(Vector2(420.0, 180.0))
	await process_frame
	if not _expect(farm_view.debug_target_at_design(Vector2(674.0, 48.0)) == "nav:settings", "Settings hit target must remain reachable at 720x1280."):
		return 1
	if "--farm2-capture" in OS.get_cmdline_user_args():
		DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(CAPTURE_PATH.get_base_dir()))
		await process_frame
		if not _expect(_save_capture(evidence_viewport, CAPTURE_PATH), "Rendered FARM.2 main viewport must save as PNG evidence."):
			return 1
		farm_view.debug_pan_to(Vector2(900.0, 430.0))
		await process_frame
		if not _expect(_save_capture(evidence_viewport, EXPANDED_CAPTURE_PATH), "Expanded FARM.2 world must save as PNG evidence."):
			return 1
		farm_view.debug_activate_target("nav:1")
		await process_frame
		if not _expect(_save_capture(evidence_viewport, REQUEST_CAPTURE_PATH), "FARM.2 request panel must save as PNG evidence."):
			return 1
		farm_view.debug_activate_target("panel:close")
		farm_view.debug_pan_to(Vector2(420.0, 180.0))
		await process_frame
	farm_view.debug_activate_target("plot:1")
	if not _expect(str(farm_view.debug_snapshot().get("panel", "")) == "crops", "Empty plot tap must open crop selection."):
		return 1
	farm_view.debug_activate_target("panel:crop:golden_sprig")
	if not _expect(str(farm_view.debug_model().plots[1].get("state", "")) == "growing", "Crop selection must plant the selected plot."):
		return 1
	farm_view.debug_model().tick(8.0)
	farm_view.debug_activate_target("plot:1")
	if not _expect(str(farm_view.debug_model().plots[1].get("state", "")) == "empty", "Ready plot tap must harvest and return to empty."):
		return 1
	farm_view.debug_activate_target("building:chicken_coop")
	if not _expect(farm_view.debug_model().animal_state("chicken") == "producing", "Animal-pen tap must feed a hungry animal when feed is available."):
		return 1
	farm_view.debug_activate_target("building:feedworks")
	if not _expect(str(farm_view.debug_snapshot().get("panel", "")) == "recipes", "Machine tap must open its recipe panel."):
		return 1
	farm_view.debug_activate_target("panel:recipe:leafy_feed_mix")
	if not _expect(farm_view.debug_model().machine_state("feedworks") == "processing", "Recipe choice must start configured machine production."):
		return 1
	farm_view.debug_activate_target("plot:3")
	farm_view.debug_activate_target("panel:crop:root_carrot")
	if not _expect(str(farm_view.debug_model().plots[3].get("state", "")) == "growing", "A second crop choice must expose a simultaneous growing timer."):
		return 1
	if "--farm2-capture" in OS.get_cmdline_user_args():
		farm_view.debug_pan_to(Vector2(720.0, 220.0))
		await process_frame
		if not _expect(_save_capture(evidence_viewport, ACTIVE_CAPTURE_PATH), "Active crop/animal/machine state must save as PNG evidence."):
			return 1
		farm_view.debug_pan_to(Vector2(420.0, 180.0))
	var view_coins_before: int = farm_view.debug_model().coins
	var view_carrots_before: int = farm_view.debug_model().amount_of("root_carrot")
	farm_view.debug_activate_target("nav:3")
	if not _expect(str(farm_view.debug_snapshot().get("panel", "")) == "market", "Market navigation must open the roadside market panel."):
		return 1
	farm_view.debug_activate_target("panel:sell:root_carrot")
	if not _expect(
		farm_view.debug_model().coins == view_coins_before + 3
		and farm_view.debug_model().amount_of("root_carrot") == view_carrots_before - 1,
		"Market action must exchange one configured item for its configured coin value."
	):
		return 1
	farm_view.debug_activate_target("nav:settings")
	farm_view.debug_activate_target("panel:locale:en")
	if not _expect(str(farm_view.debug_snapshot().get("locale", "")) == "en", "Settings must switch the live view to English."):
		return 1
	if "--farm2-capture" in OS.get_cmdline_user_args():
		await process_frame
		if not _expect(_save_capture(evidence_viewport, SETTINGS_CAPTURE_PATH), "English settings state must save as PNG evidence."):
			return 1
	farm_view.debug_activate_target("panel:locale:zh-CN")
	farm_view.debug_activate_target("panel:motion")
	if not _expect(str(farm_view.debug_snapshot().get("locale", "")) == "zh-CN" and bool(farm_view.debug_snapshot().get("reduced_motion", false)), "Settings must restore Chinese and toggle reduced motion without test persistence."):
		return 1
	evidence_viewport.queue_free()
	await process_frame
	if not await _run_visual_quality_slice("--vq-capture" in OS.get_cmdline_user_args()):
		return 1

	print("TEST_PASS: FARM.2 CSV contracts, crop economy, dual storage, animals, queues, requests, market, migration, persistence, locale, ten-minute action guard, large-world view, runtime assets, camera clamps, 720x1280 hit targets, player interaction routes, and F003-VQ.1 harvest feedback states verified.")
	return 0


func _run_visual_quality_slice(capture: bool) -> bool:
	var viewport := SubViewport.new()
	viewport.size = Vector2i(720, 1280)
	viewport.render_target_update_mode = SubViewport.UPDATE_ALWAYS
	get_root().add_child(viewport)
	var view = Farm2View.new()
	view.disable_persistence = true
	viewport.add_child(view)
	view.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	await process_frame
	await process_frame

	var initial_feedback: Dictionary = view.debug_feedback_snapshot()
	if not _expect(bool(initial_feedback.get("mouse_filter_ignore", false)), "Feedback layer must never intercept player input."):
		return false
	if not _expect(bool(initial_feedback.get("focus_none", false)), "Feedback layer must not enter keyboard or gamepad focus."):
		return false
	if not _expect(int(initial_feedback.get("max_effects", 0)) == 4, "Feedback concurrency must have a fixed budget of four groups."):
		return false
	print("F003_VQ1_STATIC_PERF: %s" % JSON.stringify(await _measure_performance(view, 30)))
	if capture:
		DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(VQ_DEFAULT_CAPTURE_PATH.get_base_dir()))
		if not _expect(_save_capture(viewport, VQ_DEFAULT_CAPTURE_PATH), "F003-VQ.1 default frame must save as real Godot evidence."):
			return false

	view.debug_activate_target("plot:0")
	view.debug_activate_target("panel:crop:golden_sprig")
	view.debug_model().tick(8.0)
	await process_frame
	if not _expect(str(view.debug_model().plots[0].get("state", "")) == "ready", "VQ ready evidence must use a genuinely mature plot."):
		return false
	if capture and not _expect(_save_capture(viewport, VQ_READY_CAPTURE_PATH), "F003-VQ.1 ready frame must save as real Godot evidence."):
		return false

	var success_amount_before: int = view.debug_model().amount_of("golden_sprig")
	view.debug_activate_target("plot:0")
	var success_feedback: Dictionary = view.debug_feedback_snapshot()
	if not _expect(str(view.debug_model().plots[0].get("state", "")) == "empty", "Successful visual feedback must follow the authoritative harvest transition."):
		return false
	if not _expect(view.debug_model().amount_of("golden_sprig") == success_amount_before + 3, "Harvest feedback must not alter the configured yield."):
		return false
	if not _expect(str(success_feedback.get("last_event_kind", "")) == "harvest" and str(success_feedback.get("last_render_mode", "")) == "motion", "Normal harvest must start motion feedback after success."):
		return false
	await create_timer(0.24).timeout
	if capture and not _expect(_save_capture(viewport, VQ_SUCCESS_CAPTURE_PATH), "F003-VQ.1 success frame must capture the live harvest arc."):
		return false
	await create_timer(0.28).timeout
	if capture and not _expect(_save_capture(viewport, VQ_SETTLE_CAPTURE_PATH), "F003-VQ.1 settle frame must capture the granary confirmation."):
		return false

	view.debug_activate_target("nav:settings")
	if not _expect(int(view.debug_feedback_snapshot().get("active_effects", -1)) == 0, "Opening an interrupting panel must clear world feedback."):
		return false
	view.debug_activate_target("panel:close")
	view.debug_activate_target("plot:1")
	view.debug_activate_target("panel:crop:golden_sprig")
	view.debug_model().tick(8.0)
	var free_capacity: int = view.debug_model().storage_capacity("granary") - view.debug_model().storage_used("granary")
	view.debug_model().add_amount("golden_sprig", free_capacity)
	var blocked_amount_before: int = view.debug_model().amount_of("golden_sprig")
	view.debug_activate_target("plot:1")
	var blocked_feedback: Dictionary = view.debug_feedback_snapshot()
	if not _expect(str(view.debug_model().plots[1].get("state", "")) == "ready", "Blocked harvest must retain the mature crop."):
		return false
	if not _expect(view.debug_model().amount_of("golden_sprig") == blocked_amount_before, "Blocked visual feedback must not mutate inventory."):
		return false
	if not _expect(str(blocked_feedback.get("last_event_kind", "")) == "blocked", "Granary-full feedback must never masquerade as success."):
		return false
	await create_timer(0.10).timeout
	if capture and not _expect(_save_capture(viewport, VQ_BLOCKED_CAPTURE_PATH), "F003-VQ.1 blocked frame must save as real Godot evidence."):
		return false

	view.debug_activate_target("nav:settings")
	view.debug_activate_target("panel:motion")
	view.debug_activate_target("panel:close")
	view.debug_model().add_amount("golden_sprig", -12)
	view.debug_activate_target("plot:2")
	view.debug_activate_target("panel:crop:golden_sprig")
	view.debug_model().tick(8.0)
	view.debug_activate_target("plot:2")
	var reduced_feedback: Dictionary = view.debug_feedback_snapshot()
	if not _expect(str(reduced_feedback.get("last_event_kind", "")) == "harvest" and str(reduced_feedback.get("last_render_mode", "")) == "reduced", "Reduced-motion harvest must use its static equivalent."):
		return false
	await create_timer(0.08).timeout
	if capture and not _expect(_save_capture(viewport, VQ_REDUCED_CAPTURE_PATH), "F003-VQ.1 reduced-motion frame must save as real Godot evidence."):
		return false
	await create_timer(0.34).timeout
	if not _expect(int(view.debug_feedback_snapshot().get("active_effects", -1)) == 0, "Reduced-motion feedback must self-clean after its bounded duration."):
		return false

	view.debug_activate_target("nav:settings")
	view.debug_activate_target("panel:motion")
	view.debug_activate_target("panel:close")
	view.debug_model().add_amount("golden_sprig", -12)
	for plot_index in range(3, 8):
		view.debug_activate_target("plot:%d" % plot_index)
		view.debug_activate_target("panel:crop:golden_sprig")
	view.debug_model().tick(8.0)
	for plot_index in range(3, 8):
		view.debug_activate_target("plot:%d" % plot_index)
	if not _expect(int(view.debug_feedback_snapshot().get("active_effects", 0)) == 4, "Rapid harvests must stay inside the four-group feedback budget."):
		return false
	print("F003_VQ1_ACTIVE_PERF: %s" % JSON.stringify(await _measure_performance(view, 18)))

	viewport.queue_free()
	await process_frame
	return true


func _measure_performance(view, sample_frames: int) -> Dictionary:
	var started_at_usec := Time.get_ticks_usec()
	for frame_index in range(sample_frames):
		await process_frame
	var elapsed_seconds := maxf(float(Time.get_ticks_usec() - started_at_usec) / 1000000.0, 0.000001)
	return {
		"canvas": "720x1280",
		"renderer": RenderingServer.get_current_rendering_method(),
		"monitor_fps": Performance.get_monitor(Performance.TIME_FPS),
		"observed_fps": float(sample_frames) / elapsed_seconds,
		"sample_frames": sample_frames,
		"sample_seconds": elapsed_seconds,
		"process_seconds": Performance.get_monitor(Performance.TIME_PROCESS),
		"static_memory_bytes": Performance.get_monitor(Performance.MEMORY_STATIC),
		"static_memory_peak_bytes": Performance.get_monitor(Performance.MEMORY_STATIC_MAX),
		"objects_in_frame": Performance.get_monitor(Performance.RENDER_TOTAL_OBJECTS_IN_FRAME),
		"primitives_in_frame": Performance.get_monitor(Performance.RENDER_TOTAL_PRIMITIVES_IN_FRAME),
		"draw_calls_in_frame": Performance.get_monitor(Performance.RENDER_TOTAL_DRAW_CALLS_IN_FRAME),
		"active_feedback_groups": view.debug_feedback_snapshot().get("active_effects", 0),
	}


func _save_capture(viewport: SubViewport, path: String) -> bool:
	var capture := viewport.get_texture().get_image()
	return capture != null and not capture.is_empty() and capture.save_png(ProjectSettings.globalize_path(path)) == OK


func _simulation_step(model, config) -> void:
	for index in range(model.plots.size()):
		var state := str(model.plots[index]["state"])
		if state == "ready" and model.harvest_plot(index):
			return
		if state == "empty":
			for crop_id in ["golden_sprig", "root_carrot", "cloud_bean"]:
				if model.plant_plot(index, crop_id):
					return
	for animal_id in ["chicken", "cow"]:
		if model.interact_animal(animal_id):
			return
	for machine_id in ["feedworks", "bakery", "dairy", "preserve"]:
		if model.machine_state(machine_id) == "output_ready" and model.collect_machine(machine_id):
			return
	for recipe in config.rows("recipes"):
		if model.queue_recipe(config.text(recipe, "id")):
			return
	for request in config.rows("requests"):
		if model.fulfill_request(config.text(request, "id")):
			return
	for item in config.rows("items"):
		if model.market_sell(config.text(item, "id"), 1):
			return


func _expect(condition: bool, message: String) -> bool:
	if condition:
		return true
	printerr("TEST_FAIL: %s" % message)
	return false
