--
-- Author: yang jian 181269573@qq.com
-- Date: 2015-08-27 15:32:49
--
testAction = class( "testAction" ,Action)  
testAction.endTime  = 0 
function testAction:ctor(  ) 
end 

-- function testAction:open( tick )  
-- end

function testAction:tick( tick )  
    report_dt("[testfunc]Action testAction"  ) 
    return Status.SUCCESS
end