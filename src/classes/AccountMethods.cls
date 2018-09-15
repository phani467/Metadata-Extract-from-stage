//*********************************************************************************************************************
// @author Paras Dhingra adapted from Tran's code
// @date 26th June 2017
// @description SFDC1-402 Class created to add common methods to be used by Account trigger handler classes
// @Last Modified By : Prachi Bhasin
// @Last Modified Date: 15 March 2018
// @Last Modified Description: SFDC1-7199 - Commenting code related to NAICS hierarchy (updateNAICSHierarchyLookup method)
// @Last Modified By : Tran-Vu Tran
// @Last Modified Date : 12nd April 2018
// @Last Modified Description : SFDC1-7718 add method to update child accounts' Compliance Restriction value from Parent account if Exception is not checked
// @Last Modified By : Harshit Singhal
// @Last Modified Date : 07 Jun 2018
// @Last Modified Description : SFDC1-8537 convert Account process builder flows to Trigger
//*********************************************************************************************************************

public class AccountMethods {
    
    /**
     * @author Tran-Vu Tran
     * @date 30th August 2017
     * @description SFDC1-2235 when a new account is inserted,
     * 1. If it was created using a Case Action (have a Source Case and a AccountCountry lookup value) then
     *  populate Account BillingCountry picklist value from the Account's Country lookup value
     * 2. If it was created using a normal method (manual/data migration) then
     *  populate Account's Country lookup value from Account BillingCountry picklist value
    */ 
    // lastModifiedby : Mohit Modi , 23 May2018, Commenting as This Method is not required, replaced by AccountMethods.updateCountryLookup
    // Also, Called from beforeInsert and beforeUpdate trigger Only, Removed from AfterInsert and afterUpdate
    /*
    public static void updateAccountCountry(TriggerParameters tp) {
        
        if (tp.tEvent == TriggerParameters.TriggerEvent.afterInsert)
        {
            // Get all accounts in this trigger
            List<Account> accounts =
            [SELECT Id, Name, SourceCase__c, BillingCountry, BillingCountryCode, AccountCountry__c FROM Account
             WHERE Id IN :tp.newList];
        
            // Processing accounts in this trigger
            List<Account> accountsToUpdate = new List<Account>();

            for (Account a:accounts) {
                // If SourceCase has value and AccountCountry lookup has value (account was created using a Case Action)
                // then assign the BillingCountry picklist using value from CountryLookup field

                // System.debug(tp.tEvent + ' for Account=' + a.Name);
                if (a.SourceCase__c != null && a.AccountCountry__c != null) {
                    // System.debug('AccountCountryCode=' + a.AccountCountryCode__c);
                    Country__c country = UtilityClass.getCountryById(a.AccountCountry__c);
                    // System.debug('Country =' + country);
                    // System.debug('a.AccountCountry =' + a.AccountCountry__c);
                    if (country != null) {
                        a.BillingCountryCode = country.CountryCode__c;
                    }
                }
                else { // account is created using data migration or manual action
                    // Country__c country = UtilityClass.getCountry(a.BillingCountry);

                    //2017-09-13 Tran-Vu Tran: change the logic to get Country by Country Code
                    Country__c country = UtilityClass.getCountryByIsoCode(a.BillingCountryCode);
                    
                    if (country != null) {
                        a.AccountCountry__c = country.Id;
                    }
                }
                
                accountsToUpdate.add(a);
            }
            
            update accountsToUpdate;
        }
    } */ 
    
    /**
     * @author Paras Dhingra
     * @date 26th June 2017
     * @description SFDC1-402 when the Account's is updated,
     * check if BillingCountry value changes then update Account Country lookup using 
     * Account BillingCountry picklist value
     * lastmodifiedby : Moit Modi, Removed form AfterInsert and AfterUpdate, Replacing the updateAccountCountry Method
     * Also, this will be called from BeforeInsert and BeforeUpdate
     */
    public static void updateCountryLookup(TriggerParameters tp) {
        
        //As standard State and Country picklists are enabled,
        //BillingCountry's new value is available in after triggers only
        if (tp.tEvent == TriggerParameters.TriggerEvent.beforeInsert || tp.tEvent == TriggerParameters.TriggerEvent.beforeUpdate) {
        
            for (Account a:(List<Account>)tp.newList) {
                
                // Getting pre-update version of the account object
                Account oldAccount;
                if (tp.oldMap != null && tp.oldMap.get(a.Id) != null) {
                    oldAccount = (Account)tp.oldMap.get(a.Id);
                }
                
                // If BillingCountry value changes
                if (a.SourceCase__c == null && (tp.oldMap == null || tp.oldMap.get(a.Id) == null
                    || oldAccount.BillingCountryCode != a.BillingCountryCode)) {
                    System.debug('inside New Direct Account Create');
                    //2017-09-13 Tran-Vu Tran: change the logic to get Country by Country Code
                    // Get the country with matching name from country map
					Country__c country = UtilityClass.getCountryByIsoCode(a.BillingCountryCode);
                    if (country != null) {
                        a.AccountCountry__c = country.Id;
                    }
                }
                /**
                 * @author Tran-Vu Tran
                 * @date 30th August 2017
                 * @description SFDC1-2235 when a new account is inserted,
                 * 1. If it was created using a Case Action (have a Source Case and a AccountCountry lookup value) then
                 *  populate Account BillingCountry picklist value from the Account's Country lookup value
                 * 2. If it was created using a normal method (manual/data migration) then
                 *  populate Account's Country lookup value from Account BillingCountry picklist value
                 * @Lastmodifiedby : Mohit Modi, Added the extra condition from method updateAccountCountry , If Account Created from Case QuickAction, populate Account Country based on Account SourceCase.
                */ 
                else if (tp.oldMap == null && a.SourceCase__c != null && a.AccountCountry__c != null) {
                    System.debug('inside quick Action Account Create');
                    Country__c country = UtilityClass.getCountryById(a.AccountCountry__c);
                    if (country != null) {
                        a.BillingCountryCode = country.CountryCode__c;
                    }
                    /*
                     * @author: Mohit Modi
                     * @date : 06 July 2018
                     * @description : SFDC1-9133 when a new account is inserted using Case QuickAction,Populate StateCode Picklist using CustomField 'State__c' field which is coming from Case quick action.
                     * If Correct State either StateCode or StateName is provided, Proceed and update the Billing State, else show Error.
                    */
                    if (a.State__c != NULL) {
                        String stateValue = UtilityClass.validateAndGetStateNameValue(a.State__c);
                        if (stateValue != '' && stateValue != NULL) {
                            a.BillingState = stateValue;
                        }
                        else {
                            a.addError('Unable to find a matching State/Province, please modify the State/Province text value (under Additional Information section on the Case "DETAILS" tab) to the correct Name or Code then try again.');
                        }
                    }
                }
                //If Account Created from Case QuickAction and if after Account.BillingCountryCode is Changed
                else if (a.SourceCase__c != null && (tp.oldMap == null || tp.oldMap.get(a.Id) == null
                    || oldAccount.BillingCountryCode != a.BillingCountryCode)) {
                    System.debug('inside update Direct Account Create');
                    //2017-09-13 Tran-Vu Tran: change the logic to get Country by Country Code
                    Country__c country = UtilityClass.getCountryByIsoCode(a.BillingCountryCode);

                    if (country != null) {
                        a.AccountCountry__c = country.Id;
                    }
                }
            }
        }
    }
    /**
     * @author Paras Dhingra
     * @date 05th Jul 2017
     * @description SFDC1-508 Update the NAICS hierarchy lookup based on NAICS code
     */
     public static void updateNAICSHierarchyLookup(TriggerParameters tp) {
        /* 
         //create a set of first 4 digits of NAICS codes
         Set<String>setNAICS4 = new Set<String>();
         
         //traverse trigger.new to populate set
         
         for(Account acc :(List<Account>)tp.newList) {
             if(acc.NaicsCode!=null) {
                 setNAICS4.add(acc.NaicsCode.subString(0,4));
             }
             
         }
         
         //query NAICS hierarchy object
         List<NAICSHierarchy__c> lstNAICSHierarchy = [Select id, Name from NAICSHierarchy__c where name IN: setNAICS4];
         
         //null and size check for hierarchy list
         if(lstNAICSHierarchy!=null && !lstNAICSHierarchy.isEmpty()) {
            
            //create a map of NAICS 4 digits field and it's id
            Map<String,Id> mapNAICS = new Map<String,Id>();
            
            //populate the map
            for(NAICSHierarchy__c naics : lstNAICSHierarchy) {
                mapNAICS.put(naics.name, naics.id);
            }
            
            //populate NAICS lookup on account
            for(Account acc: (List<Account>)tp.newList) {
                if(acc.NaicsCode!=null && mapNAICS.containsKey(acc.NaicsCode.subString(0,4))) {
                    acc.NAICSHierarchy__c = mapNAICS.get(acc.NaicsCode.subString(0,4));
                }
            }
         }
         
     */    
     }
     /**
      * @author Paras Dhingra
      * @date 07th Jul 2017
      * @description SFDC1-413 Update GAM on all open opportunities whenever it is update on opportunity
      */ 
      public static void updateGAMOnOpenOppys(TriggerParameters tp) {
          //create a set of accounts for which GAM is updated
          List<Id> accountsGAMUpdated = new List<Id>();
          
          for(Account acc: (List<Account>)tp.newList) {
              
              Account oldAccount = (Account)tp.oldMap.get(acc.Id);
              
              //check if GAM is changed on account
              if(acc.GlobalAccountManager__c <> oldAccount.GlobalAccountManager__c) {
                  accountsGAMUpdated.add(acc.Id);
              }
          }
          
        if(!accountsGAMUpdated.isempty()) {
              //query all related open opportunities
              List<Opportunity> openOppys = [Select id, GAM__c, AccountId from Opportunity where AccountId IN:accountsGAMUpdated and IsClosed=false];
              
              if(openOppys!=null && !openOppys.isEmpty()) {
                  //traverse and update open opportunities
                  for(Opportunity opp : openOppys) {
                      
                      Account newAccount = (Account)tp.newMap.get(opp.AccountId);
                      opp.GAM__c = newAccount.GlobalAccountManager__c;
                  }
                  //update the opportunities
                  update openOppys;
              }
        } 
      }
      
      /**
      * @author Paras Dhingra
      * @date 25th Jul 2017
      * @description SFDC1-1752 Update LegacyId object once an Account is created/Updated
      */
      public static void updateLegacyIdObject(TriggerParameters tp) {
        /* 2017-09-19 Tran-Vu Tran comment out because this is no longer needed per SFDC1-4517 
          //traverse to check if the ID fields are created or updated
          List<Id> accountToBeUpdated = new List<Id>();
          
          //if trigger is insert then all account should have corresponding legacyId object records
          if(tp.tEvent == TriggerParameters.TriggerEvent.afterInsert) { 
              
              createUpdateLegacyIdObject((Map<Id,Account>)tp.newMap);
          }
        */
      }
      
      
      /**
      * @author Paras Dhingra
      * @date 25th Jul 2017
      * @description SFDC1-1752 create or update related legacy object records for a given list of accounts
      * @param List<Account>
      * @return void
      */
      public static void createUpdateLegacyIdObject(Map<Id,Account> mapAccounts) {
        /* 2017-09-19 Tran-Vu Tran comment out because this is no longer needed per SFDC1-4517 
          List<LegacyAccountID__c> lstToBeInserted = new List<LegacyAccountID__c>();
          //null check for list of accounts
          if(mapAccounts!=null && !mapAccounts.isEmpty()) {
             
             for(Account acc : mapAccounts.values()) {
                 
                 if(acc.MarkitSFDC__c!=null) {
                     LegacyAccountID__c lai = new LegacyAccountID__c();
                     lai.PKIDAccount__c = acc.PK__c;
                     lai.Name = acc.MarkitSFDC__c;
                     lai.System__c = 'Markit_SFDC';
                     lai.Account__c = acc.Id;
                     lstToBeInserted.add(lai);
                     
                 }
                 if(acc.IHSCRMGUID__c!=null) {
                     LegacyAccountID__c lai = new LegacyAccountID__c();
                     lai.PKIDAccount__c = acc.PK__c;
                     lai.Name = acc.IHSCRMGUID__c;
                     lai.System__c = 'IHS_MSCRM';
                     lai.Account__c = acc.Id;
                     lstToBeInserted.add(lai);
                 }
             }
             if(lstToBeInserted!=null && !lstToBeInserted.isEmpty()) {
                 insert lstToBeInserted;
             }
          }
        */
      }
      
      /**
      * @author Paras Dhingra
      * @date 31st Jul 2017
      * @description SFDC1-1168 update account owner team member role when account ownership changes
      * @param TriggerParameters
      * @return void
      * @companyname IHS Markit
      */
      public static void updateAccountTeamMemberRole(TriggerParameters tp) {
          
          try {
                //This method will fire afterInsert and afterUpdate
                
               
                
                if(tp.tEvent == TriggerParameters.TriggerEvent.afterInsert) {
                //add account owner team member role for all of the accounts
                    Map<Id,Account> mapNewAccount= (Map<Id,Account>)tp.newMap;
                    addAccountTeamOwner(mapNewAccount);
                }
                if(tp.tEvent == TriggerParameters.TriggerEvent.afterUpdate) {
                    //delete and insert accountTeamMember only if owner is changed
                    Map<Id,Account> mapAccountOwnerUpdated = new Map<Id,Account>();
                    for(Account acc: (List<Account>)tp.newList) {
                      //check if the owner is changed
                      Account oldAccount = (Account)tp.oldMap.get(acc.Id);
                      if(acc.ownerId <> oldAccount.ownerId) {
                          mapAccountOwnerUpdated.put(acc.Id,acc);
                      }
                    }
                    if(!mapAccountOwnerUpdated.isEmpty()) {
                        List<AccountTeamMember> lstDeleteATM = [Select id, UserId, accountId from AccountTeamMember 
                                                                where accountId IN:mapAccountOwnerUpdated.keySet() AND TeamMemberRole ='Account Owner'];
                        if(lstDeleteATM!=null && !lstDeleteATM.isEmpty()) {
                            //delete existing account owner
                                        Database.DeleteResult[] lstSR = Database.delete(lstDeleteATM,false);
                            //show error message in case insert fails
                            for(Integer i=0; i<lstDeleteATM.size(); i++) {
                                Database.DeleteResult ddr = lstSR[i];
                                if(!ddr.isSuccess()) {
                                for(Database.Error err: ddr.getErrors()) {
                                        tp.newMap.get(lstDeleteATM[i].accountId).addError(System.Label.ErrorAccountTeamMember + err.getMessage());
                                    }
                                }
                            }
                        }
                        //insert new AccountTeamMember
                        addAccountTeamOwner(mapAccountOwnerUpdated);
                    }
                }
                
            } catch(Exception ex) {
                //this will happen if any exception apart from DML exception has occurred
                UtilityClass.createApexLogRecord(ex, 'AccountMethods', 'updateAccountTeamMemberRole');
              
        }
         
      }
      /**
      * @author Paras Dhingra
      * @date 31st Jul 2017
      * @description SFDC1-1168 insert AccountTeamMemberRole for accounts
      * @param TriggerParameters
      * @return void
      * @companyname IHS Markit
      */
      
      public static void addAccountTeamOwner(Map<Id,Account> mapAccountInsertATM) {
          
        String accountTeamRole = 'Account Owner';
        List<AccountTeamMember> lstInsertATM = new List<AccountTeamMember>();
        for(Account acc : mapAccountInsertATM.values() ) {
            lstInsertATM.add(new AccountTeamMember(AccountId = acc.Id,TeamMemberRole = accountTeamRole,UserId = acc.OwnerId));
        }
        if(lstInsertATM!=null && !lstInsertATM.isEmpty()) {
            
            Database.SaveResult[] lstSR = Database.insert(lstInsertATM,false);
            //show error message in case insert fails
            for(Integer i=0; i<lstInsertATM.size(); i++) {
                Database.SaveResult dsr = lstSR[i];
                if(!dsr.isSuccess()) {
                for(Database.Error err: dsr.getErrors()) {
                        mapAccountInsertATM.get(lstInsertATM[i].accountId).addError(System.Label.ErrorAccountTeamMember + err.getMessage());
                    }
                }
            }
        }
      }
    
//-----------------------------
// @author: Uttam Arya
// @date: 24 Aug 2017
// @param: TriggerParameters tp
// @description: SFDC1-2103 Whenever an account is created, whether through an integration/data migration or manually created by a Data Governance user an "Additional Account Fields" 
//                          record belonging to the account is automatically created and a link to the record is populated in the "Additional Account Fields" field on the account record. 
//                          This field should not be editable by anyone excluding the System Admin or Data Governance.
//                          This function create an Additional Fields lookup related to an Account.
// 
// @return: None
//------------------------------
    public static void setAccountAdditionalFieldsObject(TriggerParameters tp) {
    
        try {
        
            // List of Additional Account Fields thats needs to be inserted 
            List<AdditionalAccountFields__c> additionalAccountFieldsToInsert = new List<AdditionalAccountFields__c>();
            
            // Map of old values and new values
            Map<Id,Account> mapNewAccount = (Map<Id,Account>) tp.newMap;
            Map<Id,Account> mapOldAccount = (Map<Id,Account>) tp.oldMap;
            
            for(Account newAccount: mapNewAccount.values()) {
                if(tp.tEvent == TriggerParameters.TriggerEvent.afterInsert) {
                    if(newAccount.AdditionalAccountFields__c == null) {
                        String accountAdditionalFieldsName = ('Additional Fields - ' + newAccount.Name).left(80);
                        additionalAccountFieldsToInsert.add(new AdditionalAccountFields__c(Name = accountAdditionalFieldsName, AccountReference__c = newAccount.Id,
                        LegacyID__c = newAccount.LegacyID__c, LegacyIDUnique__c = newAccount.LegacyIDUnique__c, LegacySystem__c = newAccount.LegacySystem__c));  
                    }
                }
            }
            
            // insert if list has any records
            if(additionalAccountFieldsToInsert != null && additionalAccountFieldsToInsert.size() > 0) {
                insert additionalAccountFieldsToInsert;
            }
            
        } catch(Exception ex) {
                //this will happen if any exception apart from DML exception has occurred
                UtilityClass.createApexLogRecord(ex, 'AccountMethods', 'setAccountAdditionalFieldsObject');
              
        }
    }

//-----------------------------
// @author: Uttam Arya
// @date: 24 Aug 2017
// @param: TriggerParameters tp
// @description: SFDC1-2103 Whenever an account is created, whether through an integration/data migration or manually created by a Data Governance user an "Additional Account Fields" 
//                          record belonging to the account is automatically created and a link to the record is populated in the "Additional Account Fields" field on the account record. 
//                          This field should not be editable by anyone excluding the System Admin or Data Governance.
//                          This function change Account Additional Fields Object Name When Account Name Changes
// @modified by : Paras Dhingra
// @modified date: 07-09-2018
// @description: Modified to accomodate migration changes and sync legacy fields with additional account fields 
// @return: None
//------------------------------
    public static void changeAccountAdditionalFieldsObjectNameWhenAccountFieldChanges(TriggerParameters tp) {
    
        try {
        
            // List of Additional Account Fields thats needs to be inserted 
            List<AdditionalAccountFields__c> additionalAccountFieldsToUpdate = new List<AdditionalAccountFields__c>();
            
            // Map of old values and new values
            Map<Id,Account> mapNewAccount = (Map<Id,Account>) tp.newMap;
            Map<Id,Account> mapOldAccount = (Map<Id,Account>) tp.oldMap;
            
            for(Account newAccount: mapNewAccount.values()) {
                if(tp.tEvent == TriggerParameters.TriggerEvent.afterUpdate) {
                    //check if name or legacy fields are updated on account
                    Account oldAccount = mapOldAccount.get(newAccount.Id);
                    if(newAccount.AdditionalAccountFields__c != null && (newAccount.Name != oldAccount.Name || newAccount.LegacyID__c != oldAccount.LegacyID__c
                                                                        || newAccount.LegacyIDUnique__c != oldAccount.LegacyIDUnique__c|| newAccount.LegacySystem__c != oldAccount.LegacySystem__c)) {
                        String accountAdditionalFieldsName = ('Additional Fields - ' + newAccount.Name).left(80);                                                    
                        additionalAccountFieldsToUpdate.add(new AdditionalAccountFields__c(Name = accountAdditionalFieldsName, Id = newAccount.AdditionalAccountFields__c,
                                                              LegacyID__c = newAccount.LegacyID__c, LegacyIDUnique__c = newAccount.LegacyIDUnique__c, LegacySystem__c = newAccount.LegacySystem__c));  
                    }
                }
            }
            
            // insert if list has any records
            if(additionalAccountFieldsToUpdate != null && additionalAccountFieldsToUpdate.size() > 0) {
                update additionalAccountFieldsToUpdate;
            }
            
        } catch(Exception ex) {
                //this will happen if any exception apart from DML exception has occurred
                UtilityClass.createApexLogRecord(ex, 'AccountMethods', 'changeAccountAdditionalFieldsObjectNameWhenAccountNameChanges');
              
        }
    }
    
//-----------------------------
// @author: Uttam Arya
// @date: 24 Aug 2017
// @param: TriggerParameters tp
// @description: SFDC1-2103 Whenever an account is created, whether through an integration/data migration or manually created by a Data Governance user an "Additional Account Fields" 
//                          record belonging to the account is automatically created and a link to the record is populated in the "Additional Account Fields" field on the account record. 
//                          This field should not be editable by anyone excluding the System Admin or Data Governance.
//                          This function change delete Account Additional Fields record before deleting an account
// 
// @return: None
//------------------------------
    public static void deleteAccountAdditionalFieldsRecordWhenAccountGetsDeleted(TriggerParameters tp) {
    
        try {
        
            // List of Additional Account Fields thats needs to be inserted 
            List<AdditionalAccountFields__c> additionalAccountFieldsToDelete = new List<AdditionalAccountFields__c>();
            
            // Map of old values 
            Map<Id,Account> mapOldAccount = (Map<Id,Account>) tp.oldMap;
            
            for(Account oldAccount: mapOldAccount.values()) {
                if(tp.tEvent == TriggerParameters.TriggerEvent.beforeDelete) {
                    additionalAccountFieldsToDelete.add(new AdditionalAccountFields__c(Id = oldAccount.AdditionalAccountFields__c));  
                }
            }
            
            // insert if list has any records
            if(additionalAccountFieldsToDelete != null && additionalAccountFieldsToDelete.size() > 0) {
                delete additionalAccountFieldsToDelete;
            }
            
        } catch(Exception ex) {
                //this will happen if any exception apart from DML exception has occurred
                UtilityClass.createApexLogRecord(ex, 'AccountMethods', 'changeAccountAdditionalFieldsObjectNameWhenAccountNameChanges');
              
        }
    }

/*
    // 20-April-2016 comment out codes - will be replaced by formula fields
    //***************************************
    // @author: Tran-Vu Tran
    // @date: 06 April 2018
    // @param: TriggerParameters tp
    // @description: SFDC1-7718 if parent account has a Compliance Restriction value, get that value from the parent
    //***************************************
    public static void getComplianceRestrictionFromParent(TriggerParameters tp) {

        if (tp.tEvent == TriggerParameters.TriggerEvent.beforeInsert ||
            tp.tEvent == TriggerParameters.TriggerEvent.beforeUpdate) {
                
                System.debug('Executing getComplianceRestrictionFromParent');
                List <Account> newList = tp.newList;
                
                Set <Id> parentAccountIds = new Set <Id>();
                Set <String> globalUltimateCompanyIDs = new Set <String>();
                
                // first, get all the parent account IDs and Global Ultimate Company IDs
                for (Account a : newList) {
                    parentAccountIds.add(a.ParentId);
                    globalUltimateCompanyIDs.add(a.GlobalUltimateCompanyID__c);
                }
                
                // to retrieve these parent accounts from database
                Map <Id, Account> parentAccounts = new Map <Id, Account> (
                    [select Id, Name, ParentId, CorporateRestrictionException__c, ComplianceRestrictions__c
                     From Account where Id in : parentAccountIds or GlobalUltimateCompanyID__c in : globalUltimateCompanyIDs]);
                
                for (Account acct : newList) {
                    
                    Account oldAcct = null;
                    if (tp.tEvent == TriggerParameters.TriggerEvent.beforeUpdate) {
                        oldAcct = (Account) tp.oldMap.get(acct.id);
                    }
                    
                    if (oldAcct != null &&
                        (oldAcct.ParentId != acct.ParentId ||  oldAcct.ParentCompanyID__c != acct.ParentCompanyID__c
                         || (oldAcct.ComplianceRestrictions__c != acct.ComplianceRestrictions__c)
                         || (oldAcct.CorporateRestrictionException__c != acct.CorporateRestrictionException__c))
                       ) {
                           acct.RecalculateRestriction__c = true;
                       }
     
                    if (acct.RecalculateRestriction__c == false) {
                        continue; // don't need to recalculate from the parent account, just update
                    }
                    else {
                        acct.RecalculateRestriction__c = false; // reset this flag so it won't be recalculated again
                    }
                    
                    if (acct.RecalculateRestriction__c == true) {
                        acct.RecalculateRestriction__c = false; // reset this flag so it won't be recalculated again
                    }
                    
                    System.debug('Updating Account: ' + acct.Name);
                    if (acct.CorporateRestrictionException__c == false) {
                        
                        Boolean found = false;
                        Account currentAcct = acct;
                        Account parentAcct = null;
                        
                        while (currentAcct.ParentId != null && !found) {
                                
                            // try to get parent account from the pre-loaded map to reduce number of SOQL queries
                            parentAcct = parentAccounts.get(currentAcct.ParentId);

                            if (parentAcct != null) {
                                // if parent account exists and does not have restriction exception
                                if (parentAcct.CorporateRestrictionException__c == false) {

                                    found = true;
                                    System.debug('Found Parent account for Compliance Restriction value: Account=' + parentAcct.Name);
                                    
                                    // copying parent account's Compliance Restriction value to this account
                                    acct.ComplianceRestrictions__c = parentAcct.ComplianceRestrictions__c;

                                    System.debug('Updating Compliance Restriction: Account=' + acct.Name + ', Restriction="' + acct.ComplianceRestrictions__c + '"');
                                    
                                } else {
                                    // go up to the next level to get the Compliance Restriction value
                                    currentAcct = parentAcct;
                                    System.debug('Skipping Parent account due to Exception set: Account=' + parentAcct.Name);
                                }
                            }
                        }
                    }
                    
                    // before existing, updating its own record in the Map so the children can get new value when they need to do a lookup
                    if (parentAccounts.containsKey(acct.Id)) {
                        parentAccounts.put(acct.Id, acct);
                    }
                    
                    // removing this account to clean up the global waiting list
                    System.debug('GlobalVariables.AccountsWaitingForUpdate: ' + GlobalVariables.AccountsWaitingForUpdate);
                    System.debug('Removing account from GlobalVariables.AccountsWaitingForUpdate: Account=' + acct.Name + ', Id=' + acct.Id);
                    GlobalVariables.AccountsWaitingForUpdate.remove(acct.Id);
                    System.debug('GlobalVariables.AccountsWaitingForUpdate: ' + GlobalVariables.AccountsWaitingForUpdate);
                }
        }
    }
    

    //***************************************
    // @author: Tran-Vu Tran
    // @date: 06 April 2018
    // @param: TriggerParameters tp
    // @description: SFDC1-7718 ensure that all child accounts' Compliance Restriction value will get updated if Exception is not checked
    //***************************************
    public static void updateChildAccountsComplianceRestriction(TriggerParameters tp) {
        
        System.debug('Executing updateChildAccountsComplianceRestriction');
        System.debug('GlobalVariables.AccountsWaitingForUpdate: ' + GlobalVariables.AccountsWaitingForUpdate);

        List <Account> accountsToUpdate = new List <Account>();
        
        if (tp.tEvent == TriggerParameters.TriggerEvent.afterUpdate) {

            List <Account> newList = tp.newList;
            for (Account acct : newList) {
                
                System.debug('My Name: ' + acct.Name);
                System.debug('My Exception: ' + acct.CorporateRestrictionException__c);
                System.debug('My Restriction: ' + acct.ComplianceRestrictions__c);

                // if this account is already in the list (meaning itself is a child account)
                if (GlobalVariables.AccountsWaitingForUpdate.contains(acct.Id)) {
                    GlobalVariables.AccountsWaitingForUpdate.remove(acct.Id); // remove it from the list
                    System.debug('Skipping child accounts for: Account=' + acct.Name);
                    System.debug('GlobalVariables.AccountsWaitingForUpdate: ' + GlobalVariables.AccountsWaitingForUpdate);
                    continue; // skip if all of its children to avoid an the same hierarchy being processed and updated multiple times
                }
                
                Account oldAcct = null;
                if (tp.tEvent == TriggerParameters.TriggerEvent.afterUpdate) {
                    oldAcct = (Account) tp.oldMap.get(acct.id);
                }
                
                // if Compliance Restriction value changed
                if (oldAcct != null && oldAcct.ComplianceRestrictions__c != acct.ComplianceRestrictions__c) {
                    
                    //if this account's Exception box was not checked, 
                    //if (acct.CorporateRestrictionException__c == false) {

                    // cascade Compliance Restriction value downstream
                    if (true) {
                        
                        // get the list of all child accounts
                        List<Account> childAccounts = [select Id, Name, ParentId, CorporateRestrictionException__c, ComplianceRestrictions__c
                                                       From Account where ParentId =: acct.Id];
                        
                        List<Account> accountsToProcess = childAccounts;
                        
                        while (accountsToProcess != null && accountsToProcess.size() > 0) {
                            
                            List<Account> grandchildrenAccounts = new List<Account>();
                        
                            for (Account childAccount : accountsToProcess) {
                                
                                System.debug('Child account Name: ' + childAccount.Name);
                                System.debug('Child account Exception: ' + childAccount.CorporateRestrictionException__c);
                                System.debug('Child account Restriction: ' + childAccount.ComplianceRestrictions__c);

                                // first, see if the child account's Exception box was not checked
                                // and its Compliance Restriction value is different to this one
                                if (childAccount.CorporateRestrictionException__c == false
                                    && childAccount.ComplianceRestrictions__c != acct.ComplianceRestrictions__c) {
                                        
                                        // copy this account's Compliance Restriction value to the child account
                                        childAccount.ComplianceRestrictions__c = acct.ComplianceRestrictions__c;
                                        childAccount.RecalculateRestriction__c = false; // set this to false so we don't have to recalculate value for the child account
                                        
                                        System.debug('Adding child account to Compliance Restrictions update list: ' + childAccount.Name);
                                        
                                        // add the child account to the list of accounts to be updated after this account's updating is completed
                                        accountsToUpdate.add(childAccount);
                                        
                                        // also add the child Account to the global list if it's not already in there, so it won't be updated again in the same run
                                        System.debug('Adding account to GlobalVariables.AccountsWaitingForUpdate: ' + childAccount.Id);
                                        GlobalVariables.AccountsWaitingForUpdate.add(childAccount.id);
                                        //System.debug('GlobalVariables.AccountsWaitingForUpdate: ' + GlobalVariables.AccountsWaitingForUpdate);
                                        
                                    } else {
                                        System.debug('Skipping child account due to exception or no change: ' + childAccount.Name);
                                    }
                                
                                // get the list of new grandchildren accounts
                                List<Account> newGrandchildren = [select Id, Name, ParentId, CorporateRestrictionException__c, ComplianceRestrictions__c
                                                                  From Account where ParentId =: childAccount.Id];
                                
                                // then add all of them to the grand children list
                                grandchildrenAccounts.addAll(newGrandchildren);
                            }
                            
                            // after all children accounts of one level have been processed, move on to the next level
                            accountsToProcess = grandChildrenAccounts;
                            System.debug('Adding children accounts to be processed: ' + accountsToProcess);
                        }
                    }
                }
            }
            
            update accountsToUpdate;
        }
        //System.debug('GlobalVariables.AccountsWaitingForUpdate: ' + GlobalVariables.AccountsWaitingForUpdate);
    }
    
*/    
    
    //***************************************
    // @author Uttam Arya
    // @date: unknown
    // @param: Set <String> countryMetricKeys
    // @description Migrated from Markit legacy AccountMethods
    // @return: None
    // @updated: SFDC1-7592 migrated from Markit legacy codes
    // @updateBy: Tran-Vu Tran on 30 March 2018
    //***************************************

    public static void recalculateAccountRankings(Set <String> countryMetricKeys) {
        
        List <AccountRanking__c> accountRRToUpdate = new list <AccountRanking__c>();   
        
        list <AccountRanking__c> accRRList = 
            [Select  id, Value__c, Rank__c, MetricsKey__c 
             from    AccountRanking__c 
             where   Value__c != null and MetricsKey__c in : countryMetricKeys
             order by MetricsKey__c asc, Value__c desc];
        
        String initialKey = '';
        Integer j = 1;
        for (Integer i= 0 ; i < accRRList.size() ; i++ ) {
            
            //System.debug('@@@@@@UA i=' + i);
            //System.debug('@@@@@@UA initialKey=' + initialKey);
            
            if (initialKey != accRRList[i].MetricsKey__c) {
                //System.debug('@@@@@@UA accRRList[i]=' + accRRList[i]);
                initialKey = accRRList[i].MetricsKey__c;
                //System.debug('@@@@@@UA assigning accRRList[i].MetricsKey__c to initialKey=' + initialKey);
                j = 1;
                //System.debug('@@@@@@UA resetting (j)=' + j);
            }
            
            if (initialKey == accRRList[i].MetricsKey__c) {
                //System.debug('@@@@@@UA accRRList[i]=' + accRRList[i]);
                //System.debug('@@@@@@UA accRRList[i].MetricsKey__c=' + accRRList[i].MetricsKey__c);
                if (i == 0) {
                    accRRList[i].Rank__c = j;
	                //System.debug('@@@@@@UA assigning (j) to accRRList[i].Rank__c=' + accRRList[i].Rank__c);
                }
                
                if (i != 0 && accRRList[i-1].Value__c == accRRList[i].Value__c) {
                    accRRList[i].Rank__c = j;      
	                //System.debug('@@@@@@UA accRRList[i-1].Value__c == accRRList[i].Value__c ==> assigning (j) to accRRList[i].Rank__c=' + accRRList[i].Rank__c);
                }
                
                if (i != 0 && accRRList[i-1].Value__c != accRRList[i].Value__c ) {
                    
                    // if MetricsKey does not change, increase Rank value
                    if (accRRList[i-1].MetricsKey__c == accRRList[i].MetricsKey__c) {
                        j = j+1;
                    }
                    
                    accRRList[i].Rank__c = j;      
                    //System.debug('@@@@@@UA accRRList[i-1].Value__c != accRRList[i].Value__c ==> assigning (j+1) to accRRList[i].Rank__c=' + accRRList[i].Rank__c);
                }

            }
            
            accountRRToUpdate.add(accRRList[i]);
        }
     
        if (accountRRToUpdate != null && accountRRToUpdate.size() > 0) {
            
            GlobalVariables.skipAccountRanking = true;
            update accountRRToUpdate;
            GlobalVariables.skipAccountRanking = false;
        }
    }
    
    //-----------------------------
    // @author: Harshit Singhal
    // @date: 07 Jun 2018
    // @param: TriggerParameters tp
    // @description: SFDC1-8537 Convert Process Builder flow "Populate Parent Case On Account Creation" created in SFDC1-965(To populate the parent case on account creation from Case) to a trigger
    // 	
    // @return: None
    //-----------------------------
    public static void updateAccountCreatedOnParentCase(TriggerParameters tp) {
        try {
            List<Case> parentCaseUpdateList = new List<Case>();
            for(Account accObj: (List<Account>)tp.newList) {
                if(accObj.SourceCase__c != null) {
                    Case parentCase = new Case(Id=accObj.SourceCase__c,AccountCreated__c=accObj.Id);
                    parentCaseUpdateList.add(parentCase);      
                }
            }
            if(parentCaseUpdateList.size()>0) {
                update parentCaseUpdateList;
            }
        } catch (Exception ex) {
            UtilityClass.createApexLogRecord(ex, 'AccountMethods', 'updateAccountCreatedOnParentCase');
            String description = '\n Cause: '+ex.getCause()+'\n Line number : '+ ex.getLineNumber()+ '\n Message: '+ ex.getMessage()+ '\n stackTrace: '+ex.getStackTraceString();
            System.debug('Exception in setAccountCreatedOnParentCase() method. Description:'+description);
            throw new TriggerException('Something gone wrong during account creation. Please reach out to salesforce helpdesk.'+description);
        }
    }
    
    //-----------------------------
    // @author: Harshit Singhal
    // @date: 07 Jun 2018
    // @param: TriggerParameters tp
    // @description: SFDC1-8537 Convert Process Builder flow "Populate Account Owner on GAM update" created in SFDC1-1166(Update Account owner as GAM user on GAM update) to a trigger
    // 	
    // @return: None
    //-----------------------------
    public static void setAccountOwnerOnAccountManagerChangeAndUpdatePreviousOwner(TriggerParameters tp) {
        //System.debug('setAccountOwnerOnAccountManagerChange() Method BEGINS');
        for(Account accObj: (List<Account>)tp.newList) {            
            //Before Insert
            //Set Account Owner from Account Manager
            if(tp.tEvent == TriggerParameters.TriggerEvent.beforeInsert && accObj.GlobalAccountManager__c != null) {
                accObj.OwnerId = accObj.GlobalAccountManager__c;
                System.debug('BEFORE INSERT: Set Acc Owner from Account Manager');
            }
            //Before Update
            if(tp.tEvent == TriggerParameters.TriggerEvent.beforeUpdate && tp.oldMap.containsKey(accObj.Id)) {
                Account oldAcc = (Account)tp.oldMap.get(accObj.Id);
                //Set Account Owner on Account Manager change
                if(accObj.GlobalAccountManager__c != null && oldAcc.GlobalAccountManager__c != accObj.GlobalAccountManager__c && accObj.GlobalAccountManager__c != accObj.OwnerId) {
                    accObj.OwnerId = accObj.GlobalAccountManager__c;                    
                }
                //Set Previous Owner on Account Owner change
                if(oldAcc.OwnerId!=null && oldAcc.OwnerId != accObj.OwnerId) {
                    accObj.PreviousOwner__c = oldAcc.OwnerId;                    
                }
            }
        }
        //System.debug('setAccountOwnerOnAccountManagerChange() Method ENDS');
    }
}