//-----------------------------
// @author: Sonam Raju
// @date: 14 Sept 2017
// @param: NA
// @description: SFDC1-2068 Test class for RemoveOppPreviousOwnerfromOppTeam Class 
// @companyname : VERTIBA 
//-----------------------------

@isTest
    private class TestRemoveOppPreviousOwnerfromOppTeam {

    private static testMethod void testTestDeletionOppPreviousOwnerfromOppTeam() {
        Account acc = TestUtility.createTestAccount('Account testAccountforOpp', true);

        Opportunity testOpportunity1 = TestUtility.createOpportunity(acc.Id,'first test Oppy', false);
        testOpportunity1.Amount = 1000;
        insert testOpportunity1;

        OpportunityTeamMember otm = new OpportunityTeamMember(); 
        otm=[SELECT UserId FROM OpportunityTeamMember WHERE OpportunityId =: testOpportunity1.id AND (TeamMemberRole ='Opportunity Owner')];
        User newusr = TestUtility.createAdminUser('abc123@abc123xyz.com', true);

        testOpportunity1.OwnerID = newusr.id;
        update testOpportunity1;
        List<Opportunity> OppList = new  List<Opportunity> ();
        OppList.add(testOpportunity1);

        // If Process Builder is NOT Activated, we are calling the invocable method here directly
        RemoveOppPreviousOwnerfromOppTeam.RemoveOpportunityPreviousOwnerfromOppTeam(OppList);

        // If Process Builder is Activated, it will call the invocable method 
        OpportunityTeamMember updatedotm = new OpportunityTeamMember();
        updatedotm  = [SELECT UserId FROM OpportunityTeamMember WHERE OpportunityId =: testOpportunity1.id AND (TeamMemberRole ='Opportunity Owner')]; 
        System.assertEquals(newusr.id, updatedotm.UserId);
    }
}