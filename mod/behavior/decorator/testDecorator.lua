--
-- Author: yang jian 181269573@qq.com
-- Date: 2015-08-27 15:38:22
--
testDecorator = class( "testDecorator" , Decorator )
function testDecorator:ctor( ... )   
end

function testDecorator:open(tick)    
end
function testDecorator:tick(tick)  
    if not self.child then
        return Status.ERROR
    end   
    local status = self.child:_execute(tick)  
    report_dt("testDecorator:tick " ..status )
    return status
end 