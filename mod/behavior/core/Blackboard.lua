--
-- Author: yang jian 181269573@qq.com
-- Date: 2015-08-23 16:18:56
--
 

Blackboard = class("Blackboard" )
  
function Blackboard:ctor(   )  
    self._baseMemory = {}
    self._treeMemory = {}
end
function Blackboard:_getTreeMemory( treeScope) 
    if not self._treeMemory[ treeScope ] then
        self._treeMemory[ treeScope ] = {
            nodeMemory         = {},
            openNodes          = {},
            traversalDepth     = 0,
            traversalCycle    = 0,
        }
    end
    return self._treeMemory[ treeScope ]
end
function Blackboard:_getNodeMemory( treeMemory, nodeScope ) 
    local memory = treeMemory['nodeMemory']
    if not memory[ nodeScope ] then
        memory[ nodeScope ]  = {}
    end
    return memory[ nodeScope ] 
end
function Blackboard:_getMemory( treeScope, nodeScope ) 
    local memory = self._baseMemory
    if treeScope then
        memory = self:_getTreeMemory( treeScope )
        if nodeScope then
            memory = self:_getNodeMemory( memory ,nodeScope )
        end
    end
    return memory 
end
function Blackboard:set( key, value, treeScope, nodeScope) 
    local memory = self:_getMemory(treeScope, nodeScope)
    memory[key] = value  
end
function Blackboard:get( key, treeScope, nodeScope ) 
    local memory = self:_getMemory(treeScope, nodeScope);
    return memory[key];
end

return Blackboard 