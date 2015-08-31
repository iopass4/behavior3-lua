--
-- Author: yang jian 181269573@qq.com
-- Date: 2015-08-23 17:24:26
--
 ---序列节点（按从上到下顺序执行），可以执行>=1个子节点，有一个返回非成功，就中断，返回
Sequence = class("Sequence", Composite ) 
Sequence.category = YJBehavior_enumTable.composite
 
function Sequence:getName(  ) 
    return "Sequence"
end

function Sequence:tick( tick)  
    for id, v in pairs( self.children ) do  
        if type(v) == "table" then 
            local status = v:_execute(tick)
            if status ~=  Status.SUCCESS then
                return status
            end
        end 
    end  
    return Status.SUCCESS
end   

return Sequence 