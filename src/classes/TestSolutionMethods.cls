//-----------------------------
// @author: Harshit Singhal
// @date: 13 Aug 2018
// @param: NA
// @description: SFDC1-9773 Test class for Solution trigger methods 
// @return: NA
//-----------------------------

@isTest
private class TestSolutionMethods {
    
    //-----------------------------
    // @author: Harshit Singhal
    // @date: 13 Aug 2018
    // @param: NA
    // @description: SFDC1-9773 Test method for Solution trigger methods populateTopLevelCategory on after insert and after update
    // @return: NA
    //-----------------------------
    private static testMethod void testPopulateTopLevelCategory() {
        //Fetch categorynode data as it is a setup object
        Map<Id,CategoryNode> cnMap = new Map<Id,CategoryNode>([Select Id,ParentId,MasterLabel From CategoryNode]);
        System.debug('@HS cnMap='+cnMap);
        //Create a solution
        Solution testSolution1 = new Solution(SolutionName='TestSolution1');
        insert testSolution1;
        
        CategoryNode usefulCategoryNode;
        String topLevelCategoryStr;
        if(cnMap!=null && cnMap.size()>0) {
            for(CategoryNode cn:cnMap.values()) {
                CategoryNode parentNode = cn.ParentId != null ? cnMap.get(cn.ParentId) : null;
                CategoryNode grandParentNode = parentNode!=null && parentNode.ParentId != null ? cnMap.get(parentNode.ParentId) : null;
                if(grandParentNode != null) {
                    usefulCategoryNode = cn;
                    topLevelCategoryStr = parentNode.MasterLabel;
                    break;
                }                
            }
        }
        if(usefulCategoryNode != null) {
            System.debug('@HS usefulCategoryNode='+usefulCategoryNode);
        	//Create CategoryData
        	CategoryData cdTest = new CategoryData(RelatedSobjectId=testSolution1.Id, CategoryNodeId=usefulCategoryNode.Id);
            insert cdTest;
        	
            //Set trigger variable to false to execute update trigger logic
        	SolutionMethods.alreadyPopulated=false;
            
            //Update solution
        	update testSolution1;
            
            System.debug('@HS After Update:testSolution1.TopLevelCategory__c='+testSolution1.TopLevelCategory__c);
            //System.assertEquals(topLevelCategoryStr,testSolution1.TopLevelCategory__c);
        }
    }
}