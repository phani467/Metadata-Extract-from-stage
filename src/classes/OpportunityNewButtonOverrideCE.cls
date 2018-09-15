//-----------------------------
// @author Prachi Bhasin
// @date 6 July 2017
// @description:  Controller Extension for OpportunityNewButtonOverride visualforce page
// @return: NA
// @company: VERTIBA
// @lastmodified: SFDC1-1993 Defaulting the stage to '1-Open' for forecasting placeholder recordtype <Sprint 6>
//-----------------------------
public with sharing class OpportunityNewButtonOverrideCE{
    public Opportunity opp = new Opportunity();
    public String userBusinessLine;
    public String accountName; 
    public String contractStartDate;
    
    //-----------------------------
    // @author: Prachi Bhasin
    // @date: 6 July 2017
    // @param: ApexPages.StandardController controller
    // @description: Constructor method for class
    // @return: None
    //------------------------------
    public OpportunityNewButtonOverrideCE(ApexPages.StandardController controller) {
        opp = (Opportunity)controller.getRecord();
        
        if(opp.AccountId != NULL){
            accountName = [Select id,name from account where id =: opp.AccountId limit 1].name;        
            userBusinessLine = [Select id, firstname, HRBusinessLine__c from user where id=:userinfo.getuserid() limit 1].HRBusinessLine__c;
        }
        
        if(opp.ContractId != NULL){
            contractStartDate = String.valueOf([Select id, startdate from contract where id=:opp.ContractId limit 1].StartDate);
        }
    }  

    //-----------------------------
    // @author: Prachi Bhasin
    // @date: 6 July 2017
    // @param: None
    // @description: populates the fields on opportunity record before loading the edit page
    // @return: pagereference 
    // @Last Modified By : Vinod Merwade
    // @Last Modified Date : 8 Sept 2017
    // @Modified Description : Removed New and Renwal Labels as part of the requirement SFDC1-853
    //------------------------------
    public pagereference PageLoadEvent(){ 
        //get the user information that we need, this is where we store the per user default for xxx__c
        Id oppNewBusinessRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('New Business').getRecordTypeId();
        Id oppRenewalRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Renewal').getRecordTypeId();
        Id oppForecastingPlaceholderRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Forecasting Placeholder').getRecordTypeId();
        
        string URLStr = '/006/e?nooverride=1';                                                       
        URLStr = URLStr + '&retURL=' + ApexPages.currentPage().getParameters().get('retURL');
        URLStr = URLStr + '&RecordType='+String.valueOf(opp.RecordTypeId).substring(0,15);
        
        if(String.valueOf(opp.RecordTypeId).substring(0,15) == String.valueOf(oppNewBusinessRecordTypeId).substring(0,15)){
            
            URLStr = URLStr + '&opp11=' + '1-Sales Qualified';
            if(opp.AccountId != NULL){
                URLStr = URLStr + '&opp3=' +accountName;
                    if(userBusinessLine!=null)
                     URLStr = URLStr + ' - '+userBusinessLine;
                URLStr = URLStr + '&opp4=' + accountName ;
            }
        }
        if(String.valueOf(opp.RecordTypeId).substring(0,15) == String.valueOf(oppRenewalRecordTypeId).substring(0,15)){
           if(opp.AccountId != NULL){
                URLStr = URLStr + '&opp3='  +accountName ;
                if(contractStartDate !=null) 
                URLStr = URLStr + ' - '+contractStartDate;
                if(userBusinessLine != null)    
                URLStr = URLStr + ' - '+userBusinessLine;          
            } 
        }

        if(String.valueOf(opp.RecordTypeId).substring(0,15) == String.valueOf(oppForecastingPlaceholderRecordTypeId).substring(0,15)) {
           URLStr = URLStr + '&opp11=' + '1-Open';           
        }
        pageReference pageRef = new pagereference(URLStr);   
        pageRef.setredirect(false);
        return pageRef;
    }
}