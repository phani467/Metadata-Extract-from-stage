//-----------------------------
// @author: Vinod Merwade
// @date: 10 Oct 2017
// @param: NA
// @description: SFDC1-550 Test class for SubmitToSalesProcessController
// @return: NA
// @Company: Vertiba
// @Last Modified By : Hemant Shukla
// @Last Modified Description : Removed the dependency of ContractExists__c field based on SFDC1-5701
// @Last Modified Date : 6-Nov-2017
// @lastModifiedBy: Vishnu
// @LastModifiedDate: 29 Mar 2018
// @LastModifiedDescription: SFDC1-7721: Internal__C was used to indicate if a product group was part of Internal Case
// 						  record type, Since that record type is deleted, we are removing fields used specifically for it
// 						  
// 						  
// @Last Modified By : Vishnu Vardhan Chowdary Andra
// @Last Modified Date: 08 Aug 2018
// @Last Modified Description: Code is deleted/commented out as part of stories SFDC1-9677/78/80/81/82/83/84.
// 		Accordingly commenting out test class. 
//-----------------------------
@isTest
public class TestSubmitToSalesProcessController {
    //-----------------------------
    // @author: Vinod Merwade
    // @date: 19 July 2017
    // @param: NA
    // @description:SFDC1-550 Test method for SubmitToSalesProcessController
    // @return: NA
    // @Company: Vertiba
    //-----------------------------
    private static testmethod void testSubmitSalesprocess() {
        /*Account testAccount = TestUtility.createTestAccount('testAccount', false);
        testAccount.Type = 'Place Holder - General Service Account';
        insert testAccount;
        Country__c country = (Country__c)TestUtility.loadCountryData().get(0);
        opportunity opp = TestUtility.createOpportunity(testAccount.id, 'Test opportunity',country.id,true);
          // Commented By : Mohit : 16Oct2017 : as this field is in Deletion List and replaced by Formula field.
          //opp.SalesRegion__c = 'APAC';
        opp.ContractStartDate__c = System.today();
        opp.ContractEndDate__c = System.today();
        opp.ActivityCreated__c = true;
        opp.ReadyForProcessingContractExist__c  = true;
        update opp;
        contact cont = new contact (
            Email = 'false@ihsmarkit.com', 
            Phone = '1234567890',
            LastName ='TestLastName',
            FirstName='TestFirstName'
        );
        insert cont;
        OpportunityContactRole oppContactPrimary = new OpportunityContactRole();
        oppContactPrimary.OpportunityID = opp.Id;
        oppContactPrimary.IsPrimary = TRUE;
        oppContactPrimary.ContactId = cont.Id;  
        Insert oppContactPrimary;
        ProductGroup__c prdGrp = new ProductGroup__c(
            Name = 'Sales Ops'
            //Internal__c = true
        );
        insert prdGrp;
        
        Boolean flag =SubmitToSalesProcessController.regionExist(opp.Id);
        if(flag) {
            Id caseId = SubmitToSalesProcessController.submitToSalesProcessingQueue(opp.Id);
            system.debug('caseid============'+caseId);
            system.assert(caseId != NULL);
        }*/
    }
}