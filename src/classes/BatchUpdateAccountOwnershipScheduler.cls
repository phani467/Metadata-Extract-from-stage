//-----------------------------
// @author: Prachi Bhasin
// @date: 9th August 2017
// @description: SFDC1-1167 This scheduler class will be used to scheduled the BatchUpdateAccountOwnership batch class 
// @companyname: Vertiba
//------------------------------
global class BatchUpdateAccountOwnershipScheduler implements Schedulable {
    
    global void execute(SchedulableContext ctx) {
        Set<String> closedOpportunityStages = new Set<String>{'6W-Closed Won', '6W-Renewal Won', '6L-Closed Lost', '6W-Forecasting Placeholder'};
        BatchUpdateAccountOwnership batchUpdate = new BatchUpdateAccountOwnership();
        batchUpdate.query = 'SELECT Id,Name,OwnerId,Owner.Name,(Select Id, Name,OwnerId,Owner.Name, Amount, StageName from Opportunities where StageName NOT IN: closedOpportunityStages order by Amount DESC limit 1 ) FROM Account where GlobalAccountManager__c =null';
        ID batchprocessId = Database.executeBatch(batchUpdate,100);
    }
    
}