//----------------------------- 
// @Author : Legacy POLK 
// @date: 11 Oct 2017 
// @description: Migrated from Legacy POLK 
// @PROGRAMMER: Anjani Shukla 
//-----------------------------
public with sharing class QueueViewCE {
    
    private queue__c q;
    private final ApexPages.StandardController controller;
    
    public QueueViewCE(ApexPages.StandardController controller) {
        this.controller = controller;
        q= (Queue__c)controller.getRecord();
        if(q.queues__c == null) { 
                q.queues__c = 'All';
        }
        System.Debug(':::::InTheConstructor');
    }
    
    public id searchID;

    public PageReference updateView() {
        if (q.Queues__c <> 'All') {
            List<Group> queues = [Select id From Group where Type='Queue' and name =: q.Queues__c LIMIT 1 ];
            
            if(queues.size() > 0) {
                searchID = queues[0].id;
            } else {
                searchID = null;
            }
        }
                System.Debug('InUpdateView:::' + q.Queues__c);
        return null;
    }
    
    public list<WorkRequestForm__C> getWRFRecords() {
                
                List<WorkRequestForm__C> wrfResults = new list<WorkRequestForm__C>();
                
                if (q.Queues__c <>  'All') {
                    if(searchID <> null)
                        wrfResults=[select id, name, ownerid, SubmittedDateTime__c, PrimarySalesContact__c, RequestedDueDate__c, RequestStatus__c,
                            JobNumber__c, FormType__c from WorkRequestForm__C where ownerid =: searchID order by SubmittedDateTime__c asc];
                }       
        
        else {
                wrfResults=[select id, name, ownerid, SubmittedDateTime__c, PrimarySalesContact__c, RequestedDueDate__c, RequestStatus__c,
                JobNumber__c, FormType__c from WorkRequestForm__C where RequestStatus__c = 'Submitted' order by SubmittedDateTime__c asc];
        }
        return wrfResults;

    }
    
    public list<changelog__c> getCLRecords(){
        list<changelog__c> clResults = new list<changelog__c>();
        if (q.Queues__c <> 'All') {
            if(searchID <> null)
                clResults = [select id, name, ownerid, changedescription__c, changedocumentedby__c, SubmittedDateTime__c,
                    workrequestform__c, status__c, wrstatus__c from changelog__c where ownerid =: searchID order by SubmittedDateTime__c ];
        }
        else {
                    clResults = [select id, name, ownerid, changedescription__c, changedocumentedby__c, SubmittedDateTime__c,
                workrequestform__c, status__c, wrstatus__c from changelog__c where status__c = 'Submitted' order by SubmittedDateTime__c ];
        }
        return clResults;
    }
    
    public list<OrderRequest__c> getORRecords(){
        list<OrderRequest__c> orResults = new list<OrderRequest__c>();
        System.Debug('QQues:::' + q.Queues__c);
        System.Debug('SID:::' + searchID);
        if (q.Queues__c <> 'All') {
            if(searchID <> null) {
                orResults = [select id, name, ownerid, SubmittedDateTime__c,
                    workrequestform__c, status__c from OrderRequest__c where ownerid =: searchID order by SubmittedDateTime__c ];
                System.Debug(':IntheIf:::Not All');
            }
        }
        else {
                orResults = [select id, name, ownerid, SubmittedDateTime__c,
                workrequestform__c, status__c from OrderRequest__c where status__c = 'Submitted' order by SubmittedDateTime__c ];
                System.Debug(':::Else');
        }
        return orResults;
    }
 
}