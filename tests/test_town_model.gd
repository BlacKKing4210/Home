extends SceneTree

const TownConfig = preload("res://scripts/town/town_config.gd")
const TownModel = preload("res://scripts/town/town_model.gd")
const TownView = preload("res://scripts/town/town_view.gd")
const TownText = preload("res://scripts/town/town_text.gd")


func _initialize() -> void:
	quit(_run())


func _run() -> int:
	var config = TownConfig.load_default()
	if not _expect(config.is_valid(), "CSV configuration must parse without errors."):
		return 1
	if not _expect(config.number_by_id("grainleaf", "capacity") == 8, "Grainleaf capacity must come from CSV."):
		return 1
	if not _expect(config.number_by_id("meadow_loaf", "capacity") == 4, "Meadow Loaf capacity must come from CSV."):
		return 1
	if not _expect(config.number_by_id("soft_fleece", "capacity") == 6, "Soft Fleece capacity must come from F-003 CSV."):
		return 1
	if not _expect(config.number_by_id("yarn_roll", "capacity") == 3, "Yarn Roll capacity must come from F-003 CSV."):
		return 1
	if not _expect(config.number_by_id("initial_coins", "initial_value") == 12, "Initial coins must come from CSV."):
		return 1
	DirAccess.remove_absolute(ProjectSettings.globalize_path(TownText.PREFERENCE_PATH))
	var chinese_text = TownText.new()
	if not _expect(chinese_text.is_valid(), "F-002 language catalog must parse without errors."):
		return 1
	if not _expect(chinese_text.text("farm_name") == "晨光农场", "First-launch Farmboard text must default to Simplified Chinese."):
		return 1
	chinese_text.set_locale("en")
	if not _expect(chinese_text.text("farm_name") == "Market Meadow", "English locale must resolve catalog labels."):
		return 1
	if not _expect(chinese_text.text("label_willow_pen") == "Willow Pen", "F-003 English labels must resolve from the extended catalog."):
		return 1
	if not _expect(TownText.persist_locale("en") == OK, "English preference must persist."):
		return 1
	if not _expect(TownText.new().locale == "en", "Persisted language must reload on the next runtime instance."):
		return 1
	TownText.persist_locale("zh-CN")
	if not _expect(TownView.target_at_design(Vector2(125, 271)) == "plot:0", "Plot center hit target must match its visible field."):
		return 1
	if not _expect(TownView.target_at_design(Vector2(51, 209)) == "plot:0", "Plot edge hit target must match its visible field."):
		return 1
	if not _expect(TownView.target_at_design(Vector2(44, 592)) == "building:crumbworks", "Bakery edge hit target must match its visible building."):
		return 1
	if not _expect(TownView.target_at_design(Vector2(262, 592)) == "building:willow_pen", "Willow Pen edge hit target must match its visible building."):
		return 1
	if not _expect(TownView.target_at_design(Vector2(480, 592)) == "building:threadmill", "Threadmill edge hit target must match its visible building."):
		return 1
	if not _expect(TownView.target_at_design(Vector2(62, 846)) == "order:market_cart", "Bread ticket edge hit target must match its visible order."):
		return 1
	if not _expect(TownView.target_at_design(Vector2(270, 846)) == "order:fleece_bundle", "Fleece ticket edge hit target must match its visible order."):
		return 1
	if not _expect(TownView.target_at_design(Vector2(478, 846)) == "order:yarn_crate", "Yarn ticket edge hit target must match its visible order."):
		return 1
	if not _expect(TownView.target_at_design(Vector2(662, 50)) == "settings", "Settings gear hit target must match its visible icon."):
		return 1

	var model = TownModel.new(config)
	if not _expect(not model.interact_bakery(), "Bakery must reject insufficient material."):
		return 1
	if not _expect(model.feedback_key == "feedback_missing_grain", "Insufficient material must produce localized feedback."):
		return 1
	if not _expect(not model.interact_plot(3), "Locked plot must reject early interaction."):
		return 1
	if not _expect(model.feedback_key == "feedback_need_coins", "Locked plot must give localized feedback."):
		return 1

	if not _expect(_harvest_once(model, config), "First crop cycle should complete."):
		return 1
	if not _expect(model.interact_plot(0), "Second crop should plant before its early-harvest check."):
		return 1
	if not _expect(not model.interact_plot(0), "Growing crop must reject an early harvest tap."):
		return 1
	if not _expect(model.feedback_key == "feedback_growing", "Early crop tap must explain its countdown."):
		return 1
	model.tick(float(config.number(config.first_of_kind("crop"), "seconds")))
	if not _expect(model.interact_plot(0), "Second crop should harvest after its timer."):
		return 1
	if not _expect(model.amount_of("grainleaf") == 2, "Two harvests should yield two Grainleaf."):
		return 1
	if not _expect(model.interact_bakery(), "Bakery should start with the configured input."):
		return 1
	if not _expect(not model.interact_bakery(), "Busy bakery must reject a second queue request."):
		return 1
	if not _expect(model.feedback_key == "feedback_bakery_busy", "Busy bakery must provide feedback."):
		return 1
	model.tick(float(config.number(config.first_of_kind("building"), "seconds")))
	if not _expect(model.interact_bakery(), "Finished bakery item should collect."):
		return 1
	if not _expect(model.fulfill_order(), "Market Cart should accept a completed loaf."):
		return 1
	if not _expect(model.coins == config.number_by_id("initial_coins", "initial_value") + config.number(config.first_of_kind("order"), "reward_coins"), "Order reward must update coins."):
		return 1

	if not _expect(_harvest_once(model, config), "Third crop cycle should complete."):
		return 1
	if not _expect(_harvest_once(model, config), "Fourth crop cycle should complete."):
		return 1
	if not _expect(model.interact_bakery(), "Second loaf should queue."):
		return 1
	model.tick(float(config.number(config.first_of_kind("building"), "seconds")))
	if not _expect(model.interact_bakery() and model.fulfill_order(), "Second loaf should collect and deliver."):
		return 1
	if not _expect(model.interact_plot(3), "Fourth plot should unlock after two deliveries."):
		return 1
	if not _expect(str(model.plots[3].get("state", "")) == "empty", "Unlocked plot must become interactive and empty."):
		return 1

	var herd_model = TownModel.new(config)
	if not _expect(not herd_model.interact_building("threadmill"), "Threadmill must reject missing fleece."):
		return 1
	if not _expect(herd_model.feedback_key == "feedback_missing_fleece", "Threadmill shortage must identify fleece."):
		return 1
	if not _expect(_harvest_once(herd_model, config), "Grainleaf must remain available for the Willow Pen."):
		return 1
	if not _expect(herd_model.interact_building("willow_pen"), "Willow Pen should start with one Grainleaf."):
		return 1
	if not _expect(not herd_model.interact_building("willow_pen"), "Busy Willow Pen must reject a second feed."):
		return 1
	if not _expect(herd_model.feedback_key == "feedback_willow_pen_busy", "Busy Willow Pen must provide localized feedback."):
		return 1
	herd_model.tick(float(config.number_by_id("willow_pen", "seconds")))
	if not _expect(herd_model.interact_building("willow_pen"), "Finished Willow Pen output should collect."):
		return 1
	if not _expect(herd_model.amount_of("soft_fleece") == 1, "Willow Pen must collect one configured Soft Fleece."):
		return 1
	if not _expect(_harvest_once(herd_model, config), "A second Grainleaf must support a second pen cycle."):
		return 1
	if not _expect(herd_model.interact_building("willow_pen"), "Second Willow Pen cycle should start."):
		return 1
	herd_model.tick(float(config.number_by_id("willow_pen", "seconds")))
	if not _expect(herd_model.interact_building("willow_pen"), "Second Willow Pen cycle should collect."):
		return 1
	if not _expect(herd_model.amount_of("soft_fleece") == 2, "Two pen cycles must produce two Soft Fleece."):
		return 1
	if not _expect(herd_model.interact_building("threadmill"), "Threadmill should start with two Soft Fleece."):
		return 1
	herd_model.tick(float(config.number_by_id("threadmill", "seconds")))
	if not _expect(herd_model.interact_building("threadmill"), "Finished Threadmill output should collect."):
		return 1
	if not _expect(herd_model.amount_of("yarn_roll") == 1, "Threadmill must collect one configured Yarn Roll."):
		return 1
	if not _expect(herd_model.fulfill_order("yarn_crate"), "Yarn Crate must accept a Yarn Roll."):
		return 1
	if not _expect(herd_model.coins == config.number_by_id("initial_coins", "initial_value") + config.number_by_id("yarn_crate", "reward_coins"), "Yarn order reward must update coins."):
		return 1

	var order_model = TownModel.new(config)
	order_model.add_amount("meadow_loaf", 1)
	order_model.add_amount("soft_fleece", 1)
	order_model.add_amount("yarn_roll", 1)
	if not _expect(order_model.fulfill_order("market_cart"), "Bread ticket must remain fulfillable."):
		return 1
	if not _expect(order_model.fulfill_order("fleece_bundle"), "Fleece ticket must be fulfillable."):
		return 1
	if not _expect(order_model.fulfill_order("yarn_crate"), "Yarn ticket must be fulfillable."):
		return 1
	if not _expect(order_model.coins == config.number_by_id("initial_coins", "initial_value") + config.number_by_id("market_cart", "reward_coins") + config.number_by_id("fleece_bundle", "reward_coins") + config.number_by_id("yarn_crate", "reward_coins"), "Three local orders must use their configured rewards."):
		return 1

	var fleece_full_model = TownModel.new(config)
	fleece_full_model.add_amount("grainleaf", 1)
	fleece_full_model.add_amount("soft_fleece", config.number_by_id("soft_fleece", "capacity"))
	if not _expect(not fleece_full_model.interact_building("willow_pen"), "Full fleece storage must reject a new pen job."):
		return 1
	if not _expect(fleece_full_model.feedback_key == "feedback_fleece_storage_full", "Full fleece storage must provide localized feedback."):
		return 1

	var full_model = TownModel.new(config)
	var capacity: int = config.number_by_id("grainleaf", "capacity")
	for ignored_index in range(capacity):
		if not _expect(_harvest_once(full_model, config), "Harvest should succeed until CSV capacity is reached."):
			return 1
	if not _expect(_plant_to_ripe(full_model, config), "A crop should become ripe above capacity."):
		return 1
	if not _expect(not full_model.interact_plot(0), "Full inventory must reject harvest without consuming the crop."):
		return 1
	if not _expect(full_model.feedback_key == "feedback_storage_full", "Full inventory must give feedback."):
		return 1
	if not _expect(str(full_model.plots[0].get("state", "")) == "ripe", "Rejected harvest must keep the crop ripe."):
		return 1

	print("TEST_PASS: Market Meadow, herd, local orders, CSV values, locale catalog, and direct hit regions verified.")
	return 0


func _harvest_once(model, config) -> bool:
	if not _plant_to_ripe(model, config):
		return false
	return model.interact_plot(0)


func _plant_to_ripe(model, config) -> bool:
	if not model.interact_plot(0):
		return false
	model.tick(float(config.number(config.first_of_kind("crop"), "seconds")))
	return str(model.plots[0].get("state", "")) == "ripe"


func _expect(condition: bool, message: String) -> bool:
	if condition:
		return true
	printerr("TEST_FAIL: %s" % message)
	return false
