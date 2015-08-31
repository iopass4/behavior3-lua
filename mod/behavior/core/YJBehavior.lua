--
-- Author: yang jian 181269573@qq.com
-- Date: 2015-08-20 16:28:28
-- 

-- 
YJBehavior_enumTable = {
    composite = "composite" ,-- 复合节点 
    decorator = "decorator" ,-- 装饰节点
    action    = "action" ,-- 行动节点
    condition = "condition" , -- 条件节点  
} 

Status = {
    SUCCESS = "SUCCESS",                                    -- 
    FAILURE = "FAILURE",                                   --
    RUNNING = "RUNNING",                                   -- 
    ERROR   = "ERROR"                                     -- 
} 



require("mod.behavior.core.BaseNode") 
require("mod.behavior.core.Tick") 
require("mod.behavior.core.Action")
require("mod.behavior.core.Composite")
require("mod.behavior.core.Condition")
require("mod.behavior.core.Decorator") 
require("mod.behavior.core.Blackboard")
require("mod.behavior.composites.Priority")
require("mod.behavior.composites.Sequence")
require("mod.behavior.composites.MemSequence")
require("mod.behavior.composites.AllSequence")
require("mod.behavior.decorator.testDecorator")
require("mod.behavior.actions.Wait") 
require("mod.behavior.actions.testAction") 
require("mod.behavior.conditions.EqualCondition") 

--composites
YJBehavior_real_func = { 
    Priority  = Priority, -- 条件节点 
    Sequence  = Sequence,
    AllSequence = AllSequence,
    MemSequence = MemSequence
}

--action decorator conditions
YJBehavior_func_names   = {
-- ACTION 
    Wait            = Wait ,     
    testAction      = testAction,
-- decorator
    testDecorator   = testDecorator ,   
-- conditions
    EqualCondition  = EqualCondition 
}


YJBehavior  = class("YJBehavior" ) 
YJBehavior.__index = YJBehavior   -- 用于访问
 
YJBehavior.tick = nil  





local _bt_obj = {}
_bt_obj.map = {}
_bt_obj.rootNode = {}
_bt_obj.nodes = {}
_bt_obj.custom_nodes = {}
function YJBehavior:ctor(  ) 
    self.id = bt_getuuid()
    self.title       = 'The behavior tree'
    self.description = 'Default description'
    self.properties  = {}
    self.root        = nil 
    self.debug       = nil 
end 

function YJBehavior:load( path  ) 
    local fileUtils = cc.FileUtils:getInstance()
    local fullpath = fileUtils:fullPathForFilename( path ) 
    _bt_obj.map = json.decode( io.readfile(fullpath) )  
    _bt_obj.rootNode = _bt_obj.map.root 
    _bt_obj.nodes = _bt_obj.map.nodes  
    for i,v in ipairs(_bt_obj.map.custom_nodes) do
        _bt_obj.custom_nodes[ v.name ] = v 
    end 

    -- dump( _bt_obj.map , "[_bt_obj] .map  =>" )
    -- dump( _bt_obj.rootNode ,"[_bt_obj] rootNode  =>")
    -- dump( _bt_obj.nodes , "[_bt_obj] nodes  =>" )  
    -- dump( _bt_obj.custom_nodes,"[_bt_obj] custom_nodes  =>")  

    local tree_nodes = {}
    for k, v in pairs(_bt_obj.nodes) do 
        local spec = v
        local cls 
        if   YJBehavior_real_func[ spec.name ]  then
            cls = YJBehavior_real_func[ spec.name ] 
        elseif  YJBehavior_func_names[ spec.name ] then
            cls = YJBehavior_func_names[ spec.name ] 
        else
            report_dt('BehaviorTree.load: Invalid node name + "'.. spec.name .. '".')
        end
        if cls then 
            local node = cls:new( spec )
            node:setObj( spec ) 
            node.id = spec.id or node.id 
            node.title = spec.title or node.title
            node.description = spec.description or node.description
            node.properties = spec.properties or node.properties
            node.parameters = spec.parameters or node.parameters 
            tree_nodes[ node.id ] = node 
        end

    end
    
    -- Connect the nodes
    for id, v in pairs(_bt_obj.nodes) do  
        local spec = _bt_obj.nodes[ id ] 
        local node = tree_nodes[ id ]  
        if node.category == YJBehavior_enumTable.composite and spec.children then 
            dump(node, "node")
            dump(spec, "spec")
            for i=1,#node.children do
                local cid = spec.children[i]
                table.insert( node.children , tree_nodes[ cid ]) 
            end
        elseif node.category == YJBehavior_enumTable.decorator and spec.child  then
            local cid = spec.child 
            node.child = tree_nodes[ cid ] 
        end 
    end  
    self.id = tree_nodes[ _bt_obj.rootNode ].id
    self.root = tree_nodes[ _bt_obj.rootNode ] 
    -- dump(tree_nodes, "tree_nodes" )
end
function YJBehavior:tick( target , blackboard  ) 
    if not blackboard then
         __G__TRACKBACK__('The blackboard parameter is obligatory and must be an  instance of b3.Blackboard')
    end
    local tick = Tick:new()
    tick.debug = self.debug
    tick.target = target
    tick.blackboard = blackboard
    tick.tree = self  
    local state = self.root:_execute( tick )

    -- local lastOpenNodes = blackboard:get( 'openNodes', self.id )
    -- local currOpenNodes = clone(tick._openNodes)
    -- report_dt( "去节点~！！！".. state.."~~~"..#lastOpenNodes .."~~~"..#currOpenNodes )       
    -- -- dump(lastOpenNodes , "lastOpenNodes")
    -- -- dump(currOpenNodes , "currOpenNodes")
    -- local start = 1
    -- local a = 1  
    -- while( a <= math.min(#lastOpenNodes ,#currOpenNodes ) )
    -- do 
    --     start = start + 1 
    --     a=a+1 
    --     if( lastOpenNodes[a] ~=  currOpenNodes[a]  ) then 
    --         break
    --     end
    -- end
    -- report_dt( "去节点2~！！！".. start.."~~~"..#lastOpenNodes  )       
    -- --close the nodes
    -- for i = start , #lastOpenNodes do
    --     -- yj_prt(lastOpenNodes[i])
    --     cclog( "lastOpenNodes[i] "..i.."||"..  lastOpenNodes[i].category    )
    --     lastOpenNodes[i]:_close(tick)
    -- end

    -- blackboard:set('openNodes', currOpenNodes, self.id)
    -- blackboard:set('nodeCount', tick._nodeCount, self.id) 
    report_dt( "结果  == > ".. state  ) 

    return state 
end
 


return YJBehavior