//-----------------------------
// @author: Jagadesh Kumar
// @date: 31 July 2018
// @param: NA
// @description: Test Class for BatchUpdateOpportunityPrimaryContact
// @return: NA
//----------------------------
@isTest
private class TestBatchUpdateOpportunityPrimaryContact {

    static testMethod void testUpdateOppyPrimaryContactScheduledApex() {
        test.startTest();
        Account acc = TestUtility.createTestAccount('BARCLAYS PLC',true);
        Contact con = TestUtility.createContact(acc.Id,'oppty.primary@ihsmarkit.com',true,'TestOppty','TestPrimary');
        Opportunity opp = TestUtility.createOpportunity(acc.id, 'BARCLAYS Opp',null,true);
        OpportunityContactRole ocr = new OpportunityContactRole(IsPrimary = true, OpportunityId = opp.Id, ContactId=con.Id);
        insert ocr;
        String jobId = system.schedule('TestBatchUpdateOpportunityPrimaryContact', '0 0 0 3 9 ? 2022' , new BatchUpdateOpportunityPrimaryContact());
        BatchUpdateOpportunityPrimaryContact BUpdate = new BatchUpdateOpportunityPrimaryContact();
        BUpdate.query = 'Select ID,PrimaryContact__c from Opportunity where Id=\''+opp.Id+'\'';
        BUpdate.errorMsgs = 'Test';
        ID batchprocessid = Database.executeBatch(BUpdate, 1);
        Test.stopTest();
        Opportunity op = [Select ID,PrimaryContact__c from Opportunity where Id =: opp.Id];
        System.assertEquals('TestOppty TestPrimary', op.PrimaryContact__c); 
    }
}