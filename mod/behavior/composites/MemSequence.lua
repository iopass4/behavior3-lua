--
-- Author: yang jian 181269573@qq.com
-- Date: 2015-08-25 21:20:32
-- 
 ----MemSequence    --- 序列节点（按从上到下顺序执行），可以执行>=1个子节点，有一个返回非成功，就中断，
 ----                   返回，记录上次执行过的children，如果在running，第二次不会执行已经执行过的tick
MemSequence = class("MemSequence", Composite ) 
MemSequence.category = YJBehavior_enumTable.composite
 
function MemSequence:getName(  ) 
    return "MemSequence"
end 
function MemSequence:open( tick)  
    tick.blackboard:set('runningChild', 1 , tick.tree.id, self.id) 
end
function MemSequence:tick( tick) 
    local child = tick.blackboard:get('runningChild', tick.tree.id, self.id)   
    for i=child, #self.children do 
        if type(self.children[i]) == "table" then
            local status = self.children[i]:_execute(tick)
            if status ~=  Status.SUCCESS then
                if status == Status.RUNNING then
                    tick.blackboard:set('runningChild', i, tick.tree.id, self.id) 
                end
                return status
            end
        end

    end 
    return Status.SUCCESS
end 


return MemSequence 