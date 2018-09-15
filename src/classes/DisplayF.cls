//-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: 
    // @description:  This class is used in POLK WRF.
    // @return: NA
    //----------------------------- 
public with sharing class DisplayF { 
    
  
    public String DF1 {get; set;}    
    public String DF2 {get; set;}  
    public String DF3 {get; set;}  
    public String DF4 {get; set;}  
    public String DF5 {get; set;}  
    public String DF6 {get; set;}  
    public String DF7 {get; set;}  
    public String DF8 {get; set;}        
    public String DF9 {get; set;}
    public String DF10 {get; set;} 
    public String DF11 {get; set;}  
    public String DF12 {get; set;}  
    public String DF13 {get; set;}  
    public String DF14 {get; set;}  
    public String DF15 {get; set;}  
    public String DF16 {get; set;}  
    public String DF17 {get; set;}
    public String DF18 {get; set;}
    public String DF19 {get; set;}
    public String DF20 {get; set;}
    public String DF21 {get; set;}
    public String DF22 {get; set;}
    public String DF23 {get; set;}
    public String DF24 {get; set;}
    public String DF25 {get; set;}
    public String DF26 {get; set;}
    public String DF27 {get; set;}
    public String DF28 {get; set;}
    public String DF29 {get; set;}
    public String DF30 {get; set;}
    public String DF31 {get; set;}
    public String DF32 {get; set;}    
    private WorkRequestForm__c wrf = new WorkRequestForm__c();
    private  string FirstPickVal = '-None-';
    public Boolean gethasValues(){
        boolean b=false;
        if(FullDF<>'null;null;null;null;null;null;null;null;null;null;null;null;null;null;null;null;null;null;null;null;null;null;null;null;null;null;null;null;null;null;null;null'      
        //WRF FIX 11/11/2013 ELS
        ||FullDF<>';;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;'
        //END 
        ){b=true;}
        return b;
    }
    public String FullDF{
        get{
            return DF1 + ';' +     
            DF2 + ';' +  
            DF3 + ';' +  
            DF4 + ';' +  
            DF5 + ';' +  
            DF6 + ';' +  
            DF7 + ';' +  
            DF8 + ';' +         
            DF9 + ';' +
            DF10 + ';' + 
            DF11 + ';' +  
            DF12 + ';' +  
            DF13 + ';' +  
            DF14 + ';' +  
            DF15 + ';' +  
            DF16 + ';' + 
            DF17 + ';' +  
            DF18 + ';' +  
            DF19 + ';' +  
            DF20 + ';' +  
            DF21 + ';' +
            DF22 + ';' +
            DF23 + ';' +
            DF24 + ';' +
            DF25 + ';' +           
            DF26 + ';' +
            DF27 + ';' +
            DF28 + ';' +                                
            DF29 + ';' +                
            DF30 + ';' +
            DF31 + ';' +
            DF32;}
     private set;
    }
    public DisplayF(){
    }
    public DisplayF(String c){
        
         //WRF index issue fix - ELS 11/11/2013
            if (c == ';;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;'){
           //System.debug('The 1 value is: ' + c);
            c = 'null;null;null;null;null;null;null;null;null;null;null;null;null;null;null;null;null;null;null;null;null;null;null;null;null;null;null;null;null;null;null;null';
            //System.debug('The 2 value is: ' + c);                
            } else {        
            //System.debug('The 3 value is: ' + c);
            c = c.replaceAll(';;', ';null;');
              //System.debug('The 4 value is: ' + c);
             if (c.startsWith(';')){c= 'null'+c;   }
              //System.debug('The 5 value is: ' + c); 
               c = c.replaceAll(';;', ';null;');
             //System.debug('The 6 value is: ' + c);
             if (c.endsWith(';') ){c = c + 'null';  }
              //System.debug('The 7 value is: ' + c);
            }
        // 11/11/13 END
        
        
        
        //Split array is 0-index
        String[] clist = c.split(';');
        DF1=clist[0];
        DF2=clist[1];
        DF3=clist[2];
        DF4=clist[3];
        DF5=clist[4];
        DF6=clist[5];
        DF7=clist[6];
        DF8=clist[7];       
        DF9=clist[8];
        DF10=clist[9];
        DF11=clist[10];
        DF12=clist[11];
        DF13=clist[12];
        DF14=clist[13];
        DF15=clist[14];
        DF16=clist[15];
        DF17=clist[16];
        DF18=clist[17];
        DF19=clist[18];
        DF20=clist[19];
        DF21=clist[20];
        DF22=clist[21];
        DF23=clist[22];
        DF24=clist[23];
        DF25=clist[24];
        DF26=clist[25];
        DF27=clist[26];
        DF28=clist[27];
        DF29=clist[28];
        DF30=clist[29];
        if(clist.size()>30){
            DF31=clist[30];                                    
            DF32=clist[31];
        }
    }
    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: 
    // @description:  This method is used in POLK WRF.
    // @return: NA
    //----------------------------- 
    public  List<SelectOption> getDF(){
        return XedeUtility.getPickValues(wrf, 'DisplayField0__c', FirstPickVal);
        
    }
    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: 
    // @description:  This method is used in POLK WRF.
    // @return: NA
    //----------------------------- 
    public  List<SelectOption> getC1(){
        List<SelectOption> tmpSO=new List<SelectOption>();
        tmpSO.add(new SelectOption('','-None-'));
        tmpSO.add(new SelectOption('Geo Code','Geo Code'));
        tmpSO.add(new SelectOption('Geo Name','Geo Name'));
        return tmpSO;
    }
    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: 
    // @description:  This method is used in POLK WRF.
    // @return: NA
    //-----------------------------  
    public  List<SelectOption> getC2(){
        List<SelectOption> tmpSO=new List<SelectOption>();
        tmpSO.add(new SelectOption('','-None-'));
        tmpSO.add(new SelectOption('Geo Code','Geo Code'));
        tmpSO.add(new SelectOption('Geo Name','Geo Name'));
        return tmpSO;
    }
    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: 
    // @description:  This method is used in POLK WRF.
    // @return: NA
    //----------------------------- 
    public  List<SelectOption> getC3(){
        List<SelectOption> tmpSO=new List<SelectOption>();
        tmpSO.add(new SelectOption('Make Model Code','Make Model Code'));
        return tmpSO;
    }
    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: 
    // @description:  This method is used in POLK WRF.
    // @return: NA
    //----------------------------- 
    public  List<SelectOption> getC4(){
        List<SelectOption> tmpSO=new List<SelectOption>();
        tmpSO.add(new SelectOption('Vehicle Category','Vehicle Category'));
        return tmpSO;
    }
    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: 
    // @description:  This method is used in POLK WRF.
    // @return: NA
    //-----------------------------   
    public  List<SelectOption> getC5(){
        List<SelectOption> tmpSO=new List<SelectOption>();
        tmpSO.add(new SelectOption('Veh Segment(US Only)','Veh Segment(US Only)'));
        return tmpSO;
    } 
    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: 
    // @description:  This method is used in POLK WRF.
    // @return: NA
    //-----------------------------  
    public  List<SelectOption> getC6(){
        List<SelectOption> tmpSO=new List<SelectOption>();
        tmpSO.add(new SelectOption('Year Model-Broken Out','Year Model-Broken Out'));
        return tmpSO;
    }
    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: 
    // @description:  This method is used in POLK WRF.
    // @return: NA
    //-----------------------------   
    public  List<SelectOption> getC7(){
        List<SelectOption> tmpSO=new List<SelectOption>();
        tmpSO.add(new SelectOption('Make','Make'));
        return tmpSO;
    }
    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: 
    // @description:  This method is used in POLK WRF.
    // @return: NA
    //-----------------------------   
    public  List<SelectOption> getC8(){
        List<SelectOption> tmpSO=new List<SelectOption>();
        tmpSO.add(new SelectOption('Model','Model'));
        return tmpSO;
    } 
    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: 
    // @description:  This method is used in POLK WRF.
    // @return: NA
    //-----------------------------  
    public  List<SelectOption> getC9(){
        List<SelectOption> tmpSO=new List<SelectOption>();
        tmpSO.add(new SelectOption('Trim Level','Trim Level'));
        return tmpSO;
    }
    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: 
    // @description:  This method is used in POLK WRF.
    // @return: NA
    //-----------------------------   
    public  List<SelectOption> getC10(){
        List<SelectOption> tmpSO=new List<SelectOption>();
        tmpSO.add(new SelectOption('Drive Wheels','Drive Wheels'));
        return tmpSO;
    }
    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: 
    // @description:  This method is used in POLK WRF.
    // @return: NA
    //-----------------------------   
    public  List<SelectOption> getC11(){
        List<SelectOption> tmpSO=new List<SelectOption>();
        tmpSO.add(new SelectOption('Body Style','Body Style'));
        return tmpSO;
    }
    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: 
    // @description:  This method is used in POLK WRF.
    // @return: NA
    //-----------------------------   
    public  List<SelectOption> getC12(){
        List<SelectOption> tmpSO=new List<SelectOption>();
        tmpSO.add(new SelectOption('Tire Size','Tire Size'));
        return tmpSO;
    }
    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: 
    // @description:  This method is used in POLK WRF.
    // @return: NA
    //-----------------------------   
    public  List<SelectOption> getC13(){
        List<SelectOption> tmpSO=new List<SelectOption>();
        tmpSO.add(new SelectOption('Prefix','Prefix'));
        return tmpSO;
    }
    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: 
    // @description:  This method is used in POLK WRF.
    // @return: NA
    //-----------------------------   
    public  List<SelectOption> getC14(){
        List<SelectOption> tmpSO=new List<SelectOption>();
        tmpSO.add(new SelectOption('Without P','Without P'));
        return tmpSO;
    }
    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: 
    // @description:  This method is used in POLK WRF.
    // @return: NA
    //-----------------------------   
    public  List<SelectOption> getC15(){
        List<SelectOption> tmpSO=new List<SelectOption>();
        tmpSO.add(new SelectOption('Without P Speed Load','Without P Speed Load'));
        return tmpSO;
    }
    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: 
    // @description:  This method is used in POLK WRF.
    // @return: NA
    //-----------------------------   
    public  List<SelectOption> getC16(){
        List<SelectOption> tmpSO=new List<SelectOption>();
        tmpSO.add(new SelectOption('Speed Rate','Speed Rate'));
        return tmpSO;
    }
    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: 
    // @description:  This method is used in POLK WRF.
    // @return: NA
    //-----------------------------   
    public  List<SelectOption> getC17(){
        List<SelectOption> tmpSO=new List<SelectOption>();
        tmpSO.add(new SelectOption('Speed Code','Speed Code'));
        return tmpSO;
    }
    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: 
    // @description:  This method is used in POLK WRF.
    // @return: NA
    //-----------------------------   
    public  List<SelectOption> getC18(){
        List<SelectOption> tmpSO=new List<SelectOption>();
        tmpSO.add(new SelectOption('Load Index','Load Index'));
        return tmpSO;
    }
    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: 
    // @description:  This method is used in POLK WRF.
    // @return: NA
    //-----------------------------   
    public  List<SelectOption> getC19(){
        List<SelectOption> tmpSO=new List<SelectOption>();
        tmpSO.add(new SelectOption('Brand','Brand'));
        return tmpSO;
    }
    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: 
    // @description:  This method is used in POLK WRF.
    // @return: NA
    //-----------------------------   
    public  List<SelectOption> getC20(){
        List<SelectOption> tmpSO=new List<SelectOption>();
        tmpSO.add(new SelectOption('Article A','Article A'));
        return tmpSO;
    }//-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: 
    // @description:  This method is used in POLK WRF.
    // @return: NA
    //-----------------------------   
    public  List<SelectOption> getC21(){
        List<SelectOption> tmpSO=new List<SelectOption>();
        tmpSO.add(new SelectOption('Market Line A','Market Line A'));
        return tmpSO;
    }  
    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: 
    // @description:  This method is used in POLK WRF.
    // @return: NA
    //----------------------------- 
    public  List<SelectOption> getC22(){
        List<SelectOption> tmpSO=new List<SelectOption>();
        tmpSO.add(new SelectOption('Article B','Article B'));
        return tmpSO;
    }  
    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: 
    // @description:  This method is used in POLK WRF.
    // @return: NA
    //----------------------------- 
    public  List<SelectOption> getC23(){
        List<SelectOption> tmpSO=new List<SelectOption>();
        tmpSO.add(new SelectOption('Market Line B','Market Line B'));
        return tmpSO;
    }  
    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: 
    // @description:  This method is used in POLK WRF.
    // @return: NA
    //----------------------------- 
    public  List<SelectOption> getC24(){
        List<SelectOption> tmpSO=new List<SelectOption>();
        tmpSO.add(new SelectOption('Article C','Article C'));
        return tmpSO;
    }  
    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: 
    // @description:  This method is used in POLK WRF.
    // @return: NA
    //----------------------------- 
    public  List<SelectOption> getC25(){
        List<SelectOption> tmpSO=new List<SelectOption>();
        tmpSO.add(new SelectOption('Market Line C','Market Line C'));
        return tmpSO;
    }  
    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: 
    // @description:  This method is used in POLK WRF.
    // @return: NA
    //----------------------------- 
    public  List<SelectOption> getC26(){
        List<SelectOption> tmpSO=new List<SelectOption>();
        tmpSO.add(new SelectOption('Article D','Article D'));
        return tmpSO;
    }  
    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: 
    // @description:  This method is used in POLK WRF.
    // @return: NA
    //----------------------------- 
    public  List<SelectOption> getC27(){
        List<SelectOption> tmpSO=new List<SelectOption>();
        tmpSO.add(new SelectOption('Market Line D','Market Line D'));
        return tmpSO;
    } 
     //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: 
    // @description:  This method is used in POLK WRF.
    // @return: NA
    //----------------------------- 
    public  List<SelectOption> getC28(){
        List<SelectOption> tmpSO=new List<SelectOption>();
        tmpSO.add(new SelectOption('Article E','Article E'));
        return tmpSO;
    }
    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: 
    // @description:  This method is used in POLK WRF.
    // @return: NA
    //-----------------------------   
    public  List<SelectOption> getC29(){
        List<SelectOption> tmpSO=new List<SelectOption>();
        tmpSO.add(new SelectOption('Market Line E','Market Line E'));
        return tmpSO;
    } 
    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: 
    // @description:  This method is used in POLK WRF.
    // @return: NA
    //-----------------------------  
    public  List<SelectOption> getC30(){
        List<SelectOption> tmpSO=new List<SelectOption>();
        tmpSO.add(new SelectOption('Article F','Article F'));
        return tmpSO;
    }
    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: 
    // @description:  This method is used in POLK WRF.
    // @return: NA
    //-----------------------------   
    public  List<SelectOption> getC31(){
        List<SelectOption> tmpSO=new List<SelectOption>();
        tmpSO.add(new SelectOption('Market Line F','Market Line F'));
        return tmpSO;
    } 
    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: 
    // @description:  This method is used in POLK WRF.
    // @return: NA
    //-----------------------------  
    public  List<SelectOption> getC32(){
        List<SelectOption> tmpSO=new List<SelectOption>();
        tmpSO.add(new SelectOption('Total Count','Total Count'));
        return tmpSO;
    }  
  
    
}