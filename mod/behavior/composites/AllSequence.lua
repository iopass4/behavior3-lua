--
-- Author: yang jian 181269573@qq.com
-- Date: 2015-08-26 11:49:11
--
---序列节点（按从上到下顺序执行），可以执行>=1个子节点，有一个返回非成功 ，就返回，但是不会中断，所有Children都会执行

AllSequence = class("AllSequence",Composite) 
AllSequence.category = YJBehavior_enumTable.composite
local open_ids = {} 
function AllSequence:getName(  ) 
    return "AllSequence"
end

function AllSequence:tick( tick)  
    local status_reslut = Status.SUCCESS 
    for id, v in pairs( self.children ) do  
        if type(v) == "table" then 
            if not open_ids[id] then
                local status = v:_execute(tick)
                if status ==  Status.RUNNING  then
                    status_reslut = status
                end
                if status ==  Status.FAILURE then
                    open_ids[id] = true  
                    open_ids = {}  
                    return status
                end
                if status ==  Status.SUCCESS then
                    open_ids[id] = true 
                end
            end 
        end 
    end  
    if status_reslut ~=  Status.RUNNING  then
        open_ids = {} 
    end
    
    report_dt( "AllSequence:tick  status ==> ".. status_reslut .."|||"..self.id )
    return status_reslut
end   

return AllSequence 