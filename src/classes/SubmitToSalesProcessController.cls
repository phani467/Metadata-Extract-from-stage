//-----------------------------
// @author Vinod Merwade
// @date 10 Oct 2017
// @description:  SFDC1-550 Sales team to create a Case on click of quick action button and assign the case to the appropriate Sales Ops
// @return: Redirects to the converted record
// @Company: Vertiba
// @Last Modified By : Prachi Bhasin
// @Last Modified Date: 27 Dec 2017
// @Last Modified Description: Fixing queries for Group and Product Group in submitToSalesProcessingQueue method
// 
// @Last Modified By : Vishnu Vardhan Chowdary Andra
// @Last Modified Date: 08 Aug 2018
// @Last Modified Description: Code is called by a lightning component, which again is called from quick action.
// 		While changing RT type from Sales Support to Sales Operations realized this logic is not used anywhere. 
// 		So, it has been decided to comment out the code, instead of deleting logic. SFDC1-9677/78/80/81/82/83/84
//-----------------------------
public without sharing class SubmitToSalesProcessController {
    //-----------------------------
    // @author: Vinod Merwade
    // @date: 10 Oct 2017
    // @param: Opportunity Id from Lightning component
    // @description: SFDC1-550 Method which creates the case and assigns it to Sales Ops depending on the Sales Region of the Opportunity
    // @return: Id of the created case
    // @Company: Vertiba
    // @lastmodified description: Removing Internal partner record types and changing it to Sales Support. 
    // 			Also adding account to case as sales support requires account value
    // @lastmodifiedBy: Vishnu Vardhan on 4th April,2018, SFDC1-7120
    //------------------------------
    @AuraEnabled
    public static Id submitToSalesProcessingQueue(Id oppRecordId) {
       /* try {
            case salesOpsCase = new Case();
            Opportunity opp = [SELECT Id, AccountId,Opportunitynum__c, SalesRegion__c FROM Opportunity WHERE Id =:oppRecordId];
            Id rt = case.SObjectType.getDescribe().getRecordTypeInfosByName().get('Sales Support').getRecordTypeId();
            OpportunityContactRole cont = [select Id,OpportunityId,contactId from OpportunityContactRole where isPrimary= true and OpportunityId=:opp.Id Limit 1];
            salesOpsCase.Opportunity__c = oppRecordId;
            salesOpsCase.Origin='Internal';
            salesOpsCase.RecordTypeId= rt;
            salesOpsCase.AccountId=opp.AccountId;
            if (cont != NULL) {
                salesOpsCase.ContactId=cont.ContactId;
            }
            salesOpsCase.Subject = 'Opportunity '+opp.Opportunitynum__c+': Ready for Sales Support Processing';
            string region = 'Sales - '+opp.SalesRegion__c;
            
            List<Group> ownerQueue = new List<Group>();
            ownerQueue = [select Id,Name from Group where  Type = 'Queue' and Name =:region Limit 1];
            if(ownerQueue != NULL && ownerQueue.size()>0) {
                salesOpsCase.OwnerId = ownerQueue[0].Id;
            }
            
            ProductGroup__c prodGroupRecord = [select Id,Name from ProductGroup__c where Name ='Sales Ops' Limit 1];
            if(prodGroupRecord != NULL) {
                salesOpsCase.ProductGroup__c = prodGroupRecord.id;
            }
            insert salesOpsCase;
            system.debug('created case'+salesOpsCase);
            return salesOpsCase.id;
        }
        catch(Exception e) {
            System.debug('Error, method submitToSalesProcessingQueue, class SubmitToSalesProcessController '+e.getMessage());
            ApexLogger__c apexLogRecord = new ApexLogger__c(ClassName__c='SubmitToSalesProcessController ',ErrorDescription__c='Error '+e.getStackTraceString(),FunctionName__c='submitToSalesProcessingQueue');
            insert apexLogRecord;  
            return null;
        }*/
        return null;
    }
    //-----------------------------
    // @author: Vinod Merwade
    // @date: 10 Oct 2017
    // @param: Opportunity Id from Lightning component
    // @description: SFDC1-550 Method which check for the sales region on the Opportunity
    // @return: Boolean
    // @Company: Vertiba
    // @Last Modified : 16 Aug 2017
    //------------------------------
    @AuraEnabled
    public static Boolean regionExist(Id oppRecordId) {
       /* Opportunity opp =  [Select SalesRegion__c from Opportunity where Id = :oppRecordId];
        List<OpportunityContactRole> cont = [select Id,OpportunityId,contactId from OpportunityContactRole where isPrimary= true and OpportunityId=:oppRecordId ];
        if(opp.SalesRegion__c != NULL && !cont.isEmpty()) {
            return true;
        }
        else {
            return false;
        }*/
        return null;
    }
    
}