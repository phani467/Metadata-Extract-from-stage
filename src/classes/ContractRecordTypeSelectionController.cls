//-----------------------------
// @author: Prachi Bhasin
// @date: 14 Sept 2017
// @param: NA
// @description: Class which acts as controller for Create Contract Wizard in lightning 
// @return: NA
// @company: VERTIBA
// @lastModifiedBy: Prachi
// @lastModifiedSprint: Sprint 11 SFDC1-5282 - Removing NDA from create contract wizard & SFDC1-4576 Sync contact roles from Opp to Contract
// @lastModifiedSprint: Sprint 12 SFDC1-710 -  Continuation letter related updates to creation method
// @lastModifiedSprint: Sprint 12 SFDC1-5490 - Client legal entity to be populated with Account
// @lastModifiedSprint: Sprint 13 SFDC1-5520 - Continuation Letter Contract Record Entry
// @Last Modified By : Prachi Bhasin
// @Last Modified Description : Added new methods for SFDC1-5520
// @Last Modified Date : 17-Nov-2017
// @Last Modified By : Vishnu Vardhan Chowdary Andra
// @Last Modified Description : Updated findContractStartAndEndDate for new validations. SFDC1-5640
// @Last Modified Date : 22-Nov-2017
// @Last Modified By : Mohit Modi
// @Last Modified Description : SFDC1-5803 - Removed the 'Continuation Letter' recordtype selection from New Bussiness Opportunity recordtype.
// @Last Modified Date : 23-Nov-2017
// @ast Modified By: Hemant Shukla
// @Last Modified Date: 28 Nov 2017
// @Last Modified Description: SFDC1-6032, Added an additional check  before creating a contarct for owner and team member.
// @Last Modified By : Prachi Bhasin
// @Last Modified Date: 6 Dec 2017
// @Last Modified Description: SFDC1-6099, Provide functionality to create NDA contracts from opportunity And Continuation letter related changes 
// @Last Modified By : Prachi Bhasin
// @Last Modified Date: 13 Dec 2017 Sprint 15
// @Last Modified Description: SFDC1-6254, The effective date should match the Contract Start Date when the record is created.
// @Last Modified By : Prachi Bhasin
// @Last Modified Date: 15 Dec 2017
// @Last Modified Description: SFDC1-5326, Opportunity Behavior - when a Future Disconnect Product is on the Opportunity, do not allow contract creation
// @Last Modified By : Prachi Bhasin
// @Last Modified Date: 21 Dec 2017
// @Last Modified Description: SFDC1-6248, Contract Order Reason default value should appear for Order form
// @Last Modified By : Prachi Bhasin
// @Last Modified Date: 21 Dec 2017
// @Last Modified Description: SFDC1-5520, Code updated to ensure Continuation letter can be created only when Oppty has an 'Existing' status product. Deleting email notification.
// @Last Modified By : Prachi Bhasin
// @Last Modified Date: 10 Jan 2018
// @Last Modified Description: SFDC1-6493, Code updated to ensure 'MultiYear' checkbox is set on order form contracts from related opportunity.
// @Last Modified By : Prachi Bhasin
// @Last Modified Date: 9 Feb 2018
// @Last Modified Description: SFDC1-6916, Making changes for new Opportunity record type 'Gratis'.
// @Last Modified By : Prachi Bhasin
// @Last Modified Date: 14 Feb 2018
// @Last Modified Description: SFDC1-6942, Adding value '14' for continuation letter record type.SFDC1-6974- Sales Ops profile should be able to create contract for all opportunities.
// @Last Modified By : Prachi Bhasin
// @Last Modified Date: 27 Feb 2018
// @Last Modified Description: SFDC1-4739, Adding check so that unauthorized profiles are not able to create contract.
// @Last Modified By : Prachi Bhasin
// @Last Modified Date: 14 Feb 2018
// @Last Modified Description: SFDC1-7094, Enable 'System Admin' and 'Contract Manager' profile to create contract from any opportunity.
// @Last Modified By : Prachi Bhasin
// @Last Modified Date: 6 March 2018
// @Last Modified Description: SFDC1-4324, Populating 'Associated Product' lookup on contract line item.
// @Last Modified By : Prachi Bhasin
// @Last Modified Date: 7 March 2018
// @Last Modified Description: SFDC1-7212, Updating 'Order Form' to 'Order Form/ Addenda'.
// @Last Modified By : Prachi Bhasin
// @Last Modified Date: 9 March 2018
// @Last Modified Description: SFDC1-7205 - Order Form can only be created at contracting stage.
// @Last Modified By : Prachi Bhasin
// @Last Modified Date: 14 March 2018
// @Last Modified Description: SFDC1-7114 - Order Form creation on the basis of discount approval.
// @Last Modified By : Prachi Bhasin
// @Last Modified Date: 23 March 2018
// @Last Modified Description: SFDC1-7586 - Populate the Product lookup on Contract Line Items.
// @Last Modified By : Prachi Bhasin
// @Last Modified Date: 27 March 2018
// @Last Modified Description: SFDC1-7508 - Adding check since, DPA contract record type should not be created from Opportunity
// @Last Modified By : Prachi Bhasin
// @Last Modified Date: 27 March 2018
// @Last Modified Description: SFDC1-7631 -Populate contract end date after 5 years of contract effective date for NDA contracts.
// @Last Modified By : Prachi Bhasin
// @Last Modified Date: 3 April 2018
// @Last Modified Description: SFDC1-7773 -Update addenda to addendum for contract wizard.
// @Last Modified By : Prachi Bhasin
// @Last Modified Date: 19 April 2018
// @Last Modified Description: SFDC1-7679 -Including currency code for contract and contract line item
// @Last Modified By : Prachi Bhasin
// @Last Modified Date: 27 April 2018
// @Last Modified Description: SFDC1-7803 -Changes for inner year record type
// @Last Modified By : Prachi Bhasin
// @Last Modified Date: 12 June 2018
// @Last Modified Description: SFDC1-8325 - Auto Renewal should not be able to create an Order Form if Does this auto renew have change is No
// @Last Modified By : Prachi Bhasin
// @Last Modified Date: 13 June 2018
// @Last Modified Description: WAR room bug fix for SOW/Consulting
// @Last Modified By : Prachi Bhasin
// @Last Modified Date: 28 June 2018
// @Last Modified Description: SFDC1-8989 Adding logic for 'Continuation End Date' calculation
// @Last Modified By : Prachi Bhasin
// @Last Modified Date: 13 July 2018
// @Last Modified Description: SFDC1-9231 Adding logic for 'Continuation End Date' calculation, so that it includes the day from which contract is beginning
//-----------------------------
public without sharing class ContractRecordTypeSelectionController {

    public static Date startDateForContinuation;
    //-----------------------------
    // @author: Prachi Bhasin
    // @date: 14 Sept 2017
    // @param: String - name of Object
    // @description: SFDC1- 380 : When creating the Contract from an Opportunity data should flow from Opportunity to Contract
    // @return: String of wrapper (with record name and id)
    // @company: VERTIBA
    //------------------------------
    @AuraEnabled
    public static string findRecordTypes(string objName,string oppId) {
        
        string oppRecordtypeName = [select id, recordtype.Name from Opportunity where id = :oppId ].recordtype.Name ;
        system.debug('oppRecordtypeName----'+oppRecordtypeName);
        
        string returnString='';
        string queryString='Select id, name from RecordType where sobjectType =: objName and IsActive=true';
        List<sobject> recordList= Database.query(queryString);
        List<RecordTypeWrapper> wrapperList=new List<RecordTypeWrapper>();
        for(sobject sb : recordList)  {
            if((string.valueof(sb.get('name')) !='DPA') && (oppRecordtypeName == 'Renewal' || (oppRecordtypeName == 'New Business' && string.valueof(sb.get('name')) != 'Continuation Letter') || (oppRecordtypeName == 'Inner Year' && string.valueof(sb.get('name')) != 'Continuation Letter') || (oppRecordtypeName == 'Forecasting Placeholder' && string.valueof(sb.get('name')) != 'Continuation Letter'))) {
                RecordTypeWrapper rw=new RecordTypeWrapper();
                rw.recordTypeLabel=string.valueof(sb.get('name'));
                rw.recordTypeId=string.valueof(sb.get('id'));
                wrapperList.add(rw);
            }
            if(oppRecordtypeName == 'Gratis' && string.valueof(sb.get('name')) == 'Order Form') {
                RecordTypeWrapper rw=new RecordTypeWrapper();
                rw.recordTypeLabel=string.valueof(sb.get('name'));
                rw.recordTypeId=string.valueof(sb.get('id'));
                wrapperList.add(rw);
            }           
        } 
        for(RecordTypeWrapper rw:wrapperList) {
            if(rw.recordTypeLabel == 'Order Form') {
                rw.recordTypeLabel = 'Order Form/Addendum';    
            }
            if(rw.recordTypeLabel == 'Consulting') {
                rw.recordTypeLabel = 'SOW/Consulting';    
            }
        }
        returnString= JSON.serialize(wrapperList);
        system.debug('*****'+returnString);
        return returnString;
    }
    
    //-----------------------------
    // @author: Prachi Bhasin
    // @date: 21Sept 2017
    // @param: NA
    // @description: SFDC1- 380 : When creating the Contract from an Opportunity data should flow from Opportunity to Contract
    // @return: String of trialRecordType Id
    // @company: VERTIBA
    //------------------------------
    @AuraEnabled
    public static string setTrialRecordTypeId() {
        Id trialRecordTypeId = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('Trial').getRecordTypeId();
        return String.valueOf(trialRecordTypeId);
    }
    
    //-----------------------------
    // @author: Prachi Bhasin
    // @date: 7 Dec 2017
    // @param: Id opportunity record Id
    // @description: SFDC1-710 This method calculates the contract start date for continuation letter contract
    // @return: Date
    // @company: VERTIBA
    //------------------------------
    @AuraEnabled
    public static date contractContinuationStartDateCalculation(Id oppRecordId) {
        Id conLetterRecordTypeId = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('Continuation Letter').getRecordTypeId();
        List<Contract> continuationLetterList = new List<Contract>([Select id, EndDate from Contract where recordtypeId =:conLetterRecordTypeId AND Opportunity__c =: oppRecordId ORDER BY lastmodifiedDate DESC limit 1]); 
        Opportunity oppForContract = [Select id,ContractBeingRenewed__c,Opportunity.ContractBeingRenewed__r.EndDate from opportunity where id=:oppRecordId];    
            
            Contract continuationLetter;
            
            if(continuationLetterList!= NULL && continuationLetterList.size()>0)
                continuationLetter = continuationLetterList[0]; 
            
            if (continuationLetter != NULL)
                startDateForContinuation = continuationLetter.EndDate.addDays(1);
            else if (oppForContract.ContractBeingRenewed__c != NULL)
                startDateForContinuation = oppForContract.ContractBeingRenewed__r.EndDate.addDays(1);
        system.debug('startDateForContinuation---'+startDateForContinuation    );    
        return startDateForContinuation;
    }
    
    //-----------------------------
    // @author: Prachi Bhasin
    // @date: 16 Nov 2017
    // @param: String number of days
    // @param: String start date of contract
    // @description: SFDC1-5520 This method calculates the contract end date ,when start date and number of days contract is valid are provided
    // @return: Date
    // @company: VERTIBA
    //------------------------------
    @AuraEnabled
    public static date contractEndDateCalculation(String days, String startDate) {
        Date endDate = date.valueOf(startDate);
        endDate = endDate.addDays(Integer.valueOf(days)-1);
        return endDate;
    }
    
    //-----------------------------
    // @author: Prachi Bhasin
    // @date: 16 Nov 2017
    // @param: Id opportunity record Id
    // @param: String start date of contract
    // @param: String end date of contract
    // @description: SFDC1-5520 This method calculates the total days of continuation logic
    // @return: String of number of totalContinuationDays
    // @company: VERTIBA
    //------------------------------
    @AuraEnabled
    public static String findTotalDaysOfContinuation(Id oppRecordId, String startDate, String endDate) {
        Id conLetterRecordTypeId = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('Continuation Letter').getRecordTypeId();
        Opportunity oppForContract = [Select Id,TotalDaysOfContinuation__c,ContractBeingRenewed__r.EndDate,ContinuationEndDate__c, (Select Id,ContractTermDays__c,StartDate,EndDate,recordTypeId from Contracts__r) from Opportunity where Id =: oppRecordId limit 1];
        Integer totalContinuationDays = Date.valueOf(startDate).daysBetween(Date.valueOf(endDate)) +1;
        Integer currentContinuationDays = totalContinuationDays;
        system.debug('here');
        if(oppForContract.Contracts__r!= null && oppForContract.Contracts__r.size()>0) {
        for(Contract c:oppForContract.Contracts__r) {
            if(c.recordTypeId == conLetterRecordTypeId) {
                totalContinuationDays = totalContinuationDays + c.startDate.daysBetween(c.endDate) + 1;
            } 
          }
        }
        String message;
        if((totalContinuationDays<=90) || ((totalContinuationDays>90) && (oppForContract.TotalDaysOfContinuation__c>totalContinuationDays))) {
            message = 'opportunity updated';
            oppForContract.TotalDaysOfContinuation__c = totalContinuationDays;
            if(NULL != oppForContract.ContractBeingRenewed__c && NULL == oppForContract.ContinuationEndDate__c) {
            oppForContract.ContinuationEndDate__c = oppForContract.ContractBeingRenewed__r.EndDate.addDays(totalContinuationDays);
            }
            else {
            oppForContract.ContinuationEndDate__c = oppForContract.ContinuationEndDate__c.addDays(currentContinuationDays);   
            }
            update oppForContract;
        }
        else if((oppForContract.TotalDaysOfContinuation__c < totalContinuationDays)) {
            message = 'totalContinuationDays'+totalContinuationDays;
        }
        return message;
    }
    
    //-----------------------------
    // @author: Prachi Bhasin
    // @date: 16 Nov 2017
    // @param: Id opportunity record Id
    // @param: String start date of contract
    // @param: String end date of contract
    // @param: String contract term in days
    // @param: String acceptanceObtained
    // @description: SFDC1-5520 This method creates continuation letter contract record
    // @return: Id of contract record created
    // @company: VERTIBA
    // @modification date: 9th July 2018
    // @modified by : Ankita Singh
    // @modification description :SFDC1-8051 legal entity on opportunity prevented from getting copied from opportunity into contract with exception of orderform
    //------------------------------
    @AuraEnabled
    public static Id createContinuationContractRecord (Id oppRecordId, String startDate, String endDate, String status, String acceptanceObtained) {
        
        Opportunity oppForContract = [Select id,CurrencyISOCode,PORequired__c,OwnerId,Owner.Email,Owner.Name,ContractBeingRenewed__c,Opportunity.ContractBeingRenewed__r.EndDate, LegalEntity__c,TotalDaysOfContinuation__c, accountId, owner.firstname, owner.lastname, ContractEndDate__c, ContractStartDate__c, account.BillingCountry, account.name,name,Opportunitynum__c,EstimatedValue__c from opportunity where id=:oppRecordId];
        Id conLetterRecordTypeId = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('Continuation Letter').getRecordTypeId();
        Contract contractRecord = new contract(recordtypeid = conLetterRecordTypeId, accountid = oppForContract.AccountId , Opportunity__c=oppRecordId);
        List<Contract> continuationLetterList = new List<Contract>([Select id, EndDate from Contract where recordtypeId =:conLetterRecordTypeId AND Opportunity__c =: oppRecordId ORDER BY lastmodifiedDate DESC limit 1]); 
            
            Contract continuationLetter;
            
            if(continuationLetterList!= NULL && continuationLetterList.size()>0)
                continuationLetter = continuationLetterList[0];       
            if (continuationLetter != NULL)
                startDateForContinuation = continuationLetter.EndDate.addDays(1);
            else if (oppForContract.ContractBeingRenewed__c != NULL)
                startDateForContinuation = oppForContract.ContractBeingRenewed__r.EndDate.addDays(1);
                // 2018-02-2 Ayan: AccountManager__c field is deprecated per SFDC1-6814
                //contractRecord.AccountManager__c = oppForContract.owner.firstname + ' '+ oppForContract.owner.lastname;                
                contractRecord.StartDate = startDateForContinuation ;
                contractRecord.EndDate = startDateForContinuation.addDays(Integer.ValueOf(status)-1);             
                contractRecord.EffectiveDate__c = contractRecord.StartDate;
                contractRecord.OriginalContract__c = oppForContract.ContractBeingRenewed__c;
                if(status == '30' || status == '60' || status =='90' || status == '14') {        
                    contractRecord.ContractTermDays__c = status;
                } 

                contractRecord.ClientLegalEntityLookUp__c = oppForContract.AccountId;
            // Legal Entity will be populated on contract update manually
            if(oppForContract.LegalEntity__c != NULL) {
                contractRecord.IHSMarkitLegalEntity__c = oppForContract.LegalEntity__c;
            }
            contractRecord.CurrencyISOCode = oppForContract.CurrencyISOCode;          
            insert contractRecord;
            
        if(acceptanceObtained == 'Yes') {
            oppForContract.TotalDaysOfContinuation__c = oppForContract.TotalDaysOfContinuation__c + Date.valueOf(startDate).daysBetween(Date.valueOf(endDate)) +1;
            oppForContract.ContinuationEndDate__c = contractRecord.EndDate;
            update oppForContract;
        }       
        system.debug('contractRecord.id----'+contractRecord.id);
        return contractRecord.id;
    }
    
    //-----------------------------
    // @author: Prachi Bhasin
    // @date: 21Sept 2017
    // @param: NA
    // @description: SFDC1- 380 : When creating the Contract from an Opportunity data should flow from Opportunity to Contract
    // @return: String of trialRecordType Id
    // @company: VERTIBA
    //------------------------------
    @AuraEnabled
    public static date setContractStartDateFromOppty(Id oppId) {
        Opportunity oppForContract = [Select id, ContractStartDate__c from Opportunity where id =: oppId limit 1];
        return oppForContract.ContractStartDate__c;
    }
    
    //-----------------------------
    // @author: Prachi Bhasin
    // @date: 9 Nov 2017
    // @param: NA
    // @description: SFDC1- 5520 : When creating the Contract from an Opportunity it sets up continuaiton letter record type id
    // @return: String of continuation letter record type Id
    // @company: VERTIBA
    //------------------------------
    @AuraEnabled
    public static string setConLetterRecordTypeId() {
        Id conLetterRecordTypeId = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('Continuation Letter').getRecordTypeId();
        return String.valueOf(conLetterRecordTypeId);
    }
    
    //-----------------------------
    // @author: Prachi Bhasin
    // @date: 14 Sept 2017
    // @param: Id of contract record type, Id of Opportunity record from which contract record is being created
    // @description: SFDC1- 380 : When creating the Contract from an Opportunity data should flow from Opportunity to Contract
    // @return: Id of contract record that has been created in this method
    // @company: VERTIBA
	// @Modified By : Ankita Singh
	// @Modification Date: 22nd May 2018
	// @Modification Discription: SFDC1-6735: Added Contract record type 'Consulting' to the existing functionality of creating contract using createContract wizard
    // @modification date: 9th July 2018
    // @modified by : Ankita Singh
    // @modification description :SFDC1-8051 legal entity on opportunity prevented from getting copied from opportunity into contract with exception of orderform
    // @modification date: 23th July 2018
    // @modified by : Ankita Singh
    // @modification description :SFDC1-9301 When order form or consulting records are created Product Family Should be populated from Opoortunity
	//------------------------------        
    @AuraEnabled
    public static Id createDefaultRecord(Id rectype, Id oppRecordId) {
        try {
            Id orderFormRecordTypeId = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('Order Form').getRecordTypeId();
            Id continuationLetterFormRecordTypeId = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('Continuation Letter').getRecordTypeId();
            Id NDARecordTypeId = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('NDA').getRecordTypeId();
            Id consultingRecordTypeId = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('Consulting').getRecordTypeId();
         //   Id masterAgreementRecordTypeId = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('Master Agreement').getRecordTypeId();
            Id MSTRecordTypeId = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('Managed Service Terms (MST)').getRecordTypeId();
            Opportunity oppForContract = [Select id, CurrencyISOCode, LegalEntity__c,ProductFamily__c, ProductGroup__c, MultiYear__c, DiscountApprovalAttachmentCount__c, RecordType.Name,ContractBeingRenewed__r.EndDate,ContractBeingRenewed__c, PORequired__c, accountId, owner.firstname, owner.lastname, ContractEndDate__c, ContractStartDate__c, account.BillingCountry, account.BillingState from opportunity where id=:oppRecordId]; //SFDC1-5228 JK- Change
            //List<Contract> continuationLetterList = new List<Contract>([Select id, EndDate from Contract where recordtypeId =:continuationLetterFormRecordTypeId AND Opportunity__c =: oppRecordId ORDER BY lastmodifiedDate DESC limit 1]); 
            //Contract continuationLetter;
            //if(continuationLetterList!= NULL && continuationLetterList.size()>0)
                //continuationLetter = continuationLetterList[0];
        
            //if (continuationLetter != NULL)
                //startDateForContinuation = continuationLetter.EndDate;
            //else if (oppForContract.ContractBeingRenewed__c != NULL)
                //startDateForContinuation = oppForContract.ContractBeingRenewed__r.EndDate;
            
            Contract contractRecord = new contract(recordtypeid = rectype, accountid = oppForContract.AccountId , Opportunity__c=oppRecordId);
            // 2018-02-2 Ayan: AccountManager__c field is deprecated per SFDC1-6814
            //contractRecord.AccountManager__c = oppForContract.owner.firstname + ' '+ oppForContract.owner.lastname;
            contractRecord.ClientLegalEntityLookUp__c = oppForContract.AccountId;
            contractRecord.StartDate = oppForContract.ContractStartDate__c;            
            contractRecord.EffectiveDate__c = System.Today();           
            contractRecord.CurrencyISOCode = oppForContract.CurrencyISOCode; 

            if((String.valueOf(rectype).substring(0,15) == String.valueOf(NDARecordTypeId).substring(0,15))) {
                contractRecord.EndDate = contractRecord.EffectiveDate__c.addYears(5);
            }
            else {
                contractRecord.EndDate = oppForContract.ContractEndDate__c; 
            }
            // Legal Entity will be populated on contract 
            if(oppForContract.LegalEntity__c != NULL ) {
                contractRecord.IHSMarkitLegalEntity__c = oppForContract.LegalEntity__c;
			}
            
            if((String.valueOf(rectype).substring(0,15) == String.valueOf(orderFormRecordTypeId).substring(0,15)) || (String.valueOf(rectype).substring(0,15) == String.valueOf(consultingRecordTypeId).substring(0,15))) {
                contractRecord.PORequired__c = oppForContract.PORequired__c;
                contractRecord.EffectiveDate__c = contractRecord.StartDate;
                if(oppForContract.ProductFamily__c != null && oppForContract.ProductFamily__c !='') {
				contractRecord.ProductFamily__c = oppForContract.ProductFamily__c;
                }
                if(oppForContract.ProductGroup__c != null && oppForContract.ProductGroup__c !='') { //SFDC1-5228 JK- New
					contractRecord.ProductGroup__c = oppForContract.ProductGroup__c;
                }
                contractRecord.MultiyearOrderForm__c = oppForContract.MultiYear__c;
                if(oppForContract.RecordType.Name == 'Renewal') {
                    contractRecord.OrderReason__c = 'Renewal';
                }
                else {
                    contractRecord.OrderReason__c = 'New';  
                }
            }
            
            if((oppForContract.RecordType.Name == 'Renewal') && (String.valueOf(rectype).substring(0,15) == String.valueOf(continuationLetterFormRecordTypeId).substring(0,15))) {
                system.debug('startDateForContinuation--'+startDateForContinuation);
                contractRecord.StartDate = startDateForContinuation.addDays(1);
                contractRecord.ContractTermDays__c = '30';
                contractRecord.EndDate = contractRecord.StartDate.addDays(30);
            }
            
            insert contractRecord;          
            
            ContractRecordTypeSelectionController.copyContactRolesFromOpportunityToContract(oppForContract.Id, contractRecord.Id);
            
            if((String.valueOf(rectype).substring(0,15) == String.valueOf(orderFormRecordTypeId).substring(0,15)) || (String.valueOf(rectype).substring(0,15) == String.valueOf(consultingRecordTypeId).substring(0,15))) {
                    copyProductsFromOpportunityToContract(oppRecordId, contractRecord.Id,null,rectype,contractRecord.CurrencyISOCode);
                }
                return contractRecord.id;
        }
        catch(Exception e) {
            System.debug('Error, method createDefaultRecord, class ContractRecordTypeSelectionController ');
            ApexLogger__c apexLogRecord = new ApexLogger__c(ClassName__c='ContractRecordTypeSelectionController ',ErrorDescription__c='Error ',FunctionName__c='createDefaultRecord');
            insert apexLogRecord;  
            return null;
        }
    }
    
    //-----------------------------
    // @author: Prachi Bhasin
    // @date: 14 Sept 2017
    // @param: Id of opportunity record, Id of contract record
    // @description: SFDC1- 380 : When creating the Contract from an Opportunity data should flow from Opportunity to Contract
    // @return: None
    // @company: VERTIBA
	// @Modified By : Ankita Singh
	// @Modification Date: 22nd May 2018
	// @Modification Discription: SFDC1-6735: Added Contract record type 'Consulting' to the existing functionality of creating contract using createContract wizard
    //------------------------------
    public static void copyProductsFromOpportunityToContract(Id opportunityId, Id contractId, List<String> lstSelectedOppItem,Id rectype,String currencyValue) {
        try {
            Map<String,OpportunityToContractLineItemMapping__c> mapOppToContractLineItemMapping = OpportunityToContractLineItemMapping__c.getAll();
            String productStatus = 'Lost';
            Id orderFormRecordTypeId = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('Order Form').getRecordTypeId();
            Id consultingRecordTypeId = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('Consulting').getRecordTypeId();
            String querySelect = 'SELECT ';
            for(OpportunityToContractLineItemMapping__c objIns : mapOppToContractLineItemMapping.values()) {
                querySelect = querySelect + objIns.OpportunityLineItemField__c + ',';                
            }
            querySelect = querySelect +'Product2.Name,CurrencyISOCode,Product2.MediaType__c,Product2.Id,OpportunityId,SAPLineItem__c,Opportunity.RecordType.Name ';
            String queryFrom = 'FROM OpportunityLineItem ';
            String queryWhere = 'WHERE OpportunityId = \''+opportunityId+'\''; 
            
            if(lstSelectedOppItem!=null)
                queryWhere = queryWhere +'AND Id IN: lstSelectedOppItem'; 
            
            if((String.valueOf(rectype).substring(0,15) == String.valueOf(orderFormRecordTypeId).substring(0,15)) || (String.valueOf(rectype).substring(0,15) == String.valueOf(consultingRecordTypeId).substring(0,15)))
                queryWhere = queryWhere +'AND Status__c != \''+ productStatus +'\'';                             
                    
            String query = querySelect + queryFrom + queryWhere;

            List<OpportunityLineItem> lstOppLineItem = new List<OpportunityLineItem>();
            lstOppLineItem = Database.query(query);
                                   
            List<ContractLineItem__c> lstContractLineItem = new List<ContractLineItem__c>();
                if(lstOppLineItem.size()>0) {
                    for(OpportunityLineItem oppLineRec: lstOppLineItem) {
                        ContractLineItem__c contractLineRec = new ContractLineItem__c();
                        for(OpportunityToContractLineItemMapping__c objIns : mapOppToContractLineItemMapping.values()) {
                            contractLineRec.put(objIns.ContractLineItemField__c , oppLineRec.get(objIns.OpportunityLineItemField__c));  
                        }                        
                        contractLineRec.Contract__c = contractId;
                        contractLineRec.Name = oppLineRec.Product2.Name;
                        contractLineRec.MediaType__c = oppLineRec.Product2.MediaType__c;
                        contractLineRec.AssociatedProduct__c = oppLineRec.Product2.Id;
                        contractLineRec.Product__c = oppLineRec.Product2.Id;
                        contractLineRec.CurrencyISOCode = currencyValue;
                        if((String.valueOf(rectype).substring(0,15) == String.valueOf(orderFormRecordTypeId).substring(0,15) || (String.valueOf(rectype).substring(0,15) == String.valueOf(consultingRecordTypeId).substring(0,15))) && oppLineRec.Opportunity.RecordType.Name == 'Renewal')
                            contractLineRec.SAPLineItem__c= oppLineRec.SAPLineItem__c;
                                
                        lstContractLineItem.add(contractLineRec);
                    }                
                }
            if(lstContractLineItem.size()>0) {
                insert lstContractLineItem;
                List<String> lstOppLineItemId = new List<String>();
                for(OpportunityLineItem oppLineItem: lstOppLineItem)
                    lstOppLineItemId.add(String.valueOf(oppLineItem.Id));
                                              
                    if((String.valueOf(rectype).substring(0,15) == String.valueOf(orderFormRecordTypeId).substring(0,15)) || (String.valueOf(rectype).substring(0,15) == String.valueOf(consultingRecordTypeId).substring(0,15))) {
                        copySchedulesFromOpportunityToContract(opportunityId, contractId, lstOppLineItemId);
                    }               
            }
        }
        catch(Exception e) {
            System.debug('Error, method copyProductsFromOpportunityToContract, class ContractRecordTypeSelectionController ');
            ApexLogger__c apexLogRecord = new ApexLogger__c(ClassName__c='ContractRecordTypeSelectionController ',ErrorDescription__c='Error',FunctionName__c='copyProductsFromOpportunityToContract');
            insert apexLogRecord;             
        }      
    }
    
    //-----------------------------
    // @author: Prachi Bhasin
    // @date: 16 Sept 2017
    // @param: Id of opportunity record, Id of contract record, List of OpportunityLineItems
    // @description: SFDC1- 380 : When creating the Contract from an Opportunity data should flow from Opportunity line item to Contract line item schedules
    // @return: None
    // @company: VERTIBA
    //------------------------------
    public static void copySchedulesFromOpportunityToContract(Id opportunityId, Id contractId, List<String> lstOppLineItemId) {
        try {
            Map<String,OpportunityToContractScheduleMapping__c> mapOppToContractScheduleMapping = OpportunityToContractScheduleMapping__c.getAll();
            
            String querySelect = 'SELECT ';
            system.debug('mapOppToContractScheduleMapping---'+mapOppToContractScheduleMapping);
            for(OpportunityToContractScheduleMapping__c objIns : mapOppToContractScheduleMapping.values()) {
                querySelect = querySelect + objIns.OpportunityScheduleField__c + ',';                
            }
            querySelect = querySelect +'Id,OpportunityProductId__c,Opportunity__c ';
            String queryFrom = 'FROM OpportunityLineItemSchedule__c ';
            String queryWhere = 'WHERE Opportunity__c = \''+opportunityId+'\'';  
            queryWhere = queryWhere +'AND OpportunityProductID__c IN: lstOppLineItemId';    
            
            String query = querySelect + queryFrom + queryWhere;
            
            List<ContractLineItem__c> lstContractLineItem = new List<ContractLineItem__c>([Select id, name, OpportunityProductId__c from contractlineitem__c where contract__c = :contractId]);
            List<OpportunityLineItemSchedule__c> lstOppProductSchedule = new List<OpportunityLineItemSchedule__c>();
            lstOppProductSchedule = Database.query(query);
                        
            Map<String, ContractLineItem__c> mapOppProductToContractLineItem = new Map<String,ContractLineItem__c>();           
            for(ContractLineItem__c cliRecord : lstContractLineItem) {
                mapOppProductToContractLineItem.put(cliRecord.OpportunityProductId__c,cliRecord);
            } 
            
            List<ContractLineItemSchedule__c> lstContractLineItemScheduleToBeCreated = new List<ContractLineItemSchedule__c>();
            for(OpportunityLineItemSchedule__c oppProdSchedule : lstOppProductSchedule) {
                ContractLineItemSchedule__c cliSchedule = new ContractLineItemSchedule__c();
                    for(OpportunityToContractScheduleMapping__c objIns : mapOppToContractScheduleMapping.values()) {
                        cliSchedule.put(objIns.ContractScheduleField__c , oppProdSchedule.get(objIns.OpportunityScheduleField__c));  
                    }
                cliSchedule.contract__c = contractId;
                cliSchedule.ContractLineItem__c = mapOppProductToContractLineItem.get(oppProdSchedule.OpportunityProductID__c).Id;
                lstContractLineItemScheduleToBeCreated.add(cliSchedule);                
            }
            insert lstContractLineItemScheduleToBeCreated;            
        }
        catch(Exception e) {
            System.debug('Error, method copySchedulesFromOpportunityToContract, class ContractRecordTypeSelectionController ');
            ApexLogger__c apexLogRecord = new ApexLogger__c(ClassName__c='ContractRecordTypeSelectionController ',ErrorDescription__c='Error',FunctionName__c='copySchedulesFromOpportunityToContract');
            insert apexLogRecord;             
        }       
    }
    
    public class RecordTypeWrapper{
        public string recordTypeLabel{get;set;}
        public string recordTypeId{get;set;}
    }
    
    //-----------------------------
    // @author: Prachi Bhasin
    // @date: 21 Sept 2017
    // @param: Opportunity Id
    // @description: SFDC1- 380 : Provides the list of opportunity products related to opportunity 
    // @return: List of related products
    // @company: VERTIBA
    //------------------------------
    
    @AuraEnabled
    public static string findProductsRelatedToOpportunity (string opptyId) {
        string returnString='';
        string queryString='Select id, name from OpportunityLineItem where OpportunityId =: opptyId';
        List<OpportunityLineItem> recordList= Database.query(queryString);
        List<OpportunityRecordWrapper> wrapperList=new List<OpportunityRecordWrapper>();
        for(OpportunityLineItem sb : recordList) {
            OpportunityRecordWrapper rw=new OpportunityRecordWrapper();
            rw.recordName=string.valueof(sb.get('name'));
            rw.recordId=string.valueof(sb.get('id'));
            rw.checked=FALSE;
            wrapperList.add(rw);
        } 
        returnString= JSON.serialize(wrapperList);
        system.debug('*****'+returnString);
        return returnString;
    }
    
    //-----------------------------
    // @author: Prachi Bhasin
    // @date: 21 Sept 2017
    // @param: NA
    // @description: SFDC1- 380 : When creating the Contract from an Opportunity, opportunity products related to opportunity are displayed using this wrapper
    // @return: NA
    // @company: VERTIBA
    //------------------------------
    public class OpportunityRecordWrapper {
        public string recordName {get;set;}
        public string recordId {get;set;}
        public boolean checked {get;set;}
    }
    
    //-----------------------------
    // @author: Prachi Bhasin
    // @date: 21 Sept 2017
    // @param: Id of opportunity record, Id of contract record, List of selected opportunity products
    // @description: SFDC1- 380 : When creating the Contract from an Opportunity trial contract record should provide functionality to select opportunity products
    // @return: Id of create trial contract record
    // @company: VERTIBA
    // @modification date: 9th July 2018
    // @modified by : Ankita Singh
    // @modification description :SFDC1-8051 legal entity on opportunity prevented from getting copied from opportunity into contract with exception of orderform
    //------------------------------
    @AuraEnabled
    public static Id createTrialContractRecord(Id oppRecordId, String oppLineItemId) {
        try {
            List<String> selectedIdsList = new List<String>();
            Object[] values = (Object[])System.JSON.deserializeUntyped(oppLineItemId);
            if(values.size()>0) {         
                 for (Object id : values) {
                     selectedIdsList.add(string.valueof(id) );
                }
            }
            Opportunity oppForContract = [Select id, CurrencyISOCode, LegalEntity__c, accountId, owner.firstname, owner.lastname, ContractEndDate__c, ContractStartDate__c, account.BillingCountry, account.BillingState from opportunity where id=:oppRecordId];
            Id trialRecordTypeId = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('Trial').getRecordTypeId();    
                Contract contractRecord = new contract(recordtypeid = trialRecordTypeId, accountid = oppForContract.AccountId , Opportunity__c=oppRecordId);
                // 2018-02-2 Ayan: AccountManager__c field is deprecated per SFDC1-6814
                //contractRecord.AccountManager__c = oppForContract.owner.firstname + ' '+ oppForContract.owner.lastname;
                contractRecord.ClientLegalEntityLookUp__c = oppForContract.AccountId;
                contractRecord.StartDate = System.Today();
                contractRecord.EndDate = System.Today() + 30;
                contractRecord.ContractTermDays__c = '30';
                contractRecord.EffectiveDate__c = contractRecord.StartDate;
                contractRecord.CurrencyISOCode = oppForContract.CurrencyISOCode;
				//Legal Entity will be populated on contract update manually 
				//uncommenting the code to allow copying the legal entity from oppy
            if(oppForContract.LegalEntity__c != NULL) {
              contractRecord.IHSMarkitLegalEntity__c = oppForContract.LegalEntity__c;  
            }
                
                
                insert contractRecord;
            
                copyProductsFromOpportunityToContract(oppRecordId,contractRecord.Id,selectedIdsList,trialRecordTypeId,contractRecord.CurrencyISOCode);
                ContractRecordTypeSelectionController.copyContactRolesFromOpportunityToContract(oppRecordId, contractRecord.Id);
                return contractRecord.Id;  
            }
        catch(Exception e) {
            System.debug('Error, method createTrialContractRecord, class ContractRecordTypeSelectionController ');
            ApexLogger__c apexLogRecord = new ApexLogger__c(ClassName__c='ContractRecordTypeSelectionController ',ErrorDescription__c='Error',FunctionName__c='createTrialContractRecord');
            insert apexLogRecord;  
            return null;
        }         
    }
    
    //-----------------------------
    // @author: Prachi Bhasin
    // @date: 21 Sept 2017
    // @param: Id of opportunity record, Id of contract record, List of selected opportunity products
    // @description: SFDC1- 380 : When creating the Contract from an Opportunity trial contract record should provide functionality to select opportunity products
    // @return: Id of create trial contract record
    // @company: VERTIBA
    // @Updated By: Hemant Shukla
    // @Updayed On: 28 Nov 2017
    // @description: SFDC1-6032, Added an additional check  before creating a contarct for owner and team member. 
    // @Last Modified By : Uttam Arya 7th July 2018
    // @Last Modified Description : SFDC1-9148 Sales Coordinator profile excluded from the profiles being checked
    // 
    //------------------------------
    @AuraEnabled
    public static String findContractStartAndEndDate(Id oppRecordId, Id rectype) {
        Id orderFormRecordTypeId = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('Order Form').getRecordTypeId();
        Id trialFormRecordTypeId = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('Trial').getRecordTypeId();
        Id continuationLetterFormRecordTypeId = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('Continuation Letter').getRecordTypeId();

        Opportunity opp =  [Select ContractStartDate__c,ContractBeingRenewed__c,ContractBeingRenewed__r.EndDate, OwnerId,
                                    DoesThisAutoRenewalHaveChanges__c,AutoRenewal__c, DiscountApprovalAttachmentCount__c, DiscountOverThreshold__c, RecordType.Name,StageName, ContractEndDate__c, 
                                    (Select id from Contracts__r where recordtypeId = :orderFormRecordTypeId),
                                    (Select Id from OpportunityTeamMembers where UserId = :UserInfo.getUserId()) 
                                    from Opportunity 
                                    where Id = :oppRecordId];

        String profileName=[Select Id,Name from Profile where Id=:userinfo.getProfileId()].Name;
        system.debug('ProfileName'+profileName);

        List<Contract> continuationLetterList = new List<Contract>([Select id, EndDate from Contract where recordtypeId =:continuationLetterFormRecordTypeId AND Opportunity__c =: oppRecordId ORDER BY lastmodifiedDate DESC limit 1]); 
        Date fullThreeDaysAvailable = UtilityClass.addBusinessDays(System.TODAY(),3);
        Contract continuationLetter;
        if(continuationLetterList!= NULL && continuationLetterList.size()>0)
        continuationLetter = continuationLetterList[0];
        
        //SFDC1-6032 - User who is trying to create a contarct, is neither the owner nor the Opp Team member then throw an error and
        //don't allow to create.
        if(   opp.OpportunityTeamMembers.isEmpty() 
           && opp.OwnerId != UserInfo.getUserId() 
           && !profileName.contains('Sales Ops')
           && !profileName.contains('Sales Coordinator')
           && !profileName.contains('IHSMarkit System Admin') 
           && !profileName.contains('Contract Manager') 
           && !profileName.contains('System Administrator')) {
            return 'NotAnOppTeamMember';
        }
        //Check if profile is allowed to create Contract
        if(profileName.contains('Read Only') || profileName.contains('Customer Care') || profileName.contains('Data Governance')|| profileName.contains('IHSMarkit Delivery')|| profileName.contains(' Legal')||
            profileName.contains('IHSMarkit Order Management')|| profileName.contains('Marketing') ||profileName.contains('Product Manager')){
            return 'NotAnAuthorizedProfile';
        }
        if(String.valueOf(rectype).substring(0,15) == String.valueOf(orderFormRecordTypeId).substring(0,15)) {
            Integer primatyOCRCount= [Select count() from OpportunityContactRole where OpportunityId =: oppRecordId and IsPrimary = true]; 
            if(primatyOCRCount==0) {
                return 'NoPrimaryContactOnOpportunity';
            }
            Integer oliCount = [Select count() from OpportunityLineItem where OpportunityId =: oppRecordId]; 
            if(oliCount==0) {
                return 'NoProductOnOpportunity';
            }
            if(!profileName.contains('System Admin') && ((opp.RecordType.Name=='New Business' && opp.StageName != '5-Contracting') || (opp.RecordType.Name=='Renewal' && opp.StageName != '5-Renewal Contracting'))) {
                return 'NoContractingStage';    
            }
            if(opp.DiscountOverThreshold__c == TRUE && (opp.DiscountApprovalAttachmentCount__c==0)) {
                return 'discountAttachmentNeeded';    
            }
        }
        //SFDC1-5520 - No continuation letter allowed if opportunity does not have an existing product
        if(String.valueOf(rectype).substring(0,15) == String.valueOf(continuationLetterFormRecordTypeId).substring(0,15)) {
            Integer oliCount = [Select count() from OpportunityLineItem where OpportunityId =: oppRecordId and Status__c = 'Existing']; 
            if(oliCount==0) {
                return 'NoExisitingProductOnOpportunity';
            }
        }
        
        List<String> inactiveProductRelated = WarningMsgProductCrossPlantStatus.getOptyProdLineDetails(oppRecordId);
        if(!inactiveProductRelated.isEmpty() && opp.RecordType.Name=='New Business' && (rectype == orderFormRecordTypeId || rectype == trialFormRecordTypeId)) {
            return 'inactiveProductRelated';   
        } 
        
        if(opp.Contracts__r.size()>0 && (String.valueOf(rectype).substring(0,15) == String.valueOf(orderFormRecordTypeId).substring(0,15)))
            return 'orderFormAlreadyPresent';

        
        else if(((opp.ContractStartDate__c == NULL) || (opp.ContractEndDate__c == NULL)) && (String.valueOf(rectype).substring(0,15) != String.valueOf(trialFormRecordTypeId).substring(0,15)))
           return 'contractDatesRequired';
        
        else if(((opp.RecordType.Name != 'Renewal') && (String.valueOf(rectype).substring(0,15) == String.valueOf(continuationLetterFormRecordTypeId).substring(0,15))))
            return 'noRenewalOppty';
        
        else if(((opp.DoesThisAutoRenewalHaveChanges__c == FALSE && opp.AutoRenewal__c == TRUE)) && (opp.RecordType.Name == 'Renewal') && (String.valueOf(rectype).substring(0,15) == String.valueOf(continuationLetterFormRecordTypeId).substring(0,15)))
            return 'opptyNotSetToAutoRenewal';
        
        else if(((opp.DoesThisAutoRenewalHaveChanges__c == FALSE && opp.AutoRenewal__c == TRUE)) && (opp.RecordType.Name == 'Renewal') && (String.valueOf(rectype).substring(0,15) == String.valueOf(orderFormRecordTypeId).substring(0,15)))
            return 'orderFormNotAllowedOnAutoRenewalWithoutChanges';
        
        else if((continuationLetter == NULL) && (opp.ContractBeingRenewed__c == NULL) && (opp.RecordType.Name == 'Renewal') && (String.valueOf(rectype).substring(0,15) == String.valueOf(continuationLetterFormRecordTypeId).substring(0,15)))
            return 'noActiveContract';
            
        else if((continuationLetter != NULL) && (continuationLetter.EndDate < fullThreeDaysAvailable) && (String.valueOf(rectype).substring(0,15) == String.valueOf(continuationLetterFormRecordTypeId).substring(0,15)))
            return '3daysUnavailable';
        
        else if((continuationLetter == NULL) && (opp.ContractBeingRenewed__c != NULL) && (opp.ContractBeingRenewed__r.EndDate < fullThreeDaysAvailable) && (String.valueOf(rectype).substring(0,15) == String.valueOf(continuationLetterFormRecordTypeId).substring(0,15)))
            return '3daysUnavailable';    
        
        else if(((opp.ContractStartDate__c != NULL) && (opp.ContractEndDate__c != NULL)) || (String.valueOf(rectype).substring(0,15) == String.valueOf(trialFormRecordTypeId).substring(0,15)))
            return 'contractDatesPresent';
        
        else if(((opp.ContractStartDate__c != NULL) && (opp.ContractEndDate__c != NULL)) || (String.valueOf(rectype).substring(0,15) == String.valueOf(trialFormRecordTypeId).substring(0,15)))
            return 'contractDatesPresent';
      
        else
            return 'recordComplete';

    }
    
    
    //-----------------------------
    // @author: Prachi Bhasin
    // @date: 27 Sept 2017
    // @param: String - Id of Contract Record on which 'Opportunity Sync' button is clicked
    // @description: SFDC1-1047 : Contract Lines and Schedules - Sync from Opportunity Products
    // @return: NA
    // @company: VERTIBA
    //------------------------------
    @AuraEnabled
    public static void deleteExistingContractLineItemsAndSchedules(string contractId) {
        string returnString='';
        string queryString='Select id,CurrencyISOCode, name, Opportunity__c, recordType.Name, recordType.Id, (Select id from Contract_Line_Items__r), (Select id from ContractLineItemSchedules__r) from Contract where Id =: contractId';
        List<Contract> recordList= Database.query(queryString);
        Contract contractRecord = recordList[0];
        Savepoint sp = Database.setSavepoint();
        try {
            if((contractRecord.ContractLineItemSchedules__r != null) && (contractRecord.ContractLineItemSchedules__r.size()>0))
                delete contractRecord.ContractLineItemSchedules__r;
            if((contractRecord.Contract_Line_Items__r != null) && (contractRecord.Contract_Line_Items__r.size()>0))
                delete contractRecord.Contract_Line_Items__r;            
            ContractRecordTypeSelectionController.copyProductsFromOpportunityToContract(contractRecord.Opportunity__c,contractRecord.Id,null,contractRecord.recordType.Id,contractRecord.CurrencyISOCode);        
            ContractRecordTypeSelectionController.deleteExistingContractContactRoles(contractRecord.Opportunity__c, contractRecord.Id);
        }
        catch(Exception e) {
            Database.rollback(sp);
            System.debug('Error, method deleteExistingContractLineItemsAndSchedules, class ContractRecordTypeSelectionController ');
            ApexLogger__c apexLogRecord = new ApexLogger__c(ClassName__c='ContractRecordTypeSelectionController ',ErrorDescription__c='Error',FunctionName__c='deleteExistingContractLineItemsAndSchedules');
            insert apexLogRecord;
    
        }        
    }
    
    //-----------------------------
    // @author: Prachi Bhasin
    // @date: 26 Oct 2017
    // @param: Id of Opportunity Record , Id of Contract Record
    // @description: SFDC1-4576 : Copying opportunity contact role from Opportunity to contract
    // @return: NA
    // @company: VERTIBA
    //------------------------------
    @AuraEnabled
    public static void copyContactRolesFromOpportunityToContract(Id opportunityId, Id contractId) {
        List<OpportunityContactRole> recordList= new List<OpportunityContactRole>([Select OpportunityId, ContactId, Role, IsPrimary from OpportunityContactRole where OpportunityId =: opportunityId]); 
        List<ContractContactRole> contractRolesToBeCreated = new List<ContractContactRole>();       
        Savepoint sp = Database.setSavepoint();
        try {
            if((recordList!= NULL) && (recordList.size()>0)) {
                for(OpportunityContactRole roleObj: recordList) {
                    ContractContactRole contractRoleObj = new ContractContactRole();
                    contractRoleObj.ContractId = contractId;
                    contractRoleObj.ContactId = roleObj.ContactId;
                    contractRoleObj.Role = roleObj.Role;
                    contractRoleObj.IsPrimary = roleObj.IsPrimary;
                    contractRolesToBeCreated.add(contractRoleObj);
                }
                insert contractRolesToBeCreated;
            }
        }
        catch(Exception e) {
            Database.rollback(sp);
            System.debug('Error, method copyContactRolesFromOpportunityToContract, class ContractRecordTypeSelectionController ');
            ApexLogger__c apexLogRecord = new ApexLogger__c(ClassName__c='ContractRecordTypeSelectionController ',ErrorDescription__c='Error',FunctionName__c='copyContactRolesFromOpportunityToContract');
            insert apexLogRecord;
    
        }        
    }
    
    //-----------------------------
    // @author: Prachi Bhasin
    // @date: 26 Oct 2017
    // @param: Id of Contract Record
    // @description: SFDC1-4576 : Copying opportunity contact role from Opportunity to contract
    // @return: NA
    // @company: VERTIBA
    //------------------------------
    @AuraEnabled
    public static void deleteExistingContractContactRoles(Id opportunityId, Id contractId) {        
        List<ContractContactRole> recordList= new List<ContractContactRole>([Select id, contractId from ContractContactRole where contractId =: contractId]);       
        Savepoint sp = Database.setSavepoint();
        try {
            if((recordList != null) && (recordList.size()>0))
                delete recordList;       
            ContractRecordTypeSelectionController.copyContactRolesFromOpportunityToContract(opportunityId,contractId);        
        }
        catch(Exception e) {
            Database.rollback(sp);
            System.debug('Error, method deleteExistingContractContactRoles, class ContractRecordTypeSelectionController ');
            ApexLogger__c apexLogRecord = new ApexLogger__c(ClassName__c='ContractRecordTypeSelectionController ',ErrorDescription__c='Error',FunctionName__c='deleteExistingContractContactRoles');
            insert apexLogRecord;
    
        }        
    }
    
     /**
     * @author : Ankita Singh
     * @date : 02 JAN 2018
     * @description : SFDC1-5897 Method to check whether user is logged in from community or not
     * @param : void
     * @return : Boolean
     * @companyname : IHS Markit
     */
    @auraEnabled
    public static boolean isCommunity() {        
        return UtilityClass.isCommunity();
    }
}