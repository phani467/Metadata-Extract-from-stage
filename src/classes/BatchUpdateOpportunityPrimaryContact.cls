//-----------------------------
// @author: Jagadesh Kumar
// @date: 31 July 2017
// @param: NA
// @description: Batch apex class to populate primary contact in opportunity from contact roles
//-----------------------------
global class BatchUpdateOpportunityPrimaryContact implements Database.Batchable <sObject>,Database.Stateful, Schedulable {
	global String query;
    global String errorMsgs = '';
    global Database.QueryLocator start(Database.BatchableContext BC) {
        if(query == null) {
            query = 'Select ID,PrimaryContact__c from Opportunity where Isclosed = false';
        }
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<sObject> scope) {
        Map<Id, Opportunity> oppyMapTOUpdate = new Map<Id, Opportunity>();
        Map<Id, Opportunity> opptyMap = new Map<Id, Opportunity>();
        for(Opportunity opp : (List<Opportunity>)scope) {
            opptyMap.put(opp.Id, opp);
        }
        Map<Id,OpportunityContactRole> mapOppCR = new Map<ID,OpportunityContactRole>([Select Id, IsPrimary, OpportunityId, Contact.Name from OpportunityContactRole where IsPrimary = true and OpportunityId in :opptyMap.keySet()]);
        if(!mapOppCR.isEmpty()) {
            // loop through all Opportunity Contact Role records found
            for(OpportunityContactRole oppCR : mapOppCR.values()) {
                Opportunity opp = opptyMap.get(oppCR.OpportunityId);
                if(opp!= null && opp.PrimaryContact__c != oppCR.Contact.Name) {
                    opp.PrimaryContact__c = oppCR.Contact.Name;
                    oppyMapTOUpdate.put(opp.Id, opp);
                }
            }
        }
        if(oppyMapTOUpdate.size() > 0) {
            List<Database.SaveResult> updateOppyResults = Database.update(oppyMapTOUpdate.values(),false);
            // Iterate through each returned result
            for (Database.SaveResult sr : updateOppyResults) {
                if (!sr.isSuccess()) {
                    // Operation failed, so get all errors 
                    errorMsgs += 'Oppy Id: ' + sr.getId() +', '+ sr.getErrors() +'<\br>';
                }
            }
        }
    }
    
    global void finish(Database.BatchableContext BC) {
        if(errorMsgs != '') {
            String[] toAddresses = new String[] {System.Label.OpptyPrimaryContactBatchEmail};
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setToAddresses(toAddresses);
            mail.setReplyTo(System.Label.OpptyPrimaryContactBatchEmail);
            mail.setSenderDisplayName('Opportunity Batch Processing contains error');
            mail.setSubject('Opportunity Batch Primary Contact Processing contains error');
            mail.setPlainTextBody(errorMsgs);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }
    }
    
    global void execute(SchedulableContext ctx) {
        BatchUpdateOpportunityPrimaryContact BUpdate = new BatchUpdateOpportunityPrimaryContact();      
        BUpdate.query = 'Select ID,PrimaryContact__c from Opportunity where Isclosed = false';
        // Invoke the batch job
        ID batchprocessid = Database.executeBatch(BUpdate, Integer.valueOf(System.Label.OpptyPrimaryContactBatchSize.trim())); 
    }
    
}