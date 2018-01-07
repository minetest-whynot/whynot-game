----------------------------
-- Example for (custom) attribute change on new process init and an method redefinition 
----------------------------
function woodcutting.settings.on_new_process_hook(process)
	process.max_tree_count = 99

	process._get_hud_message_orig = process.get_hud_message
	function process:get_hud_message(pos)
		local message  = process:_get_hud_message_orig(pos)
		if process.treenode_counter then
			message = message.."  { "..process.treenode_counter.." / "..process.max_tree_count.." }"
		end
		return message
	end
end

----------------------------
-- Example for custom stop processing using on_after_dig_hook()
----------------------------
function woodcutting.settings.on_after_dig_hook(process, pos, oldnode)
	if not process.treenode_counter then
		process.treenode_counter = 1
	else
		process.treenode_counter = process.treenode_counter + 1
	end
	if process.treenode_counter >= process.max_tree_count then
		process:stop_process()
		return false
	end
end
