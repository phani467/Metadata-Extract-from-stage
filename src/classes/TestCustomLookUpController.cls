/**
 * @Author: Paras Dhingra
 * @Date: 01st Nov 2017
 * @Description: SFDC1-692 test class for customLookUpController 
 * @company: IHS Markit
 */

@isTest
private class TestCustomLookUpController {

	private static testMethod void testFetchLookUpValues() {
	    //create test data
	    Account testAccount1 = TestUtility.createTestAccount('ABC account', true);
	    Account testAccount2 = TestUtility.createTestAccount('XYZ account', true);
	    List<Account> assertAccount = (List<Account>)customLookUpController.fetchLookUpValues('ABC', 'Account', null);
	    System.assertEquals(testAccount1.Name,assertAccount[0].Name ,'Assert Names');

	}

}