//-----------------------------
// @author: Legacy POLK Application
// @company: VERTIBA/POLK
// @date: 17 Oct 2017
// @param: 
// @description:  This classis used in POLK WRF.
// @return: NA
//----------------------------- 
public with sharing class CarsNTrucks { 

    public String CLT1 { get; set; }    
    public String CLT2 { get; set; }  
    public String CLT3 { get; set; }  
    public String CLT4 { get; set; }  
    public String CLT5 { get; set; }  
    public String CLT6 { get; set; }  
    public String CLT7 { get; set; }  
    public String CLT8 { get; set; }        
    public String CLT9 { get; set; }
    public String CLT10 { get; set; } 
    public String CLT11 { get; set; }  
    public String CLT12 { get; set; }  
    public String CLT13 { get; set; }  
    public String CLT14 { get; set; }  
    public String CLT15 { get; set; }  
    public String CLT16 { get; set; }  
    public String CLT17 { get; set; }
    public String CLT18 { get; set; }
    public String CLT19 { get; set; }
    public String CLT20 { get; set; }
    public String CLT21 { get; set; }
    public String CLT22 { get; set; }
    public String CLT23 { get; set; }
    public String CLT24 { get; set; }
    public String CLT25 { get; set; }
    public String CLT26 { get; set; }
    private WorkRequestForm__c wrf = new WorkRequestForm__c();

    public Boolean gethasValues() {
        boolean b=false;
        if(FullCLT<>'null;null;null;null;null;null;null;null;null;null;null;null;null;null;null;null;null;null;null;null;null;null;null;null;null;null'
         //WRF index issue troubleshooting - ELS 11/11/2013
        && FullCLT<>';;;;;;;;;;;;;;;;;;;;;;;;;'
        // 11/11/13 END
        
        ){ b=true; }
        return b;
    }                                                                                     
    public String FullCLT {
        get {
            return CLT1 + ';' +     
            CLT2 + ';' +  
            CLT3 + ';' +  
            CLT4 + ';' +  
            CLT5 + ';' +  
            CLT6 + ';' +  
            CLT7 + ';' +  
            CLT8 + ';' +         
            CLT9 + ';' +
            CLT10 + ';' + 
            CLT11 + ';' +  
            CLT12 + ';' +  
            CLT13 + ';' +  
            CLT14 + ';' +  
            CLT15 + ';' +  
            CLT16 + ';' + 
            CLT17 + ';' +  
            CLT18 + ';' +  
            CLT19 + ';' +  
            CLT20 + ';' +  
            CLT21 + ';' +
            CLT22 + ';' +
            CLT23 + ';' +
            CLT24 + ';' +
            CLT25 + ';' +           
            CLT26;}
     private set;
    }
    public CarsNTrucks(){
     
    }
    public CarsNTrucks(String c) {

       
       //WRF index issue troubleshooting - ELS 11/11/2013
        if (c == ';;;;;;;;;;;;;;;;;;;;;;;;;') {
			//System.debug('The 1 value is: ' + c);
			c = 'null;null;null;null;null;null;null;null;null;null;null;null;null;null;null;null;null;null;null;null;null;null;null;null;null;null';
			//System.debug('The 2 value is: ' + c);       
        } else {    
			//System.debug('The 3 value is: ' + c);
			c = c.replaceAll(';;', ';null;');
            //System.debug('The 4 value is: ' + c);
         if (c.startsWith(';')) {c= 'null'+c;   }
            //System.debug('The 5 value is: ' + c); 
            c = c.replaceAll(';;', ';null;');
            //System.debug('The 6 value is: ' + c);
         if (c.endsWith(';') ) {c = c + 'null';  }
            //System.debug('The 7 value is: ' + c);
        }
        // 11/11/13 END
  
  
        String[] clist = c.split(';');      
        
        CLT1=clist[0];
        CLT2=clist[1];
        CLT3=clist[2];
        CLT4=clist[3];
        CLT5=clist[4];
        CLT6=clist[5];
        CLT7=clist[6];
        CLT8=clist[7];       
        CLT9=clist[8];
        CLT10=clist[9];
        CLT11=clist[10];
        CLT12=clist[11];
        CLT13=clist[12];
        CLT14=clist[13];
        CLT15=clist[14];
        CLT16=clist[15];
        CLT17=clist[16];
        CLT18=clist[17];
        CLT19=clist[18];
        CLT20=clist[19];
        CLT21=clist[20];
        CLT22=clist[21];
        CLT23=clist[22];
        CLT24=clist[23];
        CLT25=clist[24];
        CLT26=clist[25];
    }    
}