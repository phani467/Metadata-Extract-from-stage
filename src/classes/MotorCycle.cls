//-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: 
    // @description:  This classis used in POLK WRF.
    // @return: NA
    //----------------------------- 
public with sharing class MotorCycle {
    
    public String MC1 { get; set; }    
    public String MC2 { get; set; }  
    public String MC3 { get; set; }  
    public String MC4 { get; set; }  
    public String MC5 { get; set; }  
    public String MC6 { get; set; }  
    public String MC7 { get; set; }  
    public String MC8 { get; set; }        
    public String MC9 { get; set; }
    public String MC10 { get; set; } 
    private WorkRequestForm__c wrf = new WorkRequestForm__c();
    private  string FirstPickVal = '-None-';
    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: 
    // @description:  This method is used in POLK WRF.
    // @return: NA
    //----------------------------- 
    public List<SelectOption> getMOTO() {
        return XedeUtility.getPickValues(wrf, 'Motorcycle0__c', FirstPickVal);
        
    }    
    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: 
    // @description:  This method is used in POLK WRF.
    // @return: NA
    //-----------------------------                                                                                             
    public Boolean gethasValues() {
        boolean b=false;
        if(FullMC<>'null;null;null;null;null;null;null;null;null;null'){b=true;}
        return b;
    }
    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: 
    // @description:  This method is used in POLK WRF.
    // @return: NA
    //----------------------------- 
    public String FullMC {
        get {
            return MC1 + ';' +     
            MC2 + ';' +  
            MC3 + ';' +  
            MC4 + ';' +  
            MC5 + ';' +  
            MC6 + ';' +  
            MC7 + ';' +  
            MC8 + ';' +         
            MC9 + ';' +
            MC10;
        }
        private set;
    }
    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: 
    // @description:  This method is used in POLK WRF.
    // @return: NA
    //----------------------------- 
    public MotorCycle() {
    
    }
    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: 
    // @description:  This method is used in POLK WRF.
    // @return: NA
    //----------------------------- 
    public MotorCycle(String c) {
        String[] clist = c.split(';');
        MC1=clist[0];
        MC2=clist[1];
        MC3=clist[2];
        MC4=clist[3];
        MC5=clist[4];
        MC6=clist[5];
        MC7=clist[6];
        MC8=clist[7];       
        MC9=clist[8];
        MC10=clist[9];
    } 
    
    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: 
    // @description:  This method is used in POLK WRF.
    // @return: NA
    //----------------------------- 
    /*
    static testmethod void testMotorCycle() {
        MotorCycle motorcycle = new MotorCycle('a;b;c;d;e;f;g;h;i;j');
        List<SelectOption> so = motorcycle.getMOTO();
        System.assertEquals(true, motorcycle.gethasValues());
        MotorCycle motorcycle2 = new MotorCycle();
        System.assertEquals(false, motorcycle2.gethasValues());
    }*/
    
}