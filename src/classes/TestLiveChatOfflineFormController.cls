/*--------------------------------------------------------------------------------------------------------------------
    Author:        
    Company:       
    Description:   TestLiveChatOfflineFormController - test class for LiveChatOfflineFormController
    History
    07/01/2016     First Release
----------------------------------------------------------------------------------------------------------------------*/
@isTest
private class TestLiveChatOfflineFormController {
    // ensure Case inserted and redirection to confirmation page occurs
    static testMethod void testCaseCreation() {
        
                
        Account ac = TestUtility.createTestAccount('Test Pre Chat',true);
        Contact myContact1 = TestUtility.createContact(ac.Id, 'uttam.arya@test.com',true, 'Uttam', 'Arya');
        
        PageReference pageRef = Page.LiveChatOfflineForm;
        Test.setCurrentPage(pageRef);
        
        LiveChatOfflineFormController controller = new LiveChatOfflineFormController();
        controller.email = 'uttam.arya@test.com';
        controller.phone = '01234';
        controller.message = 'my comment';
        
        PageReference result = controller.submit();
        Case c = [select id from Case];
        System.assert(c != null);
        // verify that page fails without parameters
        System.assertEquals(Page.LiveChatConfirmation.getURL(), result.getURL().split('\\?')[0]);
    }
}