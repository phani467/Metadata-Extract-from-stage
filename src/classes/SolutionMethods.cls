//-----------------------------
// @author: Harshit Singhal
// @date: 11 Aug 2018
// @param: Trigger events
// @description: SFDC1-9773 Main class that contains all the methods of Solution trigger 
// @return: NA
//-----------------------------
public with sharing class SolutionMethods 
{
	public static boolean alreadyPopulated = false;
	
    //-----------------------------
    // @author: Harshit Singhal
    // @date: 11 Aug 2018
    // @description: Method to populate Top Level Category field on Solution record on after insert and after update events.
    // @param: TriggerParameters Contains the trigger parameters which includes the record(s) that got updated.    
    //-----------------------------
    public static void populateTopLevelCategory(TriggerParameters tp) {
        System.debug('@HS populateTopLevelCategory solution trigger method BEGINS');
        System.debug('@HS SolutionMethods.alreadyPopulated=' + SolutionMethods.alreadyPopulated);
        if(!SolutionMethods.alreadyPopulated) {
            Map<ID,Solution> mapSolutions = (Map<Id,Solution>)tp.newMap;
            Map<ID,CategoryData> mapSolutionCategoryData = new Map<ID,CategoryData>();            
            List<Solution> lstSolution = (List<Solution>)tp.newList.deepClone(true,true,true);            
            
            // get all solution categories
            Map<Id,CategoryNode> mapSolutionCategories = new Map<Id,CategoryNode>([Select Id, ParentId, MasterLabel From CategoryNode LIMIT 10000]);
            System.debug('@HS mapSolutionCategories.size()=' + mapSolutionCategories.size());
            
            for(CategoryData cd : [Select Id, RelatedSobjectId, CategoryNodeId From CategoryData where RelatedSobjectId in :mapSolutions.keySet()]) {
                mapSolutionCategoryData.put(cd.RelatedSobjectId, cd);
            }
            System.debug('@HS mapSolutionCategoryData.size()=' + mapSolutionCategoryData.size());            
            
            List<Solution> lstSolutionsToUpdate = new List<Solution>();
            
            for(Solution objSolution : lstSolution) {                            
                // get the solution category
                if(mapSolutionCategoryData != null && !mapSolutionCategoryData.isEmpty() && mapSolutionCategoryData.containsKey(objSolution.Id)) {
                    System.debug('@HS Inside If');
                    CategoryData solutionCategoryData = mapSolutionCategoryData.get(objSolution.Id);
                    
                    String categoryNodeId = solutionCategoryData.CategoryNodeId;
                    
                    CategoryNode solutionCategoryNode = mapSolutionCategories.get(categoryNodeId);
                    
                    if(solutionCategoryNode.ParentId != null) {
                        
                        do {
                            solutionCategoryNode = mapSolutionCategories.get(categoryNodeId);
                            categoryNodeId = solutionCategoryNode.ParentId;						
                            
                        } while (mapSolutionCategories.get(solutionCategoryNode.ParentId).ParentId != null);					
                    }
                    
                    objSolution.TopLevelCategory__c = solutionCategoryNode.MasterLabel;
                    
                    System.debug('@HS objSolution.TopLevelCategory__c : ' + objSolution.TopLevelCategory__c);
                    
                    lstSolutionsToUpdate.add(objSolution);
                }
            }
            System.debug('@HS lstSolutionsToUpdate.size()=' + lstSolutionsToUpdate.size());
            
            alreadyPopulated = true;
            try {
                if(lstSolutionsToUpdate.size() > 0) {
                    update lstSolution;
                }    
            }
            catch (Exception ex) {
                String description = '\n Cause: '+ex.getCause()+'\n Line number : '+ ex.getLineNumber()+ '\n Message: '+ ex.getMessage()+ '\n stackTrace: '+ex.getStackTraceString();
                System.debug('Exception in populateTopLevelCategory() method. Description:'+description);
                throw new TriggerException('Something gone wrong! Please reach out to salesforce helpdesk.'+description);
            }
        }
        System.debug('@HS populateTopLevelCategory solution trigger method ENDS');
    }
}