//-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: 
    // @description:  This classis used in POLK WRF.
    // @return: NA
    //----------------------------- 
public class CountrySelectorPageController {
    public String requestType {get; set;}
    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: 
    // @description:  This method is used in POLK WRF.
    // @return: NA
    //----------------------------- 
    public CountrySelectorPageController() {
        requestType = ApexPages.currentPage().getParameters().get('rt');
    }
}