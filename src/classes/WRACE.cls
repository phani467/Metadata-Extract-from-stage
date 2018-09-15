//------------------------------------------------
// @author: Legacy POLK Application
// @company: VERTIBA/POLK
// @date: 17 Oct 2017
// @param: ApexPages.StandardController
// @description:  This Class is used in POLK WRF.
// @return: 
// @Last Updated: 11/14 - Anjani Shukla: Fixed Edit, Close and Cancel for Lightning readiness
//                               Removed hardcoding from Cancel and Close buttons.
//------------------------------------------------ 

public with sharing class WRACE {
    
    public WorkRequestForm__c wrf { get; set; }
    public string formtype { get; set; }
    public string buttonValue { get; set; }
    public Opportunity o { get; set; }
    public Boolean isCloned;
    public String jobtype { get; set; }
    public String oid { get; set; }
    public CarsNTrucks CNT { get; set; }
    public MotorCycle MC { get; set; }
    public DisplayF DF { get; set; }
    public String retURL { get; set; }
    public String saveNewURL { get; set; }
    public String URLID { get; set; }
    public String testform { get; set; }
    public boolean editapproved { get { return XedeUtility.editApproved(); } }
    public boolean editDUC { get { return XedeUtility.editDUC(); } }
    public boolean editSymbol { get { return XedeUtility.editSymbol(); } }
    public boolean editMode { get; set; }
    public boolean v=false;
    private ApexPages.StandardController con;
    public String urltogetPageMode2;
    
    public Integer PNS {  
        get {
            integer tmpPNS;
            if(wrf.NOC__c) {
                tmpPNS=2;
            } else { 
                tmpPNS=1;
            }
            return tmpPNS;
        }
        set {
            PNS=value;
            if(value==1) {
                wrf.PartsService__c=true;
            } else {
                wrf.NOC__c=true;
            }
        }
    }
    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: 
    // @description:  This method is used in POLK WRF.
    // @return: Integer
    //----------------------------- 
    public Integer SS {
        get {
            integer tmpSS;
            if(wrf.VINA__c) { 
                tmpSS=1;
            }
            if(wrf.VIS__c) { 
                tmpSS=2;
            }
            if(wrf.CVINA__c) { 
                tmpSS=3;
            }
            // cvina_flat_file__c is decomissioned, was #4
            if(wrf.PCVINA__c) { 
                tmpSS=5;
            }
            if(wrf.PCVIS__c) { 
                tmpSS=6;
            }
            if(wrf.PCCVINA__c) { 
                tmpSS=7;
            }
            if(wrf.CompletePrefixFile__c) { 
                tmpSS=8;
            }
            if(wrf.MINICPF__c) { 
                tmpSS=9;
            }
            if(wrf.VINPrefixFile__c) {
                tmpSS=10;
            }
            if(wrf.VINPrice__c) {
                tmpSS=11;
            }
            if(wrf.VINTelligence__c) {
                tmpSS=12;
            }
            if(wrf.Recover__c) {
                tmpSS=13;
            }
            if(wrf.FleetFind__c) {
                tmpSS=14;}
            if(wrf.VOS__c) {
                tmpSS=15;
            }
            if(wrf.VINVerification__c) {
                tmpSS=16;
            }
            if(wrf.Custom__c) { 
                tmpSS=17;
            }
            return tmpSS;
        }
        set {
            SS=value;
            wrf.VINA__c=false;
            wrf.VIS__c=false;
            wrf.CVINA__c=false;
            wrf.PCVINA__c=false;
            wrf.PCVIS__c=false;
            wrf.PCCVINA__c=false;
            wrf.CompletePrefixFile__c=false;
            wrf.MINICPF__c=false;
            wrf.VINPrefixFile__c=false;
            wrf.VINPrice__c=false;
            wrf.VINTelligence__c=false;
            wrf.Recover__c=false;
            wrf.FleetFind__c=false;
            wrf.VOS__c=false;
            wrf.VINVerification__c=false;
            wrf.Custom__c=false;
            if(value==1) {
                wrf.VINA__c=true;
            }
            if(value==2) {
                wrf.VIS__c=true;
            }
            if(value==3) {
                wrf.CVINA__c=true;
            }
            // cvina_flat_file__c is decomissioned, was #4
            if(value==5) {
                wrf.PCVINA__c=true;
            }
            if(value==6) {
                wrf.PCVIS__c=true;
            }
            if(value==7) {
                wrf.PCCVINA__c=true;
            }
            if(value==8) {
                wrf.CompletePrefixFile__c=true;
            }
            if(value==9) {
                wrf.MINICPF__c=true;
            }
            if(value==10) {
                wrf.VINPrefixFile__c=true;
            }
            if(value==11) {
                wrf.VINPrice__c=true;
            }
            if(value==12) {
                wrf.VINTelligence__c=true;
            }
            if(value==13) {
                wrf.Recover__c=true;
            }
            if(value==14) {
                wrf.FleetFind__c=true;
            }
            if(value==15) {
                wrf.VOS__c=true;
            }
            if(value==16) {
                wrf.VINVerification__c=true;
            }
            if(value==17) {
                wrf.Custom__c=true;
            }
        }
    }
    
    
    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: ApexPages.StandardController
    // @description:  This method is used in POLK WRF.
    // @return: 
    //----------------------------- 
    public WRACE(ApexPages.StandardController controller) {
        editMode = true;
        v=true;
        system.debug('controller*****'+controller);
        if(!test.isRunningTest()) {
            controller.addFields(XedeUtility.wrfFields());  
        }
        con=controller;
        wrf=(WorkRequestForm__c)controller.getRecord();
        system.debug('buttonValue1*****'+buttonValue);
        
        // Remove if and else if block.
        //check whether page is opened in lightning or classic or sf1.
        if(ApexPages.currentPage().getParameters().get('sfdcIFrameHost') != null ||
           ApexPages.currentPage().getParameters().get('sfdcIFrameOrigin') != null ||
           ApexPages.currentPage().getParameters().get('isdtp') == 'p1') {                
               
               URLId= wrf.id;
               retURL = ApexPages.currentPage().getParameters().get('retURL');
               system.debug('retURL*****'+retURL);
               system.debuG('URLID******'+ ApexPages.currentPage().getParameters().get('URLID'));
               
               system.debug('Apexpages.currentPage().getUrl()*****'+Apexpages.currentPage().getUrl());
               
               urltogetPageMode2 = ApexPages.currentPage().getParameters().get('buttonValue');
               system.debug('urltogetPageMode1*****'+ApexPages.currentPage());
               system.debug('urltogetPageMode2*****'+ApexPages.currentPage().getParameters().get('buttonValue'));
               if(ApexPages.currentPage().getParameters().get('buttonValue') == 'EditMode') {
                   system.debug('*****Inside if block in constructor');
                   URLID = ApexPages.currentPage().getParameters().get('URLID'); 
                   retURL = ApexPages.currentPage().getParameters().get('retURL');
                   system.debug('retURL Inside if block*****'+retURL);
                   system.debuG('URLID Inside if block******'+URLID);
                   //v=false;
                   //editMode = false;
                   /*if(URLID <> null && retURL == null) {
                       v=true;
                       editMode = true;
                       system.debug('*****Inside if block in constructor and set booelan variable'+editMode);
                   }*/  
                   if(retURL != null && retURL.contains('/apex/wredit')) {
                        v=false;
                        editMode = false;     
                    }
               }
           } else {   
               system.debug('I am in else condition');
               retURL = ApexPages.currentPage().getParameters().get('retURL');
               saveNewURL = ApexPages.currentPage().getParameters().get('save_new_url');
               URLID = ApexPages.currentPage().getParameters().get('id');
               /*if(URLID <> null && retURL == null) {
                   editMode = true;
                   v=true;
               }*/
               if(retURL != null && retURL.contains('/apex/wredit')) {
                        v=false;
                        editMode = false;     
               }
           }
        testform = ApexPages.currentPage().getParameters().get('testform') ;
        countrySelectors = new List<CountrySelectorController>();
        
        CNT = (wrf.CarandLightTruckDisplay__c != null) ? new CarsNTrucks(wrf.CarAndLightTruckDisplay__c) : new CarsNTrucks();
        DF = (wrf.DisplayFields__c != null) ? new DisplayF(wrf.DisplayFields__c) : new DisplayF();
        MC = (wrf.MotorCycleDisplay__c != null) ? new MotorCycle(wrf.MotorCycleDisplay__c) : new MotorCycle();
        
        wrf.PartsService__c = (wrf.formtype__c == 'Parts & Service');
        
        wrf.NOC__c = (wrf.formtype__c == 'NOC');
        
        if(wrf.formtype__c <> null) {
            formtype = wrf.formtype__c;
        }
        else {
            if(testform != null) {
                formtype = testform;
            }
        }
        
        jobtype = wrf.jobtype__c;
        
        oid = System.currentPageReference().getParameters().get('oid');
        if(oid<>null) {
            o = [select id,name,ownerid,owner.name,accountid,Account.name, AISUltimateClient__c, CostCenter__c, owner.phone, 
                 Amount, Opportunitynum__c, CustomerContact__c, CurrencyISOCode,
                 (SELECT Quantity, ListPrice, 
                  PriceBookEntry.UnitPrice, PricebookEntry.Name,
                  PricebookEntry.product2.Family,PricebookEntry.product2.Name,
                  PricebookEntry.product2.WRFTIPNetSystem__c,PricebookEntry.product2.WRFNewUsedRegistration__c,  PricebookEntry.product2.WRFStat__c, PricebookEntry.product2.WRFCanada__c,PricebookEntry.product2.WRFSoftwareServices__c, PricebookEntry.product2.WRFSalesMatch__c, 
                  PricebookEntry.product2.WRFRecall__c, PricebookEntry.product2.WRFNVPPOnline__c, PricebookEntry.product2.WRFListAndTLAS__c, PricebookEntry.product2.WRFJobTracker__c, PricebookEntry.product2.WRFAPAC__c, PricebookEntry.product2.WRFUK__c,
                  PricebookEntry.product2.WRFContinentalTireAftermarket__c, PricebookEntry.product2.WRFCVGAndGlobal__c, PricebookEntry.product2.WRFAnalytics__c, PricebookEntry.product2.WRFAftermarket__c, PricebookEntry.product2.WRFAustralia__c
                  FROM OpportunityLineItems) from opportunity where id=:oid];
            
            wrf.Revenue__c=o.Amount;
            wrf.OpportunityNumber__c=o.Opportunitynum__c;
            wrf.PrimarySalesContact__c=o.ownerid;
            wrf.OpportunityName__c=o.id;
            wrf.Accountname__c=o.accountid;
            wrf.name=o.name+' - '+ 'WRF';
            wrf.CostCenter__c=o.CostCenter__c;
            wrf.UltimateCustomeracct__c=o.AISUltimateClient__c;
            wrf.CurrencyISOCode = o.CurrencyISoCode; 
            
        } else {
            o=new Opportunity();
        }        
        //default isCloned to false in constructor
        isCloned = false;
        //system.debug('isView*******'+v);
        
    }
    
    public List<CountrySelectorController> countrySelectors { get; set; }
    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param:CountrySelectorController 
    // @description:  This method is used in POLK WRF.
    // @return: 
    //----------------------------- 
    public void addSelector(CountrySelectorController aSelector) {
        countrySelectors = new List<CountrySelectorController>();
        countrySelectors.add(aSelector);
    }
    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: 
    // @description:  This method is used in POLK WRF.
    // @return: WRACE
    //----------------------------- 
    public WRACE getThis() {
        return this;
    }
    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: 
    // @description:  This method is used in POLK WRF.
    // @return: List<SelectOption>
    //----------------------------- 
    public List<SelectOption> getPNSList() {
        List<SelectOption> options = new List<SelectOption>(); 
        //ELS Obsolete 7/17/2012
        //options.add(new SelectOption('1','Parts/Service')); 
        options.add(new SelectOption('2','NOC')); 
        
        return options; 
    }
    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: 
    // @description:  This method is used in POLK WRF.
    // @return: List<SelectOption>
    //----------------------------- 
    public List<SelectOption> getJTypeList() {
        List<SelectOption> options = new List<SelectOption>(); 
        options.addall(XedeUtility.getpickvalues(wrf,'jobtype__c','-None-'));
        if(formtype=='Parts & Service'||formtype=='NOC') {   
            options.add(new SelectOption('Fix','Fix')); 
            options.add(new SelectOption('Investigate','Investigate')); 
        }
        return options; 
    }
    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: 
    // @description:  This method is used in POLK WRF.
    // @return: List<SelectOption>
    //----------------------------- 
    
    public List<SelectOption> getSSList() {
        List<SelectOption> options = new List<SelectOption>(); 
        options.add(new SelectOption('1','VINA'));   
        options.add(new SelectOption('2','VIS'));
        options.add(new SelectOption('3','CVINA'));
        // ELS Obsolete Product
        options.add(new SelectOption('5','PC VINA')); 
        options.add(new SelectOption('6','PC VIS')); 
        options.add(new SelectOption('7','PC CVINA')); 
        options.add(new SelectOption('8','Complete Prefix File'));
        options.add(new SelectOption('9','MINI CPF'));
        options.add(new SelectOption('10','VIN Prefix File')); 
        options.add(new SelectOption('11','VIN Price')); 
        options.add(new SelectOption('12','VIN Telligence')); 
        options.add(new SelectOption('13','Recover')); 
        options.add(new SelectOption('14','Fleet Find')); 
        options.add(new SelectOption('15','VOS')); 
        options.add(new SelectOption('16','VIN Verification')); 
        options.add(new SelectOption('17','Custom')); 
        return options; 
    }
    
    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: 
    // @description:  This method is used in POLK WRF.
    // @return: boolean
    //----------------------------- 
    public Boolean getcheckChange() {
        Boolean cc=false;
        List<ChangeLog__c> cl=[select id from ChangeLog__c where WorkRequestForm__c=:wrf.id];
        if(cl.size()>0) {
            cc=true;
        }
        return cc;
    }
    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: 
    // @description:  This method is used in POLK WRF.
    // @return: pageReference 
    //----------------------------- 
    public PageReference redirect() {
        Set<String> pageTwoFormTypes = new Set<String>{ 'Recall', 'Aftermarket', 'NewUsed Registration', 'Australia' };
            PageReference targetPage = pageTwoFormTypes.contains(formType)? Page.WREdit2 : Page.wredit1;
        
        for (String eachKey : ApexPages.currentPage().getParameters().keySet())
            targetPage.getParameters().put(eachKey, ApexPages.currentPage().getParameters().get(eachKey));
        
        targetPage.getParameters().put('buttonValue',buttonValue);
        targetPage.setRedirect(true);
        
        return targetPage;
    }
    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: 
    // @description:  This method is used in POLK WRF.
    // @return: pageReference 
    //----------------------------- 
    public void updateConti() {        
        if(formtype=='Continental Tire Aftermarket') {
            wrf.continentaltire__c=true;
        }
    }
    
    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: 
    // @description:  This method is used in POLK WRF.
    // @return: pageReference 
    //----------------------------- 
    public pageReference PagePrint() {
        //System.Debug('Here we are!!!');
        PageReference wrForm = Page.WRPrintPDF; 
        wrForm.getParameters().put('ID',wrf.ID);
        wrForm.setRedirect(True);
        return wrForm;      
    }
    
    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: 
    // @description:  This method is used in POLK WRF.
    // @return: pageReference 
    //----------------------------- 
    public pageReference next() {
        Set<String> pageOneFormtypes = new Set<String> { 'TLAS', 'Stat', 'Canada', 'Sales Match', 'Analytics', 'TIPNet', 'CVGGlobal', 'Software Services', 'Continental Tire Aftermarket', 'UK'};  
            return pageOneFormtypes.contains(formtype)? Page.WREdit1 : Page.WREdit2;
    }
    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: 
    // @description:  This method is used in POLK WRF.
    // @return: boolean
    //----------------------------- 
    public boolean getvalidProducts() {
        boolean x = false;
        if(oid==null) { 
            x = true;
        }
        else {
            if(o.Account <> null && o.Account.Name.toUpperCase().contains('CONTINENTAL TIRE')) {
                x=true;
            }
            for(OpportunityLineItem oli:o.OpportunityLineItems) {
                if(oli.PricebookEntry.product2.WRFTIPNetSystem__c) {
                    x=true;
                }
                if(oli.PricebookEntry.product2.WRFStat__c) {
                    x=true;
                }
                if(oli.PricebookEntry.product2.WRFCanada__c) {
                    x=true;
                }
                if(oli.PricebookEntry.product2.WRFSoftwareServices__c) {
                    x=true;
                }
                if(oli.PricebookEntry.product2.WRFSalesMatch__c) {
                    x=true;
                }
                if(oli.PricebookEntry.product2.WRFRecall__c) {
                    x=true;
                }
                if(oli.PricebookEntry.product2.WRFNVPPOnline__c) {
                    x=true;
                }
                if(oli.PricebookEntry.product2.WRFListAndTLAS__c) {
                    x=true;
                }
                if(oli.PricebookEntry.product2.WRFJobTracker__c) {
                    x=true;
                }
                if(oli.PricebookEntry.product2.WRFContinentalTireAftermarket__c) {
                    x=true;
                }
                if(oli.PricebookEntry.product2.WRFCVGAndGlobal__c) {
                    x=true;
                }               
                if(oli.PricebookEntry.product2.WRFAnalytics__c) {
                    x=true;
                }                    
                if(oli.PricebookEntry.product2.WRFAftermarket__c) {
                    x=true;
                }
                if(oli.PricebookEntry.product2.WRFNewUsedRegistration__c) {
                    x=true;
                } 
                if(oli.PricebookEntry.product2.WRFAustralia__c) {
                    x=true;
                } 
                if(oli.PricebookEntry.product2.WRFAPAC__c) {
                    x=true;
                } 
                if(oli.PricebookEntry.product2.WRFUK__c) {
                    x=true;
                } 
            }           
        }
        return x;
    }
    
    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: 
    // @description:  This method is used in POLK WRF.
    // @return: List<SelectOption>
    //----------------------------- 
    public List<SelectOption> getforms() {
        Boolean ALL = FALSE;
        Boolean AFT = false;
        Boolean ANA = false;
        Boolean CONT = false;
        Boolean CVG = false;
        Boolean JT = false;
        Boolean NVPP = false;
        Boolean REC = false;
        Boolean SM = false;
        Boolean SS = false;
        Boolean Stat = false;
        //ELS Added 9/16/2014
        Boolean CAN = false;       
        Boolean TLAS = false;
        Boolean TIP = false;
        //New and Used Registration added 7/1/2015
        Boolean NUREG = false;
        //Australia added 8/19/2015
        Boolean AUS = false;
        //Asia/Pacific added 3/2/2016
        Boolean APAC = false;
        //UK added 9/12/2016
        Boolean UK = false;
        if(oid==null) {
            ALL=TRUE;
        }else {
            system.debug(o.Account.Name);
            if(o.Account <> null && o.Account.Name.toUpperCase().contains('CONTINENTAL TIRE')) { CONT = TRUE; }
            for(OpportunityLineItem oli:o.OpportunityLineItems) {
                if(oli.PricebookEntry.product2.WRFTIPNetSystem__c) {
                    TIP=TRUE;
                }
                if(oli.PricebookEntry.product2.WRFStat__c) {
                    Stat=TRUE;
                }
                //ELS Added 9/16/2014
                if(oli.PricebookEntry.product2.WRFCanada__c) {
                    CAN=TRUE;
                }                
                if(oli.PricebookEntry.product2.WRFSoftwareServices__c) {
                    SS=TRUE;
                }
                if(oli.PricebookEntry.product2.WRFSalesMatch__c) {
                    SM=TRUE;
                }
                if(oli.PricebookEntry.product2.WRFRecall__c) {
                    REC=TRUE;
                }
                if(oli.PricebookEntry.product2.WRFNVPPOnline__c) {
                    NVPP=TRUE;
                }
                if(oli.PricebookEntry.product2.WRFListAndTLAS__c) {
                    TLAS=TRUE;
                }
                if(oli.PricebookEntry.product2.WRFJobTracker__c) {
                    JT=TRUE;
                }
                if(oli.PricebookEntry.product2.WRFContinentalTireAftermarket__c) {
                    CONT=TRUE;
                }
                if(oli.PricebookEntry.product2.WRFCVGAndGlobal__c) {
                    CVG=TRUE;
                }
                if(oli.PricebookEntry.product2.WRFAnalytics__c) {
                    ANA=TRUE;
                }   
                if(oli.PricebookEntry.product2.WRFNewUsedRegistration__c) {
                    NUREG=TRUE;
                }     
                if(oli.PricebookEntry.product2.WRFAftermarket__c) {
                    AFT=TRUE;
                }                 
                if(oli.PricebookEntry.product2.WRFAustralia__c) {
                    AUS=TRUE;
                }   
                if(oli.PricebookEntry.product2.WRFAPAC__c) {
                    APAC=TRUE;
                }  
                if(oli.PricebookEntry.product2.WRFUK__c) {
                    UK=TRUE;
                }            
            }
        }
        List<SelectOption> tmplist = new List<SelectOption>();
        tmplist.add(new SelectOption('','-- NONE --'));
        if(ALL||AFT) {
            tmplist.add(new SelectOption('Aftermarket','Aftermarket'));
        }
        if(ALL||ANA) {
            tmplist.add(new SelectOption('Analytics','Analytics'));
        }
        if(ALL||APAC) {
            tmplist.add(new SelectOption('APAC','APAC'));
        }
        if(ALL||AUS) {
            tmplist.add(new SelectOption('Australia','Australia'));
        }
        //ELS Added 9/16/2014
        if(ALL||CAN) {
            tmplist.add(new SelectOption('Canada','Canada'));
        }
        //Decomission Conti - 9/7/2016 BNF
        //if(ALL||CONT) {tmplist.add(new SelectOption('Continental Tire Aftermarket','Continental Tire Aftermarket'));}
        if(ALL||CVG) {
            tmplist.add(new SelectOption('CVGGlobal','CVG and Global'));
        }        
        //ELS Removed 7-17-2012 - Decommission Parts & Service Form
        //if(ALL||JT) {tmplist.add(new SelectOption('Parts & Service','Parts & Service'));}
        if(ALL||NUREG) {
            tmplist.add(new SelectOption('NewUsed Registration','Global New & Used Registration'));
        }
        //Decomission NOC - 9/7/2016 BNF
        //if(ALL||JT) {tmplist.add(new SelectOption('NOC','NOC'));}
        if(ALL||REC) {
            tmplist.add(new SelectOption('Recall','Recall'));
        }
        if(ALL||SM) {
            tmplist.add(new SelectOption('Sales Match','Sales Match'));
        }
        if(ALL||SS) {
            tmplist.add(new SelectOption('Software Services','Software Services'));
        }
        if(ALL||Stat) {
            tmplist.add(new SelectOption('Stat','Stat'));
        }
        if(ALL||TIP) {
            tmplist.add(new SelectOption('TIPNet','TIPNet'));
        }
        if(ALL||TLAS) {
            tmplist.add(new SelectOption('TLAS','List/TLAS'));
        }
        if(ALL||UK) {
            tmplist.add(new SelectOption('UK','UK'));
        }
        return tmplist;
    }
    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: 
    // @description:  This method is used in POLK WRF.
    // @return: pageReference 
    // @Last Modified by : Ankita singh on 2nd Nov ,2017
    // @Last Modified Reason:  Code added to dynamically retrieve object id (earlier it was being hard coded)
    //------------------------
    public pageReference Close() {
        system.debug('wrace 746--->');
        Schema.DescribeSObjectResult r = WorkRequestForm__c.sObjectType.getDescribe();
        system.debug('wrace 746--->' +r);
        String keyPrefix = r.getKeyPrefix();
        PageReference pageRef = new PageReference('/'+keyPrefix+'/o');
        //PageReference pageRef = new PageReference('/a0p/o');
        return pageRef;    
    }
    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: 
    // @description:  This method is used in POLK WRF.
    // @return: pageReference
    //----------------------------- 
    public pageReference convertEstimate() {        
        WorkRequestForm__c cwrf = wrf.clone(false);
        cwrf.isSubmitted__c=false;
        cwrf.RequestStatus__c='Draft';
        cwrf.formtype__c= formtype;
        insert cwrf;
        return new PageReference('/'+cwrf.id);
    }
    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: 
    // @description:  This method is used in POLK WRF.
    // @return: pagereference
    //----------------------------- 
    public pageReference SaveDraft() {
        wrf.isSubmitted__c=false;
        wrf.RequestStatus__c='Draft';
        wrf.formtype__c= formtype;
        wrf.jobtype__c=jobtype;
        wrf.CarandLightTruckDisplay__c=CNT.FullCLT;
        wrf.MotorCycleDisplay__c=MC.FullMC;
        wrf.DisplayFields__c=DF.FullDF;
        //Added to attempt to eliminate problem when draft gets set to a queue
        //Chad 2012-05-16
        WRF.OwnerId = UserInfo.getuserid();
        return saveChanges();
    }
    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: 
    // @description:  This method is used in POLK WRF.
    // @return: pagereference
    //----------------------------- 
    public pageReference quickSave() {
        wrf.isSubmitted__c=false;
        wrf.RequestStatus__c='Draft';
        wrf.formtype__c= formtype;
        wrf.jobtype__c=jobtype;
        wrf.CarandLightTruckDisplay__c=CNT.FullCLT;
        wrf.MotorCycleDisplay__c=MC.FullMC;
        wrf.DisplayFields__c=DF.FullDF;
        saveChanges();
        return null;
    }    
    
    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: 
    // @description:  This method is used in POLK WRF.
    // @return: pageReference
    //-----------------------------  
    public pageReference Submit() {     
        wrf.formtype__c= formtype;
        wrf.jobtype__c=jobtype;
        ID queueID = XedeUtility.ProductionQueue(wrf);      
        //We dive into XedeUtilityto validate the work request
        boolean valid = XedeUtility.ValidateWRF(wrf, CNT.gethasValues(), DF.gethasValues(), MC.gethasValues(), countrySelectors);
        system.debug('valid*****'+valid);
        system.debug('CNT.FullCLT*****'+CNT.FullCLT);
        system.debug('MC.FullMC*****'+MC.FullMC);
        system.debug('DF.FullDF*****'+DF.FullDF);
        if (valid) {
            wrf.isSubmitted__c=true;
            wrf.SubmittedDate__c=system.today();
            wrf.RequestStatus__c='Submitted';
            wrf.CarandLightTruckDisplay__c=CNT.FullCLT;
            wrf.MotorCycleDisplay__c=MC.FullMC;
            wrf.DisplayFields__c=DF.FullDF;
            return saveChanges();
        }       
        return null;
    }
    
    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: 
    // @description:  This method is used in POLK WRF.
    // @return: pageReference
    //----------------------------- 
    public pageReference DUCSave() {        
        wrf.formtype__c= formtype;
        wrf.jobtype__c=jobtype;     
        //We dive into XedeUtilityto validate the work request
        boolean valid = XedeUtility.ValidateWRF(wrf, CNT.gethasValues(), DF.gethasValues(), MC.gethasValues(), countrySelectors);       
        if (valid)
            return saveChanges();
        
        return null;
    }
    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: String,String
    // @description:  This method is used in POLK WRF.
    // @return: PageReference
    //----------------------------- 
    private PageReference saveChanges() {
        //Verify opportunity reference/number before saving now that they are editable in drafts
        //Bryan 2016-01-13
        //cannot limit this to drafts only due to the logic in Submit()
        if(!wrf.Internal__c && (!isValidOptyNumber() || wrf.OpportunityName__c == null)) { 
            wrf.addError('Job Overview - You may only enter valid Opportunity information which belongs to a preexisting Opportunity.');
            return null;
        }
        PageReference returnPage;
        system.debug('controller*****'+con);
        returnPage = con.save();
        
        //Create new Opportunity Work Request Form associative object for the new many-to-many relationships
        //Note: WRF MUST be saved first
        //Bryan 2016-01-19
        if(!wrf.Internal__c)
            createOpportunityWorkRequestForm();
        
        List<CountrySelection__c> selectionsToInsert = new List<CountrySelection__c>();
        List<CountrySelection__c> selectionsToDelete = new List<CountrySelection__c>();
        
        if (countrySelectors == null || countrySelectors.isEmpty())
            return returnPage;
        
        system.debug('\n\nCOUNTRYSELECTORS.SIZE() = = ' + countrySelectors.size()+'\n\n');
        for (CountrySelectorController each : countrySelectors)
            each.shareRowsForSavingTo(con.getId(), selectionsToInsert, selectionsToDelete);
        
        insert selectionsToInsert;
        delete selectionsToDelete;
        
        return returnPage;
    }
    
    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param:
    // @description:  This method is used in POLK WRF.
    // @return: pageReference
    //-----------------------------  
    public pageReference wrClone() {        
        //.clone(false) -> do not preserve ID
        WorkRequestForm__c cwrf = wrf.clone(false);
        cwrf.isSubmitted__c=false;
        cwrf.RequestStatus__c='Draft';
        cwrf.formtype__c= formtype;
        cwrf.OwnerId = UserInfo.getuserid();
        // do not copy dates or special instructions
        cwrf.SpecialInstructions__c = null;
        cwrf.SubmittedDate__c = null;
        cwrf.RequestedDueDate__c = null;
        cwrf.ApprovalDate__c = null;
        cwrf.CycleStart__c = null;
        cwrf.EndDate__c = null;
        cwrf.ExpirationDate__c = null;
        cwrf.StartDate__c = null;
        cwrf.SubmittedDateTime__c = null;
        // Append "Clone - " to WRF name if it isn't already there  
        cwrf.Name = cwrf.Name.startsWithIgnoreCase('Clone') ? cwrf.Name : ('Clone - ' + cwrf.Name).left(80);  
        // Assign the name of the parent WRF           
        cwrf.ClonedfromWRF__c = wrf.Id;
        cwrf.ChangeLogs__c = 0;
        // do not clone rejection comments
        cwrf.RejectionComments__c = null;
        // Symbols
        cwrf.SymbolsApprovedDate__c = null;
        cwrf.SymbolApproved__c = false;
        cwrf.ISOPhysicalDamageAndLiabilitySymbols__c = null;
        cwrf.ISOPhysicalDamageSymbols__c = null;
        cwrf.ISORAPASymbols__c = null;
        cwrf.SymbolMerge__c =null;
        cwrf.AIBVRG__c = null;
        //cwrf.AIB_HighTheft_Indicator__c = null; decomissioned 9/4/2014
        cwrf.MASymbols__c = null;
        cwrf.PreservedRolledSymbols__c = null;
        cwrf.RVData__c = null;
        //DUC
        cwrf.DUCApproved__c=false;
        cwrf.DUCApprovalDate__c= null;
        cwrf.DUCApprovalRequired__c = null;
        cwrf.RoyaltyVendor__c = null;
        //added 7/26/2017 - BF
        //field no longer available on forms, so it cannot be unchecked after clone
        cwrf.WorldviewParc__c = false;
        
        insert cwrf;
        
        // clone wrf's child country selection records also
        List<CountrySelection__c> countrySelectionClones = new List<CountrySelection__c>();     
        // countrySelectors list is instantiated inside constructor, will not be null even for archived forms
        for (CountrySelectorController each : countrySelectors)
            countrySelectionClones.addAll(each.clonedCountrySelections());
        
        for (CountrySelection__c each : countrySelectionClones)
            each.WorkRequestForm__c = cwrf.id;
        
        insert countrySelectionClones;
        
        return new PageReference('/'+cwrf.id);
    }  
    
    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param:
    // @description:  This method is used in POLK WRF.
    // @return: 
    //----------------------------- 
    public void lookupOpportunityByName() {
        //Note: OpportunityName__c is actually an object reference. It is NOT just a name.
        if(wrf.OpportunityName__c <> null) {
            //Querying into a list helps prevent exceptions for selecting no rows upon bad input
            Opportunity newOpp = getOpportunityById(wrf.OpportunityName__c);
            if(newOpp <> null) {
                //Lookup occured by Unique ID, should only ever be 1 record
                wrf.AccountName__c = newOpp.AccountId; //Account_Name__c is an object reference, NOT just a name.
                wrf.OpportunityNumber__c = newOpp.Opportunitynum__c;
                /* removed for TLAS form wrf.CustomerContact__c = newOpp.CustomerContact__c; */
                wrf.Revenue__c = newOpp.Amount;
                wrf.CurrencyISOCode = newOpp.CurrencyISOCode;
                //Refreshes job name to equal opty name
                //Change request 20 Jan 2016
                String newJobName = wrf.ClonedFromWRF__c==null ? newOpp.Name : 'Clone - ' + newOpp.Name;
                wrf.Name = newJobName.left(80);
            }
        } else {
            wrf.addError('Job Overview - You must enter an exiting Opportunity for Opportunity Name.');
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
    public void lookupOpportunityByNumber() {
        Opportunity newOpp = getOpportunityByNumber(wrf.OpportunityNumber__c);
        
        if(newOpp <> null && wrf.OpportunityNumber__c <> null) {
            //opty numbers are unique, so we should only get 1
            wrf.AccountName__c = newOpp.AccountId; //Account_Name__c is an object reference, NOT just a name.
            wrf.OpportunityName__c = newOpp.Id; //OpportunityName__c is an object reference, NOT just a name.
            //wrf.CustomerContact__c = newOpp.CustomerContact__c;
            /* removed for TLAS form wrf.CustomerContact__c = newOpp.CustomerContact__c; */
            wrf.Revenue__c = newOpp.Amount;
            wrf.CurrencyISOCode = newOpp.CurrencyISOCode;
            //Refreshes job name to equal opty name
            //Change request 20 Jan 2016
            String newJobName = wrf.ClonedfromWRF__c==null ? newOpp.Name : 'Clone - ' + newOpp.Name;
            wrf.Name = newJobName.left(80);
        } else {
            if(wrf.OpportunityName__c <> null) {
                Opportunity currentOpp = getOpportunityById(wrf.OpportunityName__c);                
                if(currentOpp <> null) //it should NEVER be null, this object reference has not been altered yet
                    wrf.OpportunityNumber__c = currentOpp.Opportunitynum__c;
            }
            wrf.addError('Job Overview - You may only enter valid Opportunity Numbers which belong to a preexisting Opportunity.');
        }
    }
    
    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: String
    // @description:  This method is used in POLK WRF.
    // @return: Opportunity
    //----------------------------- 
    private Opportunity getOpportunityById(String id) {
        if(id <> null) {
            List<Opportunity> qResults = [SELECT Name, AccountId, CustomerContact__c, Amount, 
                                          Opportunitynum__c, CurrencyISOCode
                                          FROM Opportunity 
                                          WHERE Id=:wrf.OpportunityName__c
                                          LIMIT 1]; //query by Id should only ever return 1
            if(qResults.size() > 0) {
                return qResults[0];
            }
        }
        return null;
    }
    
    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: String
    // @description:  This method is used in POLK WRF.
    // @return: Opportunity
    //----------------------------- 
    private Opportunity getOpportunityByNumber(String oppNum) {
        if(oppNum <> null) {
            List<Opportunity> qResults = [SELECT Id, Name, AccountId, CustomerContact__c, 
                                          Amount, CurrencyISOCode
                                          FROM Opportunity 
                                          WHERE Opportunitynum__c=:wrf.OpportunityNumber__c 
                                          LIMIT 1]; //query by unique number should only ever return 1
            if(qResults.size() > 0)
                return qResults[0];
        }
        return null;
    }
    
    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: 
    // @description:  This method is used in POLK WRF.
    // @return: boolean
    //----------------------------- 
    private boolean isValidOptyNumber() {
        return getOpportunityByNumber(wrf.OpportunityNumber__c) <> null;
    }
    
    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: 
    // @description:  This method is used in POLK WRF.
    // @return: NA
    //----------------------------- 
    private void createOpportunityWorkRequestForm() {
        OpportunityWorkRequestForm__c optyWrf;
        system.debug('wrf.Id******=>'+wrf.id);
        if(wrf.Id <> null) { //if wrf exists in db, query to make sure a relationship doesn't also exist
            optyWrf = getOptyWrfByOptyAndWrfIds(wrf.OpportunityName__c, wrf.id);
            system.debug('optyWrf******=>'+optyWrf);
            if (optyWrf <> null) //if it does, leave it alone
                return;
        } 
        
        optyWrf = new OpportunityWorkRequestForm__c();
        optyWrf.Opportunity__c = wrf.OpportunityName__c;
        //throwing error for canada type wrf request on submission
        optyWrf.WorkRequestForm__c = con.getId(); //this ensures an ID is always present
        //uid should get taken care of by workflow rule
        System.debug('Opty Id: ' + optyWrf.Opportunity__c);
        System.debug('Wrf Id:  ' + optyWrf.WorkRequestForm__c);
        System.debug('optyWrf***********  ' + optyWrf);
        insert optyWrf;        
    }
    
    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: String,String
    // @description:  This method is used in POLK WRF.
    // @return: OpportunityWorkRequestForm__c 
    //----------------------------- 
    private OpportunityWorkRequestForm__c getOptyWrfByOptyAndWrfIds(String optyId, String wrfId) {
        List<OpportunityWorkRequestForm__c> optyWrfs = [SELECT Id, Opportunity__c, WorkRequestForm__c, uid__c,WorkRequestForm__r.OpportunityName__c 
                                                        FROM OpportunityWorkRequestForm__c
                                                        WHERE Opportunity__c=:optyId
                                                        AND WorkRequestForm__c=:wrfId
                                                        LIMIT 1]; //these combinations should always be unique
        return optyWrfs.size() > 0 ? optyWrfs[0] : null;
    }
    
    
    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: 
    // @description:  This method is used in POLK WRF.
    // @return: NA
    //----------------------------- 
    public void countryPickerSave() {
        if(wrf.RequestStatus__c == 'Draft' || String.isEmpty(wrf.RequestStatus__c)) {
            SaveDraft();
            System.debug('Saving draft.');
            //for brand new WRFs
            if(wrf.id == null) {
                //this prevents the OpptyWRF methods from trying to save dupes
                wrf.id=con.getId();
            }
        } else if (wrf.RequestStatus__c == 'Submitted') {
            System.debug('Submitting.');
            Submit();
            System.debug('Submit complete.');
        } else {
            //do nothing
            //you shouldn't be able to save 'Accepted' and 'Rejected' WRFs
        }
    }
    
    //for making related objects immediately upon WRF creation
    public id getControllerId() {
        return con.getId();
    }
    
    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: 
    // @description:  This method is used in POLK WRF.
    // @return: pageReference 
    //------------------------
    public pageReference Cancel() {    
        PageReference pg;
        if(wrf.id != null) {
            pg = new PageReference('/'+wrf.id);
            system.debug('wrace 1179--->');
            Schema.DescribeSObjectResult r = WorkRequestForm__c.sObjectType.getDescribe();
            system.debug('wrace 1181--->' +r);
            String keyPrefix = r.getKeyPrefix();
            pg = new PageReference('/'+keyPrefix+'/o');
            
        } else {
            system.debug('wrace 1186--->');
            Schema.DescribeSObjectResult r = WorkRequestForm__c.sObjectType.getDescribe();
            system.debug('wrace 1188--->');
            String keyPrefix = r.getKeyPrefix();
            pg = new PageReference('/'+keyPrefix+'/o');
            
        }
        pg.setRedirect(true);
        return pg;     
    }
    
    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: 
    // @description:  This method is used in POLK WRF.
    // @return: pageReference 
    //------------------------
    public pageReference cancelOverride() {    
        PageReference pg;
        if(wrf.id != null) {
            pg = new PageReference('/'+wrf.id);
            Schema.DescribeSObjectResult r = WorkRequestForm__c.sObjectType.getDescribe();
            String keyPrefix = r.getKeyPrefix();
            pg = new PageReference('/'+keyPrefix+'/o');
            
        } 
        else {
            Schema.DescribeSObjectResult r = WorkRequestForm__c.sObjectType.getDescribe();
            String keyPrefix = r.getKeyPrefix();
            pg = new PageReference('/'+keyPrefix+'/o');
            
        }
        pg.setRedirect(true);
        return pg;        
    }
    
    
    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: 
    // @description:  This method is used in POLK WRF.
    // @return: pageReference 
    //------------------------
    public void setbuttonValue(String n) {
        buttonValue = n;
    }
    
    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: 
    // @description:  This method is used in POLK WRF.
    // @return: pageReference 
    //------------------------
    public String getbuttonValue() {
        return buttonValue;
    }
    
    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: 
    // @description:  This method is used in POLK WRF.
    // @return: pageReference 
    //------------------------
    public pageReference editOverride() {  
        //editMode = false;
        PageReference retURLRef = new PageReference('/apex/wredit?id='+wrf.id);
        retURL = '/apex/wredit?id='+wrf.id;
        system.debug('Inside editoverride******'+retURL); 
        URLID = wrf.id;
        retURLRef.getParameters().put('URLID',wrf.id);
        retURLRef.getParameters().put('retURL',retURL);
        retURLRef.getParameters().put('buttonValue','EditMode');
        system.debug('buttonValue****&*****'+ApexPages.currentPage().getParameters().get('buttonValue'));
        retURLRef.setRedirect(true);
        system.debug('Inside editoverride retURLRef******'+retURLRef);
        v= false;
        editMode = false;
        return retURLRef;
    }
    
    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: 
    // @description:  This method is used in POLK WRF.
    // @return: pageReference 
    //------------------------
    public pageReference editOverride1() {  
        //editMode = false;
        PageReference retURLRef = new PageReference('/apex/wredit1?id='+wrf.id);
        retURL = '/apex/wredit1?id='+wrf.id;
        system.debug('Inside editoverride******'+retURL);
        URLID = wrf.id;
        retURLRef.getParameters().put('URLID',wrf.id);
        retURLRef.getParameters().put('retURL',retURL);
        retURLRef.getParameters().put('buttonValue','EditMode');
        system.debug('buttonValue****&*****'+ApexPages.currentPage().getParameters().get('buttonValue'));
        retURLRef.setRedirect(true);
        system.debug('Inside editoverride retURLRef******'+retURLRef);
        v= false;
        editMode = false;
        return retURLRef;
    }
    
    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: 
    // @description:  This method is used in POLK WRF.
    // @return: pageReference 
    //------------------------
    public pageReference editOverride2() {  
        //editMode = false;        
        PageReference retURLRef = new PageReference('/apex/wredit2?id='+wrf.id);
        retURL = '/apex/wredit2?id='+wrf.id;
        system.debug('Inside editoverride******'+retURL);
        URLID = wrf.id;
        retURLRef.getParameters().put('URLID',wrf.id);
        retURLRef.getParameters().put('retURL',retURL);
        retURLRef.getParameters().put('buttonValue','EditMode');
        system.debug('buttonValue****&*****'+ApexPages.currentPage().getParameters().get('buttonValue'));
        retURLRef.setRedirect(true);
        system.debug('Inside editoverride retURLRef******'+retURLRef);
        v= false;
        editMode = false;
        return retURLRef;
    }

    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: 
    // @description:  This method is used in POLK WRF.
    // @return: boolean
    // @Last Update:11/14 - Anjani Shukla: Fixed Edit, Close and Cancel for Lightning readiness
    //----------------------------- 
    
    public boolean getisView() {
        v= true;
        editMode = true;
        system.debug('URLid***%***'+URLid);
        system.debug('retURL***%***'+retURL);
        /*if(retURL==null && URLid<>null) {
            system.debug('retURL==null && URLid<>null  ==>');
            v=true;
            editMode = true;
        }
        
        if(retURL!=null && URLid<>null) {
            system.debug('retURL!=null && URLid<>null  ==>');
            v=false;
            editMode = false;
        }
        if(urltogetPageMode2.equalsIgnoreCase('EditMode')) {
            v=false;
            editMode = false;  
        }*/
        //when creating new wrf 
        if(retURL == null && URLid == null) {
            system.debug(' both null 427');
            v=false;
            editMode = false;     
        }
        
        if(retURL != null && retURL.contains('/apex/wredit')) {
            system.debug(' both not null 433');
            v=false;
            editMode = false;     
        }
        
        if(retURL != null && (retURL.contains('/apex/WRDriver') || retURL.contains('WorkRequestForm__c'))) {
            system.debug(' both not null 439');
            v=false;
            editMode = false;     
        }
        system.debug('getisView*****'+v);
        return v;
    }
        
}