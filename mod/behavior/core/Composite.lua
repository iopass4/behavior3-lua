--
-- Author: yang jian 181269573@qq.com
-- Date: 2015-08-23 16:17:48
-- 
 

Composite = class("Composite", BaseNode ) 
Composite.category = YJBehavior_enumTable.composite
function Composite:ctor(    ) 

end

function Composite:setObj( setting ) 
    self.name  = setting.name  or ""
    self.title = setting.title or self.name   
    self.description = ""
    self.children = setting.children or nil ;
    self.properties = setting.properties or nil  
end

function Composite:tick( tick) 
    report_dt( "Composite:tick")
    return Status.SUCCESS
end


function Composite:close( tick, status) 

end

return Composite  