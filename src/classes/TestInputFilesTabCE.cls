//-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: 
    // @description:  This test class is used in POLK WRF.
    // @return: NA
    //----------------------------- 
@isTest
private class TestInputFilesTabCE {
    
    public static testMethod void testInputFiles() {
        InputFilesTabCE controller = new InputFilesTabCE();
        controller.wrf = TestUtility.newWRF();
        controller.wrfid = controller.wrf.Id;
        controller.reset();
        controller.add();
         controller.InputFileList[0].NumberofRecords__c=500;
         controller.InputFileList[0].AdditionalInformation__c='test';
        controller.save();
        List<InputFile__c> testlist = [select id from InputFile__c where WorkRequestForm__c=:controller.wrf.id];
        system.assert(testlist.size()==1,'ERROR SAVING Input Files');
        controller.delid=testlist[0].id;
        controller.DeleteAccount();
        List<InputFile__c> testlist2 = [select id from InputFile__c where WorkRequestForm__c=:controller.wrf.id];
        system.assert(testlist2.size()==0,'ERROR DELETING INput FIle');
        controller.getinputFiles();
    }
   
    
}