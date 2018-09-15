//-----------------------------
// @author: Uttam Arya
// @date: 22 June 2017
// @param: NA
// @description: Class to hold trigger methods 
// @return: NA
//-----------------------------
public class CaseMethods {
    
    
    //-----------------------------
    // @author: Uttam Arya
    // @date: 22 June 2017
    // @param: TriggerParameters tp
    // @description: When the product is selected in a case, the function creates an additional case fields (record) 
    // 				 for the product that requires additional fields.
    // 
    // @edits: 31st July 2017 SFDC1-1159 Uttam Arya, When the Internal Partner is selected in a case, the function creates an additional case fields (record) 
    // 				 for the Internal Partner product that requires additional fields.
    //         2nd Aug 2017 SFDC1-1941 Uttam Arya, Change Record Name Convention-Additional Case Fields (CaseNumber instead of 'Yes')
	//         22nd Jan 2018 SFDC1-6729 Vishnu Vardhan, When the additnonal case type linking field is created with a product group, product family and case record type. 
	//         		Now on creating with case, product group and different product family still creates additional case fields object. Adding extra condition to stop this.
	//         14th Feb 2018 SFDC1-6382 Vishnu Vardhan, Most of the earlier code is rewritten. Additnonal case type linking record 
	//         		is used to determine, ACF record type. It is done based on product group, product family, internal case and case record type. 
	//         		New case scenarios have come up as mentioned below. So plotting a table and where/how it is achieved in the code.
	//         		Also, additional case fields record name has been changed to ACF-<<CaseNumber>>
	//         	3rd Apr 2018 SFDC1-7120 Vishnu Vardhan, Removing internal partner related code.
	//         	4rd Apr 2018 SFDC1-6382 Vishnu Vardhan, When a case is created and after that ACTL gets created or deleted then ACF was not 
	//         		Getting created or deleted. Have added code to cover this scenario.
	//          06th Sep 2018 Paras Dhingra migration exercise Adding legacy id fields for AdditionalCaseFields 
	//---------------------------------------------------------------------------------------------------------------
	// Case Record| Product group  | Additional Case | Additional Case	 | Action To be Taken | Achieved at line	|
	// Type		  | Producy Family | Type Linking	 | Field Record Type | on ACF Record	  |	number		   		|
	//---------------------------------------------------------------------------------------------------------------
	// Same		  | Same		   |	Filtering out these cases from furhter processing 	  |	For loop at line 55	|
	// Either One changed		   |	Not Found	 |  				 | Delete ACF		  |	If at line 94		|
	// Either One changed		   |	Found, but OLD Case dont have ACF| Create ACF		  |	If at line 97		|
	// Same		  | Changed		   |	Found		 | Different		 | Delete and Recreate|	If at line 112		|
	// Same		  | Changed		   |	Found		 | Same				 | Do Nothing		  |	If at line 91		|
	// Changed	  | Changed		   |	Found		 | Different		 | Delete and Recreate|	If at line 112		|
	// Changed	  | Changed		   |	Found		 | Same				 | Do Nothing		  |	If at line 91		|
	// Changed	  | Same		   |	Found		 | Same				 | Do Nothing		  |	If at line 91		|
	// Changed	  | Same		   |	Found		 | Different		 | Change Record Type |	If at line 105		|
	//---------------------------------------------------------------------------------------------------------------
    // @return: None
    //------------------------------
    public static void setCaseAdditionalFieldsObject(TriggerParameters tp) {
        // Map of old values and new values
        Map<Id,Case> mapNewCase = (Map<Id,Case>) tp.newMap;
        Map<Id,Case> mapOldCase = (Map<Id,Case>) tp.oldMap;

        //Additinonal case fields whose record type or name will be changed and updated or deleted.
        Map<id,AdditionalCaseFields__c> existingAdditionalCaseFields = new Map<id,AdditionalCaseFields__c>();

        // List to hold Additional Case Fields thats needs to be Upserted and deleted.
        List<AdditionalCaseFields__c> additionalCaseFieldsToUpsert = new List<AdditionalCaseFields__c>();
        List<AdditionalCaseFields__c> additionalCaseFieldsToDelete = new List<AdditionalCaseFields__c>();
        
        //Set of Case Id whose Product Group/Product family/Case record type is updated
        Set <Id> updatedCases = new Set <Id>();
        
        // Build caseProductGroupMap to find unique product per case
        for(Case newCase: mapNewCase.values()) {
            Case oldCase = new Case();
            if(tp.tEvent == TriggerParameters.TriggerEvent.afterUpdate) {
                oldCase = mapOldCase.get(newCase.Id);
            }
            if(oldCase.ProductFamily__c != newCase.ProductFamily__c
               || oldCase.ProductGroup__c != newCase.ProductGroup__c
               || oldCase.RecordTypeId != newCase.RecordTypeId) {
                   //Intrested only in cases, that have changes in above fields
                   updatedCases.add(newCase.Id);
               }
        }
        
        if(updatedCases != null && updatedCases.size() > 0) {
        	// Map to store (Product Group Id + Case Recordtype Id) / (Product Family Id + Case Recordtype Id) as key for ACF Record Id.
        	Map<String, String> actlMap = prepareACTLMap();
            
            // If the event is after update, get old additional case fields. So that they can be updated or deleted.
            if(tp.tEvent == TriggerParameters.TriggerEvent.afterUpdate) {
                // List of Additional Case Fields thats needs to be deleted/updated 
                existingAdditionalCaseFields = new Map<Id, AdditionalCaseFields__c>([Select Id, Case__c, RecordTypeId from AdditionalCaseFields__c where Case__c in :updatedCases]);
            }
            
            for(Id caseId: updatedCases) {
                Case newCase = mapNewCase.get(caseId);
                Case oldCase = new Case();
                AdditionalCaseFields__c oldAcf = null;

                System.debug('@@@UA CaseId: ' + caseId);
                String newACFRecordTypeId = getACFRecordTypeId (newCase, actlMap);
                String oldACFRecordTypeId = '';
                //If the event is after update get old values
                if(tp.tEvent == TriggerParameters.TriggerEvent.afterUpdate) {
                	oldCase = mapOldCase.get(newCase.Id);
                    oldACFRecordTypeId = getACFRecordTypeId(oldCase, actlMap);
                }
                oldAcf = existingAdditionalCaseFields.get(oldCase.AdditionalFields__c);
                if(String.isBlank(newACFRecordTypeId) && String.isBlank(oldACFRecordTypeId)) {
                	//Both dont have any ACTL Records. Can ignore, there can be a scenario when
					// case was created there was ACTL record and now it is deleted, 
                } else if (String.isBlank(newACFRecordTypeId)) {
                	// Old ACLT has a record type and new one dont have, Delete old ACF record.
                } else if (String.isBlank(oldACFRecordTypeId)) {
                    // new ACLT has a record type and old one done have, Create new ACF record. Or New case is created
                    additionalCaseFieldsToUpsert.add(
                        new AdditionalCaseFields__c(RecordTypeId = newACFRecordTypeId, 
                                                    Name = 'ACF - ' + newCase.CaseNumber, Case__c = newCase.Id,
                                                    LegacyID__c = newCase.LegacyID__c, LegacyIDUnique__c = newCase.LegacyIDUnique__c,
                                                    LegacyReference__c = newCase.LegacyReference__c, LegacySystem__c = newCase.LegacySystem__c));
                } else if (newACFRecordTypeId.equals(oldACFRecordTypeId)) {
                    if(oldAcf == null) { 
                        // Create Case that does not have matching ACTL.
                        // Create ACTL for above case with ACF record type as X, create another ACTL with ACF record type as X
                        // Now Change case to match second ACTL. Earlier ACF record was not getting generated.
                        // So added below condition.
                        additionalCaseFieldsToUpsert.add(
                        new AdditionalCaseFields__c(RecordTypeId = newACFRecordTypeId, 
                                                    Name = 'ACF - ' + newCase.CaseNumber, Case__c = newCase.Id,
                                                    LegacyID__c = newCase.LegacyID__c, LegacyIDUnique__c = newCase.LegacyIDUnique__c,
                                                    LegacyReference__c = newCase.LegacyReference__c, LegacySystem__c = newCase.LegacySystem__c));
                    }
                    //Though, PF or PG or case RT got changed, still ACF RT is same. 
                    continue;
                } else if (oldCase.ProductFamily__c == newCase.ProductFamily__c 
                           && oldCase.ProductGroup__c == newCase.ProductGroup__c) { 
                    //At this point newACFRecordTypeId!=oldACFRecordTypeId; So, not chekcing
                    //Only Case record type is changed. So, Change ACF record type and do not recreate ACF.
                    oldAcf.RecordTypeId = newACFRecordTypeId;
                    additionalCaseFieldsToUpsert.add(oldAcf);
                    continue; //If continue is not there then, ACF will be deleted.
                } else {
                    //Either Product group or Product family is changed. Recreate ACF.
                    additionalCaseFieldsToUpsert.add(
                        new AdditionalCaseFields__c(RecordTypeId = newACFRecordTypeId, 
                                                    Name = 'ACF - ' + newCase.CaseNumber, Case__c = newCase.Id,
                                                    LegacyID__c = newCase.LegacyID__c, LegacyIDUnique__c = newCase.LegacyIDUnique__c,
                                                    LegacyReference__c = newCase.LegacyReference__c, LegacySystem__c = newCase.LegacySystem__c));
                }
                if(oldAcf!=null) { 
                    additionalCaseFieldsToDelete.add(oldAcf);
                }
            }
            
            // upsert/delete if list has any records. First delete and then upsert
            if(additionalCaseFieldsToDelete != null && additionalCaseFieldsToDelete.size() > 0) {
                delete additionalCaseFieldsToDelete;
            }
            if(additionalCaseFieldsToUpsert != null && additionalCaseFieldsToUpsert.size() > 0) {
                upsert additionalCaseFieldsToUpsert;
            }
        }
    }

    //-----------------------------
    // @author : Vishnu Vardhan Chowdary Andra
    // @date : 07-Feb-2018
    // @param : Cas - Case for which additional case fields object type is being figured.
    // 			actlMap - Map containing key as Product families Id + CaseRecord type ID and
    // 					product group id+ case record type id's as key and their values as additional case field record type. 
    // @description : SFDC1-6382: Moving a common piece of code into a seperate method. Based on the prodcut
    // 			family or product group of a case, and case record type, additional case field record type is found in the 
    // 			actl map and is returned. If no match is found, then empty string is returned implying case dont have ACF.
    // @LastModifiedDate : 3rd Apr 2018
    // @LastModifiedDescription: SFDC1-7120 Vishnu Vardhan, Removing internal partner related code
    // @LastModifiedDate : 26 Jun 2018
    // @LastModifiedDescription: SFDC1-8397: When product family is not setup, then fallback on product group while selecting
    // 						ACTL record.
    // @LastModifiedBy: Vishnu  Vardhan Chowdary
    // @return : String - Id for the additional Case field record type.
    //-----------------------------
    private static String getACFRecordTypeId(Case cas, Map<String, String> actlMap) {
        String recordId = null;
        if(cas !=null && cas.ProductFamily__c != null) {
            recordId = actlMap.get(String.valueOf(cas.ProductFamily__c) + String.valueOf(cas.RecordTypeId));
        }
        if(String.isBlank(recordId) && cas !=null && cas.ProductGroup__c != null) {
            recordId = actlMap.get(String.valueOf(cas.ProductGroup__c) + String.valueOf(cas.RecordTypeId));
        }
        return recordId;
    }
    
    //-----------------------------
    // @author: Vishnu Vardhan Chowdary Andra
    // @date: 07 Feb 2018
    // @param: 
    // @description: SFDC1-6382 Moving ACTL object map creation into a seperate method
    // @return: Map containing key as Product families Id + CaseRecord type ID and
    //		product group id+ case record type id's as key and their values as additional case field record type
    //------------------------------
    public static Map<String, String> prepareACTLMap() {
        // Query all Additional Case Type Linking
        List<AdditionalCaseTypeLinking__c> aCaseTypeLinkings = [SELECT AdditionalCaseRecordType__c,CaseRecordType__c,ProductFamily__c,ProductGroup__c FROM AdditionalCaseTypeLinking__c];
        // Map to store (Product Group Id + Case Recordtype Id) / (Product Family Id + Case Recordtype Id) as key for Additional Case Type Linking
        Map<String, String> actlMap = new Map<String, String>();

        for(AdditionalCaseTypeLinking__c actl: aCaseTypeLinkings) {
            System.debug('@@@UA actl: ' + actl);

            if( actl.ProductFamily__c != null 
               && Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(actl.CaseRecordType__c) != null 
               && Schema.Sobjecttype.AdditionalCaseFields__c.getRecordTypeInfosByName().get(actl.AdditionalCaseRecordType__c) != null) {
                   actlMap.put(String.valueOf(actl.ProductFamily__c) + Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(actl.CaseRecordType__c).getRecordTypeId(), 
                               Schema.Sobjecttype.AdditionalCaseFields__c.getRecordTypeInfosByName().get(actl.AdditionalCaseRecordType__c).getRecordTypeId());
               }

            if( actl.ProductGroup__c != null && actl.ProductFamily__c == null 
               && Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(actl.CaseRecordType__c) != null 
               && Schema.Sobjecttype.AdditionalCaseFields__c.getRecordTypeInfosByName().get(actl.AdditionalCaseRecordType__c) != null) {
                   actlMap.put(String.valueOf(actl.ProductGroup__c) + Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(actl.CaseRecordType__c).getRecordTypeId(), 
                               Schema.Sobjecttype.AdditionalCaseFields__c.getRecordTypeInfosByName().get(actl.AdditionalCaseRecordType__c).getRecordTypeId());
               }
        }
        System.debug('@@@UA actlMap: ' + actlMap);
        return actlMap;
    }

    //-----------------------------
    // @author: Paras Dhingra
    // @date: 30 June 2017
    // @param: TriggerParameters tp
    // @description: SFDC1-441 Update Milestones when the criteria are met 
    // 				  
    // @return: None
    //------------------------------
    public static void updateCaseMilestones(TriggerParameters tp) {
        
        // list will contain the casemilestones to be updated
        Set<CaseMilestone> setCaseMilestoneToBeUpdated = new set<CaseMilestone>();
        
        //fetch all milestones related to case
        List<CaseMilestone> lstCaseMilestone = [Select id, CaseId, CompletionDate, MilestoneType.Name from CaseMilestone where Caseid IN:tp.newMap.keySet() and isCompleted=false];
        
        //Proceed only if associated milestones exist
        if(lstCaseMilestone!=null &&!lstCaseMilestone.isEmpty()) {
            
            //traverse all caseMilestones
            for(CaseMilestone cm : lstCaseMilestone) {
                
                Case newCase = (Case)tp.newMap.get(cm.CaseId);
                Case oldCase = (Case)tp.oldMap.get(cm.CaseId);
                
                //close all milestones in case the case is closed
                if(newCase.IsClosed) {
                    
                    cm.CompletionDate = System.now();
                    setCaseMilestoneToBeUpdated.add(cm);
                    
                    //skip the for loop iteration as milestones already got closed
                    continue;
                }
                
                //close first touch
                //update has happened
                if(cm.MilestoneType.Name== 'First Touch' && tp.tEvent==TriggerParameters.TriggerEvent.afterUpdate) {
                    
                    //in case update has happened the first touch milestone will be closed
                    cm.CompletionDate = System.now();
                    setCaseMilestoneToBeUpdated.add(cm);
                }
                
                //close assigned
                String ownerId = newCase.OwnerID;
                
                if(cm.MilestoneType.Name == 'Assignment' && 
                   (oldCase.OwnerID <> newCase.OwnerID || ownerId.startsWith('005'))) {
                       
                       cm.CompletionDate = System.now();
                       setCaseMilestoneToBeUpdated.add(cm);
                   }
                
            }
            
            //check and update the list
            if(setCaseMilestoneToBeUpdated!=null && !setCaseMilestoneToBeUpdated.isEmpty()) {
                
                List<CaseMilestone> lstUpdateCaseMilestone = new List<CaseMilestone>();
                lstUpdateCaseMilestone.addAll(setCaseMilestoneToBeUpdated);
                
                //Update the final list
                update lstUpdateCaseMilestone;
            }
        }
    }
    
    // Static reference to Case Record Type "Order Management/Delivery Help Desk"
    public static Id caseRecordTypeOMDHelpDesk {
        get {
            if (caseRecordTypeOMDHelpDesk == null) {
                caseRecordTypeOMDHelpDesk = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Order Management/Delivery Help Desk').getRecordTypeId(); 
            }
            return caseRecordTypeOMDHelpDesk;
        }
        
        set;
    }

    //-----------------------------
    // @author: Tran-Vu Tran
    // @date: 01 June 2018
    // @param: TriggerParameters tp
    // @description: SFDC1-8381 Convert Process Builder flow "SetDefaultValuesForProductGroup" created in SFDC1-6418 to a trigger
    // 	SFDC1-6418 set Product Group value depending on Case Record Type, Team Select and Customer Care Initiated values:
    // 	1. If Record Type == "Order Management/Delivery Help Desk" AND Team Select == "Order Management" AND CustomerCareInitiated == FALSE, then set Produc Group value == "Order Mgmt. Helpdesk".
    // 	2. If Record Type == "Order Management/Delivery Help Desk" AND Team Select == "Delivery" AND CustomerCareInitiated == FALSE, then set  Product Group value == "Delivery Helpdesk"
    // 	3. If Record Type == "Order Management/Delivery Help Desk" AND Team Select == "Retail" AND CustomerCareInitiated == FALSE, then set Product Group value == "Retail Helpdesk"
    // @return: None
    //------------------------------
    public static void setCaseProductGroupForOrderManagementDeliveryHelpDesk(TriggerParameters tp) {
        
        // Map of old values and new values
        List<Case> listNewCase = tp.newList;
        Map<Id, Case> mapOldCase = (Map<Id,Case>) tp.oldMap;

        getProductGroupIds();
                
        for (Case newCase : listNewCase) {
            
            if (newCase.RecordTypeId != caseRecordTypeOMDHelpDesk) {
                continue; // skip the logic below if this is not "Order Management/Delivery Help Desk" case record type
            }
            
            Case oldCase = null;
            if (tp.tEvent == TriggerParameters.TriggerEvent.beforeUpdate) {
                oldCase = mapOldCase.get(newCase.Id);
            }
            
            if (newCase.CustomerCareInitiated__c == false &&
                (oldCase == null || oldCase.TeamSelect__c != newCase.TeamSelect__c)) {

                if (newCase.TeamSelect__c == 'Order Management') {
                    newCase.ProductGroup__c = productGroupIdOrderMgmtHelpdesk;
                } else if (newCase.TeamSelect__c == 'Delivery') {
                    newCase.ProductGroup__c = productGroupIdDeliveryHelpdesk;
                } else if (newCase.TeamSelect__c == 'Retail') {
                    newCase.ProductGroup__c = productGroupIdRetailHelpdesk;
                }
            }
        }
    }
    
    // Static references to Product Group IDs
    public static Id productGroupIdOrderMgmtHelpdesk;
    public static Id productGroupIdDeliveryHelpdesk;
    public static Id productGroupIdRetailHelpdesk;
    public static Boolean productGroupIdsLoaded = false;

    public static void getProductGroupIds() {
        
        if ((productGroupIdOrderMgmtHelpdesk == null || productGroupIdDeliveryHelpdesk == null || productGroupIdRetailHelpdesk == null) 
            && productGroupIdsLoaded == false) {

            productGroupIdsLoaded = true; // prevent the method to be run multiple times when no matching product group was found 
                
            Map<String, ProductGroup__c> productGroups = new Map<String, ProductGroup__c>();
            
            // reload from database
            for (ProductGroup__c pg : [select Id, Name from ProductGroup__c where Name in ('Order Mgmt. Helpdesk', 'Delivery Helpdesk', 'Retail Helpdesk')]) {
                
                productGroups.put(pg.Name, pg);
            }
                
            ProductGroup__c pgOrderMgmtHelpdesk = productGroups.get('Order Mgmt. Helpdesk');
            if (pgOrderMgmtHelpdesk != null) {
                productGroupIdOrderMgmtHelpdesk = pgOrderMgmtHelpdesk.Id;
            }
            
            ProductGroup__c pgDeliveryHelpdesk = productGroups.get('Delivery Helpdesk');
            if (pgDeliveryHelpdesk != null) {
                productGroupIdDeliveryHelpdesk = pgDeliveryHelpdesk.Id;
            }
            
            ProductGroup__c pgRetailHelpdesk = productGroups.get('Retail Helpdesk');
            if (pgRetailHelpdesk != null) {
                productGroupIdRetailHelpdesk = pgRetailHelpdesk.Id;
            }
        }
    }
    
    //-----------------------------
    // @author: Tran-Vu Tran
    // @date: 18 July 2017
    // @param: TriggerParameters tp
    // @description: SFDC1-204 & SFDC1-965 Update Case's Account and Contact lookup 
    // for Data Governance cases when the criteria are met 
    //-----------------------------
    // @author: Tran-Vu Tran
    // @date: 01 June 2018
    // @param: TriggerParameters tp
    // @description: SFDC1-8356 update logic to populate Order Management/Delivery Help Desk case's account and contact
    // 1. The Contact Name on parent Customer Care case to be mapped to the "Contact Reference" of OM/Del Heldpesk child case
    // 2. The Account Name on parent Customer Care case to be mapped to the "Account Reference" of OM/Del heldpesk child case
    // 3. The Created By on parent Customer Care case to be mapped to the "Contact Name" and its related account to be mapped to the "Account Name" of the OM/Del Heldpesk child case
    // @return: None
    //------------------------------
    
    public static void setInternalCaseAccountAndContact(TriggerParameters tp) {
        
        // Look up for a contact record with email address matching to the user's email address
        Contact userContact = UtilityClass.getContactByEmail(UserInfo.getUserEmail());
        List<Case> newList = tp.newList;
        
        for (Case c : newList) {

            if (tp.tEvent == TriggerParameters.TriggerEvent.beforeInsert) {
                
                if (c.Type != 'Data Governance' && // if this is not a Data Governance case type
                    c.RecordTypeId != caseRecordTypeOMDHelpDesk) { // and not an "OM/D Help Desk" case record type
                    continue; // skip the logic below
                }
                
                if (c.Type == 'Data Governance' || // always run for Data Governance case type 
                    c.CustomerCareInitiated__c == true) { // and only if CustomerCareInitiated is true for "OM/D Help Desk" case record type
                    if (userContact != null) {
                        if (userContact.AccountId != null) {
                            c.ContactId = userContact.Id;
                            c.AccountId = userContact.AccountId;
                        }
                        else {
                            c.addError('The contact matching to your email address does not have an account linked to it, please update that contact\'s account to IHS Markit.');
                        }
                    }
                    else {
                        c.addError('Please create a contact with email address matching to your email address under IHS Markit account then try again.');
                    }
                }
            }
        }
    }
    
    //-----------------------------
    // @author: Uttam Arya
    // @date: 11 Oct 2017
    // @param: TriggerParameters tp
    // @description: SFDC1-5616 When the product family is selected in a case, the function auto populates the product group
    // @return: None
    //------------------------------
    public static void setCaseProductGroupFromProductFamily(TriggerParameters tp) {
        
        // Map to store Product Family Id per Case 
        Map<Id, Id> caseFamilyMap = new Map<Id, Id>();
        
        // Build casefamilyMap to find unique product family per case
        for(Case newCase: (list <Case>) tp.newList) {
            if(tp.tEvent == TriggerParameters.TriggerEvent.beforeUpdate) {
                
                Case oldCase = (Case) tp.oldMap.get(newCase.Id);
                
                //reset product family lookup, incase product group is changed
                if(newCase.ProductFamily__c != null 
                   && newCase.ProductFamily__c == oldCase.ProductFamily__c 
                   && newCase.ProductGroup__c != null 
                   && newCase.ProductGroup__c != oldCase.ProductGroup__c) {
                       newCase.ProductFamily__c = null;
                   }
            }
            if(newCase.ProductFamily__c != null) {
                caseFamilyMap.put(newCase.Id, newCase.ProductFamily__c);
            }
        }
        
        if(caseFamilyMap != null && caseFamilyMap.size() > 0) {
            // Query Product families realted to cases in trigger
            Map<Id, Family__c> productFamilyMap = new Map<Id, Family__c>([Select Id, Name, ProductGroup__c
                                                                          from Family__c where Id in :caseFamilyMap.values()]);
            for(Case newCase: (list <Case>) tp.newList) {
                if(caseFamilyMap.get(newCase.Id) != null & productFamilyMap.get(caseFamilyMap.get(newCase.Id)) != null) {
                    newCase.ProductGroup__c = productFamilyMap.get(caseFamilyMap.get(newCase.Id)).ProductGroup__c;
                }
            }
        }
    } 
    
    
    //-----------------------------
    // @author: Hemant Shukla
    // @date: 18 Jan 2018
    // @param: TriggerParameters tp
    // @description: SFDC1-6629, To fire the case Assignment rules which are created in Quick Actions
    // @Update author: Vishnu Vardhan Chowdary
    // @Update date: 11 Jul 2018
    // @Update description: SFDC1-6026 - Adding an additional check for email 2 case scenarion where 
    // 				case assignment rules shouldn't execute.
    // @Update author: Vishnu Vardhan Chowdary
    // @Update date: 07 Aug 2018
    // @Update description: SFDC1-9677 - Changing the record type to Sales Operations.
    // @return: None
    //------------------------------
    Public static void fireCaseAssignmentRule(TriggerParameters tp) {
        
        List<Case> cases = new List<Case>();
        Id salesOprtationsRTId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get('Sales Operations').getRecordTypeId();
        
        for(Case obj : (list <Case>) tp.newList) {
            
            //Do only when Sales Operations case are created via quick action. AssignToQueue__c field will be true only for those criteria.
            if(obj.AssignToQueue__c && Obj.RecordTypeId == salesOprtationsRTId
              && obj.SuppliedEmail == null) {// Dont want email 2 cases go through 
                case c = new case(Id = obj.Id);
                Database.DMLOptions dmo = new Database.DMLOptions();
                dmo.assignmentRuleHeader.useDefaultRule= true;
                c.setOptions(dmo);
                cases.add(c);
            }    
        }
        
        if(!cases.isEmpty()) {
            update cases;
        }   
    } 
    
    //-----------------------------
    // @author: Mohit Modi
    // @date: 06 Feb 2018
    // @param: TriggerParameters tp
    // @description: SFDC1-6009, To set the Contact Name same as Owner, if Contact Exists only for 'Sales Support' Recordtype, Valid for insert and Owner update only with a specified Account stored in Label.    // 
    // 
    // @modified by: Harshit Singhal
    // @date: 04 Jun 2018
    // @description: SFDC1-8551, Modified the existing method to set contact name on 'Salesforce Helpdesk' record type cases based on current/logged-in user when the case gets created from Global Quick Action 'Create Salesforce Helpdesk Case'
    // 
    // @modified by: Harshit Singhal
    // @date: 08 Jun 2018
    // @description: SFDC1-8256, Modified the existing method to set account Id on 'Sales Support' record type cases from related Contact's account
    //
    // @modified by: Vishnu Vardhan Chowdary Andra
    // @date: 07 Aug 2018
    // @description: SFDC1-9677, Record type got changed from Sales Support to Sales Operations
    //
    // @return: None
    //------------------------------
    public static void setContactNamefromOwner(TriggerParameters tp) {		
        Id salesSupportRTId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get('Sales Operations').getRecordTypeId();
        Id salesforceHelpdeskRTId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get('Salesforce Helpdesk').getRecordTypeId();        
        set<Id> setOwnerID = new set<ID>();		
        map<id,string> mapOwnerIdEmail= new map<id,string>();
        map<string,Contact> mapEmailContactObj= new map<string,Contact>();
        map<string,Contact> mapSalesforceHelpdeskEmailContactObj= new map<string,Contact>();
        
        for(Case obj : (list <Case>) tp.newList) {            
            //for the Insert Record when the Owner is User and Contact is not filled and for only SalesOperations RecordType
            if(Obj.RecordTypeId == salesSupportRTId && 
                tp.tEvent == TriggerParameters.TriggerEvent.beforeInsert &&
                String.valueof(Obj.OwnerId).Startswith('005') &&
                Obj.contactid == NULL) {
                setOwnerID.add(Obj.OwnerId);
            }
            //for the Update Record when the Owner is User and Contact is not Changed for only SalesOperations RecordType
            if(Obj.RecordTypeId == salesSupportRTId &&
                tp.tEvent == TriggerParameters.TriggerEvent.beforeUpdate && 
                ((Case)tp.oldMap.get(Obj.Id)).OwnerID != Obj.OwnerID &&
                String.valueof(Obj.OwnerId).Startswith('005') && 
                ((Case)tp.oldMap.get(Obj.Id)).contactid == Obj.contactid) {
                setOwnerID.add(Obj.OwnerId);
            }
            //for the Insert Record, for only Salesforce Helpdesk RecordType, find contact based on logged-in user
            if(!setOwnerID.contains(UserInfo.getUserId()) && obj.RecordTypeId == salesforceHelpdeskRTId && tp.tEvent == TriggerParameters.TriggerEvent.beforeInsert && obj.Origin == 'Quick Action' && obj.ContactId == null) {                   
                setOwnerID.add(UserInfo.getUserId());
            }            
        }
        
        //fetching the Email for the Case Owners
        if(!setOwnerID.isEmpty()) {
            for(User userobj : [select id, Email from User where id in :setOwnerID ]) {            
                mapOwnerIdEmail.put(userobj.id,userobj.Email);
            }            
        }
        
        //fetching the ContactIds for the Case Owners'Email
        if(!mapOwnerIdEmail.isEmpty()) {
            //for(Contact Contactobj : [select id,Accountid,Account.Name, email from contact where email in : mapOwnerIdEmail.values() and Account.Name =: label.CaseAccountNameForSalesSupport]) {
            for(Contact Contactobj : [select id,Accountid,Account.Name, email from contact where email in : mapOwnerIdEmail.values()]) {
                if(Contactobj.Account.Name == label.CaseAccountNameForSalesSupport) {
                    mapEmailContactObj.put(Contactobj.Email,Contactobj);
                }
                mapSalesforceHelpdeskEmailContactObj.put(Contactobj.Email,Contactobj);
            }            
        }
        
        //setting up the Case's Contact if Correct Email is found        
        for(Case obj : (list <Case>) tp.newList) {
            // Insert Case for 'Sales Operations' Recordtype
            if(Obj.RecordTypeId == salesSupportRTId && 
            tp.tEvent == TriggerParameters.TriggerEvent.beforeInsert &&
            String.valueof(Obj.OwnerId).Startswith('005') &&
            Obj.contactid == NULL && mapOwnerIdEmail.containskey(Obj.OwnerId)) {
                obj.contactid = mapEmailContactObj.containskey(mapOwnerIdEmail.get(Obj.OwnerId)) ? mapEmailContactObj.get(mapOwnerIdEmail.get(Obj.OwnerId)).Id : NULL;
                obj.accountId = mapEmailContactObj.containskey(mapOwnerIdEmail.get(Obj.OwnerId)) ? mapEmailContactObj.get(mapOwnerIdEmail.get(Obj.OwnerId)).AccountId : NULL;
            }
            
            // Update Case for 'Sales Operations' Recordtype
            if(Obj.RecordTypeId == salesSupportRTId &&
            tp.tEvent == TriggerParameters.TriggerEvent.beforeUpdate && 
            ((Case)tp.oldMap.get(Obj.Id)).OwnerID != Obj.OwnerID &&
            String.valueof(Obj.OwnerId).Startswith('005') && 
            ((Case)tp.oldMap.get(Obj.Id)).contactid == Obj.contactid && mapOwnerIdEmail.containskey(Obj.OwnerId)) {
                obj.contactid = mapEmailContactObj.containskey(mapOwnerIdEmail.get(Obj.OwnerId)) ? mapEmailContactObj.get(mapOwnerIdEmail.get(Obj.OwnerId)).Id : NULL;
                obj.accountId = mapEmailContactObj.containskey(mapOwnerIdEmail.get(Obj.OwnerId)) ? mapEmailContactObj.get(mapOwnerIdEmail.get(Obj.OwnerId)).AccountId : NULL;
            }
            
            //Insert case for 'Salesforce Helpdesk' RecordType
            Id currentUserId = UserInfo.getUserId();
            if(obj.RecordTypeId == salesforceHelpdeskRTId && tp.tEvent == TriggerParameters.TriggerEvent.beforeInsert && obj.Origin == 'Quick Action' && obj.ContactId == null && mapOwnerIdEmail.containskey(currentUserId)) {
                obj.contactId = mapSalesforceHelpdeskEmailContactObj.containsKey(mapOwnerIdEmail.get(currentUserId)) ? mapSalesforceHelpdeskEmailContactObj.get(mapOwnerIdEmail.get(currentUserId)).Id : NULL;
                obj.AccountId = mapSalesforceHelpdeskEmailContactObj.containsKey(mapOwnerIdEmail.get(currentUserId)) ? mapSalesforceHelpdeskEmailContactObj.get(mapOwnerIdEmail.get(currentUserId)).AccountId : NULL;
            }            
        }        
    } 
       
	//------------------------------
    // @author: Vishnu Vardhan
    // @date: 13 May 2018
    // @param: TriggerParameters tp
    // @description: SFDC1-7183: Once all the implementation cases status is set to closed, then related parent contract 
    // 						record status to be set to "Delivered to Customer" and stage to 'Completed'.
    // @return: None
    //------------------------------
    public static void afterAllCaseClosedOnContract(TriggerParameters tp) {
        // Map of old values and new values
        Map<Id,Case> mapNewCase = (Map<Id,Case>) tp.newMap;
        Map<Id,Case> mapOldCase = (Map<Id,Case>) tp.oldMap;
        List<Id> contractIds = new List<Id>(); 
        Id caseImplemetationRecordTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get('Implementation').getRecordTypeId();
        
        Id continuationLetterRecordTypeId = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('Continuation Letter').getRecordTypeId();
        Id trialRecordTypeId = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('Trial').getRecordTypeId();
        Id orderFormRecordTypeId = Schema.Sobjecttype.Contract.getRecordTypeInfosByName().get('Order Form').getRecordTypeId();
        if(tp.tEvent == TriggerParameters.TriggerEvent.afterUpdate) {
            for(Case newCase: mapNewCase.values()) {
                Case oldCase = new Case();
                oldCase = mapOldCase.get(newCase.Id);
                if(newCase.isClosed 
                   && newCase.RecordTypeId == caseImplemetationRecordTypeId 
                   && newCase.Contract__c != null 
                   && newCase.Status != oldCase.Status) {
                       //Collecting the contract ids for verifying if related cases are closed.
                       contractIds.add(newCase.Contract__c); 
                   }
            }
            
            if(!contractIds.isEmpty()) {
                List<contract> contractsToUpdate = new List<contract>();
                for(Contract ctrct: [Select id, ContractStatus__c, status, recordTypeId, 
                                     (Select isClosed, recordTypeId from Cases__r where recordTypeId = :caseImplemetationRecordTypeId ) from contract where id In :contractIds]) {
                    if(ctrct.RecordTypeId == trialRecordTypeId || ctrct.RecordTypeId == continuationLetterRecordTypeId) { 
                        //Checking only for trial and continuation letter record type.
                        boolean updateStatus = true;
                        updateStatus = checkIfAllImplementationCasesAreClosed(ctrct.Cases__r,caseImplemetationRecordTypeId);                       
                        if(updateStatus) {
                            ctrct.ContractStatus__c = 'Delivered to Customer';
                            ctrct.status = 'Complete';
                            contractsToUpdate.add(ctrct);
                            
                        }
                    }
                    if(ctrct.RecordTypeId == orderFormRecordTypeId) { 
                        //Checking only for order form record type.
                        boolean updateStatus = true;
                        updateStatus = checkIfAllImplementationCasesAreClosed(ctrct.Cases__r,caseImplemetationRecordTypeId);
                        system.debug('updateStatus @725---'+updateStatus); 
                        if(updateStatus) {
                            ctrct.SAPPGId__c = 'New';
                            contractsToUpdate.add(ctrct);
                            system.debug('contractsToUpdate---'+contractsToUpdate);
                        }
                    }
                }
                try {
                    if(!contractsToUpdate.isEmpty()) {
                        update contractsToUpdate;
                    }
                }
                catch(exception e) {
                    UtilityClass.createApexLogRecord(e, 'CaseMethods', 'afterAllCaseClosedOnContract');       
                }
            }
        }
    }

    //------------------------------
    // @author: Vishnu Vardhan
    // @date: 18 May 2018
    // @param: TriggerParameters tp
    // @description: SFDC1-7740: Once the Order Management case is set to Validated or Validated PO Pending, 
    // 						then update related Contract of Order Form status to Validated or Validated PO Pending.
    // @modified by: Vishnu Vardhan
    // @date: 14 Jun 2018
    // @description: SFDC1-8337: When case is set to Validated PO Pending, then Contract should be set to Validated PO Pending
    // @modified by: Sruti Srivastava
	// @date: 3 July 2018
	// @Description: SFDC1-8960 -Update status on Consulting Contracts, when status on OM Case changes to Validated or //"Validated PO Pending"
	// Consulting contracts
	// @return: None
    //------------------------------
    public static void updateContractWhenOMCaseIsValidated(TriggerParameters tp) {
        if(tp.tEvent == TriggerParameters.TriggerEvent.afterUpdate ) {
            try { 
                Map<Id,Case> mapNewCase = (Map<Id,Case>) tp.newMap;
                Map<Id,Case> mapOldCase = (Map<Id,Case>) tp.oldMap;
                Map<Id,String> mapContractIdAndStatus = new Map<Id,String>();
                Id caseOMRecordTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get('Order Management').getRecordTypeId();
				
                for(Case newCase: mapNewCase.values()) {
                    Case oldCase = new Case();
                    oldCase = mapOldCase.get(newCase.Id);
                    if(newCase.RecordTypeId == caseOMRecordTypeId
                       && newCase.Contract__c != null 
                       && newCase.Status != oldCase.Status 
                       && (newCase.Status == 'Validated' || newCase.Status == 'Validated PO Pending')) {
                           //Case should be OM type, status should be changed, should have contract. 
                           //new status should be 'Validated' and 'Validated PO Pending'. 
                           //Old status shouldnt be one of them.
                           mapContractIdAndStatus.put(newCase.Contract__c, newCase.Status); 
                       }
                }
                if(!mapContractIdAndStatus.isEmpty()) {
                    Id orderFormRecordTypeId = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('Order Form').getRecordTypeId();
					Id consultingRecordTypeId = Schema.SobjectType.Contract.getRecordTypeInfosByName().get('Consulting').getRecordTypeId();
                    List<contract> contractsToUpdate = new List<contract>();
                    for(Contract ctrct: [Select id, ContractStatus__c from contract where id In :mapContractIdAndStatus.keySet() 
                                         AND (recordTypeId = :orderFormRecordTypeId OR RecordTypeId =:consultingRecordTypeId)]) {
                        if(ctrct.ContractStatus__c != mapContractIdAndStatus.get(ctrct.id)) {
                        	ctrct.ContractStatus__c = mapContractIdAndStatus.get(ctrct.id);
                            contractsToUpdate.add(ctrct);
                        }
                    }
                    if(!contractsToUpdate.isEmpty()) {
                        update contractsToUpdate;
                    }
                }
            } catch(DMLException e) {
                if(e.getMessage().contains(System.Label.CaseContactAndAccountMatchMSG)) {
                	((List<Case>) tp.newList).get(0).addError(System.Label.CaseContactAndAccountMatchMSG);
                } else if(e.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION')) {
                   ((List<Case>) tp.newList).get(0).addError(e.getMessage().substringBetween('FIELD_CUSTOM_VALIDATION_EXCEPTION,',':'));  
                } else {
                    ((List<Case>) tp.newList).get(0).addError(e.getMessage());
                }
            } catch (Exception e) {
                UtilityClass.createApexLogRecord(e,'CaseMethods','updateContractWhenOMCaseIsValidated'); 
            }
        }
    }

    //------------------------------
    // @author: Vishnu Vardhan
    // @date: 21 May 2018
    // @param: TriggerParameters tp
    // @description: SFDC1-8120: When the Order Management case is set to rejected, 
    //                      then update related Order Form Contract status to rejected.
    // @return: None
	// @LastModifiedDate : 29 Jun 2018
    // @LastModifiedDescription: SFDC1-8957 Prachi Bhasin, Adding Consulting record type
	// @LastModifiedDate : 31 Jul 2018
    // @LastModifiedDescription: SFDC1-8120 Vishnu, Removing if Condition. so that Status will be updated for both 
    // 				Consulting and Order form record type
    //------------------------------
    public static void updateContractWhenOMCaseIsRejected(TriggerParameters tp) {
        if(tp.tEvent == TriggerParameters.TriggerEvent.afterUpdate ) {
            try { 
                Map<Id,Case> mapNewCase = (Map<Id,Case>) tp.newMap;
                Map<Id,Case> mapOldCase = (Map<Id,Case>) tp.oldMap;
                //Set<id> contractIds = new Set<Id>();
                Map<Id,Case> mapContractIdAndRejectionReason = new Map<Id,Case>();
                
                Id caseOMRecordTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get('Order Management').getRecordTypeId();

                for(Case newCase: mapNewCase.values()) {
                    Case oldCase = new Case();
                    oldCase = mapOldCase.get(newCase.Id);
                    if( newCase.RecordTypeId == caseOMRecordTypeId 
                       && newCase.Contract__c != null 
                       && newCase.Status != oldCase.Status 
                       && newCase.Status == 'Rejected') {
                           //Case should be OM type, status should be changed, should have contract. 
                           //new status should be 'Rejected'.             
                           mapContractIdAndRejectionReason.put(newCase.Contract__c,newCase);                     
                       }
                }               
                if(mapContractIdAndRejectionReason!=NULL && !mapContractIdAndRejectionReason.isEmpty()) {
                    Id orderFormRecordTypeId = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('Order Form').getRecordTypeId();
                    Id consultingRecordTypeId = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('Consulting').getRecordTypeId();
                    List<Id> lstContractRecordTypeIds = new List<Id>();
                    lstContractRecordTypeIds.add(consultingRecordTypeId);
                    lstContractRecordTypeIds.add(orderFormRecordTypeId);
                    List<contract> contractsToUpdate = new List<contract>();                        
                    for(Contract ctrct: [Select id, ContractStatus__c,AdditionalRejectionInformation__c,RecordTypeId, status from contract where id In :mapContractIdAndRejectionReason.keyset() and recordTypeId IN :lstContractRecordTypeIds and ContractStatus__c != 'Rejected']) {                        
                        ctrct.ContractStatus__c = 'Rejected';
                        ctrct.ReasonforRejection__c = mapContractIdAndRejectionReason.get(ctrct.id).ReasonforRejection__c;
                        ctrct.AdditionalRejectionInformation__c= mapContractIdAndRejectionReason.get(ctrct.id).AdditionalRejectionInformation__c;
                        //Earlier this was happening in field update for OF. So didnt add it. but due to validation rule it is throwing error and had to add it.
                        //if(String.valueOf(ctrct.RecordTypeId).substring(0,15) == String.valueOf(consultingRecordTypeId).substring(0,15)) {
                        ctrct.Status = 'Creation';
                        //}
                        contractsToUpdate.add(ctrct);
                    }
                    if(!contractsToUpdate.isEmpty()) {                       
                        update contractsToUpdate;                        
                    }
                    
                }
            } catch (Exception e) {
                UtilityClass.createApexLogRecord(e,'CaseMethods','updateContractWhenOMCaseIsRejected'); 
            }
        }
    }
    //-----------------------------/
    // @author:Vishnu Vardhan Chowdary
    // @date: 15 MARCH 2018
    // @param: TriggerParameters tp
    // @description: SFDC1-7163: This requirement is for Implementation case with contract as order form
    //          1. If Onboarding case required is checked then create Onboarding case
    //          2. If Onboarding case required is un-checked then delete Onboarding case
    //          3. If account/contact/contract is changed in parent case, update child case.
    // @return: None
    // @lastmodifiedby : Mohit Modi
    // @lastmodifieddescription : SFDC1-9440, Added more default fields from Implementation Case to Onboarding Case
    // @lastmodifiedby : Sruti Srivastava
    // @lastmodifieddescription : SFDC1-9466, Onboarding Case Owner should be parent case owner
    //------------------------------
    public static void upsertOnboardingCaseFromImplementationCase(TriggerParameters tp) {
        if(tp.tEvent == TriggerParameters.TriggerEvent.afterUpdate ) {
            try { 
                Map<Id,Case> mapNewCase = (Map<Id,Case>) tp.newMap;
                Map<Id,Case> mapOldCase = (Map<Id,Case>) tp.oldMap;
                Set<Case> listFilteredCases = new Set<Case>();
                
                Id orderFormRecordTypeId = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('Order Form').getRecordTypeId();
                Id caseImplemetationRecordId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get('Implementation').getRecordTypeId();
                for(Case caseObj : mapNewCase.values()) {
                    Case oldCase = mapOldCase.get(caseObj.id);
                    //OnboardingCaseRequired__c is checked then create child case, if unchecked delete child case
                    //If account, Contact, Contract are changed in parent, change them in child record.
                    if(caseObj.RecordTypeId == caseImplemetationRecordId
                       	&& caseObj.Contract__c != null
                       	&& (caseObj.OnboardingCaseRequired__c != oldCase.OnboardingCaseRequired__c
                              || caseObj.AccountId != oldCase.AccountId
                              || caseObj.ContactId != oldCase.ContactId
                              || caseObj.Contract__c != oldCase.Contract__c)
                           ) {
                               listFilteredCases.add(caseObj);
                    }
                }
                if(listFilteredCases.isEmpty()) {
                    System.debug('No cases to process');
                    return;
                }
                List<Case> deleteCases = new List<Case>();
                List<Case> upsertCases = new List<Case>();
                System.debug('Cases to process '+listFilteredCases);
                Map<Id, Case> parentIdToCase = new Map<Id, Case>();
                for(Case cas : [Select id, ParentId, AccountId, Contract__c, ContactId from Case where ParentId in :listFilteredCases]) {
                    parentIdToCase.put(cas.ParentId, cas);
                }
                
                Id caseOnboardingRecordId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get('Onboarding').getRecordTypeId();
                
                for(Case caseObj : listFilteredCases) {
                    Case oldCase = mapOldCase.get(caseObj.id);
                    Case childCase = parentIdToCase.get(caseObj.Id);
                    if(childCase == null && caseObj.OnboardingCaseRequired__c) {
                        childCase = new Case();
                        childCase.RecordTypeId = caseOnboardingRecordId;
                        childCase.AccountId = caseObj.AccountId;
                        childCase.Contract__c = caseObj.Contract__c;
                        childCase.ContactId = caseObj.ContactId;
                        childCase.Status = 'New';
                        childCase.ParentId = caseObj.Id;
                        childCase.OwnerId = caseObj.OwnerId;
                        childCase.Subject = caseObj.Subject;
                        childCase.Description = caseObj.Description;
                        childCase.Type = caseObj.Type;
                        upsertCases.add(childCase);
                    } else if (childCase != null && !caseObj.OnboardingCaseRequired__c) {
                        deleteCases.add(childCase);
                    } else if (childCase != null && (
                        caseObj.AccountId != oldCase.AccountId
                        || caseObj.ContactId != oldCase.ContactId
                        || caseObj.Contract__c != oldCase.Contract__c)) {
                            childCase.AccountId = caseObj.AccountId;
                            childCase.ContactId = caseObj.ContactId;
                            childCase.Contract__c = caseObj.Contract__c;
                            upsertCases.add(childCase);
                    }
                }
                System.debug('delete child cases'+deleteCases);
                if(!deleteCases.isEmpty()) {
                    delete deleteCases;
                }
                System.debug('upsert child cases'+upsertCases);
                if(!upsertCases.isEmpty()) {
                    upsert upsertCases;
                }
            } catch (Exception e) {
                UtilityClass.createApexLogRecord(e,'CaseMethods','upsertOnboardingCaseFromImplementationCase'); 
            }
        }
    }

    //-----------------------------/
    // @author:Vishnu Vardhan Chowdary
    // @date: 21 MARCH 2018
    // @param: TriggerParameters tp
    // @description: SFDC1-7163: Verify that onboarding case required can be checked for
    // 			implementation cases where contract is of order form type only.
    // @return: None
    //------------------------------
    public static void validateIfOBCaseCanCreateFromImplCase(TriggerParameters tp) {
        //SFDC1-9712 Ignore the validation rule if logged in user has IgnoreCaseValidationRules permission set
        // Mohit : Added !Test.isRunningTest() for TestClass Failure
		if(GlobalConstants.hasIgnoreValidationPermission && !Test.isRunningTest()) {
            return;
        }
        if(tp.tEvent == TriggerParameters.TriggerEvent.beforeUpdate ) {
            try { 
                Map<Id,Case> mapNewCase = (Map<Id,Case>) tp.newMap;
                Map<Id,Case> mapOldCase = (Map<Id,Case>) tp.oldMap;
                Set<Case> listFilteredCases = new Set<Case>();
                
                Id caseImplemetationRecordId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get('Implementation').getRecordTypeId();
                for(Case caseObj : mapNewCase.values()) {
                    Case oldCase = mapOldCase.get(caseObj.id);
                    System.debug('Case Obj:'+caseObj);
                    System.debug('oldCase:'+oldCase);
                    if(caseObj.RecordTypeId == caseImplemetationRecordId
                       && caseObj.Contract__c != null
                       && caseObj.OnboardingCaseRequired__c != oldCase.OnboardingCaseRequired__c
                       && caseObj.OnboardingCaseRequired__c) {
                           //only for implementation case, has contract and OnboardingCaseRequired is checked now.
                           listFilteredCases.add(caseObj);
                    }
                }
                if(listFilteredCases.isEmpty()) {
                    System.debug('No cases to process');
                    return;
                }
                Id orderFormRecordTypeId = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('Order Form').getRecordTypeId();
                System.debug('Cases to verify '+listFilteredCases);
                for(Case cas : [Select id, Contract__r.RecordTypeId from Case where id in :listFilteredCases and Contract__r.RecordTypeId != :orderFormRecordTypeId]) {
                    //if(cas.Contract__r.RecordTypeId != orderFormRecordTypeId) {
                        Case caseObj = mapNewCase.get(cas.id);
                        caseObj.addError(System.Label.OnboardingCaseCreationValidationError);
                    //}
                }
            } catch (Exception e) {
                UtilityClass.createApexLogRecord(e,'CaseMethods','validateIfOBCaseCanCreateFromImplCase'); 
            }
        }
    }
//-----------------------------
    // @author: Prachi Bhasin
    // @date: 09 Apr 2018
    // @param: TriggerParameters
    // @description: This method assigns cases via custom assignment rules of Triage object
    // @return: None
    //------------------------------
    public static void assignCasesViaTriage(TriggerParameters tp) {
        if(System.Label.RunCustomCaseAssignmentRule.containsIgnoreCase('TRUE')) {
            Long starttime = DateTime.now().getTime();
            System.debug(' XXX Starttime: ' + starttime);
            String cpuTime = ' XXX Limits CPU Time 1: ' + Limits.getCpuTime();
            List<Case> listNewCase = (List<Case>) tp.newList;
            List<Case> casesToMatchIHS = new List<Case>(); 
            List<Case> casesToMatchMSERV = new List<Case>();            
            List<Case> casesToMatchMarkit = new List<Case>();
            
            ID CustomerCareRecordTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get('Customer Care').getRecordTypeId();
            ID IHSTriageRecordTypeId = Schema.Sobjecttype.TriageCriteria__c.getRecordTypeInfosByName().get('IHS').getRecordTypeId();
            ID MSERVTriageRecordTypeId = Schema.Sobjecttype.TriageCriteria__c.getRecordTypeInfosByName().get('MarkitSERV').getRecordTypeId();
            
            // picking the cases for which triage assignment rules should be executed, and dividing them between 2 different queues
            // only MarkitSERV rules will be evaluated for cases in list casesToMatchMSERV
            // only IHS rules will be evaluated for cases in list casesToMatchIHS
            // EmailFromValue label contains value 'Email:support@markitserv' which depicts that case via email-2-case and was directed to support@markitserv.com
            for(Case c : listNewCase) {
                if(c.Origin == System.Label.EmailFromValue && tp.tEvent==TriggerParameters.TriggerEvent.beforeInsert) {
                    casesToMatchMSERV.add(c);
                    system.debug('inside if--'+TriggerParameters.TriggerEvent.beforeInsert);                
                }
                else if (c.Origin == System.Label.EmailFromValue && c.RunCaseAssignmentRule__c == TRUE) {
                    c.RunCaseAssignmentRule__c = FALSE;
                    casesToMatchMSERV.add(c);              
                }
                else if (c.Origin == System.Label.EmailFromValueMarkit && tp.tEvent==TriggerParameters.TriggerEvent.beforeInsert) {
                    casesToMatchMarkit.add(c);
                    system.debug('inside if--'+TriggerParameters.TriggerEvent.beforeInsert);                
                }
                else if (c.Origin == System.Label.EmailFromValueMarkit && c.RunCaseAssignmentRule__c == TRUE) {
                    c.RunCaseAssignmentRule__c = FALSE;
                    casesToMatchMarkit.add(c);              
                }
                else if (c.Origin != System.Label.EmailFromValue && c.RunCaseAssignmentRule__c == TRUE &&  String.valueOf(c.RecordTypeId).substring(0,15) == String.valueOf(CustomerCareRecordTypeId).substring(0,15)) {
                    c.RunCaseAssignmentRule__c = FALSE;
                    casesToMatchIHS.add(c);              
                }
            }
        
            if((casesToMatchIHS!= NULL && casesToMatchIHS.size()>0) || (casesToMatchMSERV!= NULL && casesToMatchMSERV.size()>0) || (casesToMatchMarkit!= NULL && casesToMatchMarkit.size()>0)) {
                try {
                    //Changes made here : converted to a static query to get all triage records : starts changes to global class se pick kare
                    List<TriageCriteria__c> lstAllTriageRecords = new List<TriageCriteria__c>();
                    lstAllTriageRecords = caseMethodHelperForQueries.allTriageList;
                    //Changes made here : converted to a static query to get all triage records : ends
                                       
                    List<TriageCriteria__c> lstMSERVTriage = new List<TriageCriteria__c>();
                    List<TriageCriteria__c> lstIHSTriage = new List<TriageCriteria__c>();
                    List<TriageCriteria__c> lstMarkitTriage = new List<TriageCriteria__c>();
                    
                    List<String> lstNameOfAllQueues = new List<String>();
                    //Adding FM | MSERV queue by default
                    lstNameOfAllQueues.add(System.Label.MSERVTriageDefaultQueue);
                    lstNameOfAllQueues.add(System.Label.IHSTriageDefaultQueue);
                    
                    // Make different data sets for IHS and MSERV rules by categroizing them on basis of Triage record type
                    for(TriageCriteria__c trc :lstAllTriageRecords) {
                        lstNameOfAllQueues.add(trc.Queue__c);
                        if(String.valueOf(trc.RecordTypeId).substring(0,15) == String.valueOf(IHSTriageRecordTypeId).substring(0,15)) {
                            lstIHSTriage.add(trc);
                        }
                        else if (String.valueOf(trc.RecordTypeId).substring(0,15) == String.valueOf(MSERVTriageRecordTypeId).substring(0,15)) {
                            lstMSERVTriage.add(trc);
                        }
                        else {
                            lstMarkitTriage.add(trc);
                        }
                    } 
                    List<Group> lstAllQueues = new List<Group>([Select Id,name,DeveloperNAME From Group where Type = 'Queue' and ( name in :lstNameOfAllQueues OR DeveloperNAME  in :lstNameOfAllQueues)]);
                    Map<String, Id> mapOfAllQueues = new Map<String, Id>();
                    for(Group grp: lstAllQueues) {
                        if(grp.Name.contains('/')) {
                            mapOfAllQueues.put((grp.DeveloperNAME), grp.Id);
                            }
                        else {
                            mapOfAllQueues.put((grp.NAME), grp.Id); 
                            }                                                 
                    }
                    System.debug(' mapOfAllQueues: ' + mapOfAllQueues.keyset());
                    if(casesToMatchIHS!= NULL && casesToMatchIHS.size()>0) {
                        assignIHSCasesViaTriage(mapOfAllQueues,casesToMatchIHS,lstIHSTriage);
                    }
                    if(casesToMatchMSERV!= NULL && casesToMatchMSERV.size()>0) {
                        assignMarkitSERVCasesViaTriage(mapOfAllQueues,casesToMatchMSERV,lstMSERVTriage,System.Label.MSERVTriageDefaultQueue);
                    }
                    if(casesToMatchMarkit!= NULL && casesToMatchMarkit.size()>0) {
                        assignMarkitSERVCasesViaTriage(mapOfAllQueues,casesToMatchMarkit,lstMarkitTriage,System.Label.IHSTriageDefaultQueue);
                    }
                    cpuTime += ' CPU Time 1e: ' + Limits.getCpuTime();
                    System.debug(' XXX Endtime: ' + DateTime.now().getTime());
                    Long totalTime = DateTime.now().getTime() - starttime;
                    System.debug(' XXX Total time (ms): ' + totalTime);
                    System.debug(cpuTime);              
                }
                catch(Exception e) {
                    System.debug('Error at line 895, method assignCasesViaTriage, class CaseMethods');
                    ApexLogger__c apexLogRecord = new ApexLogger__c(ClassName__c='CaseMethods',ErrorDescription__c=e.getMessage(),FunctionName__c='assignCasesViaTriage');
                    insert apexLogRecord;   
                }          
            }  
        }           
    }
    
    //-----------------------------
    // @author: Prachi Bhasin
    // @date: 09 Apr 2018
    // @param: TriggerParameters
    // @description: This method assigns cases via custom assignment rules of Triage object
    // @return: None
    // @LastModifiedBy: Prachi Bhasin
    // @LastModifiedSprint: Sprint 30
    // @LastModifiedReason: SFDC1-9206 Update default queue to be 'FM | Customer Care' rather than 'To Be Assigned'
    //------------------------------
    public static void assignIHSCasesViaTriage( Map<String, Id> mapOfAllQueues,List<Case> casesToMatchIHS,List<TriageCriteria__c> lstIHSTriage) {
        System.debug(' lstIHSTriage: ' +lstIHSTriage);
        Id defaultQueueId = mapOfAllQueues.get(System.Label.IHSTriageDefaultQueue);
        for(Case csObj: casesToMatchIHS) {
            csObj.OwnerId = defaultQueueId;
            Boolean breakMe = false;
            for(TriageCriteria__c trcMatched: lstIHSTriage) { 
                if((trcMatched.Subtype__c==NULL || (trcMatched.Subtype__c==csObj.Subtype__c))
                        && (trcMatched.ProductFamily__c==NULL ||  (trcMatched.ProductFamily__c==csObj.ProductFamily__c))
                        && (trcMatched.Subject__c==NULL ||  ((csObj.Subject).containsIgnoreCase(trcMatched.Subject__c)))
                        && (trcMatched.Type__c==NULL ||  (trcMatched.Type__c==csObj.Type))
                        && (trcMatched.SkillLevel__c==NULL ||  (trcMatched.SkillLevel__c==csObj.SkillLevel__c))
                        && (trcMatched.ProductGroup__c==NULL ||  (trcMatched.ProductGroup__c==csObj.ProductGroup__c))) {
                    System.debug(' trcMatched ' +trcMatched);     
                    csObj.OwnerId = mapOfAllQueues.get(trcMatched.Queue__c);
                    System.debug(' csObj.OwnerId ' +csObj.OwnerId ); 
                    breakme = true;
                }
                if(breakme)
                    break;
            }
        }
    }
    
    //-----------------------------
    // @author: Prachi Bhasin
    // @date: 09 Apr 2018
    // @param: TriggerParameters
    // @description: This method assigns cases via custom assignment rules of Triage object
    // @return: None
    //------------------------------
    public static void assignMarkitSERVCasesViaTriage(Map<String, Id> mapOfAllQueues,List<Case> casesToMatchMSERV,List<TriageCriteria__c> lstMSERVTriage,String defaultQueue) {
        for(Case csObj: casesToMatchMSERV) {
            csObj.OwnerId = mapOfAllQueues.get(defaultQueue);
            Boolean breakMe = false;
            for(TriageCriteria__c trcMatched: lstMSERVTriage) {             
                if((trcMatched.Subtype__c==NULL || (trcMatched.Subtype__c==csObj.Subtype__c))
                        && (trcMatched.ProductFamily__c==NULL ||  (trcMatched.ProductFamily__c==csObj.ProductFamily__c))
                        && (trcMatched.Subject__c==NULL ||  ((csObj.Subject).containsIgnoreCase(trcMatched.Subject__c)))
                        && (trcMatched.Type__c==NULL ||  (trcMatched.Type__c==csObj.Type))
                        && (trcMatched.SkillLevel__c==NULL ||  (trcMatched.SkillLevel__c==csObj.SkillLevel__c))
                        && (trcMatched.ProductGroup__c==NULL ||  (trcMatched.ProductGroup__c==csObj.ProductGroup__c))) {
                    csObj.OwnerId = mapOfAllQueues.get(trcMatched.Queue__c);
                    break;
                }
            }           
        }
    }
    //-----------------------------
    // @author: Prachi Bhasin
    // @date: 21 May 2018
    // @param: list of cases, Id of 'Implementation' case record type
    // @description: This method checks if all the implementation cases related to a contract are closed or not
    // @return: Boolean
    //------------------------------
    public static boolean checkIfAllImplementationCasesAreClosed(List<case> lstCase, Id caseRecordTypeId) {
        Boolean updateStatus =true;
        for(Case cas : lstCase) {
            if(cas.RecordTypeId == caseRecordTypeId 
                && !cas.isClosed) { //Will the current one will be updated to DB by now or should get case from map and check
                updateStatus = false;
                break;
                }
        }
        system.debug('updateStatus @1031---'+updateStatus);    
        return updateStatus;
    }
    //-----------------------------
    // @author: Jagadesh Kumar
    // @date: 30 May 2018
    // @param: list of cases, Id of 'Sales Support' case record type
    // @description: SFDC1-8014 This method is used to populate the Case lookup fields
    // @LastModifieddate : 18 July 2018
	// @LastModifieby : Mohit Modi
	// @LastModifieddescription : SFDC1-9031-Commenting this Method as field ContractOwner__c and OpportunityOwner__c is nomore required.
    //------------------------------
    /*
    public static void populateCaseLookUpFields(TriggerParameters tp) {
        Id recordtypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get('Sales Support').getRecordTypeId();
        Set<Id> opptyIdSet = new Set<Id>();
        Set<Id> contractIdSet = new Set<Id>();
        Map<String,Id> emailContactIdMap= new Map<String,Id>();
        Map<Id,String> ownerEmailMap = new Map<Id,String>();
        if(tp.tEvent==TriggerParameters.TriggerEvent.beforeInsert) {
            for (Case c : (List<Case>)tp.newList) {
                if(c.RecordTypeId == recordtypeId && c.Opportunity__c != null && c.OpportunityOwner__c == null) {
                    opptyIdSet.add(c.Opportunity__c);
                }
                if(c.RecordTypeId == recordtypeId && c.Contract__c != null && c.ContractOwner__c == null) {
                    contractIdSet.add(c.Contract__c);
                }
            }
            if(opptyIdSet.size() > 0) {
                for(Opportunity oppty : [SELECT OwnerId,Owner.Email FROM Opportunity WHERE ID IN : opptyIdSet]) {
                    ownerEmailMap.put(oppty.Id, oppty.Owner.Email);
                }
            }
            if(contractIdSet.size() > 0) {
                for(Contract con : [SELECT OwnerId,Owner.Email FROM Contract WHERE ID IN : contractIdSet]) {
                    ownerEmailMap.put(con.Id, con.Owner.Email);                    
                }
            }
            if(ownerEmailMap.size() > 0) {
                for(Contact con : [select Id,email from contact where email in : ownerEmailMap.values()]) {
                    emailContactIdMap.put(con.Email,con.Id);
                }
                //Update the Opportunity owner and Contract Owner
                for (Case c : (List<Case>)tp.newList) {
                    if(c.RecordTypeId == recordtypeId && c.Opportunity__c != null && c.OpportunityOwner__c == null) {
                        c.OpportunityOwner__c = emailContactIdMap.get(ownerEmailMap.get(c.Opportunity__c));
                    }
                    if(c.RecordTypeId == recordtypeId && c.Contract__c != null && c.ContractOwner__c == null) {
                        c.ContractOwner__c = emailContactIdMap.get(ownerEmailMap.get(c.Contract__c));
                    }
                }
            }
        }
    }
    */
    //-----------------------------
    // @author: Jagadesh Kumar
    // @date: 03 July 2018
    // @param: list of cases, 'Implementation' case record type
    // @description: SFDC1-9020 This method is used to validate the Case Account and Case->Contact->Account/Case->Contact->Related Accounts 
    // @LastModifiedBy: Mohit Modi
    // @LastModifiedDate: 01 Aug 2018
    // @LastModifiedReason: SFDC1-9595- Adding Onboarding Case for the Validation with Implementation Case, and updated ContactAndAccountShouldMatch to exclude Onboarding Case.
    //------------------------------
    public static void validateCaseContactAndAccountMatch(TriggerParameters tp) {
        // SFDC1-9712 Ignore the validation rule if logged in user has IgnoreCaseValidationRules permission set
        // Mohit : Added !Test.isRunningTest() for TestClass Failure
		if(GlobalConstants.hasIgnoreValidationPermission && !Test.isRunningTest()) {
            return;
        }
        if(!GlobalConstants.hasImplementationCaseValidated) {
            
            Set<Id> accts = new Set<Id>();
            Map<Id,String> acctTypeMap = new Map<Id,String>();
            Id implementationRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Implementation').getRecordTypeId();
            Id onboardingRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Onboarding').getRecordTypeId();
            if(tp.tEvent==TriggerParameters.TriggerEvent.beforeInsert) {
                for(Case c : (List<Case>)tp.newList) {
                    if(c.RecordTypeId == implementationRecordTypeId || c.RecordTypeId == onboardingRecordTypeId ) {
                        accts.add(c.AccountId);
                    }
                }
                if(accts.size() > 0) {
                    for(Account acc : [SELECT Id,Type FROM Account where Id IN : accts]) {
                        acctTypeMap.put(acc.Id , acc.Type);
                    }
                }
                try {
                    validateCaseContactAndAccount((List<Case>)tp.newList,acctTypeMap);	
                } Catch(DMLException e) {
                    System.debug('Exception:Validation failed while inserting Implementation Case Records, class CaseMethods');
                    ((List<Case>)tp.newList).get(0).addError(e.getMessage());
                }
            }
        }
    }
    //-----------------------------
    // @author: Jagadesh Kumar
    // @date: 03 July 2018
    // @param: list of cases, 'Implementation' case record type
    // @description: SFDC1-9020 This method is used to validate the Case Account and Case->Contact->Account/Case->Contact->Related Accounts 
    //               This method will be called in ContractMethods once OrderManagement Case set Status 'Validated/'
    // 
    // @LastModifiedBy: Sruti Srivastava
    // @LastModifiedDate: 20 July 2018
    // @LastModifiedSprint: Sprint 30
    // @LastModifiedReason: SFDC1-9309- bypassing validation if parent case is an Order Management case
    // @LastModifiedBy: Mohit Modi
    // @LastModifiedDate: 01 Aug 2018
    // @LastModifiedReason: SFDC1-9595- Adding Onboarding Case for the Validation with Implementation Case, and updated ContactAndAccountShouldMatch to exclude Onboarding Case.
    //------------------------------
    public static void validateCaseContactAndAccount(List<Case> implementationCaseList,Map<Id,String> acctTypeMap) {
        Set<Id> contactIds = new Set<Id>();
        Set<Id> parentCaseIds = new Set<Id>();
        Id implementationRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Implementation').getRecordTypeId();
        Id caseOMRecordTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get('Order Management').getRecordTypeId();
        Id onboardingRecordTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get('Onboarding').getRecordTypeId();

        for(Case c : implementationCaseList) {
            if((c.RecordTypeId == implementationRecordTypeId || c.RecordTypeId == onboardingRecordTypeId ) && c.ContactId != null) {
                contactIds.add(c.ContactId);
            }
            if(c.ParentId != null) {
                parentCaseIds.add(c.ParentId);
            }
        }
        Map<Id, Case> mapOMCases = new Map<Id, Case>();
        if(!parentCaseIds.isEmpty()) {
            mapOMCases.putAll([Select Id, RecordTypeId From Case where ID IN: parentCaseIds AND RecordTypeId =: caseOMRecordTypeId]);
        }
        
        if(contactIds.size() > 0) {
            Map<Id,Contact> contactMap = new Map<Id,Contact>([SELECT Id,AccountId, 
                                                                     (SELECT Id,AccountId,Account.Name FROM AccountContactRelations) 
                                                                     FROM Contact WHERE Id in :contactIds]);
            for(Case c : implementationCaseList) {
                Boolean acctConMatch = false;
                //bypassing validation if parent case is an Order Management case
                if(c.ContactId != null && contactMap.get(c.ContactId) != null && 
                                    ( c.RecordTypeId == implementationRecordTypeId || c.RecordTypeId == onboardingRecordTypeId )
                                    && (c.ParentId == null ||
                                    (c.ParentId != null && (mapOMCases == null || 
                                                            (mapOMCases != null &&  !mapOMCases.containsKey(c.ParentId)))))) {
                    Contact con = contactMap.get(c.ContactId);
                    if(c.AccountId == con.AccountId) {
                        System.debug('*** case Account and Contact Account match found ***');
                        acctConMatch = true;
                    } else {//Check for Related accounts
                        List<AccountContactRelation> actConRel = con.AccountContactRelations;
                        for(AccountContactRelation rel : actConRel) {
                            if(c.AccountId == rel.AccountId) {
                                System.debug('*** case Account and Contact Related Account match found ***');
                                acctConMatch = true;    
                            }
                        }
                    }
                    if(!acctConMatch && acctTypeMap.get(c.AccountId) != 'Place Holder - Unknown Account' && acctTypeMap.get(c.AccountId) != 'Place Holder - General Service Account') { //No matches found then don't create Implementation case type.
                        System.debug('Exception:Validation failed for inserting Implementation Case Records, class CaseMethods');
                        //Throw the exception to rollback the transaction in both case and Contract records and show the validation message.
                        throw new DMLException(System.Label.CaseContactAndAccountMatchMSG);
                    }
                }
            }
        }
    }
    //-----------------------------
    // @author: Prachi Bhasin
    // @date: 12 July 2018
    // @param: TriggerParameters tp
    // @description: SFDC1-8945 Populating fields on OM/Delivery Helpdesk case when created from order form
    //------------------------------
    public static void populateOMDeliveryHelpDeskCaseFields(TriggerParameters tp) {
        Id recTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Order Management/Delivery Help Desk').getRecordTypeId();
        String loggedInUserEmail = UserInfo.getUserEmail();
        
        List<Id> contractIds = new List<Id>();
        if(tp.tEvent==TriggerParameters.TriggerEvent.beforeInsert) {
            for (Case c : (List<Case>)tp.newList) {
                if(String.valueOf(c.RecordTypeId).substring(0,15) == String.valueOf(recTypeId).substring(0,15)) {
                    contractIds.add(c.Contract__c);
                }                   
            }
            if(contractIds!=NULL && contractIds.size()>0) {
                List<ContractContactRole> lstPrimaryContacts = new List<ContractContactRole>([Select id,contactid,ContractId  from ContractContactRole where ContractId IN : contractIds AND isprimary =:true]);
                Map<Id,Id> mapContractIdPrimaryContactId = new Map<Id,Id>();
                for(ContractContactRole contactRole:lstPrimaryContacts) {
                    mapContractIdPrimaryContactId.put(contactRole.ContractId,contactRole.contactid);            
                }
                Contact loggedInContact = UtilityClass.getContactByEmail(loggedInUserEmail);
                for (Case c : (List<Case>)tp.newList) {           
                    if(c.RecordTypeId == recTypeId) {
                        c.ContactId = loggedInContact!=NULL?loggedInContact.id:NULL;
                        c.AccountId = c.ContactId!=NULL?loggedInContact.AccountId:NULL;
                        c.AccountName__c = 'IHS Markit';
                        if(mapContractIdPrimaryContactId.containsKey(c.Contract__c)) {
                            c.ContactReference__c = mapContractIdPrimaryContactId.get(c.Contract__c);
                        }
                    }
                }
            }
        }
    }
}