//---------------------------------
// @author: Paras Dhingra
// @date: 15th Mar 2018
// @Description: SFDC1-7564 test class for TestOutBoundEmailTracking
// @Company: IHS Markit
//---------------------------------
@isTest
private class TestOutBoundEmailTracking {

	private static testMethod void testHandleInboundEmail() {
        //create test data
        Account testAccount  = TestUtility.createTestAccount('Test Account', true);
        // create a new email and envelope object
        Messaging.InboundEmail email = new Messaging.InboundEmail() ;
        Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
        list <String> toAddress = new list <String>();      
        toAddress.add('testemail@testmail.com');
        toAddress.add('uttam.arya@testmarkit.com');
        String accountID = (string)testAccount.Id; 
        // setup the data for the email
        email.subject = 'Test Job Applicant';
        email.fromname = 'FirstName LastName';
        email.toAddresses = toAddress;
        email.htmlBody = '<p>This is just a testing</p> <br/> <p>[RECID:'+accountID+'] </p>';
        
        env.fromAddress = 'paras.dhingra@testihsmarkit.com';
        env.toAddress = 'paras.dhingra@testmarkit.com';
        //start testing
        Test.startTest();
        OutBoundEmailTracking trackerObj = new OutBoundEmailTracking();
        Messaging.InboundEmailResult emailSuccess = trackerObj.handleInboundEmail(email, env);    
        System.assert(emailSuccess.success);
        //assert email message was created
        EmailMessage emailMsg = [Select Id from EmailMessage where relatedToId =:accountID and subject=:email.subject];
        System.assertNotEquals(null,emailMsg);
        
        //check for plainTextBody
        email.plainTextBody = 'This is just a testing[RECID:'+accountID+']';
        email.htmlBody = null;
        emailSuccess = trackerObj.handleInboundEmail(email, env);   
        System.assert(emailSuccess.success);
        Test.stopTest();
        //stop testing
        
	}

}