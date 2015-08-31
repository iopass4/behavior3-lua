--
-- Author: yang jian 181269573@qq.com
-- Date: 2015-08-27 15:37:36
--
testCondition = class("testCondition", Condition )  
testCondition.category = YJBehavior_enumTable.condition 

function testCondition:tick( tick )   
    report_dt("testCondition:tick" , k,v , value )   
end 

return testCondition 