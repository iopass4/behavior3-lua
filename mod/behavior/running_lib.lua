local is_init = false
local funcs = {}
local add_task = {}
local del_task = {}

-- 暂时凑合用，有空补个系统级的func
local function running_lib_get_cur_time_ms()
	return ((os.clock()*10^6) / 1000)
end

local function running() 


	-- add task handler
	local has_new_add_task = false
	for key, rd in pairs(add_task) do  
    	funcs[key] = rd;
    	has_new_add_task = true
	end
	if has_new_add_task then
		add_task = {}
	end

	-- del task handler
	local has_new_del_task = false;
	for key, call_func in pairs(del_task) do  
    	funcs[key] = nil
    	has_new_del_task = true
	end
	if has_new_del_task then
		del_task = {}
	end	

        -- funcs handler
    local cur_time = running_lib_get_cur_time_ms()
    for key, rd in pairs(funcs) do  
        -- timed task can handler
        if (cur_time - rd.time >= rd.run_time) then
            rd.call_func()
            rd.time = cur_time
            if rd.run_num > -1 then
                rd.run_num = rd.run_num - 1
                if rd.run_num < 1 then 
                    running_lib_del(rd.call_func)
                end
            end
        end
    end
    
end

-- 运行时间，默认1s，单位ms
-- callFunc
-- 运行多少次，默认-1为无数次
function running_lib_reg(call_func, run_time, run_num)
	if not call_func then return false end

	if not run_time then run_time = 1000 end
  	if not run_num  then run_num = -1 end

  	if not is_init then 
  		is_init = true
      require("mod.behavior.running_lib") 
  		frame_updater_reg(running)
  	end

  	rd = {
		call_func=call_func, 
		run_time=run_time, 
		run_num=run_num, 
		time=running_lib_get_cur_time_ms() ,
        uid = bt_getuuid()  --TODO  不知道这个唯一ID靠谱不靠谱
  	} 
	add_task[call_func] = rd 
	return rd.uid 
end

-- callFunc
function running_lib_del(func)
	local rd = funcs[func] 
	if not rd then return false end

	del_task[func] = rd

	return true
end

-- callFunc
function running_lib_del_by_time( uid )
    -- local rd = nil
    local func = nil 
    for k,v in pairs(funcs) do 
        if v.uid == uid then 
            func = v.call_func
            -- rd = funcs[func] 
        end
    end 
    funcs[func] = nil
    add_task[func] = nil 
    return true
end

-- callFunc
function running_lib_del_immediate(func)
	funcs[func] = nil
	add_task[func] = nil
end