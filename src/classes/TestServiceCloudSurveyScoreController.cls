//-----------------------------------------------------------------
// @author: Uttam Arya
// @date: 9 Sept 2017
// @param: NA
// @description: SFDC1-442 Test Class for ServiceCloudSurveyScoreController
// @return: NA
// @author: Vishnu Vardhan
// @date: 18 Dec 2017
// @description: SFDC-6010: Response date was mandatory, because of which test case was failing. 
//				So, Fixed it.
//-----------------------------------------------------------------
@isTest
public class TestServiceCloudSurveyScoreController {
    public static testMethod void test1() {
        String oid = 'INC0101200';
        // create test Account
        Account ihsMarkitAccount = TestUtility.createTestAccountWithAddress('IHS Markit', 
                                                                            '4th floor Ropemaker Place, 25 Ropemaker Street',
                                                                            'London', '', 'GB', true);
        Contact myTestContact = TestUtility.createContact(ihsMarkitAccount.Id, 'TestServiceCloudSurveyScoreController@test.com', true, 'Test', 'Contact');
        // insert an case with an oid
        Case c = new Case (AccountId = ihsMarkitAccount.id, OIDTicket__c = oid, ContactId = myTestContact.Id);
        insert c;
        
        SurveyResponse__c sc = new SurveyResponse__c(Contact__c = myTestContact.Id, 
                                                     Account__c = ihsMarkitAccount.Id, 
                                                     SurveyType__c ='Customer Care', 
                                                     Case__c = c.Id,
                                                     Score__c = 9,
                                                     ResponseDate__c=System.today());
        
        insert sc;
        
        // check that the oid is retrieved in controller
        ServiceCloudSurveyScoreController controller = new ServiceCloudSurveyScoreController(new ApexPages.StandardController(c));
        System.assertEquals(controller.accountOID, oid);
    }
}