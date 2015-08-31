--
-- Author: yang jian 181269573@qq.com
-- Date: 2015-08-23 16:15:51
-- 
Condition = class("Condition", BaseNode )  
Condition.category = YJBehavior_enumTable.condition
function Condition:ctor(   ) 
    BaseNode.ctor(self)  

end

-- function Condition:tick( tick) 
--     return Status.SUCCESS
-- end


-- function Condition:close( tick, status) 

-- end

return Condition 