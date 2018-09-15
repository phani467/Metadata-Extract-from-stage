//-----------------------------
// @author: Prachi Bhasin
// @date: 9th August 2017
// @description: SFDC1-1167 This batch class will update account owners on the basis of highest value open 
//               opportunity owner for those accounts where GAM is not present
// @companyname: Vertiba
//------------------------------
global class BatchUpdateAccountOwnership implements Database.Batchable<sObject> {
    public String query;
    public Set<String> closedOpportunityStages = new Set<String>{'6W-Closed Won', '6W-Renewal Won', '6L-Closed Lost'};
    public List<Account> lstAccountsToBeUpdated = new List<Account>();
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        
        //String query = 'SELECT Id,Name,OwnerId,Owner.Name,(Select Id, Name,OwnerId,Owner.Name, Amount, StageName from Opportunities where StageName !=\'6L-Closed Lost\' order by Amount DESC limit 1 ) FROM Account where GlobalAccountManager__c =null';        
        return Database.getQueryLocator(query);   
    }
    global void execute(Database.BatchableContext BC, List<Account> scope) {       
        try {
            for(Account acc : scope)
            {
                if(acc.Opportunities != NULL) 
                {
                    for(Opportunity opp:acc.Opportunities)
                    {
                        acc.OwnerId = opp.ownerid;
                        lstAccountsToBeUpdated.add(acc);
                    }
                }
            }
            Database.update(lstAccountsToBeUpdated,false);
        }
        catch (Exception e) {
            System.debug('Error at line 33, method execute, class BatchUpdateAccountOwnership');
            ApexLogger__c apexLogRecord = new ApexLogger__c(ClassName__c='BatchUpdateAccountOwnership',ErrorDescription__c='Error at line 33',FunctionName__c='execute');
            insert apexLogRecord;
        }
    }
    global void finish(Database.BatchableContext BC) {
    }
}