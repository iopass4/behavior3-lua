
cc.FileUtils:getInstance():setPopupNotify(false)
cc.FileUtils:getInstance():addSearchPath("src/")
cc.FileUtils:getInstance():addSearchPath("res/")

require "config"
require "cocos.init"
require("mod.behavior.util")
require("mod.behavior.core.YJBehavior") 

 -- cclog
cclog = function(...)
    print(string.format(...))
end

local function testbt(  )
    local bt = YJBehavior:new()
    bt:load( "res/test_behavior3.json" )
    local b = Blackboard:new()
    local s = bt:tick( "hello" , b  )  

    -- 下面的用法是在每一帧里面去条用tick  具体使用具体嵌入tick就好了
    -- local callback_time = nil 
    -- local running_tick = function (  )
    --     local s = bt:tick( "hello" , b  )  
    --     -- report_dt("tick state2 == > ".. s .. "|||" ..callback_time  ) 
    --     if s ~= Status.RUNNING     then 
    --         running_lib_del_by_time(callback_time) 
    --     end
    -- end
    -- callback_time = running_lib_reg(  running_tick , 1000   )
end
function __G__TRACKBACK__bt(msg)
    cclog("----------------------------------------")
    cclog("__G__TRACKBACK__bt: " .. tostring(msg) .. "\n")
    cclog(debug.traceback())
    cclog("----------------------------------------") 

end
 


local function main() 
    testbt()  
end 

xpcall(main, __G__TRACKBACK__)
 