//-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: 
    // @description:  This method is used in POLK WRF.
    // @return: NA
    //----------------------------- 
public with sharing class WRFRedirectCE {
    
    public String formType { get; set; }
    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: ApePages.StandardController
    // @description:  This method is used in POLK WRF.
    // @return: NA
    //----------------------------- 
    public WRFRedirectCE(ApexPages.StandardController controller) {
        
        if(!test.isRunningTest())
            controller.addFields(XedeUtility.wrfFields());
        
        WorkRequestForm__c wrf=(WorkRequestForm__c)controller.getRecord();
        
        formType = wrf.formtype__c;
    }
    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: 
    // @description:  This method is used in POLK WRF.
    // @return: Pagereference
    //----------------------------- 
    public PageReference redirect() {
        Set<String> pageTwoFormTypes = new Set<String>{ 'Recall', 'Aftermarket', 'NewUsed Registration', 'Australia', 'APAC' };
            
        PageReference targetPage = pageTwoFormTypes.contains(formType)? Page.WREdit2 : Page.WREdit1;
        
        for (String eachKey : ApexPages.currentPage().getParameters().keySet())
            targetPage.getParameters().put(eachKey, ApexPages.currentPage().getParameters().get(eachKey));
        
        targetPage.setRedirect(true);
        
        return targetPage;
    }
     
}