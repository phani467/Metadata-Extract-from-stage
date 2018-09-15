/******************************************************
* @author Ankita Singh
* @date 10thOct 2017
* @description Test class for unit testing on WRFRedirectCE
******************************************************/

@isTest(seeAllData=false)
private class TestWRFRedirectCE {  
    
    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: 
    // @description:  This method is used in POLK WRF.
    // @return: NA
    //----------------------------- 
    public static testMethod void testWRF() {
        
        WorkRequestForm__c newWrf = new WorkRequestForm__c();
        newWrf.FormType__c = 'TLAS';
        upsert newWrf;
        ApexPages.StandardController controller = new ApexPages.StandardController(newWrf);       
        WRFRedirectCE con = new WRFRedirectCE(controller);
        con.formType = newWrf.FormType__c;
        con.redirect();
        
    }
    
}