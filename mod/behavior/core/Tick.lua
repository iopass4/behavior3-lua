--
-- Author: yang jian 181269573@qq.com
-- Date: 2015-08-23 15:36:08
--  


Tick = class("Tick" )  

Tick.tree = nil 
Tick.debug = nil 
Tick.target = nil 
Tick.blackboard = nil 

Tick._openNodes = {}
Tick._nodeCount = 0 
function Tick:ctor() 
    self.tree = nil 
    self.debug = nil 
    self.target = nil 
    self.blackboard = nil 

    self._openNodes = {}
    self._nodeCount = 0 
    -- report_dt('Tick:ctor')
end

function Tick:_enterNode( node) 
    self._nodeCount = self._nodeCount +1  
    table.insert(self._openNodes , node )
end
function Tick:_openNode ( node)  
    -- TODO 
end
function Tick:_tickNode ( node)  
    -- TODO 
end
function Tick:_closeNode ( node)  
    -- TODO  
    table.remove(self._openNodes  )
end

function Tick:_exitNode ( node)  
    -- TODO 
end

function Tick:tick( tick) 
    return Status.SUCCESS
end 

return Tick 