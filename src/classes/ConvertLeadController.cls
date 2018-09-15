//-----------------------------
// @author Vinod Merwade
// @date 18 July 2017
// @description:  SFDC1-45 and SFDC1-186 Controller Extension for ConvertLeadPage visualforce page. Converts Lead to Activity,Case,Contact and Opportunity
// @return: Redirects to the converted record
// @Company: Vertiba
// @Last Modified : 25 Oct 2017
// @Last Modified Description : SFDC1-2079 - Should not convert lead if Account is "Unknown Account" or "General Service Account"
// SFDC1-2326 and SFDC1-2213 - User friendly Error messages
// SFDC-186 Bug Fix 
// SFDC1-853 - Story to remove 'New' while converting Lead to an Opportunity
// SFDC1-2377 - Story to Update the status of the Lead to 'Converted' only through Custom solution
// SFDC1-4487 - Provision to Select the available contact if the Duplicate contacts were found
// SFDC1-5402 - On conversion of Lead to Case, Owner should be a Queue. 
// SFDC1- 5196 - task should have a Lead Lookup to identify from which Lead it is being created and Same should be pouplate in Selected 
// Opportunity while converting to an Activity.
//-----------------------------
public class ConvertLeadController {
    public Lead leadObj{get;set;}
    public Lead leadOpportunity{get;set;}
    public string selectedValue{get;set;}
    public string leadStage {get;set;}
    public string leadStatus {get;set;}
    public string Status {get;set;}
    public Id accountId {get;set;}
    public Id contactId {get;set;}
    public Id convertedId {get;set;}
    public Id opportunityId {get;set;}
    public Id selectedContact {get;set;}
    public boolean contactCreatedByUser;
    public boolean opportunityCreatedByUser;
    public boolean dummyContact;
    public boolean accountDG;
    public boolean accountTypePlaceholder;
    public string userBusinessLine{get;set;}
    public string opportunityNameStandard;
    public Integer opportunityAmount;
    public String budgetRange;
    public List<sObject> duplicateRecords {get;set;}
    public boolean hasDuplicateResult{get;set;}
    //-----------------------------
    // @author: Vinod Merwade
    // @date: 18 July 2017
    // @param: ApexPages.StandardController controller
    // @description: SFDC1-45 and SFDC1-186 Constructor method for class
    // @return: None
    // @Company: Vertiba
    // @Last Modified : 16 Aug 2017
    //------------------------------
    public ConvertLeadController(ApexPages.StandardController controller) {
        leadObj = (Lead)controller.getRecord();
        leadOpportunity = new Lead();
        selectedValue ='';
        Lead temp = [select id, name, account__c,status,budgetRange__c from lead where id=:leadObj.id limit 1];
        accountId = temp.Account__c;
        dummyContact = false;
        accountDG = false;
        accountTypePlaceholder = false;
        contactCreatedByUser=false;
        Status =temp.Status;
        budgetRange = temp.BudgetRange__c;
        hasDuplicateResult =false;
        duplicateRecords = new List<sObject>();
        system.debug('budgetRange'+budgetRange);
    }
    
    public ConvertLeadController() {
    }
    
    //-----------------------------
    // @author: Vinod Merwade
    // @date: 18 July 2017
    // @param: None
    // @description: SFDC1-45 and SFDC1-186 Lead is converted to selected object type and redirected to converted record detail page
    // @return: None
    // @Company: Vertiba
    // @Last Modified : 16 Aug 2017
    //------------------------------
    
    public PageReference convertLead() {        
        Boolean isError = false;
        String errorMessage;       
        map<string,LeadConversionFieldMapping__c> mapLeadToConversionMappping = LeadConversionFieldMapping__c.getall();
        if(hasDuplicateResult) {
        	accountId = [select accountId from Contact where id =:selectedContact ].accountId; 
        }
        Savepoint sp = Database.setSavepoint();
        try {
            if(accountId !=NULL) {                
                Account accObj = [SELECT Name,Id,Type,DataGovernanceStatus__c FROM Account where id=: accountId LIMIT 1];
                String accDG = accObj.DataGovernanceStatus__c; 
                if(accObj.Type == System.Label.AccountTypePlaceholder || !(accDG.equalsIgnoreCase('Approved'))) {                   
                    accountTypePlaceholder = true;   
                }
            }
            if(selectedValue == 'Case') {
                errorMessage = '';
                if(accountId == NULL) {
                    isError = true;
                    errorMessage += System.Label.AccountRequiredForLead+'<br>';
                }
                if(Status == System.Label.LeadNonConvertable) {
                    
                    isError = true;
                    errorMessage += System.Label.LeadArchived+'<br>';
                }
                if(isError){
                    ApexPages.addMessage (new ApexPages.Message(ApexPages.Severity.ERROR,errorMessage));
                    return null;
                }
                else {
                    leadStage = 'SenttoCustomerCare';
                    leadStatus = System.Label.LeadNonConvertable;
                    convertedId = CreateObject(leadObj,mapLeadToConversionMappping, 'Case','LeadToCase');
                }
            }            
            if(selectedValue == 'Contact') {
                errorMessage = '';
                if(accountId == NULL) {
                    isError = true;
                    errorMessage += System.Label.AccountRequiredForLead+'<br>';
                   
                }
                if(accountTypePlaceholder) {
                    isError = true;
                    errorMessage += System.Label.AccountTypePlaceholderError+'<br>';
                   
                }
                if(isError) {
                    ApexPages.addMessage (new ApexPages.Message(ApexPages.Severity.ERROR,errorMessage));
                    return null;
                }
                else {
                    if(!hasDuplicateResult) {
                        convertedId= CreateObject(leadObj,mapLeadToConversionMappping, 'Contact','LeadToContact');
                    }
                    else {
                        convertedId = selectedContact;
                    }
                    contactCreatedByUser =true;
                    contactId = convertedId;
                }
            }
            if(selectedValue == 'Activity') {
                errorMessage ='';
                if(leadOpportunity.ExistingOpportunity__c == NULL ) {
                    isError = true;
                    errorMessage += 'Please Select an Opportunity';
                }
                if(Status == System.Label.LeadNonConvertable) {
                    isError = true;
                    errorMessage += System.Label.LeadArchived+'<br>';
                   
                }
                if(accountTypePlaceholder) {
                    isError = true;
                    errorMessage += System.Label.AccountTypePlaceholderError+'<br>';
                   
                }
                if(isError) {
                    ApexPages.addMessage (new ApexPages.Message(ApexPages.Severity.ERROR,errorMessage));
                    return null;
                }
                else {
                    leadStage = 'SenttoSales';
                    leadStatus = System.Label.LeadNonConvertable;
                    convertedId= CreateObject(leadObj,mapLeadToConversionMappping, 'Task','LeadToTask');
                }
            }
            if(selectedValue == 'OppCont') {
                errorMessage ='';
                if(budgetRange == NULL) {
                    isError = true;
                    errorMessage += System.Label.BudgetRangeError+'<br>';
                   
                }                
                if(accountId == NULL) {
                    isError = true;
                    errorMessage += System.Label.AccountRequiredForLead+'<br>';
                    
                }               
                if(accountTypePlaceholder) {
                    isError = true;
                    errorMessage += System.Label.AccountTypePlaceholderError+'<br>';                    
                }
                if(isError) {
                    ApexPages.addMessage (new ApexPages.Message(ApexPages.Severity.ERROR,errorMessage));
                    return null;
                }
                else {
                    if(!hasDuplicateResult) {
                        contactId = CreateObject(leadObj,mapLeadToConversionMappping, 'Contact','LeadToContact');  
                    }
                    else {
                        contactId = selectedContact;
                    }
                    system.debug('contactId**********************'+contactId);
                    if(contactId!=NULL) {
                        opportunityId = CreateObject(leadObj,mapLeadToConversionMappping, 'Opportunity','LeadToOpportunity');
                        if(opportunityId!=NULL){                    
                            contactCreatedByUser = true;
                            opportunityCreatedByUser = true;
                            OpportunityContactRole oppContactPrimary = new OpportunityContactRole();
                            oppContactPrimary.OpportunityID = opportunityId;
                            oppContactPrimary.IsPrimary = TRUE;
                            oppContactPrimary.ContactId = contactId;  
                            Database.Insert(oppContactPrimary,false);
                        }
                    }
                    convertedId = opportunityId;  
                    if(convertedId != NULL){
                        campaignFromLeadToOpportunity(leadObj, opportunityId);
                    }
                }
            }           
            if(convertedId==NULL) {
                ApexPages.addMessage (new ApexPages.Message(ApexPages.Severity.ERROR,'Lead could not be converted.Something went Wrong!'));
                return NULL;
            }
            else {
                convertCurrentLead(leadObj);
                return new pagereference('/'+convertedId);
            }
        }
        catch(Exception e) {
            Database.rollback(sp);           
            system.debug('Error occurred during conversion of the Lead==='+e.getMessage());
            ApexPages.addMessage (new ApexPages.Message(ApexPages.Severity.ERROR,'Lead could not be converted.Something went Wrong!<br/>'+e.getMessage()));
            return NULL;
        }
    }
    
    //-----------------------------
    // @author: Vinod Merwade
    // @date: 18 July 2017
    // @param: Lead Object, Map<string,LeadConversionFieldMapping__c>, Target Object API Name, Mapping Name Keyword
    // @description: SFDC1-45 and SFDC1-186 Uses Lead field and Maps the field based on the Object selected.
    // @return: Id of created object using Lead fields
    // @Company: Vertiba
    //------------------------------   
    public Id CreateObject(Lead leadObj,map<string,LeadConversionFieldMapping__c> mapLeadToConversionMappping,String ObjectName,String MappingNameStr)
    {
        map<string,LeadConversionFieldMapping__c> mapLeadToCaseField = new map<string,LeadConversionFieldMapping__c>();
        mapLeadToCaseField= getFieldMapping(MappingNameStr,mapLeadToConversionMappping);
        sObject tempObj = Schema.getGlobalDescribe().get(ObjectName).newSObject() ;
        if(!mapLeadToCaseField.isEmpty()) {
            leadObj = getLead(mapLeadToCaseField.keyset(),leadObj.id);
            if(leadObj != NULL) {
                Lead lObj = [select id,FirstName,LastName,Email from lead where id =:leadObj.id ];
                string fName = '%'+(string)lObj.FirstName+'%';
                string lName = '%'+(string)lObj.LastName+'%';
                string email = (string)lObj.email;
                for(String Leadfields : mapLeadToCaseField.keyset()) {
                    String SourceAPI = mapLeadToCaseField.get(Leadfields).SourceAPIField__c;
                    String TargetAPI = mapLeadToCaseField.get(Leadfields).TargetAPIField__c;                    
                    Object TargetValue ;
                    if(!TargetAPI.startsWithIgnoreCase('NoUse') && !TargetAPI.containsIgnoreCase('NoUse')) {                       
                        if(Leadfields.startsWithIgnoreCase('NoUse') && Leadfields.containsIgnoreCase('NoUse')) {
                            
                            TargetValue = mapLeadToCaseField.get(Leadfields).DefaultValue__c;
                        }
                        else {
                            TargetValue = leadObj.get(Leadfields);
                        }
                        /* 
                        * Specific Changes which are required for Only for Case : Start
                        */
                        if(TargetAPI.equalsIgnoreCase('recordtypeId')&&mapLeadToCaseField.get(Leadfields).TargetObjectName__c.equalsIgnoreCase('Case')) {
                            
                            TargetValue = Schema.SObjectType.Case.getRecordTypeInfosByName().get(mapLeadToCaseField.get(Leadfields).DefaultValue__c).getRecordTypeId();
                        }
                        /* 
                        * Specific Changes which are required for Only for Case : End
                        */
                        /* 
                         * Specific Changes which are required for Only for Opportunity : Start
                         */
                        if(mapLeadToCaseField.get(Leadfields).TargetObjectName__c.equalsIgnoreCase('Opportunity')) {                            
                            tempObj.put('CloseDate',system.today()+14);
                            if(TargetAPI.equalsIgnoreCase('Probability')) {                               
                                TargetValue = mapLeadToCaseField.get(Leadfields).DefaultValue__c;
                                TargetValue = integer.valueof(TargetValue);
                            }
                            if(TargetAPI.equalsIgnoreCase('Amount')) {                               
                                Decimal Amountval = (string)leadObj.get(Leadfields) !=NULL ? Decimal.valueOf((string)leadObj.get(Leadfields)) : 0; 
                                TargetValue = integer.valueof(Amountval);
                                opportunityAmount = (Integer)TargetValue;
                            }
                            if(TargetAPI.equalsIgnoreCase('Name')) {
                                userBusinessLine = [Select id, firstname, HRBusinessLine__c from user where id=:userinfo.getuserid() limit 1].HRBusinessLine__c;
                                TargetValue = (string)leadObj.get('AccountName__c');
                                if(userBusinessLine !='' && userBusinessLine !=NULL) {
                                    TargetValue +=' - '+userBusinessLine;
                                }
                                opportunityNameStandard = 'NEW - '+(string)leadObj.get('AccountName__c');
                            }                           
                        }
                        /* 
                        * Specific Changes which are required for Only for Opportunity : End
                        */                                                
                       /* 
                        * Specific Changes which are required for Only for Activity : Start
                        */
                        if(mapLeadToCaseField.get(Leadfields).TargetObjectName__c.equalsIgnoreCase('Task')) {
                            
                            tempObj.put('WhatId',leadOpportunity.ExistingOpportunity__c);
                            tempObj.put('Lead__c', leadObj.id);
                            leadObj.ExistingOpportunity__c = leadOpportunity.ExistingOpportunity__c;
                            update leadObj;
                        }
                        if(mapLeadToCaseField.get(Leadfields).TargetObjectName__c.equalsIgnoreCase('Case')) {
                            if(TargetAPI.equalsIgnoreCase('OwnerId')) { 
                                String ownerQueue = mapLeadToCaseField.get(Leadfields).DefaultValue__c;
                                system.debug('ownerQueue====='+ownerQueue);
                                try{
                                	Id Owner = [select Id,Name from Group where  Type = 'Queue' and Name =: ownerQueue limit 1].id;
                                    if(Owner != NULL){
                                        TargetValue = (Id)Owner;
                                    }
                                }
                                Catch(Exception ex)
                                {
                                    if(ex.getMessage().contains('List has no rows for assignment to SObject'))
                                    {
                                        ApexPages.addMessage (new ApexPages.Message(ApexPages.Severity.ERROR,'Queue for ownership is not defined. Please contact System Admin.'));
                                        return null;
                                    }
                                }
                                
                            }
                        }
                            
                        /* 
                        * Specific Changes which are required for Only for Activity : End
                        */
                        tempObj.put(TargetAPI,TargetValue);
                    }
                }
                try {
                    if(selectedValue =='Case') {
                        // SFDC1-5716: Chnaged Field from LinkedLead__c to LeadReference__c 
                        tempObj.put('LeadReference__c',leadObj.id);
                    }
                    Database.SaveResult saveResult;
                  if(selectedValue =='OppCont' || selectedValue =='Contact' ) {
                    Database.DMLOptions dml = new Database.DMLOptions(); 
                    dml.DuplicateRuleHeader.allowSave = true;
                    dml.DuplicateRuleHeader.runAsCurrentUser = true;  
                     saveResult = Database.insert(tempObj, dml);
                  }
                    else {
                     saveResult = Database.insert(tempObj, false);
                    }
                    //insert tempObj;
                    if (!saveResult.isSuccess()) {
                        set<id> duplicateContactIds = new set<id>();
                        for (Database.Error error : saveResult.getErrors()) {
                            
                            if (error instanceof Database.DuplicateError) {
                                Database.DuplicateError duplicateError = 
                                    (Database.DuplicateError)error;
                                Datacloud.DuplicateResult duplicateResult = 
                                    duplicateError.getDuplicateResult();
                                ApexPages.Message errorMessage = new ApexPages.Message(
                                    ApexPages.Severity.ERROR, 'Duplicate Error: ' + 
                                    duplicateResult.getErrorMessage());
                                ApexPages.addMessage(errorMessage);
                                
                                this.duplicateRecords = new List<sObject>();
                                
                                Datacloud.MatchResult[] matchResults = 
                                    duplicateResult.getMatchResults();
                                
                                Datacloud.MatchResult matchResult = matchResults[0];
                                
                                Datacloud.MatchRecord[] matchRecords = matchResult.getMatchRecords();
                                
                                for (Datacloud.MatchRecord matchRecord : matchRecords) {
                                    System.debug('MatchRecord: ' + matchRecord.getRecord());
                                   // this.duplicateRecords.add(matchRecord.getRecord());
                                    duplicateContactIds.add(matchRecord.getRecord().id);
                                }
                                this.hasDuplicateResult = !duplicateContactIds.isEmpty();
                              //  system.debug('duplicateRecords===='+duplicateRecords);
                            }
                        }
                        duplicateRecords = [Select Id, Name,Email,AccountId,Account.Name,Owner.Name,ownerID ,Phone,LastModifiedDate from contact where id in : duplicateContactIds];
                        system.debug('duplicateRecords===='+duplicateRecords);
                        return null;
                    }
                }
                catch(Exception exc) {
                    if(exc.getMessage().contains('DUPLICATES_DETECTED')) {
                        ApexPages.addMessage (new ApexPages.Message(ApexPages.Severity.Error,'Duplicate Contact or similar contact, You\'re creating a contact record with First Name and Last Name or Email Id similar to existing contact(s).'));
                    }
                    system.debug('Exception during lead conversion==='+exc.getMessage());
                    return NULL;
                }
            }
        }
        return tempObj != NULL ? tempObj.id : NULL;
    }
    
    //-----------------------------
    // @author: Vinod Merwade
    // @date: 18 July 2017
    // @param: Lead Object
    // @description:SFDC1-45 and SFDC1-186 Converts the Lead and status of the Lead will be set to Qualified
    // @return: None
    // @Company: Vertiba
    //------------------------------
    
    public void convertCurrentLead(Lead currentleadObj) {
        //converts current lead to be converted and status will be set to Qualified
        if(!selectedValue.equalsIgnoreCase('Case') && !selectedValue.equalsIgnoreCase('Activity')) {
            Database.LeadConvert lc = new Database.LeadConvert();
            lc.setLeadId(currentleadObj.id);
            lc.setAccountId(accountId); 
            
            if(opportunityCreatedByUser == TRUE) {                
                lc.setOpportunityId(opportunityId);
                lc.setContactId(contactId);
            }
            else {
                lc.setDoNotCreateOpportunity(true);
            }         
            if(contactCreatedByUser == TRUE) {
                lc.setContactId(contactId);     
            }                       
            LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];
            lc.setConvertedStatus(convertStatus.MasterLabel);
            currentleadObj.ConvertedFromCustom__c = true;
            update currentleadObj;
            Database.LeadConvertResult lcr = Database.convertLead(lc);
            if(!lcr.isSuccess()) {                
                currentleadObj.addError('Conversion of the Lead Failed due to some error reach out to your System Admin for more Information');
            }
            if(contactCreatedByUser == FALSE ) {
                Lead contId = [select id,name,convertedContactId from lead where id=:currentleadObj.id limit 1];
                contact con = [select id,name from contact where id=:contId.convertedContactId];
                system.debug('created contact--'+con);
                Delete con;
                system.debug('deleted====='+con);
            }            
        }
        else {
            currentleadObj.Lead__c= leadStage;
            currentleadObj.Status=leadStatus;
            Database.SaveResult result = Database.update(currentleadObj,false);
            if(!result.isSuccess()) {
                currentleadObj.addError('Lead could not be converted due to some issues');
            }
        }               
    }
    
    //-----------------------------
    // @author: Vinod Merwade
    // @date: 18 July 2017
    // @param: Source Fields from Custom Setting for Lead, Lead Id
    // @description: SFDC1-45 and SFDC1-186 Genrates an dynamic Query based on the parameters
    // @return: Lead Object
    // @Company: Vertiba
    //------------------------------       
    public static Lead getLead(set<string> Leadfields,Id leadObjid)
    {
        if(!Leadfields.isempty() && leadObjid != NULL) {
            String LeadQuery = 'select id, ';
            for(String LeadField : Leadfields) {
                if(!LeadField.startsWithIgnoreCase('NoUSe') && !LeadField.containsIgnoreCase('NoUSe')) {
                    LeadQuery += LeadField + ',';
                }
            }
            LeadQuery = LeadQuery.substring(0,LeadQuery.length()-1);
            LeadQuery += ' from Lead where id = \'' +leadObjid + '\'';
            system.debug('LeadQuery***'+LeadQuery);
            Lead TempLead = (Lead)Database.query(LeadQuery);
            system.debug('TempLead***'+TempLead);
            return TempLead;
        }
        return NULL;
    }
    
    //-----------------------------
    // @author: Vinod Merwade
    // @date: 18 July 2017
    // @param:  None
    // @description: SFDC1-45 and SFDC1-186 Goes back to the Lead detail page
    // @return: none
    // @Company: Vertiba
    //------------------------------   
    public PageReference backToLead()
    {
        return new pagereference('/'+leadObj.Id);
    }
    
    //-----------------------------
    // @author: Vinod Merwade
    // @date: 18 July 2017
    // @param:  Mapping Name Keyword, map<string,LeadConversionFieldMapping__c> 
    // @description: SFDC1-45 and SFDC1-186 Creates field Mapping for the Lead and Selected Object
    // @return: map<string,LeadConversionFieldMapping__c>
    // @Company: Vertiba
    //------------------------------    
    public static map<string,LeadConversionFieldMapping__c> getFieldMapping(string mapName,map<string,LeadConversionFieldMapping__c> mapLeadToConversionMappping)
    {
        map<string,LeadConversionFieldMapping__c> mapLeadToTargetField = new map<string,LeadConversionFieldMapping__c>();
        if(!mapLeadToConversionMappping.isEmpty()) {
            for(String MappingName : mapLeadToConversionMappping.keyset()) {
                if(MappingName.ContainsIgnoreCase(mapName) && MappingName.startswith(mapName)) {
                    mapLeadToTargetField.put(mapLeadToConversionMappping.get(MappingName).SourceAPIField__c,mapLeadToConversionMappping.get(MappingName));
                }
            }
        }
        return mapLeadToTargetField;
    } 
    //-----------------------------
    // @author: Vinod Merwade
    // @date: 12 Oct 2017
    // @param:  Lead Object and converted Opportunity Id 
    // @description: SFDC1-4816 when the lead is converted, Campaigns associated with Lead will be associate to the Opportunity
    // @return: NA
    // @Company: Vertiba
    //------------------------------    
    public void campaignFromLeadToOpportunity(Lead currentleadObj, Id OppId) {
        try {
            Id CampaignModel = [select Id from CampaignInfluenceModel where IsDefaultModel= true limit 1].id;
            List<Campaign> camps =[select  Id, Name from Campaign where Id in (select CampaignId from CampaignMember c where LeadId =: currentleadObj.Id)];
            List<CampaignInfluence>  campaignInfluenceList = new List<CampaignInfluence>();
            if(!camps.isEmpty()) {
                for(campaign c :camps) {
                    CampaignInfluence campInfluence = new CampaignInfluence();
                    campInfluence.OpportunityId = OppId;
                    campInfluence.CampaignId = c.id;
                    campInfluence.ModelId = CampaignModel;
                    campInfluence.Influence =100;
                    campaignInfluenceList.add(campInfluence);
                }
            }
            if(!campaignInfluenceList.isEmpty()) {
                insert campaignInfluenceList;
            }
        } catch (Exception e) {
            system.debug('Campaign Influence Insertion Failed!'+e.getMessage());
        }
    }
}