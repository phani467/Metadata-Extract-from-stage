/**
* @author Paras Dhingra
* @date 3rd August 2017
* @description SFDC1-775 update relationship for accounts
* @companyname IHS Markit
*/
global class BatchUpdateAccountRelationship implements Database.Batchable<sObject> {
    public String query;
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext BC, List<Account> scope) {
        
        Set<String> closedWonStage = new Set<String>{'6W-Closed Won', '6W-Renewal Won'};
        List<Account> lstAccountsToBeUpdated = new List<Account>();
        Set<Id> setAccountsToBeQueried = new Set<Id>();
        for(Account acc : scope) {
            setAccountsToBeQueried.add(acc.Id);
        }
        if(setAccountsToBeQueried!=null && !setAccountsToBeQueried.IsEmpty()) {
            //query accounts and it's children
            List<Account> lstAccountsData = [Select Id, Relationship__c, (select id, CloseDate from Opportunities where StageName in: closedWonStage ORDER BY CloseDate DESC)
                                            ,(Select id, status from Contracts where EndDate >TODAY AND STATUS <> 'Draft') from Account where ID in:setAccountsToBeQueried];
            if(lstAccountsData!=null && !lstAccountsData.isEmpty()) {
                    for(Account acc : lstAccountsData) {
                        if((acc.Opportunities==null || acc.Opportunities.size()==0)&&(acc.Contracts==null || acc.Contracts.size()==0)&& acc.Relationship__c!='Prospect') {
                            acc.Relationship__c = 'Prospect';
                            lstAccountsToBeUpdated.add(acc);
                        }else if(acc.Contracts!=null && !acc.Contracts.isEmpty() && acc.Relationship__c!='Customer') {
                            acc.Relationship__c = 'Customer';
                            lstAccountsToBeUpdated.add(acc);
                            continue;
                        }else if(acc.Opportunities!=null && acc.Opportunities.size()>0) {
                            if(acc.Opportunities[0].CloseDate< System.today()-365 && acc.Relationship__c!='Previous Customer') {
                                acc.Relationship__c = 'Previous Customer';
                                lstAccountsToBeUpdated.add(acc);
                            }else if(acc.Opportunities[0].CloseDate> System.today()-365 && acc.Relationship__c!='Customer') {
                                acc.Relationship__c = 'Customer';
                                lstAccountsToBeUpdated.add(acc);
                            }
                        }
                    }
                    if(lstAccountsToBeUpdated!=null && lstAccountsToBeUpdated.size()>0) {
                        update lstAccountsToBeUpdated;
                    }
                }
        }
    }
    global void finish(Database.BatchableContext BC){
    }
}