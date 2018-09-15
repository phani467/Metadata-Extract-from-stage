/**
* @author: Mohit Modi
* @date: 27 September 2017
* @description: SFDC1-4363. Before insert and Before update dispatcher event handler class that calls the functions in ContractMethods.
* @companyname: VERTIBA
* @LastModifiedby: Prachi Bhasin
* @ModifiedDate: 26 Feb 2018
* @description: SFDC1-4739: Adding preventContractDeletion method
* @LastModifiedby: Vishnu Vardhan, Ankita
* @ModifiedDate: 13 Mar 2018
* @description: SFDC1-4324, 4702, 7204: Adding new methods to execute after Update handler.
* @LastModifiedby: Mohit Modi
* @ModifiedDate: 24 April 2018
* @description: SFDC1-8059 : updated preventContractDeletion method, Removed all the profiles and added a reverse check for allowing only System Admin profile to delete the Contract.
* @author: Sruti Srivastava
* @date: 11th May 2018
* @description: SFDC1-7855-When an "Order Form" Contract record is updated "Completed" 
* the Opportunity should be updated to 6WP
*
* @ModifiedBy: Tran-Vu Tran
* @ModifiedDate: 22 May 2018
* @Description: implementation for SFDC1-7680 Update Countersignature Status and Countersignature Owner
* 				and SFDC1-8252 Update Contract Stage
* @ModifiedBy: Sruti Srivastava
* @ModifiedDate: 2 July 2018
* @Description: SFDC1-8960 - Update Contract Stage to "Complete", when Contract Status is updated to "Validated" for Consulting contracts
* @ModifiedBy: Jagadesh Kumar
* @ModifiedDate: 03 July 2018
* @Description: SFDC1-9020 - To validate the Case Account and Case->Contact->Account/Case->Contact->Related Accounts 
*/

public class ContractMethods {

    /** 
    * @author: Mohit Modi
    * @date: 27 September 2017
    * @description: SFDC1-4363. When a Contract record is created/updated the Opportunity, Copy the Primary Contact Values to Contract Record
    * @param: TriggerParameters Contains the trigger parameters which includes the record(s) that got created.
    * @companyname: VERTIBA
    * @return: void
    */
    /** 
    * @author: Mohit Modi
    * @date: 27 September 2017
    * @description: SFDC1-4363. When a Contract record is created/updated the Opportunity, Copy the Primary Contact Values to Contract Record
    * @param: TriggerParameters Contains the trigger parameters which includes the record(s) that got created.
    * @companyname: VERTIBA
    * @LastModifiedby: Ayan Mohanty
    * @ModifiedDate: 14th Feb 2018
    * @description: SFDC1-6993: Removing BillToFaxNumber__c and ShipToFaxNumber__c instances
    * @return: void
    */
    public static void CopyPrimaryContactToContract(TriggerParameters tp) {
        
        if(tp.tEvent == TriggerParameters.TriggerEvent.beforeInsert ||
            tp.tEvent == TriggerParameters.TriggerEvent.beforeUpdate)
        {   
            set<id> setOpportunityid = new set<id>();
            List<Contract> listContracts = (List<Contract>) tp.newList;
            Map<Id,Contract> mapOldContract = (Map<Id,Contract>)tp.oldMap;
            map<id,OpportunityContactRole> mapOpportunityIdOpportunityContactRole = new map<id,OpportunityContactRole>();

            //1. Collect all the OpportunityIds for the Contracts
            for(Contract Contractobj : listContracts ) {
                if(tp.tEvent == TriggerParameters.TriggerEvent.beforeInsert && !String.isBlank(Contractobj.Opportunity__c))
                {
                    setOpportunityid.add(Contractobj.Opportunity__c);
                }
                if(tp.tEvent == TriggerParameters.TriggerEvent.beforeUpdate && !String.isBlank(Contractobj.Opportunity__c) &&
                    Contractobj.Opportunity__c != mapOldContract.get(Contractobj.id).Opportunity__c)
                {
                    setOpportunityid.add(Contractobj.Opportunity__c);
                }
            }
            
            if(!setOpportunityid.isEmpty())
            {
                // Quering the Opportunity Contact Role Records with Contact Values
                for( OpportunityContactRole OpportunityContactRoleobj : [select id,ContactId,IsPrimary,OpportunityId,Contact.FirstName,
                                                                           Contact.LastName,Contact.Fax,Contact.Email,Contact.Phone from OpportunityContactRole
                                                                           where IsPrimary = true AND OpportunityId in : setOpportunityid])
                {
                    mapOpportunityIdOpportunityContactRole.put(OpportunityContactRoleobj.OpportunityId ,OpportunityContactRoleobj);
                }
                
                for(Contract Contractobj : listContracts ) {
                    
                   if(mapOpportunityIdOpportunityContactRole.containskey(Contractobj.Opportunity__c))
                   {
                       // Adding Bill To Fields from Primary Contact to Contract
                       Contractobj.BillToContactEmailAddress__c = mapOpportunityIdOpportunityContactRole.get(Contractobj.Opportunity__c).Contact.Email;
                       Contractobj.BillToContactFirstName__c = mapOpportunityIdOpportunityContactRole.get(Contractobj.Opportunity__c).Contact.FirstName;
                       Contractobj.BillToContactLastName__c = mapOpportunityIdOpportunityContactRole.get(Contractobj.Opportunity__c).Contact.LastName;
                       Contractobj.BillToContactTelephoneNumber__c = mapOpportunityIdOpportunityContactRole.get(Contractobj.Opportunity__c).Contact.Phone;
                       //Contractobj.BillToFaxNumber__c = mapOpportunityIdOpportunityContactRole.get(Contractobj.Opportunity__c).Contact.Fax;
                       
                       // Adding Ship To Fields from Primary Contact to Contract
                       Contractobj.ShipToContactEmailAddress__c = mapOpportunityIdOpportunityContactRole.get(Contractobj.Opportunity__c).Contact.Email;
                       Contractobj.ShipToContactFirstName__c = mapOpportunityIdOpportunityContactRole.get(Contractobj.Opportunity__c).Contact.FirstName;
                       Contractobj.ShipToContactLastName__c = mapOpportunityIdOpportunityContactRole.get(Contractobj.Opportunity__c).Contact.LastName;
                       Contractobj.ShipToContactTelephoneNumber__c = mapOpportunityIdOpportunityContactRole.get(Contractobj.Opportunity__c).Contact.Phone ;
                       //Contractobj.ShipToFaxNumber__c = mapOpportunityIdOpportunityContactRole.get(Contractobj.Opportunity__c).Contact.Fax;
                       
                   }
                }
            }
        }
    } 
    /** 
    * @author: Prachi Bhasin
    * @date: 26 Feb 2018
    * @description: SFDC1-4739- Do not allow certain profiles to delete contract.
    * @param: TriggerParameters Contains the trigger parameters which includes the record(s) that got created.
    * @companyname: VERTIBA
    * @return: void
    * @author : Mohit Modi
    * @description : SFDC1-8059 : Removed all the profiles and added a reverse check for allowing only System Admin profile to delete the Contract.
    * @date : 24 April 2018
    */
    public static void preventContractDeletion(TriggerParameters tp) {
        String profileName=[Select Id,Name from Profile where Id=:userinfo.getProfileId()].Name;
        system.debug('ProfileName'+profileName);
        List<Contract> listContracts = (List<Contract>) tp.oldList;
        for(Contract contractObj : listContracts ) {
            if(!profileName.contains('System Admin')){
                contractObj.addError('You are not authorized to Delete a Contract.');
            }
        }               
    }

    //-----------------------------
    // @author: Ankita Singh, Vishnu vardhan chowdary
    // @date: 13 March 2018
    // @description: SFDC1-4702, 7204, 4324 - Create child cases based on the contract status 'ReadyForProcessing'
    // 			and Record type. If the Contract is moved back to 'ReadyForProcessing' again, then dont recreate 
    // 			case, instead first check and then either create/ignore/delete the case.
    // @param: TriggerParameters Contains the trigger parameters which includes the record(s) that got updated.
    // @companyname: VERTIBA
    // @author: Vishnu Vardhan
    // @date: 13 April 2018
    // @description: SFDC-7826: Removing all the code written for 4702, 7204.
    // @author: Vishnu Vardhan
    // @date: 18 May 2018
    // @description: SFDC-7740: Adding the code for OF Contracts.
    // @author: Vishnu Vardhan
    // @date: 24 May 2018
    // @description: SFDC-4324: Changing code for Continuation letter Contracts. To get CLI from original contract
    // @author: Vishnu Vardhan
    // @date: 29 Jun 2018
    // @description: SFDC-8902, 8948: Populating new fields in implementation case
    // @Modified By : Vishnu Vardhan Chowdary Andra
    // @Modification Date: 13 Jul 2018
    // @Modification Description: SFDC1-9241 -If Contract Status is Scheduled Termination, then ignore existing
    // 				Impl cases and create new ones.
    // @Modified By : Vishnu Vardhan Chowdary Andra
    // @Modification Date: 24 Jul 2018
    // @Modification Description: SFDC1-9470 -If Contract Status is Validated PO Pending, then create imple cases
    // @return: void
    //-----------------------------
    public static void createCaseFromContract(TriggerParameters tp) {
        if(tp.tEvent == TriggerParameters.TriggerEvent.afterUpdate) {   
               List<Contract> listContracts = (List<Contract>) tp.newList;
               Map<Id,Contract> mapOldContract = (Map<Id,Contract>)tp.oldMap;
               Set<ID> listFilteredContractId = new  Set<Id>();
               List<Case> caseToBeInserted = new List<Case>();
               List<Case> caseToBeDeleted = new List<Case>();
               Map<string,id> caseQueue = new Map<string, id>();
               
               Id orderManagementRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Order Management').getRecordTypeId();
               Id implementationRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Implementation').getRecordTypeId();
               Id orderFormRecordTypeId = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('Order Form').getRecordTypeId();
               Id trialRecordTypeId = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('Trial').getRecordTypeId();
               Id continuationLetterRecordTypeId = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('Continuation Letter').getRecordTypeId();

               for(Contract Contractobj : listContracts ) {
                   Contract oldContract = mapOldContract.get(Contractobj.id);
                   if(Contractobj.status != oldContract.status 
                      && Contractobj.status == 'ReadyForProcessing'
                      && (Contractobj.recordTypeId == trialRecordTypeId ||
                          Contractobj.recordTypeId == continuationLetterRecordTypeId)) {
                              listFilteredContractId.add(Contractobj.id);
                   }
                   else if(Contractobj.ContractStatus__c != oldContract.ContractStatus__c 
                      && Contractobj.recordTypeId == orderFormRecordTypeId) {
                       if(Contractobj.ContractStatus__c == 'Scheduled Termination') {
                          //Even if a contract has OM case generated when it moved to Validation, still OM 
                          //Case has to be created if Contract is marked as Scheduled Termination
                          listFilteredContractId.add(Contractobj.id);
                       } else if ((Contractobj.ContractStatus__c == 'Validated PO Pending' || Contractobj.ContractStatus__c == 'Validated') 
                            && (oldContract.ContractStatus__c != 'Validated' && oldContract.ContractStatus__c != 'Validated PO Pending')) {
                           //If a case is moving from Validated PO Pending to Validated and in reverse, then case shouldnt be created.
                           listFilteredContractId.add(Contractobj.id);
                       } 
                   } 
               }
               if(listFilteredContractId.isEmpty()) {
                   System.debug('No Contracts to process');
                   return;
               }
               System.debug('Contracts to process '+listFilteredContractId);
               for(Group g : [select Id,DEVELOPERNAME from Group where Type = 'Queue' AND 
                              DEVELOPERNAME in ('FMOnboarding','CSOnboarding')]) {
                   caseQueue.put(g.DEVELOPERNAME,g.id);
               }
               
               //List of contracts that will be processed, Closed cases can be ignored.
               List <Contract> contractList = [select id, accountId, account.Name,account.Type, recordTypeId, OriginalContract__c, ContractNumber, 
                                               ContractStatus__c, (Select ContactId from ContractContactRoles where IsPrimary = true limit 1),
                                               (select id, recordTypeId, LoadingGroupOnboarding__c from Cases__r where recordTypeId in (:implementationRecordTypeId, :orderManagementRecordTypeId) and isClosed=false)
                                               FROM Contract where id IN: listFilteredContractId];
               listFilteredContractId = new Set<id>();
               //Prepare list of Contract ids from which loading group will be taken
               Map<Id,String> acctTypeMap = new Map<Id,String>();//AccountId and Account Type Map Used while insert Implementation case Type records
               for(Contract ctrct: contractList) {
                   if(ctrct.recordTypeId != continuationLetterRecordTypeId) {
                       listFilteredContractId.add(ctrct.id);
                   } else if (ctrct.OriginalContract__c != null) {
                       listFilteredContractId.add(ctrct.OriginalContract__c);
                   }
                   acctTypeMap.put(ctrct.accountId,ctrct.account.Type);
               }

               Map<id,Contract> contractMap = new Map<id, Contract>([select id,
                                              (Select id, associatedProduct__r.Name, associatedProduct__r.loadingGroup__r.name, associatedProduct__r.loadingGroup__r.loadingGroupCategory__c From Contract_Line_Items__r) 
                                              FROM Contract where id IN: listFilteredContractId]);

               for(Contract ctrct: contractList) {
                   List<Case> existingCaseList = ctrct.Cases__r;
                   Id parentCaseId = null;
                   if(ctrct.RecordTypeId == orderFormRecordTypeId && ctrct.ContractStatus__c == 'Scheduled Termination') {
                       existingCaseList = null;//If Scheduled Termination is the status then ignore existing cases. Create new.
                   }
                   if(ctrct.RecordTypeId == orderFormRecordTypeId && existingCaseList != null && !existingCaseList.isEmpty()){
                       for(Integer i=0; i<existingCaseList.size();i++) {
                           if(existingCaseList.get(i).recordTypeId == orderManagementRecordTypeId){
                               //Om case will be used as parent case for all newly created cases.
                               //After entire process is done, left over cases will be deleted. So, removing it.
                               parentCaseId = existingCaseList.remove(i).Id;
                               break;
                           }
                       }
                   }
                   //Existing cases for the contract will be transferred into a map where 
                   //Key is loading group id or OMRecord for order form with IHS and values as cases
                   Map<String,Case> loadingIdToCaseMap = createLoadingIdToCaseMap (existingCaseList);
                   System.debug('loading Id To Case Map:'+loadingIdToCaseMap);

                   String caseType='';
                   if(ctrct.RecordTypeId == continuationLetterRecordTypeId) {
                       caseType = 'Continuation';
                   } else if (ctrct.RecordTypeId == trialRecordTypeId) {
                       caseType = 'Trial';
                   } else if (ctrct.RecordTypeId == orderFormRecordTypeId) {
                       if(ctrct.ContractStatus__c == 'Validated' || ctrct.ContractStatus__c == 'Validated PO Pending') {
                           caseType = 'New Contract';
                       }  /*else if (ctrct.ContractStatus__c == 'Scheduled Termination' && !ctrct.Opportunities2__r.isEmpty()) {
                           Opportunity renewalOpp = ctrct.Opportunities2__r.get(0);
                           if(renewalOpp.StageName != null && renewalOpp.StageName.contains('6L')) {
                               caseType = 'Scheduled Termination';
                           }
                       }*/ else if (ctrct.ContractStatus__c == 'Scheduled Termination') {
                           caseType = 'Scheduled Termination';
                       }
                   }
                   Map<Id, List<String>> loadingIdProductMap = new Map<Id, List<String>>();
                   //get all the available loading groups for this contract. if Contract is CL then get from related contract.
                   Map<String,Set<Id>> loadingGroups = new Map<String, Set<Id>>();
                   if(ctrct.recordTypeId != continuationLetterRecordTypeId) {
                       loadingGroups = getLoadingGroupCategoriesForThisContract(contractMap.get(ctrct.id));
                       loadingIdProductMap = getLoadingIdToProductMap(contractMap.get(ctrct.id));
                   } else if (ctrct.OriginalContract__c != null && 
                              contractMap.containsKey(ctrct.OriginalContract__c)) {
                       loadingGroups = getLoadingGroupCategoriesForThisContract(contractMap.get(ctrct.OriginalContract__c));
                       loadingIdProductMap = getLoadingIdToProductMap(contractMap.get(ctrct.OriginalContract__c));
                   } // Else if there are any existing implementation cases for this contract they will be deleted.
                   System.debug('Contract will have cases for:'+loadingGroups);
                   
                   if (loadingGroups.containsKey('Markit')) {
                       System.debug('have a markit case ');
                       Set<Id> loadingGroupIds = loadingGroups.get('Markit');
                       //4324, 7740 - (If the loading Group names/record id are same AND Loading Group Category == "Markit"), then create only ONE Implementation Case (child case)
                       //4324, 7740 - (If the loading Group names/record id are not same AND Loading Group Category == "Markit") , Create an Implementation Case (child Case) for every Loading Group
                       for(Id loadingGroupId : loadingGroupIds) {
                           System.debug('have a markit case for loading group id'+loadingGroupId);
                           Case cas = loadingIdToCaseMap.remove(loadingGroupId);
                           if(cas == null) { //Then create new case, else continue
                               cas = createCase (ctrct, caseQueue.get('FMOnboarding'), implementationRecordTypeId, 
                                                 loadingGroupId, parentCaseId, loadingIdProductMap.get(loadingGroupId));
                               cas.Type = caseType;
                               System.debug('Adding case for Markit'+cas);
                               caseToBeInserted.add(cas);
                           }
                       }
                   } 
                   if (loadingGroups.containsKey('IHS')) {
                       //7740 - If the Loading Group Category == "IHS", then as of now ignore, 
                       if(ctrct.recordTypeId == orderFormRecordTypeId) {
                           continue;
                       } else {
                           System.debug('have a IHS case for loading group id');
                           Set<Id> loadingGroupIds = loadingGroups.get('IHS');
                           //4324 - (If the loading Group names/record id are same AND Loading Group Category == "IHS"), then create only ONE Implementation Case (child case)
                           //4324 - (If the loading Group names/record id are not same AND Loading Group Category == "IHS") , Create an Implementation Case (child Case) for every Loading Group
                           for(Id loadingGroupId : loadingGroupIds) {
                               Case cas = loadingIdToCaseMap.remove(loadingGroupId);
                               System.debug('have a IHS case for '+loadingGroupId);
                               if(cas == null) { //Then create new case, else continue
                                   System.debug('Adding case for IHS2'+cas);
                                   cas = createCase (ctrct, caseQueue.get('CSOnboarding'), implementationRecordTypeId,
                                                     loadingGroupId, parentCaseId, loadingIdProductMap.get(loadingGroupId));
                                   cas.Type = caseType;
                                   caseToBeInserted.add(cas);
                               }
                           }
                       }
                   }
                   if(!loadingIdToCaseMap.values().isEmpty()) {
                   		caseToBeDeleted.addAll(loadingIdToCaseMap.values());
                   }
               }
               System.debug('Cases that will be deleted: '+caseToBeDeleted);
               if(caseToBeDeleted != null && !caseToBeDeleted.isEmpty()) {
                   delete caseToBeDeleted;
               }
               if(caseToBeInserted != null && !caseToBeInserted.isEmpty()) {
                   //SFDC1-9020 Before insert validate the Implementation Case Records, 
                   //Whether Case Account and Case Contact Account and Case Contact Related Accounts match.
                   CaseMethods.validateCaseContactAndAccount(caseToBeInserted,acctTypeMap);
                   //set this to true,so that it will not re validate the implementation case records in CaseMethods while insertion.
                   GlobalConstants.hasImplementationCaseValidated = true;
                   System.debug('Cases that will be created:'+caseToBeInserted);
                   insert caseToBeInserted;
               }
        }
    }

    //-----------------------------
	// @Author : Vishnu Vardhan Chowdary Andra
	// @Date : 13 Mar 2018
	// @Description : This method takes a Contract record, owner id, record type id and returns a case record
	// @param : Contract record, Owner Id, case record Type Id
    // @author: Vishnu Vardhan
    // @date: 29 Jun 2018
    // @description: SFDC-8902, 8948: Populating new fields in implementation case
	// @return : case
	//-----------------------------
    private static Case createCase (Contract ctrct, Id ownerId, Id recordId, Id loadingGroupId, 
                                    Id parentCaseId, List<String> productNames) {
        Case cas = new Case();
        cas.RecordTypeId = recordId;
        cas.LoadingGroupOnboarding__c = loadingGroupId;
        cas.AccountId = ctrct.AccountId;
        cas.Contract__c = ctrct.id;	
        cas.OwnerId = ownerId;
        cas.Status = 'New';
        cas.Origin = 'Internal';
        cas.Subject = ctrct.ContractNumber+ ' for '+ctrct.Account.Name;
        cas.ParentId = parentCaseId;
        if(!ctrct.ContractContactRoles.isEmpty()) {
            cas.ContactId = ctrct.ContractContactRoles.get(0).ContactId;
        }
        if(!productNames.isEmpty()) {
            cas.Subject = cas.Subject + ' - '+ productNames.remove(0);
            String description = 'In order to close this case you must attach Proof of Delivery for the following Products: \r\n';
            for(String pName : productNames) {
        		description = description + '\r\n' + pName;
        	}
            cas.Description = description;
        }
        return cas;
    }

	//-----------------------------
	// @Author : Vishnu Vardhan Chowdary Andra
	// @Date : 13 Mar 2018
	// @Description : This method takes a Contract record, as input and returns a set of loading group categories.
	// 			1. From Contract, get Contract Line items.
	// 			2. From each contract line item, get an associated product and from it, a loading group record.
	// 			3. In each loading group record there is a loading group category (either IHS or Markit).
	// @param : Contract record
	// @return : Map<String,Set<Id>>
	//-----------------------------
    private static Map<String,Set<Id>> getLoadingGroupCategoriesForThisContract (Contract contractObj) {
        Map<String,Set<Id>> loadingGroups = new Map<String,Set<Id>>();
        List<ContractLineItem__c> cliLst = contractObj.Contract_Line_Items__r;
        System.debug('All Contract Line items '+ cliLst);
        if(cliLst!=null && !cliLst.isEmpty()) {
            for (ContractLineItem__c cli : cliLst) {
                System.debug('Line item '+ cli);
                if (cli.AssociatedProduct__c!=null && cli.AssociatedProduct__r.LoadingGroup__c!=null) {
                    if(!loadingGroups.containsKey(cli.AssociatedProduct__r.LoadingGroup__r.LoadingGroupCategory__c)) {
                        loadingGroups.put(cli.AssociatedProduct__r.LoadingGroup__r.LoadingGroupCategory__c, new Set<Id>());
                    }
                    Set<Id> loadingGroupIds = loadingGroups.get(cli.AssociatedProduct__r.LoadingGroup__r.LoadingGroupCategory__c);
                    loadingGroupIds.add(cli.AssociatedProduct__r.LoadingGroup__c);
                    loadingGroups.put(cli.AssociatedProduct__r.LoadingGroup__r.LoadingGroupCategory__c, loadingGroupIds);
                } //else{//BSA's are pretty sure, we dont end here. Every CLI will have associated product, and loading group}
            }
        }
        return loadingGroups;
    }

    //-----------------------------
	// @Author : Vishnu Vardhan Chowdary Andra
	// @Date : 28 Jun 2018
	// @Description : This method takes a Contract record, as input and returns a Map with keys as loading group ids.
	// 			Keys as product names and loading group name from the contract line item. 
	// @param : Contract record
	// @return : Map<Id,Set<String>>
	//-----------------------------
    private static Map<Id,List<String>> getLoadingIdToProductMap (Contract contractObj) {
        Map<Id,List<String>> loadingGroups = new Map<Id,List<String>>();
        List<ContractLineItem__c> cliLst = contractObj.Contract_Line_Items__r;
        System.debug('All Contract Line items '+ cliLst);
        if(cliLst!=null && !cliLst.isEmpty()) {
            for (ContractLineItem__c cli : cliLst) {
                System.debug('Line item '+ cli);
                if (cli.AssociatedProduct__c!=null && cli.AssociatedProduct__r.LoadingGroup__c!=null) {
                    List<String> productNames = loadingGroups.get(cli.AssociatedProduct__r.LoadingGroup__c);
                    if(productNames == null) {
                        productNames = new List<String>();
                        //Adding loading group name as 0 element as it is required in Subject
                        productNames.add(cli.AssociatedProduct__r.LoadingGroup__r.Name);
                    } 
                    if (!productNames.contains(cli.AssociatedProduct__r.Name)) {
                        productNames.add(cli.AssociatedProduct__r.Name);
                    }
                    loadingGroups.put(cli.AssociatedProduct__r.LoadingGroup__c, productNames);
                } //else{//BSA's are pretty sure, we dont end here. Every CLI will have associated product, and loading group}
            }
        }
        return loadingGroups;
    }
    //-----------------------------
	// @Author : Vishnu Vardhan Chowdary Andra
	// @Date : 13 Mar 2018
	// @Description : This method takes a caseList List and creates a map with LoadingId, case.
	// 			This will help in verifying if a case has been already created for a specific criteria or not.
	// @param : caseList
	// @return : Map<String,Case>
    //-----------------------------
    private static Map<String,Case> createLoadingIdToCaseMap (List<Case> caseList) {
        Map<String,Case> caseMap = new Map<String,Case>();
        if(caseList != null && !caseList.isEmpty()) {
            for(Case c : caseList) {
                if(c.LoadingGroupOnboarding__c!=null) {
                    caseMap.put(c.LoadingGroupOnboarding__c, c);
                } else {
                    //We create only one case, for all the IHS loading group records in order form contract, 
                    //So, we dont have loading group in the case record. 
                    caseMap.put('OMRecord', c);
                }
            }
        }
        return caseMap;
    }
    
    
    //-----------------------------
    // @author: Ankita Singh
    // @date: 26 April 2018
    // @description: SFDC1-7488 Updating opportunity and case when ContractRejectionPastDue__c is set to true by Time trigger after 10 days
    // @param: TriggerParameters Contains the trigger parameters which includes the record(s) that got updated.
    // @companyname: VERTIBA
    // @return: void
    //-----------------------------
    public static void updateCaseAndOppoStatusContract(TriggerParameters tp) { 
        // Initializing variables
        List<Contract> listContracts = (List<Contract>) tp.newList;
        Map<Id,Contract> mapOldContract = (Map<Id,Contract>)tp.oldMap;
		Set<Id> opportunityId = new Set<Id>();
		Set<Id> caseId = new Set<Id>();
		List<Opportunity> oppoList = new List<Opportunity>();
		List<Case> caseList = new List<Case>();
		List<sObject> recordsToUpdate = new List<sObject>();
        String oppRecordTypeRenewal = 'Renewal';
        String oppRecordTypeNewB = 'NewBusiness';
        String oppRecordTypeIY = 'InnerYear';
        Id orderFormRecordTypeId = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('Order Form').getRecordTypeId();
		// fetching relevant ids to fetch case and opportunity associated with contract
		for(Contract c : listContracts) {
            Boolean ContRejecnPastDueOld = mapOldContract.get(c.id).ContractRejectionPastDue__c;          
			if(c.ContractRejectionPastDue__c == TRUE &&
               ContRejecnPastDueOld != c.ContractRejectionPastDue__c &&
               c.RecordTypeId == orderFormRecordTypeId) {
					opportunityId.add(c.Opportunity__c);
					caseId.add(c.Id);
			}	
		}
        // Opportunity stage change for relevant record 
		if(opportunityId.size() > 0 && opportunityId != null) {
			oppoList = [Select Id , StageName , recordType.DeveloperName from Opportunity where Id In:opportunityId];
			if(oppoList.size()>0) {
                
				for(Opportunity o : oppoList) {
					if(o.recordType.DeveloperName == oppRecordTypeRenewal || o.recordType.DeveloperName == oppRecordTypeIY) {
						o.StageName = '5-Renewal Contracting';
						recordsToUpdate.add(o);
					} 
					else if(o.recordType.DeveloperName == oppRecordTypeNewB) {
						o.StageName = '5-Contracting';
						recordsToUpdate.add(o);
					}
				}
			}
		}
        // case status change for relevant record of record type Order Management
		if(caseId.size() > 0 && caseId != null) {
			caseList = [Select Id , Status from Case where Contract__c In:caseId AND recordType.name = 'Order Management' AND Status='Rejected' ];
			if(caseList.size()>0) {
				for(Case c : caseList) {
						c.status = 'Canceled';	
						recordsToUpdate.add(c);	
				}
				
			}
		}
		try {
			if(recordsToUpdate.size()>0) {
				update recordsToUpdate;
			}
		}
		catch(Exception e) {
			UtilityClass.createApexLogRecord(e,'ContractMethods','updateCaseAndOppoStatusContract');
		}
	}   
    
    //-----------------------------
	// @Author : Vishnu Vardhan Chowdary Andra
	// @Date : 10 May 2018
	// @Description : SFDC1-7738: When order form contract is moved to Ready For Processing status.
	// 			then If OM case already exists, and have status as rejected then update status to 'Updated'. 
	// 			     If exists and status is different then update all fields from Contract and other related fields.
	// 			     Else create a new one and update all fields from Contract and other related fields.
	// @param : TriggerParameters Contains the trigger parameters which includes the record(s) that got updated.
	// @Company: Vertiba
	// @return : Void
	// @Modified By : Ankita Singh
	// @Modification Date: 22nd May 2018
	// @Modification Discription: SFDC1-6735: Added Contract record type 'Consulting' to the existing functionality which creates OM CASES.
    // @Modified By : Vishnu Vardhan Chowdary Andra
    // @Modification Date: 23rd May 2018
    // @Modification Discription: SFDC1-8262: Removing Contract Owner, as the field has to be recreatd to change lookup type
    // @Modified By : Tran-Vu Tran
    // @Modification Date: 29 May 2018
    // @Modification Discription: Update logic to use the new Opportunity's ComplianceRestrictions__c formula field
    //                            instead of Account's ComplianceRestrictions__c picklist field
    // @Modified By : Prachi Bhasin
    // @Modification Date: 8 Jun 2018
    // @Modification Discription: SFDC1-8691: Adding subject to case record being created / updated
	// @Modified By : Vishnu Vardhan Chowdary Andra
    // @Modification Date: 14 Jun 2018
    // @Modification Discription: SFDC1-8775: Changing field from Text to Currency, Since Cant change the field used
	//				in text, creating a new field and using it here.
	// @Modified By : Vishnu Vardhan Chowdary Andra
    // @Modification Date: 18 Jun 2018
    // @Modification Discription: SFDC1-7738: Changing the owner to Order Management Queue.
    // @Modified By : Anjani Shukla
    // @Modification Date: 03 Jul 2018
    // @Modification Description: SFDC1-7992 -Generate OM Case for Closed Lost Renewal
    // @Modified By : Prachi Bhasin
    // @Modification Date: 27 Jul 2018
    // @Modification Discription: SFDC1-9505: Populating PO required field on OM case.    
    //-----------------------------
    public static void createOrModifyOMCasesForOrderFormContracts(TriggerParameters tp) {
        if(tp.tEvent == TriggerParameters.TriggerEvent.afterUpdate) {   
           try { 
               List<Contract> listContracts = (List<Contract>) tp.newList;
               Map<Id,Contract> mapOldContract = (Map<Id,Contract>)tp.oldMap;
               Set<ID> listFilteredContractId = new  Set<Id>();
               List<Case> caseToBeInserted = new List<Case>();
               Map<string,id> caseQueue = new Map<string, id>();
               
               Id consultingRecordTypeId = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('Consulting').getRecordTypeId();
               Id orderManagementRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Order Management').getRecordTypeId();
               Id orderFormRecordTypeId = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('Order Form').getRecordTypeId();
               Id OrderMgmtQueueId = [SELECT QueueId,Queue.name FROM QueueSobject where Queue.name =: 'Order Management' limit 1].QueueId;
               
               for(Contract Contractobj : listContracts ) {
                   if(Contractobj.status != mapOldContract.get(Contractobj.id).status && 
                      (Contractobj.status == 'ReadyForProcessing') &&
                      (Contractobj.recordTypeId == orderFormRecordTypeId || Contractobj.recordTypeId == consultingRecordTypeId)) {
                       listFilteredContractId.add(Contractobj.id);                        
                   }
                   //SFDC1-7992 - Create OM Case
                    if(Contractobj.ContractStatus__c != mapOldContract.get(Contractobj.id).ContractStatus__c 
                       && Contractobj.ContractStatus__c == 'Scheduled Termination' && Contractobj.recordTypeId == orderFormRecordTypeId
                       ) {
                     	listFilteredContractId.add(Contractobj.id);       
                    }       
                }
               
               if(listFilteredContractId.isEmpty()) {
                   System.debug('No Contracts to process');
                   return;
               }
               System.debug('Contracts to process '+listFilteredContractId);
               String Ownerid = UserInfo.getUserId();//Just in case if queue is not there.
               List<Group> groupList = [select Id,DEVELOPERNAME from Group where Type = 'Queue' AND 
                              DEVELOPERNAME in ('OrderManagement')];
               if(!groupList.isEmpty()) {
                   OwnerId = groupList.get(0).id;
               }

               for(Contract ctrct: [
                   select id,ContractStatus__c, recordType.Name,ContractNumber, TotalContractValue__c, IHSMarkitLegalEntity__c, ChannelPartnerCompanyName__c, Status,
                   OrderReason__c, StartDate, EndDate, AutoRenewal__c, MultiyearOrderForm__c, BPNum__c, BSI__c, ProcessedContracttext__c,
                   Owner.UserRegion__c, Owner.HRBusinessLine__c, OwnerId, accountId, Opportunity__r.ComplianceRestrictions__c,Opportunity__r.PORequired__c, 
                   Opportunity__c, Opportunity__r.DoesThisAutoRenewalHaveChanges__c, Opportunity__r.LostReasonCode__c, Opportunity__r.LostReasonDescription__c,
                   (select id, TotalContractValueNew__c, ContractOwnerRegion__c, IHSMarkitLegalEntityNew__c, ContractRecordType__c, OrderReason__c, 
                    ContractStartDate__c, ContractEndDate__c, AccountId, Opportunity__c, Contract__c, ContractStage__c, status, //ContractOwner__c, 
                    AutoRenewal__c, AutoRenewalWithChange__c, Multiyear__c, ChannelPartnerCompanyName__c, ChannelPartnerBP__c, ComplianceRestrictions__c, 
                    BSIMembership__c, LostReasonCode__c, LostReasonDescription__c, SAPContract__c from Cases__r where recordTypeId =: orderManagementRecordTypeId)
                   FROM Contract where id IN: listFilteredContractId]) {
                       //ctrct.Cases__r
                       //1. Check if case is there and populate values. 
                       //2. Else create case.
                       Case cas = new Case();
                       if(!ctrct.Cases__r.isEmpty() && ctrct.ContractStatus__c != 'Scheduled Termination') {
                           //As per BSA, User cant directly create a OM case, so can safely assume 
                           //There will be either one or zero OM case.
                           cas = ctrct.Cases__r.get(0);
                           if (cas.Status == 'Rejected') {
                               cas.Status = 'Updated';
                           }
                       } else {
                           cas.RecordTypeId = orderManagementRecordTypeId;
                           //SFDC1-7992 - Create OM Case
                           system.debug('ctrct.ContractStatus__c1---->'+ctrct.ContractStatus__c);
                           system.debug('mapOldContract.get(ctrct.id).ContractStatus__c1--->'+mapOldContract.get(ctrct.id).ContractStatus__c);
                           
                           if(ctrct.ContractStatus__c != mapOldContract.get(ctrct.id).ContractStatus__c 
                              && ctrct.ContractStatus__c == 'Scheduled Termination'
                             ) {
                                 cas.OwnerId = OrderMgmtQueueId; 
                             } else {
                               	 cas.OwnerId = OwnerId;
                           }
                       }
                       cas.TotalContractValueNew__c = ctrct.TotalContractValue__c;
                       cas.ContractOwnerRegion__c = ctrct.Owner.UserRegion__c;
                       cas.HRBusinessUnit__c = ctrct.Owner.HRBusinessLine__c;
                       cas.IHSMarkitLegalEntityNew__c = ctrct.IHSMarkitLegalEntity__c;
                       cas.ContractRecordType__c = ctrct.RecordType.Name;
                       cas.OrderReason__c = ctrct.OrderReason__c;
                       cas.ContractStartDate__c = ctrct.StartDate;
                       cas.ContractEndDate__c = ctrct.EndDate;
                       cas.AccountId = ctrct.AccountId;
                       cas.Opportunity__c = ctrct.Opportunity__c;
                       cas.Contract__c = ctrct.Id;
                       String cntrctNumber = ctrct.ContractNumber;
                       //SFDC1-7992 - Create OM Case
                       system.debug('ctrct.ContractStatus__c2---->'+ctrct.ContractStatus__c);
                       system.debug('mapOldContract.get(ctrct.id).ContractStatus__c2--->'+mapOldContract.get(ctrct.id).ContractStatus__c);
                       if(ctrct.ContractStatus__c != mapOldContract.get(ctrct.id).ContractStatus__c &&  
                          ctrct.ContractStatus__c == 'Scheduled Termination'
                             ) {
                           cas.Subject = 'Closed Lost Renewal – {'+cntrctNumber +'}';
                        } else {
                            	cas.Subject = 'Processing Request – {'+cntrctNumber+'}';
                        }              
                       //cas.ContractOwner__c = ctrct.OwnerId;
                       cas.ContractStage__c = ctrct.Status;
                       cas.AutoRenewal__c = ctrct.AutoRenewal__c;
                       cas.AutoRenewalWithChange__c = ctrct.Opportunity__r.DoesThisAutoRenewalHaveChanges__c;
                       cas.Multiyear__c = ctrct.MultiyearOrderForm__c;
                       cas.ChannelPartnerCompanyName__c = ctrct.ChannelPartnerCompanyName__c;
                       cas.ChannelPartnerBP__c = ctrct.BPNum__c;
                       cas.ComplianceRestrictions__c = ctrct.Opportunity__r.ComplianceRestrictions__c;
                       cas.BSIMembership__c = ctrct.BSI__c;
                       cas.LostReasonCode__c = ctrct.Opportunity__r.LostReasonCode__c;
                       cas.LostReasonDescription__c = ctrct.Opportunity__r.LostReasonDescription__c;
                       cas.SAPContract__c = ctrct.ProcessedContracttext__c;
                       cas.PORequired__c = ctrct.Opportunity__r.PORequired__c;
                       caseToBeInserted.add(cas);
                   }
               System.debug('Cases to upsert:'+caseToBeInserted);
               if(!caseToBeInserted.isEmpty()) {
                   upsert caseToBeInserted;
                   system.debug('caseToBeInserted==>'+caseToBeInserted);
               }
           } catch (Exception e) {
               UtilityClass.createApexLogRecord(e,'ContractMethods','createOrModifyOMCasesForOrderFormContracts'); 
           }
        }
    }
	
    // @author: Sruti Srivastava
	// @date: 11th May 2018
	// @description: SFDC1-7855-When an "Order Form" Contract record is updated "Completed" 
	// the Opportunity should be updated to 6WP, runs on After Update
	// @param: TriggerParameters Contains the trigger parameters which includes the record(s) that got created.
	// @companyname: VERTIBA
	// @return: void
    public static void updateOppTo6WPClosedWonOPWhenOrderFormIsCompleted(TriggerParameters tp) {
        //this method runs on after update currently, adding after insert for future purpose
        if(tp.tEvent == TriggerParameters.TriggerEvent.afterUpdate || tp.tEvent == TriggerParameters.TriggerEvent.afterInsert) {
        	
            set<id> setOpportunityIds = new set<id>();
            List<Contract> listContracts = (List<Contract>) tp.newList;
            Map<Id,Contract> mapOldContract = (Map<Id,Contract>)tp.oldMap;
            map<id, Opportunity> mapOpportunity = new map<id, Opportunity>();
            Id orderFormRecordTypeId = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('Order Form').getRecordTypeId();
            
            // Collect all the OpportunityIds with recordtype "Gratis", "New Business" and "Renewal" for the Contracts with status "Complete"
            for(Contract contractObj : listContracts ) {
                if( !String.isBlank(contractObj.Opportunity__c) && contractObj.RecordTypeId == orderFormRecordTypeId
                  && !String.isBlank(contractObj.Status) && contractObj.Status.equalsIgnoreCase('Complete')  && 
                   (mapOldContract == null ||
                    (mapOldContract != null && !mapOldContract.get(contractObj.Id).Status.equalsIgnoreCase('Complete')))
                  && (contractObj.OpportunityRecordType__c.containsIgnoreCase('Business') || contractObj.OpportunityRecordType__c.containsIgnoreCase('Gratis') 
                      || contractObj.OpportunityRecordType__c.containsIgnoreCase('Renewal'))) {
                    setOpportunityIds.add(contractObj.Opportunity__c);
                }            
            }
                
            if(!setOpportunityIds.isEmpty()) {
                // Updating Opportunity Records to stage '6WP-Closed Won/Order Processed' 
                for( Id oppId : setOpportunityIds) {
                    mapOpportunity.put(oppId , new Opportunity(Id= oppId, StageName ='6WP-Closed Won/Order Processed'));
                }
            }
                
            try {
                //Updating Opportunity
                if(!mapOpportunity.isEmpty()) {
                    update mapOpportunity.values();
                }
            }
            catch(Exception exp) {
                String errMessage = exp.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION')? 
                                    exp.getMessage().substringAfterLast('FIELD_CUSTOM_VALIDATION_EXCEPTION,'):exp.getMessage();
                UtilityClass.createApexLogRecord(exp,'ContractMethods','updateOppTo6WPClosedWonOPWhenOrderFormIsCompleted');
                tp.newList[0].addError('Error: '+errMessage);
            }
        }
    } 
    //-----------------------------
    // @Author : Prachi Bhasin
    // @Date : 18 May 2018
    // @Description : SFDC1-8056: If SAP PGI’d is changed on order form contract, populate PGI Owner with LastModifiedBy field
    // @param : TriggerParameters Contains the trigger parameters which includes the record(s) that got updated.
    // @Company: Vertiba
    // @return : Void
    //-----------------------------
    public static void updatePGIOwnerField(TriggerParameters tp) {
        if(tp.tEvent == TriggerParameters.TriggerEvent.beforeUpdate || tp.tEvent == TriggerParameters.TriggerEvent.beforeInsert) {   
            try {
                Id orderFormRecordTypeId = Schema.Sobjecttype.Contract.getRecordTypeInfosByName().get('Order Form').getRecordTypeId(); 
                List<Contract> listContracts = (List<Contract>) tp.newList;
                Map<Id,Contract> mapOldContract = (Map<Id,Contract>)tp.oldMap;
                for(Contract conObj: listContracts) {
                    if((conObj.RecordTypeId == orderFormRecordTypeId) &&((NULL == mapOldContract && conObj.SAPPGId__c != NULL ) || (NULL != mapOldContract && conObj.SAPPGId__c != mapOldContract.get(conObj.Id).SAPPGId__c))) {
                        conObj.PGIOwner__c = UserInfo.getUserId();
                    }   
                }
            }               
            catch (Exception e) {
               UtilityClass.createApexLogRecord(e,'ContractMethods','updatePGIOwnerField'); 
           }
        }
    }
    
    //-----------------------------
    // @Author : Tran-Vu Tran
    // @Date : 22 May 2018
    // @Description: this method implements the following requirements for 2 user stories
    // 
    // + SFDC1-7680:
    // 	3. Update Countersignature Status to "New" if Countersignature Status was Null, and:
    // 		a. Record Type = "Order Form" or "Consulting", and Contract Status = "Validated" or "Validated PO Pending",
    // 		b. Record Type = Trial, Continuation, Master, NDA, MST, DPA, and Stage = "Ready for Processing"
    // 	4. If Countersignature Status value changed, populate Countersignature Owner with LastModifiedBy field
    // 
    // + SFDC1-8252: If Contract Status = "Validated" and Record Type = "Order Form", update Stage to "Completed"
    // @param : TriggerParameters Contains the trigger parameters which includes the record(s) that got updated.
    // @return : Void
	// Updated By: Sruti Srivastava
	// Description: SFDC1-8960 - Update Contract Stage to "Complete", when Contract Status is updated to "Validated" for
	// Consulting contracts

    //-----------------------------

    public static void updateCountersignatureFields(TriggerParameters tp) {
        if(tp.tEvent == TriggerParameters.TriggerEvent.beforeUpdate || tp.tEvent == TriggerParameters.TriggerEvent.beforeInsert) {   
            try {
                List<Contract> listContracts = (List<Contract>) tp.newList;
                Map<Id,Contract> mapOldContract = (Map<Id,Contract>)tp.oldMap;

                Id orderFormRecordTypeId = Schema.SobjectType.Contract.getRecordTypeInfosByName().get('Order Form').getRecordTypeId();
                Id consultingRecordTypeId = Schema.SobjectType.Contract.getRecordTypeInfosByName().get('Consulting').getRecordTypeId();
                
                for (Contract c: listContracts) {
                    if (c.RecordTypeId == orderFormRecordTypeId || c.RecordTypeId == consultingRecordTypeId) {
                        
                        // SFDC1-7680: if Contract Status = "Validated" or "Validated PO Pending", and Countersignature Status was not set
                        if ((c.ContractStatus__c == 'Validated' || c.ContractStatus__c == 'Validated PO Pending')
                            && c.CountersignatureStatus__c == null) {
                                // update Countersignature Status to "New"
                                c.CountersignatureStatus__c = 'New';
                        }

                        // SFDC1-8252, SFDC1-8960: if Contract Status = "Validated" and Record Type = "Order Form" or "Consulting"
                        if (c.ContractStatus__c == 'Validated' && c.Status != 'Complete') {
                                // update Stage to "Completed"
                                c.Status = 'Complete';
                        }
						
                    } else { // for different record types
                        if (c.Status == 'ReadyForProcessing'
                            && c.CountersignatureStatus__c == null ) {
                                // update Countersignature Status to "New"
                                c.CountersignatureStatus__c = 'New';
                        }
                    }
                    
                    // if CountersignatureStatus__c value changes
                    if ((mapOldContract == null && c.CountersignatureStatus__c != null) // when this one is a new inserted record
                        || (mapOldContract!=null && c.CountersignatureStatus__c != mapOldContract.get(c.Id).CountersignatureStatus__c) // or during update
                       ) {
                           c.CountersignatureOwner__c = UserInfo.getUserId(); // populate with current user Id, which would be the same as LastModifiedBy
                       }
                }

            }               
            catch (Exception e) {
               UtilityClass.createApexLogRecord(e,'ContractMethods','updateCountersignatureFields'); 
           }
        }
    }
	
	    //-----------------------------
    // @Author : Prachi Bhasin
    // @Date : 24 May 2018
    // @Description : SFDC1-8096: updating notice address fields  on contract from lega entity via code instead of process builder 'Populate IHS Markit Street Address on Contract'
    // @param : TriggerParameters Contains the trigger parameters which includes the record(s) that got updated.
    // @Company: Vertiba
    // @return : Void
    //-----------------------------
    public static void updateNoticeAddressFieldsOnContractFromLegalEntity(TriggerParameters tp) {
        
        if(tp.tEvent == TriggerParameters.TriggerEvent.beforeInsert ||
            tp.tEvent == TriggerParameters.TriggerEvent.beforeUpdate)
        { 
            try {
                Set<id> setLegalEntityId = new set<id>();
                List<Contract> listContracts = (List<Contract>) tp.newList;
                Map<Id,Contract> mapOldContract = (Map<Id,Contract>)tp.oldMap;
                for(Contract Contractobj : listContracts ) {
                    if(tp.tEvent == TriggerParameters.TriggerEvent.beforeInsert && NULL != Contractobj.IHSMarkitLegalEntity__c)
                    {
                        setLegalEntityId.add(Contractobj.IHSMarkitLegalEntity__c);
                    }
                    if(tp.tEvent == TriggerParameters.TriggerEvent.beforeUpdate && (NULL != Contractobj.IHSMarkitLegalEntity__c) &&
                        Contractobj.IHSMarkitLegalEntity__c != mapOldContract.get(Contractobj.id).IHSMarkitLegalEntity__c)
                    {
                        setLegalEntityId.add(Contractobj.IHSMarkitLegalEntity__c);
                    }
                    else if(tp.tEvent == TriggerParameters.TriggerEvent.beforeUpdate && (NULL == Contractobj.IHSMarkitLegalEntity__c) &&
                        Contractobj.IHSMarkitLegalEntity__c != mapOldContract.get(Contractobj.id).IHSMarkitLegalEntity__c)
                    {
                        Contractobj.IHSMarkitNoticeAddressCity__c = '';
                        Contractobj.IHSMarkitNoticeAddressCountry__c = '';
                        Contractobj.IHSMarkitNoticeZipCode__c = '';
                        Contractobj.IHSMarkitNoticeState__c = '';                   
                        Contractobj.IHSMarkitNoticeAddressStreet__c = '';
                        Contractobj.IHSMarkitLegalEntityStreet__c = '';
                        Contractobj.IHSMarkitLegalEntityStateProvinceNew__c = ''; 
                        Contractobj.IHSMarkitStateOfIncorporationText__c = '';                            
                    }
                }
                if(setLegalEntityId != NULL && setLegalEntityId.size()>0) {
                Map<Id,LegalEntity__c> mapLegalEntity = new Map<Id,LegalEntity__c>([Select id, AddressLine1__c,AddressLine2__c,AddressLine3__c,City__c,Country__c,Country__r.Name,toLabel(StateOrProvinceNew__c),toLabel(IncorporatedinState__c),PostalCode__c from LegalEntity__c where Id IN : setLegalEntityId]);
                    for(Contract Contractobj : listContracts ) {
                        LegalEntity__c legObj = mapLegalEntity.get(Contractobj.IHSMarkitLegalEntity__c);
                        Contractobj.IHSMarkitNoticeAddressCity__c = legObj.City__c;
                        Contractobj.IHSMarkitNoticeAddressCountry__c = legObj.Country__r.Name;
                        Contractobj.IHSMarkitNoticeZipCode__c = legObj.PostalCode__c;
                        Contractobj.IHSMarkitNoticeState__c = legObj.StateOrProvinceNew__c;
                        Contractobj.IHSMarkitStateOfIncorporationText__c = legObj.IncorporatedinState__c;
                        String address = '';
                        if(!String.isBlank(legObj.AddressLine1__c)) {
                            address = address + legObj.AddressLine1__c;
                        }
                        if(!String.isBlank(legObj.AddressLine2__c)) {
                            address = address + ',' + legObj.AddressLine2__c;
                        }
                        if(!String.isBlank(legObj.AddressLine3__c)) {
                            address = address + ',' + legObj.AddressLine3__c;
                        }
                        
                        Contractobj.IHSMarkitNoticeAddressStreet__c = address;
                        Contractobj.IHSMarkitLegalEntityStreet__c = address;
                        Contractobj.IHSMarkitLegalEntityStateProvinceNew__c = legObj.StateOrProvinceNew__c;              
                    }
                }
            }
        catch (Exception e) {
               UtilityClass.createApexLogRecord(e,'ContractMethods','updateNoticeAddressFieldsOnContractFromLegalEntity'); 
           }
        }
    }
    
     //-----------------------------
    // @Author : Prachi Bhasin
    // @Date : 5 June 2018
    // @Description : SFDC1-8096: updating Client State of Incorporation fields  on contract from client legal entity (instead of formula field)
    // @Description :SFDC1-905 Populate Client Notice Address Fields (SFDC1-7542: converted process builder 'PopulateClientNoticeAddressFieldsOnContract' to this method )
    // @param : TriggerParameters Contains the trigger parameters which includes the record(s) that got updated.
    // @Company: Vertiba
    // @return : Void
    //-----------------------------
    public static void updateClientStateOfIncorporationFromClientLegalEntity(TriggerParameters tp) {
        
        if(tp.tEvent == TriggerParameters.TriggerEvent.beforeInsert ||
            tp.tEvent == TriggerParameters.TriggerEvent.beforeUpdate)
        { 
            try {
                Set<id> setAccountId = new set<id>();
                List<Contract> listContracts = (List<Contract>) tp.newList;
                Map<Id,Contract> mapOldContract = (Map<Id,Contract>)tp.oldMap;
                for(Contract Contractobj : listContracts ) {
                    if(tp.tEvent == TriggerParameters.TriggerEvent.beforeInsert && NULL != Contractobj.ClientLegalEntityLookUp__c)
                    {
                        setAccountId.add(Contractobj.ClientLegalEntityLookUp__c);
                    }
                    if(tp.tEvent == TriggerParameters.TriggerEvent.beforeUpdate && (NULL != Contractobj.ClientLegalEntityLookUp__c) &&
                        Contractobj.ClientLegalEntityLookUp__c != mapOldContract.get(Contractobj.id).ClientLegalEntityLookUp__c)
                    {
                        setAccountId.add(Contractobj.ClientLegalEntityLookUp__c);
                    }
                    else if(tp.tEvent == TriggerParameters.TriggerEvent.beforeUpdate && (NULL == Contractobj.ClientLegalEntityLookUp__c) &&
                        Contractobj.ClientLegalEntityLookUp__c != mapOldContract.get(Contractobj.id).ClientLegalEntityLookUp__c)
                    {
                        Contractobj.ClientStateofIncorporationNew__c = '';   
                        Contractobj.ClientNoticeAddressCity__c  = '';   
                        Contractobj.ClientNoticeAddressCountryLookup__c = NULL;   
                        Contractobj.ClientNoticeAddressStreet__c = '';   
                        Contractobj.ClientNoticeAddressStateProvince__c = '';   
                        Contractobj.ClientNoticeAddressZipPostalCode__c  = '';   
                        Contractobj.ClientLegalEntityCity__c = '';
                        Contractobj.ClientLegalEntityCountryLookup__c = NULL;
                        Contractobj.ClientLegalEntityZipPostalCode__c = '';
                        Contractobj.ClientLegalEntityStateProvince__c = '';
                        Contractobj.ClientLegalEntityStreet__c = '';                        
                    }
                }
                if(setAccountId != NULL && setAccountId.size()>0) {
                Map<Id,Account> mapAccountValues = new Map<Id,Account>([Select id,toLabel(StateOfIncorporation__c),AccountCountry__c,BillingCity,BillingStreet,BillingCountry,BillingPostalCode,BillingState from Account where Id IN : setAccountId]);
                    for(Contract Contractobj : listContracts ) {
                        Account clientLegObj = mapAccountValues.get(Contractobj.ClientLegalEntityLookUp__c);
                        Contractobj.ClientStateofIncorporationNew__c = clientLegObj.StateOfIncorporation__c;
                        Contractobj.ClientNoticeAddressCity__c  = clientLegObj.BillingCity;   
                        Contractobj.ClientNoticeAddressCountryLookup__c = clientLegObj.AccountCountry__c;   
                        Contractobj.ClientNoticeAddressStreet__c = clientLegObj.BillingStreet;   
                        Contractobj.ClientNoticeAddressStateProvince__c = clientLegObj.BillingState;   
                        Contractobj.ClientNoticeAddressZipPostalCode__c  = clientLegObj.BillingPostalCode;   
                        Contractobj.ClientLegalEntityCity__c = clientLegObj.BillingCity;
                        Contractobj.ClientLegalEntityCountryLookup__c = clientLegObj.AccountCountry__c;
                        Contractobj.ClientLegalEntityZipPostalCode__c = clientLegObj.BillingPostalCode;
                        Contractobj.ClientLegalEntityStateProvince__c = clientLegObj.BillingState;
                        Contractobj.ClientLegalEntityStreet__c = clientLegObj.BillingStreet;                        
                    }
                }
            }
        catch (Exception e) {
               UtilityClass.createApexLogRecord(e,'ContractMethods','updateClientStateOfIncorporationFromClientLegalEntity'); 
           }
        }
    }
    
    //-----------------------------
    // @Author : Prachi Bhasin
    // @Date : 6 June 2018
    // @Description :SFDC1-4421 Populate Bill To Fields on Contract with Global Alliance Fields when Opportunity
    // associated to Contract as Global Alliance Sales Channel (SFDC1-7542: converting process builder
    // 'PopulateBillToFieldsonContractwithGlobalAllianceFields' first part)
    // @Description :SFDC1-6173 Copy Bill to and Ship to fields to the new Contract being created
    // @Description :SFDC1-4363 Populate Ship To and Bill To Address Information on Contract from Related Account 
    // @Description :SFDC1-7542: converting process builder 'PopulateBillToAndShipToInformationOnContractFromAccount', 'CopyBillToandShiptoFieldsfromRenewalOpptytoContract'  
    // and 'PopulateBillToFieldsonContractwithGlobalAllianceFields' before insert part (Copy Account details over to Bill To fields)
    // to this method
    // @param : TriggerParameters Contains the trigger parameters which includes the record(s) that got updated.
    // @Company: Vertiba
    // @return : Void
    //-----------------------------
    public static void populateBillToAndShipToInformationOnContractFromAccount(TriggerParameters tp) {
        
       if(tp.tEvent == TriggerParameters.TriggerEvent.beforeInsert)
        {
            try {
                Set<id> setAccountId = new set<id>();
                Set<id> setOppId = new set<id>();
                List<Contract> listContracts = (List<Contract>) tp.newList;
                Map<Id,Contract> mapOldContract = (Map<Id,Contract>)tp.oldMap;
                Id orderFormRecordTypeId = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('Order Form').getRecordTypeId();
                Id trialRecordTypeId = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('Trial').getRecordTypeId();
                for(Contract Contractobj : listContracts ) {
                    if((String.valueOf(Contractobj.RecordTypeId).substring(0,15) == String.valueOf(orderFormRecordTypeId).substring(0,15) || String.valueOf(Contractobj.RecordTypeId).substring(0,15) ==String.valueOf(trialRecordTypeId).substring(0,15) ) && NULL!= Contractobj.AccountId && NULL!= Contractobj.Opportunity__c && Contractobj.OpportunityRecordType__c == 'New Business') {
                        setAccountId.add(Contractobj.AccountId); 
                    } 
                    else if(NULL!= Contractobj.AccountId && NULL!= Contractobj.Opportunity__c && Contractobj.OpportunityRecordType__c == 'Renewal') {
                        setOppId.add(Contractobj.Opportunity__c);
                    }
                }
                if(setAccountId != NULL && setAccountId.size()>0) {
                Map<Id,Account> mapAccValues = new Map<Id,Account>([Select Name,AccountCountry__c,BillingCity,BillingStreet,BillingCountry,BillingPostalCode,BillingState from Account where Id IN : setAccountId]);
                // query here whether i should create 2 lookup fields on oppty to store lookup country record data OR do all logic here                
                    for(Contract Contractobj : listContracts ) {
                            Account clientLegObj = mapAccValues.get(Contractobj.AccountId);
                            Contractobj.ShipToCity__c = clientLegObj.BillingCity;
                            Contractobj.ShipToClientName__c  = clientLegObj.Name;   
                            Contractobj.ShipToCountryCodeLookup__c = clientLegObj.AccountCountry__c;   
                            Contractobj.ShipToPostalZipCode__c = clientLegObj.BillingPostalCode;   
                            Contractobj.ShipToStateProvince__c = clientLegObj.BillingState;   
                            Contractobj.ShipToStreet__c  = clientLegObj.BillingStreet;
                            Contractobj.BillToCity__c = clientLegObj.BillingCity;
                            Contractobj.BillToClientName__c  = clientLegObj.Name;   
                            Contractobj.BillToCountryCodeLookup__c = clientLegObj.AccountCountry__c;   
                            Contractobj.BillToPostalZipCode__c = clientLegObj.BillingPostalCode;   
                            Contractobj.BillToStateProvince__c = clientLegObj.BillingState;   
                            Contractobj.BillToStreet__c  = clientLegObj.BillingStreet;                          
                        }
                }
                if(setOppId != NULL && setOppId.size()>0) {
                system.debug('here---'+setOppId);
                Map<Id,Opportunity> mapOppValues = new Map<Id,Opportunity>([Select BillToCity__c,ShipToCountryNew__c,BillToCountryNew__c,BillToClientName__c,BillToCompanySAP__c,BillToContactEmailAddress__c,BillToContactFirstName__c,BillToContactLastName__c,BillToContactSAP__c,BillToContactTelephoneNumber__c,BillToPostalZipCode__c,BillToStateProvince__c,BillToStreet__c,ShipToCity__c,ShipToClientName__c,ShipToCompanySAP__c,ShipToContactEmailAddress__c,ShipToContactFirstName__c,ShipToContactLastName__c,ShipToContactSAP__c,ShipToContactTelephoneNumber__c,ShipToPostalZipCode__c,ShipToStateProvince__c,ShipToStreet__c from Opportunity where Id IN : setOppId]);
                // query here whether i should create 2 lookup fields on oppty to store lookup country record data OR do all logic here                
                    system.debug('mapOppValues---'+mapOppValues);
                    for(Contract Contractobj : listContracts ) {
                            Opportunity opp = mapOppValues.get(Contractobj.Opportunity__c);
                            system.debug('opp---'+opp);
                            Contractobj.BillToCity__c = opp.BillToCity__c;
                            Contractobj.BillToClientName__c  = opp.BillToClientName__c;   
                            Contractobj.BillToCompanySAP__c = opp.BillToCompanySAP__c;   
                            Contractobj.BillToContactEmailAddress__c = opp.BillToContactEmailAddress__c;   
                            Contractobj.BillToContactFirstName__c = opp.BillToContactFirstName__c;   
                            Contractobj.BillToContactLastName__c  = opp.BillToContactLastName__c;
                            
                            Contractobj.BillToContactSAP__c = opp.BillToContactSAP__c;
                            Contractobj.BillToContactTelephoneNumber__c  = opp.BillToContactTelephoneNumber__c;   
                            Contractobj.BillToCountryCodeLookup__c =UtilityClass.getCountry(opp.BillToCountryNew__c)== null?null:UtilityClass.getCountry(opp.BillToCountryNew__c).Id;      
                            Contractobj.BillToPostalZipCode__c = opp.BillToPostalZipCode__c;   
                            Contractobj.BillToStateProvince__c = opp.BillToStateProvince__c;   
                            Contractobj.BillToStreet__c  = opp.BillToStreet__c;
                            
                            Contractobj.ShipToCity__c = opp.ShipToCity__c;
                            Contractobj.ShipToClientName__c  = opp.ShipToClientName__c;   
                            Contractobj.ShipToCompanySAP__c = opp.ShipToCompanySAP__c;   
                            Contractobj.ShipToContactEmailAddress__c = opp.ShipToContactEmailAddress__c;   
                            Contractobj.ShipToContactFirstName__c = opp.ShipToContactFirstName__c;   
                            Contractobj.ShipToContactLastName__c  = opp.ShipToContactLastName__c;
                            
                            Contractobj.ShipToContactSAP__c = opp.ShipToContactSAP__c;
                            Contractobj.ShipToContactTelephoneNumber__c  = opp.ShipToContactTelephoneNumber__c;   
                            Contractobj.ShipToCountryCodeLookup__c = UtilityClass.getCountry(opp.ShipToCountryNew__c)== null?null:UtilityClass.getCountry(opp.ShipToCountryNew__c).Id; 
                            Contractobj.ShipToPostalZipCode__c = opp.ShipToPostalZipCode__c;   
                            Contractobj.ShipToStateProvince__c = opp.ShipToStateProvince__c;   
                            Contractobj.ShipToStreet__c  = opp.ShipToStreet__c;                         
                        }
                }
            }
        catch (Exception e) {
               UtilityClass.createApexLogRecord(e,'ContractMethods','updateClientStateOfIncorporationFromClientLegalEntity'); 
           }
        }
    }
    
    //-----------------------------
    // @Author : Prachi Bhasin
    // @Date : 6 June 2018
    // @Description :SFDC1-4421 Populate Bill To Fields on Contract with Global Alliance Fields when Opportunity
    // associated to Contract as Global Alliance Sales Channel (SFDC1-7542: converting process builder
    // 'PopulateBillToFieldsonContractwithGlobalAllianceFields' first part)
    // to this method
    // @param : TriggerParameters Contains the trigger parameters which includes the record(s) that got updated.
    // @Company: Vertiba
    // @return : Void
    // @lastmodifiedby : Mohit Modi
    // @lastmodifieddate : 15 June 2018
    // @lastmodifiedDescription : SFDC1-8366, Updating 'ChannelPartnerCompanyName__c' from 'GlobalAllianceCompanyName__c' for CopyTo functionality.
    //-----------------------------
    public static void populateBillToFieldsonContractwithGlobalAllianceFields(TriggerParameters tp) {
        
       if(tp.tEvent == TriggerParameters.TriggerEvent.beforeInsert ||
            tp.tEvent == TriggerParameters.TriggerEvent.beforeUpdate)
        {
            try {
                List<Contract> listContracts = (List<Contract>) tp.newList;
                Map<Id,Contract> mapOldContract = (Map<Id,Contract>)tp.oldMap;
                if (tp.tEvent == TriggerParameters.TriggerEvent.beforeUpdate) {
                    for(Contract Contractobj : listContracts ) {
                        Contract oldContract;
                        if(tp.oldMap != null && tp.oldMap.get(Contractobj.Id) != null) {
                            oldContract = (Contract)tp.oldMap.get(Contractobj.Id);
                        }
                        if ((oldContract.CopytoBillTo__c !=Contractobj.CopytoBillTo__c)  
                            && (Contractobj.CopytoBillTo__c == TRUE)) {
                            Contractobj.BillToCity__c = Contractobj.GlobalAllianceAddressCity__c;
                            Contractobj.BillToClientName__c  = Contractobj.ChannelPartnerCompanyName__c;    
                            Contractobj.BillToContactEmailAddress__c = Contractobj.GlobalAllianceContactEmailAddress__c;   
                            Contractobj.BillToContactFirstName__c = Contractobj.GlobalAllianceContactFirstName__c;   
                            Contractobj.BillToContactLastName__c  = Contractobj.GlobalAllianceContactLastName__c;
                            
                            Contractobj.BillToContactTelephoneNumber__c  = Contractobj.GlobalAllianceContactPhoneNumber__c;   
                            Contractobj.BillToCountryCodeLookup__c = UtilityClass.getCountry(Contractobj.GlobalAllianceAddressCountry__c)== null?null:UtilityClass.getCountry(Contractobj.GlobalAllianceAddressCountry__c).Id;      
                            Contractobj.BillToPostalZipCode__c = Contractobj.GlobalAllianceAddressPostalZipCode__c;   
                            Contractobj.BillToStateProvince__c = Contractobj.GlobalAllianceAddressStateProvince__c;   
                            Contractobj.BillToStreet__c  = Contractobj.GlobalAllianceAddressStreet__c;
                        }
                    }
                }
                if (tp.tEvent == TriggerParameters.TriggerEvent.beforeInsert) {
                    for(Contract Contractobj : listContracts ) {
                        if (Contractobj.CopytoBillTo__c == TRUE && ! String.IsBlank(Contractobj.ChannelPartnerCompanyName__c)) {
                            Contractobj.BillToCity__c = Contractobj.GlobalAllianceAddressCity__c;
                            Contractobj.BillToClientName__c  = Contractobj.ChannelPartnerCompanyName__c;    
                            Contractobj.BillToContactEmailAddress__c = Contractobj.GlobalAllianceContactEmailAddress__c;   
                            Contractobj.BillToContactFirstName__c = Contractobj.GlobalAllianceContactFirstName__c;   
                            Contractobj.BillToContactLastName__c  = Contractobj.GlobalAllianceContactLastName__c;
                            
                            Contractobj.BillToContactTelephoneNumber__c  = Contractobj.GlobalAllianceContactPhoneNumber__c;   
                            Contractobj.BillToCountryCodeLookup__c = UtilityClass.getCountry(Contractobj.GlobalAllianceAddressCountry__c)== null?null:UtilityClass.getCountry(Contractobj.GlobalAllianceAddressCountry__c).Id;   
                            Contractobj.BillToPostalZipCode__c = Contractobj.GlobalAllianceAddressPostalZipCode__c;   
                            Contractobj.BillToStateProvince__c = Contractobj.GlobalAllianceAddressStateProvince__c;   
                            Contractobj.BillToStreet__c  = Contractobj.GlobalAllianceAddressStreet__c;
                        }
                    }                       
                }               
            }
        catch (Exception e) {
               UtilityClass.createApexLogRecord(e,'ContractMethods','updateClientStateOfIncorporationFromClientLegalEntity'); 
           }
        }
    }
    //-----------------------------
    // @Author : Prachi Bhasin
    // @Date : 6 June 2018
    // @Description :SFDC1-6994  This updates Bill to/Ship to fields on Opportunity where the contract is 'Originating Contract' 
    //(if oppty is open) (SFDC1-7542: converting process builder 'UpdateAddressOnRenewalOppty' 
    // to this method)
    // @param : TriggerParameters Contains the trigger parameters which includes the record(s) that got updated.
    // @Company: Vertiba
    // @return : Void
    //-----------------------------
    public static void updateAddressOnRenewalOppty(TriggerParameters tp) {
        
       if(tp.tEvent == TriggerParameters.TriggerEvent.afterUpdate)
        {
            try {
                List<Contract> listContracts = new List<Contract>();
                Map<Id,Contract> mapOldContract = (Map<Id,Contract>)tp.oldMap;
                Id orderFormRecordTypeId = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('Order Form').getRecordTypeId();
                Id renewalRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Renewal').getRecordTypeId();
                for(Contract c :(List<Contract>) tp.newList) {
                    Contract oldContract = mapOldContract.get(c.id);
                    if((String.valueOf(c.RecordTypeId).substring(0,15) == String.valueOf(orderFormRecordTypeId).substring(0,15))
                        && (c.BillToCity__c != oldContract.BillToCity__c || c.BillToCompanySAP__c != oldContract.BillToCompanySAP__c ||
                            c.BillToClientName__c != oldContract.BillToClientName__c || c.BillToContactEmailAddress__c != oldContract.BillToContactEmailAddress__c ||
                            c.BillToContactFirstName__c != oldContract.BillToContactFirstName__c || c.BillToContactLastName__c != oldContract.BillToContactLastName__c ||
                            c.BillToContactSAP__c != oldContract.BillToContactSAP__c || c.BillToContactTelephoneNumber__c != oldContract.BillToContactTelephoneNumber__c ||
                            c.BillToCountryCodeLookup__c != oldContract.BillToCountryCodeLookup__c || c.BillToPostalZipCode__c != oldContract.BillToPostalZipCode__c ||
                            c.BillToStateProvince__c != oldContract.BillToStateProvince__c || c.BillToStreet__c != oldContract.BillToStreet__c ||
                            c.ShipToCity__c != oldContract.ShipToCity__c || c.ShipToClientName__c != oldContract.ShipToClientName__c ||
                            c.ShipToCompanySAP__c != oldContract.ShipToCompanySAP__c || c.ShipToContactEmailAddress__c != oldContract.ShipToContactEmailAddress__c ||
                            c.ShipToContactFirstName__c != oldContract.ShipToContactFirstName__c || c.ShipToContactLastName__c != oldContract.ShipToContactLastName__c ||
                            c.ShipToContactSAP__c != oldContract.ShipToContactSAP__c || c.ShipToContactTelephoneNumber__c != oldContract.ShipToContactTelephoneNumber__c ||
                            c.ShipToCountryCodeLookup__c != oldContract.ShipToCountryCodeLookup__c || c.ShipToPostalZipCode__c != oldContract.ShipToPostalZipCode__c ||
                            c.ShipToStateProvince__c != oldContract.ShipToStateProvince__c || c.ShipToStreet__c != oldContract.ShipToStreet__c)
                    ) {
                        listContracts.add(c);
                    }   
                }
                system.debug('listContracts----'+listContracts);
                if(listContracts != NULL && listContracts.size()>0) {
                    List<Contract> lstContract = new List<Contract>();
                    List<Opportunity> lstOpp = new List<Opportunity>();
                    lstContract = [Select id,name,BillToCity__c,BillToClientName__c,ShipToCity__c,ShipToContactLastName__c,ShipToContactTelephoneNumber__c,ShipToPostalZipCode__c,ShipToStreet__c,ShipToContactEmailAddress__c,ShipToClientName__c,BillToStreet__c,BillToPostalZipCode__c,BillToContactTelephoneNumber__c,BillToContactLastName__c,BillToContactEmailAddress__c,BillToCompanySAP__c,ShipToStateProvince__c,ShipToCountryCodeLookup__r.Name,ShipToContactSAP__c,ShipToContactFirstName__c,ShipToCompanySAP__c,BillToStateProvince__c,BillToContactFirstName__c,BillToContactSAP__c,BillToCountryCodeLookup__r.Name,(select id, name from Opportunities2__r where RecordTypeId =:renewalRecordTypeId AND StageName!= '6W-Renewal Won' AND StageName!= '6W-Renewal Lost') from Contract where Id IN : listContracts];
                    for(Contract c:lstContract) {
                        for(Opportunity opp : c.Opportunities2__r) {
                            opp.BillToCity__c = c.BillToCity__c;
                            opp.BillToClientName__c = c.BillToClientName__c;
                            opp.BillToContactFirstName__c = c.BillToContactFirstName__c;
                            opp.BillToContactSAP__c = c.BillToContactSAP__c;
                            opp.BillToCountryNew__c = c.BillToCountryCodeLookup__r.Name;
                            opp.BillToStateProvince__c = c.BillToStateProvince__c;
                            opp.ShipToCity__c = c.ShipToCity__c;
                            opp.ShipToCompanySAP__c = c.ShipToCompanySAP__c;
                            opp.ShipToContactFirstName__c = c.ShipToContactFirstName__c;
                            opp.ShipToContactSAP__c = c.ShipToContactSAP__c;
                            opp.ShipToCountryNew__c= c.ShipToCountryCodeLookup__r.Name;
                            opp.ShipToStateProvince__c = c.ShipToStateProvince__c;
                            opp.BillToCompanySAP__c = c.BillToCompanySAP__c;
                            opp.BillToContactEmailAddress__c = c.BillToContactEmailAddress__c;
                            opp.BillToContactLastName__c = c.BillToContactLastName__c;
                            opp.BillToContactTelephoneNumber__c = c.BillToContactTelephoneNumber__c;
                            opp.BillToPostalZipCode__c = c.BillToPostalZipCode__c;
                            opp.BillToStreet__c = c.BillToStreet__c;
                            opp.ShipToClientName__c = c.ShipToClientName__c;
                            opp.ShipToContactEmailAddress__c =c.ShipToContactEmailAddress__c;
                            opp.ShipToStreet__c = c.ShipToStreet__c;
                            opp.ShipToPostalZipCode__c = c.ShipToPostalZipCode__c;
                            opp.ShipToContactTelephoneNumber__c = c.ShipToContactTelephoneNumber__c;
                            opp.ShipToContactLastName__c = c.ShipToContactLastName__c; 
                        }
                        lstOpp.add(c.Opportunities2__r);
                    }                   
                    update lstOpp;
                }
            }
            catch (Exception e) {
                UtilityClass.createApexLogRecord(e,'ContractMethods','updateClientStateOfIncorporationFromClientLegalEntity'); 
            }
        }
    }
    
    //-----------------------------
    // @author: Ankita Singh
    // @date: 12 June 2018
    // @description: SFDC1-8051- Validating IHS Markit Legal Entity list of values(lookup on contract) by eligibility and Record Type of Contract.
    // @param: TriggerParameters Contains the trigger parameters which includes the record(s) that got updated.
    // @companyname: VERTIBA
    // @return: void
    //-----------------------------
    public static void validateLegalEntityOnContract(TriggerParameters tp) {
        if(tp.tEvent == TriggerParameters.TriggerEvent.beforeUpdate) {   
            
            List<Contract> listContracts = (List<Contract>) tp.newList;
            Map<Id,Contract> mapOldContract = (Map<Id,Contract>)tp.oldMap;
            Map<Id,Contract> mapContract = new Map<Id,Contract>();
            Set<Id> legalEntity = new Set<Id>();
            // Fetching Contract RecordType Id
            Id consultingRecordTypeId = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('Consulting').getRecordTypeId();
            Id trialRecordTypeId = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('Trial').getRecordTypeId();
            Id continuationLetterRecordTypeId = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('Continuation Letter').getRecordTypeId();
            Id DPARecordTypeId = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('DPA').getRecordTypeId();
            Id MSTRecordTypeId = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('Managed Service Terms (MST)').getRecordTypeId();
            Id masterAgreementRecordTypeId = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('Master Agreement').getRecordTypeId();
            
            for(Contract Contractobj : listContracts ) {
                Contract oldContract = mapOldContract.get(Contractobj.id);
                    // filtering relevant contract Ids and associated Legal Entity Ids selected from the lookup
                    mapContract.put(Contractobj.id,Contractobj);
                    legalEntity.add(Contractobj.IHSMarkitLegalEntity__c);
            }
            // Fectching Legal Entity Field values for the correspoding contract Ids
            Map<ID, LegalEntity__c> legalEntityMAP = new Map<ID, LegalEntity__c>([Select Id,EligibleforStatementofWork__c,EligibleforDPA__c,EligibleforMangedServiceTerms__c,EligibleforMasterAgreement__c,EligibleforContinuation__c,EligibleforTrial__c from LegalEntity__c where Id IN:legalEntity]);
            // Validating the legal entity seleted from lookup wether it is valid for the particular contract Id else throw error
            for(Id contractId : mapContract.keySet()) {
                Contract c = mapContract.get(contractId);
                if(legalEntityMAP != NULL && legalEntityMAP.size() > 0 && legalEntityMAP.containskey(c.IHSMarkitLegalEntity__c)) {
                    if(mapContract.get(contractId).RecordTypeId==consultingRecordTypeId && legalEntityMAP.get(c.IHSMarkitLegalEntity__c).EligibleforStatementofWork__c=='No') {
                        c.addError(Label.LegalEntityErrorOnContract);
                    }
                    else if(mapContract.get(contractId).RecordTypeId==trialRecordTypeId && legalEntityMAP.get(c.IHSMarkitLegalEntity__c).EligibleforTrial__c=='No') {
                        c.addError(Label.LegalEntityErrorOnContract);
                    }
                    else if(mapContract.get(contractId).RecordTypeId==continuationLetterRecordTypeId && legalEntityMAP.get(c.IHSMarkitLegalEntity__c).EligibleforContinuation__c=='No') {
                        c.addError(Label.LegalEntityErrorOnContract);
                    }
                    else if(mapContract.get(contractId).RecordTypeId==DPARecordTypeId && legalEntityMAP.get(c.IHSMarkitLegalEntity__c).EligibleforDPA__c=='No') {
                        c.addError(Label.LegalEntityErrorOnContract);
                    }
                    else if(mapContract.get(contractId).RecordTypeId==MSTRecordTypeId && legalEntityMAP.get(c.IHSMarkitLegalEntity__c).EligibleforMangedServiceTerms__c == 'No') {
                        c.addError(Label.LegalEntityErrorOnContract);
                    }
                    else if(mapContract.get(contractId).RecordTypeId==masterAgreementRecordTypeId && legalEntityMAP.get(c.IHSMarkitLegalEntity__c).EligibleforMasterAgreement__c =='No') {
                        c.addError(Label.LegalEntityErrorOnContract);
                    }
                }
            } 
        }
    }
	
	//-----------------------------
    // @author: Harshit Singhal
    // @date: 20 Jun 2018
    // @description: SFDC1-8533 Convert Process Builder flow "Roll up Annual And Total Contract Value on Opportunity" on Contract object created in SFDC1-5906(this is to roll up contract values on Parent Opportunity whenever Value fields gets updated.) + SFDC1-7233(Removed the dependency of Opportunity's 'Total Contract Value' field.) to a trigger
    // 				 This methods updates Total Annual Contract Value field on parent Opportunity record during after update transactions.
    // @param: TriggerParameters Contains the trigger parameters which includes the record(s) that got updated.    
    // @return: None
    //-----------------------------
    public static void updateTotalAnnualContractValueOnOpp(TriggerParameters tp) {
        Id orderFormContractRecTypeId = Schema.SobjectType.Contract.getRecordTypeInfosByName().get('Order Form').getRecordTypeId();
        Id newBusinessOppRecTypeId = Schema.SobjectType.Opportunity.getRecordTypeInfosByName().get('New Business').getRecordTypeId();
        Id renewalOppRecTypeId = Schema.SobjectType.Opportunity.getRecordTypeInfosByName().get('Renewal').getRecordTypeId();
        List<Opportunity> oppUpdateList = new List<Opportunity>();        
        Set<Id> contractIdSet = new Set<Id>();
        Map<Id,Contract> newContractMap = new Map<Id,Contract>();
        
        for(Contract newContractObj : (List<Contract>)tp.newList) {
            Contract oldContract = (Contract) tp.oldMap.get(newContractObj.Id);
            if(newContractObj.Opportunity__c != null &&
              (newContractObj.FirstYearContractValue__c != oldContract.FirstYearContractValue__c || newContractObj.TotalContractValue__c != oldContract.TotalContractValue__c)) {
                contractIdSet.add(newContractObj.Id);                
            }
        }        
        
        if(contractIdSet.size() > 0) {
            newContractMap.putAll([Select Id, RecordTypeId, Opportunity__c, FirstYearContractValue__c, TotalContractValue__c,
                                   Opportunity__r.RecordTypeId, Opportunity__r.AutoRenewal__c, Opportunity__r.ContractBeingRenewed__c, Opportunity__r.ContractBeingRenewed__r.FirstYearContractValue__c 
                                   From Contract 
                                   Where Id IN :contractIdSet AND Opportunity__c != Null]);
        }
        contractIdSet.clear();
        
        if(newContractMap.size() > 0) {
            for(Contract newContract: newContractMap.values()) {                        
                if(newContract.RecordTypeId == orderFormContractRecTypeId && (newContract.Opportunity__r.RecordTypeId == newBusinessOppRecTypeId || newContract.Opportunity__r.RecordTypeId == renewalOppRecTypeId)) {                       
                    Opportunity oppUpdate = new Opportunity(Id=newContract.Opportunity__c);                       
                    if(newContract.Opportunity__r.RecordTypeId == renewalOppRecTypeId && newContract.Opportunity__r.AutoRenewal__c && 
                       newContract.Opportunity__r.ContractBeingRenewed__c != null && newContract.Opportunity__r.ContractBeingRenewed__r.FirstYearContractValue__c != null) {
                           oppUpdate.TotalAnnualContractValue__c = newContract.Opportunity__r.ContractBeingRenewed__r.FirstYearContractValue__c + newContract.FirstYearContractValue__c;
                       }
                    else {                           
                        oppUpdate.TotalAnnualContractValue__c = newContract.FirstYearContractValue__c;
                    }
                    oppUpdateList.add(oppUpdate);                   
                }
            }
        }
        
        try {
            if(oppUpdateList.size() > 0) {
                update oppUpdateList;
            }
        }        
        catch(Exception ex) {
            //UtilityClass.createApexLogRecord(ex, 'ContractMethods', 'updateTotalAnnualContractValueOnOpp');		//The custom exception below will rollback this DML hence commented.
            String description = '\n Cause: '+ex.getCause()+'\n Line number : '+ ex.getLineNumber()+ '\n Message: '+ ex.getMessage()+ '\n stackTrace: '+ex.getStackTraceString();
            System.debug('Exception in updateTotalAnnualContractValueOnOpp() method. Description:'+description);
            throw new TriggerException('Something gone wrong! Please reach out to salesforce helpdesk.'+description);
        }        
    }
    
    //-----------------------------
    // @author: Harshit Singhal
    // @date: 21 Jun 2018
    // @description: SFDC1-8533 Convert Process Builder flow "SendNotificationtoOpportunityOwneronContractCancellation" on Contract object created in SFDC1-802(Send Notification to Opportunity Owner when Cancel Request Received Date on  Contract is filled) to a trigger
    // 				 This methods updates Oppty Owner Email field on Contract record during before update transactions.
    // @param: TriggerParameters Contains the trigger parameters which includes the record(s) that got updated.    
    // @return: None
    //-----------------------------
    public static void setOpptyOwnerEmail(TriggerParameters tp) {        
        List<Contract> contractListToUpdate = new List<Contract>();
        Set<Id> oppIdSet = new Set<Id>();
        //Get Opportunity records
        for(Contract newContract: (List<Contract>)tp.newList) {
            Contract oldContract = (Contract)tp.oldMap.get(newContract.Id);
            if(newContract.Opportunity__c != null && newContract.CancelRequestReceivedDate__c != null && newContract.CancelRequestReceivedDate__c != oldContract.CancelRequestReceivedDate__c) {
                //newContract.OpptyOwnerEmail__c = newContract.Opportunity__r.Owner.Email;
                //Get Opportunity Ids
                oppIdSet.add(newContract.Opportunity__c);
                contractListToUpdate.add(newContract);
            }
        }
        
        //Get Opportunity Owners' Email
        Map<Id,Opportunity> oppMap = new Map<Id,Opportunity>();
        if(oppIdSet.size() > 0) {
            oppMap.putAll([SELECT Id,Opportunity.Owner.Email FROM Opportunity WHERE Id IN :oppIdSet]);
        }        
        
        //Set Email on Contract
        if(oppMap.size() > 0 && contractListToUpdate.size() > 0) {
            for(Contract updContract: contractListToUpdate) {                
                updContract.OpptyOwnerEmail__c = oppMap.get(updContract.Opportunity__c).Owner.Email;                
            }
        }        
    }

	//-----------------------------
    // @author: Harshit Singhal
    // @date: 22 Jun 2018
    // @description: SFDC1-8533 Convert Process Builder flow "Sync Contract Object Dates to Opportunity Contract Dates" on Contract object created in SFDC1-653(If contract dates are changed they should flow back to opportunity till opportunity reaches a read only stage i.e 6W stage) to a trigger
    // 				 This methods updates Contract Start Date and Contract End Date field on all child opportunities of a Contract based on a criteria during after insert and after update operations.
    // @param: TriggerParameters Contains the trigger parameters which includes the record(s) that got inserted and updated.
    // @return: None
    //-----------------------------
    public static void updateOpptyContractStartEndDates(TriggerParameters tp) {
        List<Opportunity> oppUpdateList = new List<Opportunity>();
        List<String> eligibleStageList = new List<String> {'6L-Renewal Lost','6L-Closed Lost','6W-Closed Won','6W-Renewal Won'};
        
        Set<Id> contractIdSet = new Set<Id>();
        Map<Id,Contract> newContractMap = new Map<Id,Contract>();
        for(Contract newContractObj : (List<Contract>)tp.newList) {            
            if(newContractObj.Opportunity__c != null) {
                contractIdSet.add(newContractObj.Id);                
            }
        }        
        if(contractIdSet.size() > 0) {
            newContractMap.putAll([Select Id, (Select Id From Opportunities), StartDate, EndDate, Opportunity__c, Opportunity__r.StageName
                                   From Contract 
                                   Where Id IN :tp.newList AND Opportunity__c != Null]);
        }
        if(newContractMap.size() > 0) {
            for(Contract newContract: newContractMap.values()) {
                if(eligibleStageList.contains(newContract.Opportunity__r.StageName)) {
                    for(Opportunity oppUpdate: newContract.Opportunities) {                        
                        oppUpdate.ContractStartDate__c = newContract.StartDate;
                        oppUpdate.ContractEndDate__c = newContract.EndDate;
                        oppUpdateList.add(oppUpdate);
                    }
                }
            }  
        }
        
        try {                    
            if(oppUpdateList.size() > 0) {
                update oppUpdateList;                
            }            
        }
        catch(Exception ex) {            
            String description = '\n Cause: '+ex.getCause()+'\n Line number : '+ ex.getLineNumber()+ '\n Message: '+ ex.getMessage()+ '\n stackTrace: '+ex.getStackTraceString();
            System.debug('Exception in updateOpptyContractStartEndDates() method. Description:'+description);
            throw new TriggerException('Something gone wrong! Please reach out to salesforce helpdesk.'+description);
        }        
    }
        
    //-----------------------------
    // @author: Harshit Singhal
    // @date: 24 Jun 2018
    // @description: SFDC1-8533 Convert Process Builder flow "UpdateGeneralAgreementEffectiveDateOnOrderForm" on Contract object created in SFDC1-5851(Agreement Effective Date automatically updated if the General Agreement has its Effective Date changed) to a trigger
    // 				 This methods updates Agreement Effective Date field on child Order Form contracts during after update operation on General Agreement contract.
    // @param: TriggerParameters Contains the trigger parameters which includes the record(s) that got updated.
    // @return: None
    //-----------------------------
    public static void updateAgreementEffectiveDateOnOrderFormAgreements(TriggerParameters tp) {        
        Id orderFormRecordTypeId = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('Order Form').getRecordTypeId();
        Id masterAgreementRecordTypeId = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('Master Agreement').getRecordTypeId();
        Set<Id> masterAgreementIdSet = new Set<Id>();
        List<Contract> orderFormContractUpdateList = new List<Contract>();
        
        for(Contract newContract: (List<Contract>) tp.newList) {
            Contract oldContract = (Contract) tp.oldMap.get(newContract.Id);
            if(newContract.RecordTypeId == masterAgreementRecordTypeId && newContract.EffectiveDate__c != oldContract.EffectiveDate__c ) {
                masterAgreementIdSet.add(newContract.Id);                
            }
        }
        if(masterAgreementIdSet.size() > 0) {
            for(Contract contractUpdate:[SELECT Id,GeneralAgreement__c FROM Contract WHERE GeneralAgreement__c IN :masterAgreementIdSet AND RecordTypeId = :orderFormRecordTypeId]) {
                contractUpdate.GeneralAgreementDate__c = ((Contract)tp.newMap.get(contractUpdate.GeneralAgreement__c)).EffectiveDate__c;
                orderFormContractUpdateList.add(contractUpdate);
            }    
        }
        
        try {            
            if(orderFormContractUpdateList.size() > 0) {                
                update orderFormContractUpdateList;
            }    
        }
        catch(Exception ex) {
            String description = '\n Cause: '+ex.getCause()+'\n Line number : '+ ex.getLineNumber()+ '\n Message: '+ ex.getMessage()+ '\n stackTrace: '+ex.getStackTraceString();
            System.debug('Exception in updateAgreementEffectiveDateOnOrderFormAgreements() method. Description:'+description);
            throw new TriggerException('Something gone wrong! Please reach out to salesforce helpdesk.'+description);
        }
    }
    
    //-----------------------------
    // @author: Harshit Singhal
    // @date: 24 Jun 2018
    // @description: SFDC1-8533 Convert Process Builder flow "ReadyforProcessingStageOpportunityUpdate" on Contract object created in SFDC1-5253(Move the Contract stage to 'Ready for Processing' updates the related opportunity to 6W) to a trigger
    // 				 This methods updates Stage field on parent Opportunity record during after update transactions.
    // @param: TriggerParameters Contains the trigger parameters which includes the record(s) that got updated.
    // 
    // @modified by: Harshit Singhal
    // @date: 29 Jun 2018
    // @description: SFDC1-8955 Changes to update Opportunity to 6W stages if related Consulting contract is moved to 'Ready For Processing'
    // @return: None
    //-----------------------------
    public static void updateStageOnOpp(TriggerParameters tp) {                
        Id orderFormContractRecTypeId = Schema.SobjectType.Contract.getRecordTypeInfosByName().get('Order Form').getRecordTypeId();
        Id consultingContractRecTypeId = Schema.SobjectType.Contract.getRecordTypeInfosByName().get('Consulting').getRecordTypeId();
        
        Id newBusinessOppRecTypeId = Schema.SobjectType.Opportunity.getRecordTypeInfosByName().get('New Business').getRecordTypeId();
        Id renewalOppRecTypeId = Schema.SobjectType.Opportunity.getRecordTypeInfosByName().get('Renewal').getRecordTypeId();
        Id placeholderOppRecTypeId = Schema.SobjectType.Opportunity.getRecordTypeInfosByName().get('Forecasting Placeholder').getRecordTypeId();
        Id gratisOppRecTypeId = Schema.SobjectType.Opportunity.getRecordTypeInfosByName().get('Gratis').getRecordTypeId();
        Set<Id> opptyIdSet = new Set<Id>();
        List<Opportunity> oppUpdateList = new List<Opportunity>();
        for(Contract newContract : (List<Contract>)tp.newList) {
            if((newContract.RecordTypeId == orderFormContractRecTypeId || newContract.RecordTypeId == consultingContractRecTypeId) && newContract.Opportunity__c != null && newContract.Status == 'ReadyForProcessing') {            
                Contract oldContract = (Contract)tp.oldMap.get(newContract.Id);
                if(newContract.Status != oldContract.Status) {
                    opptyIdSet.add(newContract.Opportunity__c);
                }                 
            }
        }
        
        if(opptyIdSet.size() > 0) {
            for(Opportunity oppToUpdate: [SELECT Id,StageName,RecordTypeId FROM Opportunity WHERE Id IN :opptyIdSet]) {
                if(opptyIdSet.contains(oppToUpdate.Id)) {
                    //Set Stage for New Business Opportunity
                    if(oppToUpdate.RecordTypeId == newBusinessOppRecTypeId && oppToUpdate.StageName != '6W-Closed Won' && oppToUpdate.StageName != '6L-Closed Lost') {                    
                        oppToUpdate.ReadyForProcessingContractExist__c = true;                    
                        oppToUpdate.StageName = '6W-Closed Won';
                        oppUpdateList.add(oppToUpdate);
                    }
                    //Set Stage for Renewal Opportunity
                    else if(oppToUpdate.RecordTypeId == renewalOppRecTypeId && oppToUpdate.StageName != '6W-Renewal Won' && oppToUpdate.StageName != '6L-Renewal Lost') {
                        oppToUpdate.ReadyForProcessingContractExist__c = true;                    
                        oppToUpdate.StageName = '6W-Renewal Won';
                        oppUpdateList.add(oppToUpdate);
                    }
                    //Set Stage for Forecasting Placeholder Opportunity
                    else if(oppToUpdate.RecordTypeId == placeholderOppRecTypeId && oppToUpdate.StageName != '6W-Forecasting Placeholder' && oppToUpdate.StageName != '6L-Forecasting Placeholder') {
                        oppToUpdate.ReadyForProcessingContractExist__c = true;                    
                        oppToUpdate.StageName = '6W-Forecasting Placeholder';
                        oppUpdateList.add(oppToUpdate);
                    }
                    //Set Stage for Gratis Opportunity
                    else if(oppToUpdate.RecordTypeId == gratisOppRecTypeId) {
                        oppToUpdate.ReadyForProcessingContractExist__c = true;                    
                        oppToUpdate.StageName = '6W-Closed Won';
                        oppUpdateList.add(oppToUpdate);
                    }                
                }
            }
        }
        
        try {
            if(oppUpdateList.size() > 0) {
                update oppUpdateList;                
            }            
        }
        catch(Exception ex) {
            String description = '\n Cause: '+ex.getCause()+'\n Line number : '+ ex.getLineNumber()+ '\n Message: '+ ex.getMessage()+ '\n stackTrace: '+ex.getStackTraceString();
            System.debug('Exception in updateStageOnOpp() method. Description:'+description);
            throw new TriggerException('Something gone wrong! Please reach out to salesforce helpdesk.'+description);
        }        
    }
    
    //-----------------------------
    // @author: Harshit Singhal
    // @date: 25 Jun 2018
    // @description: SFDC1-8533 Convert Process Builder flow "Update Contract Line Item Currency when Order Form Currency changes" on Contract object created in SFDC1-7467(When Contract Currency changes, change contract line currency as well.) to a trigger
    // 				 This methods copies Contract Currency from parent contract to Currency on child contract line items during after update transactions.
    // @param: TriggerParameters Contains the trigger parameters which includes the record(s) that got updated.    
    // @return: None
    //-----------------------------
    public static void updateCurrencyOnContractLineItems(TriggerParameters tp) {        
        Set<Id> parentContractIdSet = new Set<Id>();
        List<ContractLineItem__c> lineItemUpdateList = new List<ContractLineItem__c>();
        for(Contract newContract : (List<Contract>)tp.newList) {
            Contract oldContract = (Contract)tp.oldMap.get(newContract.Id);
            if(newContract.CurrencyIsoCode != oldContract.CurrencyIsoCode) {
                parentContractIdSet.add(newContract.Id);
            }
        }
        if(parentContractIdSet.size() > 0) {
            for(ContractLineItem__c lineItemUpdate : [SELECT Id,Contract__c FROM ContractLineItem__c WHERE Contract__c IN :parentContractIdSet]) {
                lineItemUpdate.CurrencyIsoCode = ((Contract)tp.newMap.get(lineItemUpdate.Contract__c)).CurrencyIsoCode;
                lineItemUpdateList.add(lineItemUpdate);
            }    
        }
        
        try {
            if(lineItemUpdateList.size() > 0) {
                update lineItemUpdateList;                
            }
        }
        catch(Exception ex) {
            String description = '\n Cause: '+ex.getCause()+'\n Line number : '+ ex.getLineNumber()+ '\n Message: '+ ex.getMessage()+ '\n stackTrace: '+ex.getStackTraceString();
            System.debug('Exception in updateCurrencyOnContractLineItems() method. Description:'+description);
            throw new TriggerException('Something gone wrong! Please reach out to salesforce helpdesk.'+description);
        }
    }
		//-----------------------------
    // @author: Anjani Shukla	
    // @date: 23 July 2018
    // @description: SFDC1-5864 - This method will replace process builder which updates contract default value when status ='Creation' and autorenewal is //                            true. Due to rollupsummary field values are not available in before so written in After.
    // @return: None
    //-----------------------------
    public static void updateDefaultContractCumulative(TriggerParameters tp) {  
        try{
            if(tp.tEvent == TriggerParameters.TriggerEvent.AfterUpdate) {
                Id orderFormContractRecTypeId = Schema.SobjectType.Contract.getRecordTypeInfosByName().get('Order Form').getRecordTypeId();
                Map<Id,Contract> mapNewContract = (Map<Id,Contract>) tp.newMap;
                Map<Id,Contract> mapOldContract = (Map<Id,Contract>) tp.oldMap;
                Set<Id> contractIds = new Set<Id>();
                //get opty ids
                if(mapNewContract != null) {
                    for(Contract newContract: mapNewContract.values()) {
                        if(newContract.Status == 'Creation' && 
						   newContract.Status != mapOldContract.get(newContract.Id).status &&
                           newContract.AutoRenewal__c && 
                           newContract.RecordTypeId == orderFormContractRecTypeId
                          ) {
                            contractIds.add(newContract.id);
                        	
                        }    
                    }
                }
                
                
                //get Opportunity
                Map<Id,Contract> contractRenewedMap = new  Map<Id,Contract>();
                //get Details for Contract being Renewed
                if(contractIds != null) {
                	contractRenewedMap = new Map<Id,Contract>([select Id,AllAssociatedTotalOpportunityValue__c,
                                                               AutoRenewal__c,ContractStatus__c,
                                                               FirstYearContractValue__c,
                                                               Name,Opportunity__c,Status,
                                                               Opportunity__r.ContractBeingRenewed__c,
                                                               TotalContractValue__c,RecordTypeId 
                                                               from Contract where ID IN: contractIds]);	    
                }  
                
                system.debug('contractRenewedMap==>'+contractRenewedMap.values());
                
                //List to update
                List<Contract> updateContractDefaultValue = new List<Contract>();
                
                //check whether annualcumulative value is NULL on Contract Creation.
                if(contractRenewedMap != null) {
                    for(Contract newContract: contractRenewedMap.values() ) {
                        
                        if(newContract.id == mapNewContract.get(newContract.id).id && 
                           newContract.Status != mapOldContract.get(newContract.Id).status &&
                           newContract.Status == 'Creation'
                          ) {                           
                               // Now Capture Contract Id where we have to set Contract default value.
							   // Assign default total contract value when status is Creation and autorenewal is true.
                               Contract updateContract = new Contract(id= newContract.Id);
                               updateContract.AllAssociatedTotalOpportunityValue__c = newContract.TotalContractValue__c;                           
                               updateContractDefaultValue.add(updateContract);
                               system.debug('updateContractDefaultValue==>'+updateContractDefaultValue);
                           }    
                    }   
                }
                
                if(updateContractDefaultValue != null) {
                    update updateContractDefaultValue;    
                }
                
            }
        }
        catch(Exception ex) {
            UtilityClass.createApexLogRecord(ex,'ContractMethods','updateDefaultContractCumulative');  
        }
	}
    
}