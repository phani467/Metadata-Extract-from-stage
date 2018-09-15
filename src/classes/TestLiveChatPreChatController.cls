//-----------------------------
// @author: Uttam Arya
// @date: 22 June 2017
// @param: NA
// @description: SFDC1-834 TestLiveChatOfflineFormController - test class for LiveChatPreChatController
// @return: NA
//-----------------------------
@isTest
private class TestLiveChatPreChatController {
    // ensure Chat_Survey__c inserted and redirection to confirmation page occurs
    static testMethod void test1() {
        
        Account ac = TestUtility.createTestAccount('Test Pre Chat',true);
        
        Contact myContact1 = TestUtility.createContact(ac.Id, 'uttam.arya@test.com',true, 'Uttam', 'Arya');
        
        PageReference pageRef = Page.LiveChatPreChat;
        
        Test.setCurrentPage(pageRef);

        LiveChatPreChatController controller = new LiveChatPreChatController();
        
        controller.suppliedemail = 'uttam.arya@test.com';
        
        Contact assertCon = LiveChatPreChatController.getContact(controller.suppliedemail);
        
        System.assertEquals(myContact1.Id, assertCon.Id);
    }
}