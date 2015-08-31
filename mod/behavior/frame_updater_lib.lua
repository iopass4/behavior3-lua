local is_init = false
local run_time =  0.015 --60fps
local scheduler_id = -1

local funcs = {}
local add_task = {}
local del_task = {}
local now_reset = false

local function running()

	-- add task handler
	local has_new_add_task = false;
	for key, func in pairs(add_task) do  
    	funcs[key] = func;
    	has_new_add_task = true
	end
	if has_new_add_task then
		add_task = {}
	end

	-- del task handler
	local has_new_del_task = false;
	for key, func in pairs(del_task) do  
    	funcs[func] = nil
    	has_new_del_task = true 
	end
	if has_new_del_task then
		del_task = {}
	end
 
	-- funcs handler
	for key, func in pairs(funcs) do  
    	func()
	end


	-- reset handler
	if now_reset then
		now_reset = false
		if scheduler_id > -1 then
			cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.ScriptFuncId)
		end
		scheduler_id = cc.Director:getInstance():getScheduler():scheduleScriptFunc(
			running, run_time, false)
	end
end

local function frame_updater_init()
	scheduler_id = cc.Director:getInstance():getScheduler():scheduleScriptFunc(
        running, run_time, false)
end

function frame_updater_reset(time)
	run_time = time
	now_reset = true
end

function frame_updater_reg(func)
	if not(is_init) then
		is_init = true
		frame_updater_init()
	end
	add_task[func] = func
end

function frame_updater_del(func)
	del_task[func] = func
end