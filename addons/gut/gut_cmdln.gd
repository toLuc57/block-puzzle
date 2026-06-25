extends SceneTree

const DEFAULT_TEST_DIR := "res://tests/unit/"

func _initialize():
	call_deferred("_run")

func _run():
	var test_dir := _get_arg_value("-gdir", DEFAULT_TEST_DIR)
	var files := _list_test_files(test_dir)
	var total := 0
	var failed := 0

	for path in files:
		var script := load(path)
		if script == null:
			failed += 1
			push_error("GUT runner: could not load %s" % path)
			continue

		var test_instance = script.new()
		var method_names := []
		for method in test_instance.get_method_list():
			var name = method.name
			if typeof(name) == TYPE_STRING and name.begins_with("test_"):
				method_names.append(name)

		for method_name in method_names:
			total += 1
			if test_instance.has_method("before_each"):
				test_instance.before_each()
			var error := false
			var result = test_instance.call(method_name)
			if result == false:
				error = true
			if test_instance.has_method("after_each"):
				test_instance.after_each()
			if error:
				failed += 1

	print("GUT runner completed: %d tests, %d failed" % [total, failed])
	quit(failed)

func _get_arg_value(flag: String, default_value: String) -> String:
	var args := OS.get_cmdline_user_args()
	for i in range(args.size()):
		if args[i] == flag and i + 1 < args.size():
			return args[i + 1]
		if args[i].begins_with(flag + "="):
			return args[i].get_slice("=", 1)
	return default_value

func _list_test_files(test_dir: String) -> Array:
	var results := []
	var dir := DirAccess.open(test_dir)
	if dir == null:
		push_error("GUT runner: could not open %s" % test_dir)
		return results

	dir.list_dir_begin()
	while true:
		var file_name := dir.get_next()
		if file_name == "":
			break
		if dir.current_is_dir():
			continue
		if file_name.ends_with(".gd"):
			results.append(test_dir.path_join(file_name))
	dir.list_dir_end()
	results.sort()
	return results
