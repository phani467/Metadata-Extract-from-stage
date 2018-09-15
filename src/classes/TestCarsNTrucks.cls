//-----------------------------
// @author: Legacy POLK Application
// @company: VERTIBA/POLK
// @date: 17 Oct 2017
// @param: 
// @description:  This class is used in POLK WRF.
// @return: NA
//----------------------------- 
@isTest
private class TestCarsNTrucks {
    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: 
    // @description:  This method is used in POLK WRF.
    // @return: NA
    //----------------------------- 
    public static testMethod void testCarsNTrucksMethod() {
        WorkRequestForm__c wrf = new WorkRequestForm__c();
        wrf.FormType__c = 'TLAS';
        wrf.CarAndLightTruckDisplay__c = ';;;;;;;;;;;;;;;;;;;;;;;;;';
        insert wrf;
        CarsNTrucks ct = new CarsNTrucks(wrf.CarAndLightTruckDisplay__c);
        ct.gethasValues();
        
    }
}