/**
*@author: Hemant Shukla
*@date: 12-Oct-2017
*@description: SFDC1-4630, This class is used to create Case when Opportunity gets closes and it has Sales Led Commissionable campaign
*@companyname : VERTIBA 
*@Last Modified By : Vishnu Vardhan Chowdary Andra
*@Last Modified Date: 08 Aug 2018
*@Last Modified Description: Story for which the code is developed is marked as obsolete.
* 		While changing RT type from Sales Support to Sales Operations comment out the code, 
* 		instead of deleting logic. SFDC1-9677/78/80/81/82/83/84
**/
global class CreateCaseForSalesLedCampaign {
    
    //-----------------------------
    //@author: Hemant Shukla
    //@date: 12-Oct-2017
    //@param: List of ID of the Opportunity, which will trigger this class. Will be passed from process builder 
    //@description: SFDC1-4630, This method is used to create Case when Opportunity gets closes and it has Sales Led Commissionable campaign
    //@return: void
    //@companyname : VERTIBA 
    //@lastmodified description: Removing Internal partner record types and changing it to Sales Support. 
    // 			Also adding account to case as sales support requires account value
    //@lastmodifiedBy: Vishnu Vardhan on 4th April,2018, SFDC1-7120
    //-----------------------------
    @InvocableMethod(label='Create Case to Sales Claims Team on 6W when Campaign is Sales Led and Commissionable' 
                    description='Create Case to Sales Claims Team on 6W when Campaign is Sales Led and Commissionable') 
    global static void createCase(List<Id> oppIds) {
        
        //Set the process builder flag to true once its fired. Used for Test class
        /*GlobalConstants.hasCreateCaseForSalesLedCampaignprocessfired = true; 
        
        Id salesSupportRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Sales Support').getRecordTypeId();
        Id SalesClaimsTeamid;
        List<Case> cases = new List<Case>();
        List<Group> queues = [select Id from Group where Name = 'Sales Claims Team' and Type = 'Queue']; 
        
        if(queues.isEmpty())
           return;
           
        SalesClaimsTeamid = queues[0].Id;
        
        //querying CampaignInfluence and creating corresponding cases
        for(CampaignInfluence ci: [select Id, OpportunityId, Opportunity.Opportunitynum__c, Opportunity.AccountId, Opportunity.owner.Name, Campaign.Name
                                   from CampaignInfluence
                                   where Campaign.IsActive = true And Campaign.Type = 'Sales Led' ANd Campaign.Commissionable__c = true And
                                         OpportunityId in :oppIds
                                  ]){
                                      
            case obj = new case(Subject = 'Sales Claim Request',
                                origin = 'Internal',
                                AccountId = ci.Opportunity.AccountId,
                                Description = 'Opportunity ' +   ci.Opportunity.Opportunitynum__c  + ' num has just been Closed Won. It is associated with a Campaign that is has a commissions impact for the Owner. Please Review.' + 
                                              '\n' + ' Opportunity Owner:' + ci.Opportunity.owner.name + 
                                              '\n' + ' Campaign:' + ci.Campaign.Name,
                                RecordTypeId = salesSupportRecordTypeId,
                                ownerId = SalesClaimsTeamid,
                                Opportunity__c = ci.OpportunityId
                                );   
                                
            cases.add(obj);                               
            
        }
        
        try{
            insert cases;
        }
        catch(exception e){
            
            system.debug('----------------exception message' + e.getMessage()); 
        }*/
    }
}