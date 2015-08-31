--
-- Author: yang jian 181269573@qq.com
-- Date: 2015-08-23 15:48:05
--  
Decorator = class("Decorator", BaseNode )  
Decorator.category = YJBehavior_enumTable.decorator
function Decorator:ctor(  ) 
    report_dt("Decorator:ctor "   )
    settings = settings or {}  
    self.child = settings.child or nil ;

end

function Decorator:tick( tick) 
    report_dt("Decorator:tick "   )
end


-- function Decorator:close( tick, status) 

-- end

return Decorator 