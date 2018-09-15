@isTest
private class TestInternalDataTabCE {
 
    public static testMethod void testInternalData() {
        InternalDataTabCE controller = new InternalDataTabCE();
        controller.wrf = TestUtility.newWRF();
        controller.wrfid = controller.wrf.Id;
        controller.reset();
        controller.add();
         controller.InternalDataList[0].ExpectedOutputQuanity__c='500';
         controller.InternalDataList[0].ManufacturerDivision__c='test';
        controller.save();
        List<InternalData__c> testlist = [select id from InternalData__c where WorkRequestForm__c=:controller.wrf.id];
        system.assert(testlist.size()==1,'ERROR SAVING Input Files');
        controller.delid=testlist[0].id;
        controller.DeleteAccount();
        List<InternalData__c> testlist2 = [select id from InternalData__c where WorkRequestForm__c=:controller.wrf.id];
        system.assert(testlist2.size()==0,'ERROR DELETING INput FIle');
        controller.getinternalData();
    }

    
}