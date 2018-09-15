//-----------------------------
// @author: Legacy POLK Application
// @company: VERTIBA/POLK
// @date: 17 Oct 2017
// @param: 
// @description:  This method is used in POLK WRF.
// @return: NA
//----------------------------- 
@isTest
private class TestMotorCycle {
    static testmethod void testMotorCycle() {
        MotorCycle motorcycle = new MotorCycle('a;b;c;d;e;f;g;h;i;j');
        List<SelectOption> so = motorcycle.getMOTO();
        System.assertEquals(true, motorcycle.gethasValues());
        MotorCycle motorcycle2 = new MotorCycle();
        System.assertEquals(false, motorcycle2.gethasValues());
    }
}