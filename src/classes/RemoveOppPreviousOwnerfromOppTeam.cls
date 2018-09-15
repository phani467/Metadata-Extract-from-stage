/**
*@author: Sonam Raju
*@date: 14- Sept- 2017
*@description:SFDC1-2068 This class is used to delete the Opportunity Previous Owner from the Opportunity team who has 'Opportunity Owner' Role
*@companyname : VERTIBA 
**/
global class RemoveOppPreviousOwnerfromOppTeam {

    //-----------------------------
    //@author: Sonam Raju
    //@date: 14- Sept- 2017
    //@param: List of ID of the opportunities whose owners have been changed
    //@description:SFDC1-2068 This class is used to delete the Opportunity Previous Owner from the Opportunity team
    //@return: void
    //@companyname : VERTIBA 
    //LastModifiedDate : 29 Jun 2018
    //LastModifiedBy : Prachi Bhasin (VERTIBA)
    //@LastModifiedSprint : Sprint 29, SFDC1-8760 Updating opportunity team owner role on opportunity team
    //-----------------------------
    @InvocableMethod
    global static void RemoveOpportunityPreviousOwnerfromOppTeam (List<Opportunity> OpportunityList) {
        try {
            Opportunity oppRecord = OpportunityList[0];
            List<OpportunityTeamMember> OppTeamMemberList = new list<OpportunityTeamMember>([SELECT UserId FROM OpportunityTeamMember WHERE OpportunityId =: oppRecord.id AND (TeamMemberRole ='Opportunity Owner') ]);        
            List<OpportunityTeamMember> OppTeamMemberListtobedeleted = new List<OpportunityTeamMember> ();
            List<Id> lstUsersToBeDeletedFromOppSplit = new List<Id>();
            
             for(OpportunityTeamMember memtemp : OppTeamMemberList ) {
                if(memtemp.UserId != oppRecord.OwnerId) { 
                    OppTeamMemberListtobedeleted.add(memtemp);
                    lstUsersToBeDeletedFromOppSplit.add(memtemp.UserId);
                }
            }
            List<OpportunitySplit> oppSplit = new List<OpportunitySplit>([Select id, opportunityId, splitOwnerId from OpportunitySplit WHERE OpportunityId =: oppRecord.id AND splitOwnerId IN : lstUsersToBeDeletedFromOppSplit]);
            delete oppSplit;
            delete OppTeamMemberListtobedeleted;
            OpportunityTeamMember otm = new OpportunityTeamMember();
            otm.UserId = oppRecord.OwnerId;
            otm.TeamMemberRole ='Opportunity Owner';
            otm.OpportunityId = oppRecord.Id;
            insert otm;
        } 
        catch(Exception e) {
            System.debug('Error at line 18, method RemoveOpportunityPreviousOwnerfromOppTeam, class RemoveOppPreviousOwnerfromOppTeam ');
            ApexLogger__c apexLogRecord = new ApexLogger__c(ClassName__c='RemoveOppPreviousOwnerfromOppTeam ',ErrorDescription__c='Error at line 18',FunctionName__c='RemoveOpportunityPreviousOwnerfromOppTeam');
            insert apexLogRecord;   
        }   
    } 
}