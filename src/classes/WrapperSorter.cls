//-------------------------------------
//@Author: Sruti Srivastava
//@Date: 24 July 2018
//@Description: SFDC1-5233- It sorts wrapper class. Called from ViewEntitlementsController
//@companyname: VERTIBA 
//-------------------------------------
public class WrapperSorter implements Comparable {
    public ViewEntitlementsController.ProductLicenseWrapper objProductLicenseWrapper;
    public ViewEntitlementsController.ProductUsageSummary objProductUsageSummary;
    
    public WrapperSorter(ViewEntitlementsController.ProductLicenseWrapper objProductLicenseWrapper) {
        this.objProductLicenseWrapper = objProductLicenseWrapper;
    }
    public WrapperSorter(ViewEntitlementsController.ProductUsageSummary objProductUsageSummary) {
        this.objProductUsageSummary = objProductUsageSummary;
    }
    //-------------------------------------
    //@Author: Sruti Srivastava
    //@Date: 24 July 2018
    //@param: Object to compare to
    //@Description: SFDC1-5233- Compares values
    //@return: Integer
    //-------------------------------------    
    public Integer compareTo(Object compareTo) {
        WrapperSorter compareToEmp = (WrapperSorter)compareTo;
        if(this.objProductLicenseWrapper != null && !String.isBlank(this.objProductLicenseWrapper.productName)) {
            if (this.objProductLicenseWrapper.productName == compareToEmp.objProductLicenseWrapper.productName) return 0;
            if (this.objProductLicenseWrapper.productName > compareToEmp.objProductLicenseWrapper.productName) return 1;  
        }
        if(this.objProductUsageSummary != null && !String.isBlank(this.objProductUsageSummary.ContactName)) {
            if (this.objProductUsageSummary.ContactName == compareToEmp.objProductUsageSummary.ContactName) return 0;
            if (this.objProductUsageSummary.ContactName > compareToEmp.objProductUsageSummary.ContactName) return 1;  
        }
        return -1;
    }
}