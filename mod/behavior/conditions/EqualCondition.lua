--
-- Author: yang jian 181269573@qq.com
-- Date: 2015-08-26 16:46:02
-- EqualCondition - 等于条件 
EqualCondition = class("EqualCondition", Condition )  
EqualCondition.category = YJBehavior_enumTable.condition 

function EqualCondition:tick( tick )  
    for k,v in pairs(self.properties) do 
        local value = tick.blackboard:get( k , tick.tree.id ) 
        report_dt("EqualCondition:tick" , k,v , value )
        if value == self.properties[k] then
            tick.blackboard:set( k , nil , tick.tree.id ) 
            return Status.SUCCESS
        end
    end
    return Status.FAILURE
end 

return EqualCondition 