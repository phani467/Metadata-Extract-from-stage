//-----------------------------
// @author: Prachi Bhasin
// @date: 3 July 2017
// @param: NA
// @description: Class to hold trigger methods 
// @return: NA
// @Update author : Hemant Shukla
// @Updated On : 21 NOV 2017
// @description : SFDC1-5857 : Removing a method checkEndUserCertificateAttachment() as this validation is not longer needed.
// @Last Modified By : Prachi Bhasin
// @Last Modified Date: 20 Dec 2017
// @Last Modified Description: SFDC1-6411:Updated validation method checkPrimaryContact so that stage '3 - renewal pending' can bypass the validation.
// @Last Modified By : Sonam Raju
// @Last Modified Date: 3 Jan 2018
// @Last Modified Description: SFDC1-6245: When a Channel Partner owns an opportunity, it cannot be moved past Stage 2 if it doesn't have a Opportunity Team Member with a Channel Manager Role
// @Last Modified By : Paras Dhingra
// @Last Modified Date: 4th Jan 2018
// @Last Modified Description: SFDC-4723 Update Oppy split on GAM update
// @Last Modified By : Sonam Raju
// @Last Modified Date: 8th Mar 2018
// @Last Modified Description: SFDC1-6937 Added method to create Additional Opportunity Field record when a 'New Business' Opportunity is created
// @Last Modified By: Sruti Srivastava
// @Last Modified Date: 9th April 2018
// @Last Modified Description: SFDC1-7027- Added method updateContractStartDateAndEndDateOnOpportunityLineItem which updates
// Contract Start Date and End Date on Opportunity Line Items if 'ContractStartDate__c' 
// and 'ContractEndDate__c' field on Opportunity are updated.
// @Last Modified By : Anjani Shukla
// @Last Modified Date: 09 Apr 2018
// @Last Modified Description: SFDC1-7667 : Added Method 'updateOpportunityRiskRecordStatus' to update Opportunity Risk Record Status when New Business //                                          Opportunity is being set to 6L - Closed Lost and an Opportunity at Risk record exists with the status = "Open - //                                          Pending Resolution", then 
//                                          set the Status field to “Closed - Opportunity Lost”.
// @Last Modified By : Anjani Shukla
// @Last Modified Date : 05 Jun 2018
// @Last Modified Description - SFDC1-8392 : Update Account Manager on Opportunity when Account is updated.
// @Last Modified By : Anjani Shukla
// @Last Modified Date : 21 Jun 2018
// @Last Modified Description - SFDC1-8147 : Product Restriction - Added metohd updateOpportunityProductRestriction to restrict Opportunity Stage Change.
// @Last Modified By : Paras Dhingra
// @Last Modified Date : 28 Jun 2018
// @Last Modified Description - SFDC1-8243 : Updating fiscal year of Opportunity schedules on change of opportunity close date
// @Last Modified By : Paras Dhingra
// @Last Modified Date : 06 Sep 2018
// @Last Modified Description - Adding legacy field code for Additional Opportunity fields
//-----------------------------
//-----------------------------
public class OpportunityMethods {
    
    
//-----------------------------
// @author: Prachi Bhasin
// @date: 2 July 2017
// @param: TriggerParameters tp
// @description: When the GAM is updated on Opportunity, this method updates this user's name as the GAM Opportunity Team Member
// @return: None
// @Updated By : Mohit Modi
// @description: SFDC1- 1036 : updated the Team Role 'GAM' to 'Account Owner' for the Opportunity Team Member Roles
//------------------------------
    public static void updateGAMOnOpportunityTeam(TriggerParameters tp) {
        Map<Id,Id> opportunityGAMMap = new Map<Id,Id>();
        Map<Id,Opportunity> mapNewOpportunity = (Map<Id,Opportunity>)tp.newMap;
        Map<Id,Opportunity> mapOldOpportunity = (Map<Id,Opportunity>)tp.oldMap;
        Map<Id,OpportunityTeamMember> mapOppIdAndTeamMember = new Map<Id,OpportunityTeamMember>();
        
        List<OpportunityTeamMember> listTeamToBeInserted = new List<OpportunityTeamMember>();
        List<OpportunityTeamMember> listTeamToBeDeleted = new List<OpportunityTeamMember>();        
        try{
            for(Opportunity newOpp: mapNewOpportunity.values()) {
                Opportunity oldOpportunity = new Opportunity();
                if(tp.tEvent == TriggerParameters.TriggerEvent.afterUpdate) {
                    oldOpportunity = mapOldOpportunity.get(newOpp.Id);
                }
                
                if(newOpp.GAM__c != oldOpportunity.GAM__c)
                    opportunityGAMMap.put(newOpp.Id, newOpp.GAM__c);
            }
            if(!opportunityGAMMap.isEmpty()) {
                List<OpportunityTeamMember> listExistingGAMOnOpportunity = new List<OpportunityTeamMember>();
                listExistingGAMOnOpportunity = [Select Id,TeamMemberRole,UserId,OpportunityId from OpportunityTeamMember where opportunityId IN: opportunityGAMMap.keyset() AND TeamMemberRole=: 'Account Owner' ];
                for(OpportunityTeamMember oppTeamMember : listExistingGAMOnOpportunity) {
                    mapOppIdAndTeamMember.put(oppTeamMember.OpportunityId,oppTeamMember);
                }
                
                for(Id oppId: opportunityGAMMap.keyset()) {
                    if(mapOppIdAndTeamMember.containsKey(oppId) && opportunityGAMMap.get(oppId)!=null) {
                        OpportunityTeamMember oppTeamMember = createOpportunityTeamMember(oppId,opportunityGAMMap.get(oppId),'Edit','Account Owner'); 
                        listTeamToBeInserted.add(oppTeamMember);
                        listTeamToBeDeleted.add(mapOppIdAndTeamMember.get(oppId));
                    }
                    else if(!mapOppIdAndTeamMember.containsKey(oppId) && opportunityGAMMap.get(oppId)!=null) {
                        OpportunityTeamMember oppTeamMember = createOpportunityTeamMember(oppId,opportunityGAMMap.get(oppId),'Edit','Account Owner');                
                        listTeamToBeInserted.add(oppTeamMember);
                    }
                    else if(mapOppIdAndTeamMember.containsKey(oppId) && opportunityGAMMap.get(oppId) == null) {
                        OpportunityTeamMember oppTeamMember = mapOppIdAndTeamMember.get(oppId);
                        listTeamToBeDeleted.add(oppTeamMember);
                    }           
                }
                
                if(listTeamToBeInserted.size()>0) {
                    insert listTeamToBeInserted;
                }
                if(listTeamToBeDeleted.size()>0) {
                    delete listTeamToBeDeleted;
                }
            }
        }
        catch(Exception e) {
            System.debug('Error at line 82, method updateGAMOnOpportunityTeam, class OpportunityMethods');
            ApexLogger__c apexLogRecord = new ApexLogger__c(ClassName__c='OpportunityMethods',ErrorDescription__c='Error at line 65',FunctionName__c='updateGAMOnOpportunityTeam');
            insert apexLogRecord;          
        }
    }
    
    
    //-----------------------------
    // @author: Prachi Bhasin
    // @date: 2 July 2017
    // @param: Id Opportunity Id,Id User Id,String Opportunity Access Level,String Team Member Role
    // @description: This method adds an OpportunityTeamMember to Opportunity 
    // @return: None
    //------------------------------
    public static OpportunityTeamMember createOpportunityTeamMember(Id OpportunityId, Id UserId, String OpportunityAccessLevel, String TeamMemberRole) {
        OpportunityTeamMember oppTeamMember = new OpportunityTeamMember();
        oppTeamMember.OpportunityId = OpportunityId;
        oppTeamMember.UserId = UserId;
        oppTeamMember.TeamMemberRole = TeamMemberRole;
        oppTeamMember.OpportunityAccessLevel= OpportunityAccessLevel;
        oppTeamMember.OpportunityGAMValue__c = TRUE;
        return oppTeamMember;
    }
    
    //-----------------------------
    // @author: Prachi Bhasin
    // @date: 3 July 2017
    // @param: TriggerParameters tp 
    // @description: This method checks a primary contact is present or not on New Business Opportunity when it is moving to Stage-2 
    // @return: None
    // @Update Author: Mohit Modi
    // @Description : SFDC1-2502,SFDC1-480 : Added the logic for checkeing the Valid Email Address and Status for the Primary Contact on Opportunity
    // @Modification : exemption for sys admin and sales ops profile removed as per SFDC1-5782 and SFDC1-5029
    // @Modified by : Ankita Singh on 4th December,2017 
    // @lastmodifiedby : Mohit Modi
    // @lastmodifieddate : 23 May 2018
    // @lastmodifieddescription : SFDC1-6971-Adding StageName change check to resolve query issue.As this method is called from beforeUpdate handler
    //------------------------------
    public static void checkPrimaryContactOnNewBusinessOpportunity(TriggerParameters tp) {
    
        Map<Id,Opportunity> mapNewOpportunity = (Map<Id,Opportunity>)tp.newMap;
        Map<Id,Opportunity> mapOldOpportunity = (Map<Id,Opportunity>)tp.oldMap;     
        Map<Id,Opportunity> stage2NewBusinessOpportunity = new Map<Id,Opportunity>();
        
        Id NewBusinessOppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('New Business').getRecordTypeId();
        Id RenewalOppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Renewal').getRecordTypeId();
        
        try{
            for(Opportunity opp: mapNewOpportunity.values()) {        
                if(mapOldOpportunity != NULL && mapOldOpportunity.get(opp.id).StageName != opp.StageName && 
                ((opp.RecordTypeId == NewBusinessOppRecordTypeId ) && !(opp.StageName == '1-Sales Qualified' || opp.StageName == '6L-Closed Lost')) ||
                ((opp.RecordTypeId == RenewalOppRecordTypeId ) && !(opp.StageName == '3-Renewal Pending'))) {
                    stage2NewBusinessOpportunity.put(opp.id,opp);
                }
            }
            if(stage2NewBusinessOpportunity.size()>0) {
            
                List<OpportunityContactRole> listOpportunityContactRole = new List<OpportunityContactRole>([SELECT IsPrimary,OpportunityID,ContactId,Contact.Email,Contact.Status__c FROM OpportunityContactRole where OpportunityID IN: stage2NewBusinessOpportunity.keyset() AND IsPrimary =: TRUE]);
            
                Map<Id,Boolean> mapOpportunityAndPrimaryContact = new Map<Id,Boolean>();
                Map<Id,String> mapOpportunityAndPrimaryContactEmailValue = new Map<Id,String>();
                Map<Id,String> mapOpportunityAndPrimaryContactStatus = new Map<Id,String>();
            
                for(OpportunityContactRole oppContactRole: listOpportunityContactRole) {
                    mapOpportunityAndPrimaryContact.put(oppContactRole.OpportunityID,oppContactRole.IsPrimary);
                    mapOpportunityAndPrimaryContactEmailValue.put(oppContactRole.OpportunityID,oppContactRole.Contact.Email);
                    mapOpportunityAndPrimaryContactStatus.put(oppContactRole.OpportunityID,oppContactRole.Contact.Status__c);                   
                }
                
                for(Opportunity opp: stage2NewBusinessOpportunity.values()) {
                    String ErrorString = '';
                    
                    if(!mapOpportunityAndPrimaryContact.containsKey(opp.Id) ||(mapOpportunityAndPrimaryContact.containsKey(opp.Id) && mapOpportunityAndPrimaryContact.get(opp.Id) == false)) {
                    
                        ErrorString = System.Label.OpportunityPrimaryContactValidationError;
                    }
                    if((mapOpportunityAndPrimaryContactEmailValue.containsKey(opp.Id) && String.ISBLANK(mapOpportunityAndPrimaryContactEmailValue.get(opp.Id)))) {
                    
                        ErrorString = '\nPrimary Contact needs an email address.';
                    }
                    if(opp.RecordTypeId == RenewalOppRecordTypeId && mapOpportunityAndPrimaryContactStatus.containsKey(opp.Id) && (String.ISBLANK(mapOpportunityAndPrimaryContactStatus.get(opp.Id)) || mapOpportunityAndPrimaryContactStatus.get(opp.Id) == 'Inactive')) {
                    
                        ErrorString = '\nPrimary Contact should be Active for Renewal Opportunity.';
                    }
                    if(ErrorString != '') {
                    
                        opp.addError(ErrorString);
                    }
                }
            }
        }
        catch(Exception e) {
            UtilityClass.createApexLogRecord(e, 'OpportunityMethods', 'checkPrimaryContactOnNewBusinessOpportunity');
        }
    }
    
     /**
     * @author Paras Dhingra
     * @date 26th June 2017
     * @description SFDC1-382 method to change ownership of account
     *  with highest open opportunity owner
     * @param TriggerParameters
     * @return void
     * @companyname IHS Markit
     * @Update author : Mohit modi
     * @description : SFDC1-2098 : Updating the Code/Query for resolving the bug. Changing the Amount field to Amount__c
     * @Update author : Mohit modi
     * @description : SFDC1-4308 : Updating the Code resolving the bug. Changing in Error Catching Method
     */
     
     public static void changeAccountOwnershipOnInsertUpdate(TriggerParameters tp) {
         
         //check if it's an insert or update
         try {
            //map to store Account and opportunity Values
            Map<id,id> mapAccountIdOpportunityId = new Map<id,id>();
            //fetch the accountIds of opportunities
            List<Id> lstAccountsToBeUpdated = new List<Id>();
            Map<Id,Opportunity> mapNewOpportunity = (Map<Id,Opportunity>)tp.oldMap;
            //iterate through new list and update opportunity owner
            for(Opportunity opp: (List<Opportunity>)tp.newList) {
                if((tp.tEvent == TriggerParameters.TriggerEvent.afterInsert) || (tp.tEvent == TriggerParameters.TriggerEvent.afterUpdate && opp.Amount__c != mapNewOpportunity.get(opp.Id).Amount__c)) {
                    lstAccountsToBeUpdated.add(opp.accountId);
                    mapAccountIdOpportunityId.put(opp.accountId,opp.id);    
                }               
            }
            //process the records if list is not empty
            if(lstAccountsToBeUpdated!=null && !lstAccountsToBeUpdated.isEmpty()) { 
                //SFDC1-2098 : Updating the Query for resolving the bug. Changing the Amount field to Amount__c
                List<Account> lstAccountOwnershipUpdate = [Select id, OwnerId, 
                                                          (select id, OwnerId,Amount,Amount__c from Opportunities where isClosed = false ORDER By Amount__c DESC limit 1 )
                                                          from account where GlobalAccountManager__c=null and id in : lstAccountsToBeUpdated];
                if(lstAccountOwnershipUpdate!=null && !lstAccountOwnershipUpdate.isEmpty()) {
                    List<Account> lstAccountOwnersToBeUpdated = new List<Account>();
                    for(Account acc: lstAccountOwnershipUpdate) {
                        if(acc.Opportunities!=null && !acc.Opportunities.isEmpty()) {
                            if(acc.OwnerId!=acc.Opportunities[0].OwnerId) {
                                acc.OwnerId = acc.Opportunities[0].OwnerId;
                                lstAccountOwnersToBeUpdated.add(acc);
                            }
                        }
                    }
                    if(lstAccountOwnersToBeUpdated!=null && !lstAccountOwnersToBeUpdated.isEmpty()) {
                        
                        Database.SaveResult[] lstSR = Database.update (lstAccountOwnersToBeUpdated,false);
                        //show error message based on the list success or error
                        for(Integer i=0; i<lstAccountOwnersToBeUpdated.size(); i++) {
                            Database.SaveResult dsr = lstSR[i];
                            if(!dsr.isSuccess()) {
                                for(Database.Error err: dsr.getErrors()) {
                                    tp.newMap.get(mapAccountIdOpportunityId.get(lstAccountOwnersToBeUpdated[i].id)).addError(err.getMessage());
                                }
                            }
                        }
                        
                    }
                }
            }
             
         }
         catch(Exception ex) {
            String description = '\n Cause: '+ex.getCause()+'\n Line number : '+ ex.getLineNumber()+ '\n Message: '+ ex.getMessage()+ '\n stackTrace: '+ex.getStackTraceString();
            tp.newList[0].addError(System.Label.OpportunityGenericError+description);
         }
         
     }
     /**
      * @author Paras Dhingra
      * @date 2nd August 2017
      * @description SFDC1-1168 insert AccountTeamMemberRole for accounts
      * @param TriggerParameters
      * @return void
      * @companyname IHS Markit
      */
      
      public static void updateAccountRelationship(TriggerParameters tp) {
            if(GlobalVariables.preventRecursiveExecution) {
                GlobalVariables.preventRecursiveExecution = false;
                Try{
                    //generate accountId list
                    Set<Id> setAccountId = new Set<Id>();
                    
                    for(Opportunity opp : (List<Opportunity>)tp.newList) {
                        setAccountId.add(opp.accountID);
                    }
                    System.debug('--setAccountID--'+setAccountId);
                    Set<String> closedWonStage = new Set<String>{'6W-Closed Won', '6W-Renewal Won'};
                    //query related oppys and contracts
                    List<Account> lstAccountsData = [Select Id, Relationship__c, (select id, CloseDate from Opportunities where StageName in: closedWonStage ORDER BY CloseDate DESC)
                                                ,(Select id, status from Contracts where EndDate >TODAY AND STATUS <> 'Draft') from Account where id in:setAccountId];
                    System.debug('--lstAccountsData--'+ lstAccountsData);
                    if(lstAccountsData!=null && !lstAccountsData.isEmpty()) {
                        List<Account> lstAccountsToBeUpdated = new List<Account>();
                        for(Account acc : lstAccountsData) {
                            if((acc.Opportunities==null || acc.Opportunities.size()==0)&&(acc.Contracts==null || acc.Contracts.size()==0)&& acc.Relationship__c!='Prospect') {
                                acc.Relationship__c = 'Prospect';
                                lstAccountsToBeUpdated.add(acc);
                            }else if(acc.Contracts!=null && !acc.Contracts.isEmpty() && acc.Relationship__c!='Customer') {
                                acc.Relationship__c = 'Customer';
                                lstAccountsToBeUpdated.add(acc);
                                continue;
                            }else if(acc.Opportunities!=null && acc.Opportunities.size()>0) {
                                if(acc.Opportunities[0].CloseDate< System.today()-365 && acc.Relationship__c!='Previous Customer') {
                                    acc.Relationship__c = 'Previous Customer';
                                        lstAccountsToBeUpdated.add(acc);
                                }else if(acc.Opportunities[0].CloseDate> System.today()-365 && acc.Relationship__c!='Customer') {
                                    acc.Relationship__c = 'Customer';
                                    lstAccountsToBeUpdated.add(acc);
                                }
                            }
                        }
                        System.debug('--lstAccountsToBeUpdated--'+lstAccountsToBeUpdated);
                        if(lstAccountsToBeUpdated!=null && lstAccountsToBeUpdated.size()>0) {
                            
                            update lstAccountsToBeUpdated;
                           
                        }
                    }
                
                 }catch(Exception ex) {
                    String description = '\n Cause: '+ex.getCause()+'\n Line number : '+ ex.getLineNumber()+ '\n Message: '+ ex.getMessage()+ '\n stackTrace: '+ex.getStackTraceString();
                    tp.newList[0].addError(System.Label.OpportunityGenericError+description);
                }
            }        
        }   
      
      /**
      * @author Prachi Bhasin
      * @date 8th Sept 2017
      * @description SFDC1-1990 Populate External Source System on Create
      * @param TriggerParameters
      * @return void
      * @companyname Vertiba
      */
      
      public static void populateExternalSourceSystemOnOpportunity(TriggerParameters tp) {
        try {
            for(Opportunity opp : (List<Opportunity>)tp.newList) {
                    if(opp.Isclone() && opp.getCloneSourceId()!=NULL)
                        opp.SourceSystem__c = 'Clone';
                }  
            }
        catch(Exception ex) {
            String description = '\n Cause: '+ex.getCause()+'\n Line number : '+ ex.getLineNumber()+ '\n Message: '+ ex.getMessage()+ '\n stackTrace: '+ex.getStackTraceString();
            tp.newList[0].addError(System.Label.OpportunityGenericError+description);
        }
          
      }

    /**
     * @author: Vishnu vardhan Chowdary Andra
     * @date: 13 September 2017
     * @description: SFDC1-2207, SFDC1-1085: When GAM is changed an accuont then account trigger
     *      gets executed and updates GAM on all the open opportunities. But when opportunity is
     *      created from account or directly, then account's GAM is not cascaded to the opportunity.
     *      This method is written to populate opportunity's GAM when it is created.    
     * @companyname: VERTIBA 
    */
    public static void updateGAMOnOpportunityCreation(TriggerParameters tp) {
        Set<Id> setAccountId = new Set<Id>();
        //Collect all the accounts and get the GAM details
        for(Opportunity opp : (List<Opportunity>)tp.newList) {
            setAccountId.add(opp.accountID);
        }
        if(!setAccountId.isEmpty()) {
            Map<Id, Account> accountsMap = new Map<Id,Account>(
                    [Select Id, GlobalAccountManager__c from Account where id in:setAccountId]);
            if(accountsMap!=null && !accountsMap.isEmpty()) {
                //For each opportunity, get the account from MAP and update GAM.
                for(Opportunity opp : (List<Opportunity>)tp.newList) {
                    Account account = accountsMap.get(opp.AccountId);
                    if(account != null && account.GlobalAccountManager__c != null) {
                        //As per the SFDC1-413 'Account GAM always wins over opportunity GAM'
                        //So not checking if opportunity has GAM or not.
                        opp.GAM__c = account.GlobalAccountManager__c;
                    }
                }
            }
        }
    }
    /**
     * @author: Sonam Raju
     * @date: 13 December 2017
     * @description: SFDC1-6245 When a Channel Partner owns an opportunity, 
     * it cannot be moved past Stage 2 if it doesn't have a Opportunity Team Member with a Channel Manager Role
     * @companyname: VERTIBA 
    */
   
    public static void checkChannelManagerRoleonOpptyTeamforStage2andhigher(TriggerParameters tp) {
        set<string> teamMemberRoleSet = new set<string>();
        Map<Id,Opportunity> MapOpptyWithStage2orHigher = new Map<Id,Opportunity>();
        Map<Id,Opportunity> mapOldOpportunity = (Map<Id,Opportunity>)tp.oldMap;
        try{ 
            
            for(Opportunity opp: (List<Opportunity>)tp.newList) {
                if((!((opp.StageName.contains('1-'))||(opp.StageName.contains('3-Renewal Pending')))) && (opp.StageName!=mapOldOpportunity.get(opp.Id).StageName)) {
                        MapOpptyWithStage2orHigher.put(Opp.Id, opp);
                }
            }
            if(MapOpptyWithStage2orHigher.size() >0) {
                Profile pf = [SELECT Id,name FROM Profile where Name like 'IHS Markit: Channel Partner User%'];
                for(Opportunity opp: [ select id,owner.Profile.Name, owner.profileId, ( Select Id,TeamMemberRole,UserId,OpportunityId from OpportunityTeamMembers) from opportunity where Id IN: MapOpptyWithStage2orHigher.keyset() ]) {
                    if(opp.owner.ProfileId == pf.id) {
                        if(opp.OpportunityTeamMembers.size() > 0 ) {
                            for(OpportunityTeamMember opptyTeamMember : opp.OpportunityTeamMembers ) {
                                teamMemberRoleSet.add(opptyTeamMember.TeamMemberRole);
                                }
                            if(!teamMemberRoleSet.contains('Channel Manager')) {
                                tp.newMap.get(opp.id).addError(System.Label.OpptyChannelPartnerError);
                            }
                            } 
                        else {
                                tp.newMap.get(opp.id).addError(System.Label.OpptyChannelPartnerError);
                            }
                    }
                }
            }
        }
        catch(Exception e) {
            System.debug('Error at line 384, method checkChannelManagerRoleonOpptyTeamforStage2andhigher, class OpportunityMethods');
            ApexLogger__c apexLogRecord = new ApexLogger__c(ClassName__c='OpportunityMethods',ErrorDescription__c=e.getMessage(),FunctionName__c='checkChannelManagerRoleonOpptyTeamforStage2andhigher');
            insert apexLogRecord;     
        }
    }
    //-----------------------------
    // @author: Paras Dhingra
    // @date: 04th Jan 2018
    // @param: TriggerParameters
    // @description: SFDC1-4723 Update Overlay oppy split on GAM update
    // @return: None
    //------------------------------
    public static void updateOpportunitySplitOnGamChange(TriggerParameters tp) {
        List<OpportunitySplit> listOppySplitToInsert = new List<OpportunitySplit>();
        
        Map<Id,Opportunity> mapNewOpportunity = (Map<Id,Opportunity>)tp.newMap;
        Map<Id,Opportunity> mapOldOpportunity = (Map<Id,Opportunity>)tp.oldMap;
        Set<Id> setOppyChanged = new Set<Id>();
        //query overlay split type id
        Id overlaySplitTypeId = UtilityClass.OverlayId;
        try {
            for(Opportunity newOppy: mapNewOpportunity.values()) {
                
                Opportunity oldOppy = new Opportunity();
                if(tp.tEvent == TriggerParameters.TriggerEvent.afterUpdate) {
                    oldOppy = mapOldOpportunity.get(newOppy.Id);
                }
                if(newOppy.GAM__c!=oldOppy.GAM__c) {
                    
                    // oppy changed.. add it to overlay delete list
                    setOppyChanged.add(newOppy.Id);
                    //add new GAM as overlay split member
                    if(newOppy.GAM__c!=null) {
                        OpportunitySplit newOppySplit = new OpportunitySplit();
                        newOppySplit.OpportunityID = newOppy.Id;
                        newOppySplit.SplitTypeId = overlaySplitTypeId;
                        newOppySplit.SplitOwnerId = newOppy.GAM__c;
                        newOppySplit.SplitPercentage = 100.00;
                        listOppySplitToInsert.add(newOppySplit);
                    }
                    
                }
            }
            //query old split related to GAM and delete them 
            if(setOppyChanged!=null && !setOppyChanged.isEmpty()) {
                List<OpportunitySplit> listOppySplitToDelete = new List<OpportunitySplit>();
                listOppySplitToDelete = [Select Id from OpportunitySplit 
                                        where  OpportunityID IN:setOppyChanged AND SplitTypeId=:overlaySplitTypeId];
                if(listOppySplitToDelete!=null && !listOppySplitToDelete.isEmpty()) {
                   delete listOppySplitToDelete; 
                }
            }
            //create new Opportunity Splits
            if(listOppySplitToInsert!=null && !listOppySplitToInsert.isEmpty()) {
                insert listOppySplitToInsert;
            }
        } 
        catch(Exception ex) {
            String description = '\n Cause: '+ex.getCause()+'\n Line number : '+ ex.getLineNumber()+ '\n Message: '+ ex.getMessage()+ '\n stackTrace: '+ex.getStackTraceString();
            tp.newList[0].addError(System.Label.OpportunityGenericError+description);
            
        }
    }
    //-----------------------------
    // @author: Sonam Raju adapted from Uttam's code
    // @date: 8 Mar 2018
    // @param: TriggerParameters tp
    // @description: SFDC1-6937 When a 'New Business 'Opportunity is created, manually or from an external system 
    //                          we need to create an additional opportunity fields record which can hold aditional 
    //                          opportunity associated information.
    // @return: None
    //------------------------------
    public static void setOpportunityAdditionalFieldsObject(TriggerParameters tp) {
    
        try {
        
            // List of Additional Opportunity Fields thats needs to be inserted 
            List<AdditionalOpportunityFields__c> additionalOpportunityFieldsToInsert = new List<AdditionalOpportunityFields__c>();
            
            // Map of old values and new values
            Map<Id,Opportunity> mapNewOpportunity = (Map<Id,Opportunity>) tp.newMap;
            Map<Id,Opportunity> mapOldOpportunity = (Map<Id,Opportunity>) tp.oldMap;
            
            for(Opportunity newOpportunity: mapNewOpportunity.values()) {
                if(tp.tEvent == TriggerParameters.TriggerEvent.afterInsert) {
                    if(newOpportunity.OpportunityRecordType__c == 'New Business' && newOpportunity.AdditionalOpportunityFields__c == null) {
                        String additionalOpportunityName = ('Additional Fields - ' + newOpportunity.Name).left(80);
                        additionalOpportunityFieldsToInsert.add(new AdditionalOpportunityFields__c(Name = additionalOpportunityName, OpportunityReference__c = newOpportunity.Id,
                                                                LegacyID__c= newOpportunity.LegacyID__c, LegacyIDUnique__c = newOpportunity.LegacyIDUnique__c,
                                                                LegacyReference__c = newOpportunity.LegacyReference__c, LegacySystem__c = newOpportunity.LegacySystem__c ));
                    }
                }
            }
            
            // insert if list has any records
            if(additionalOpportunityFieldsToInsert != null && additionalOpportunityFieldsToInsert.size() > 0) {
                insert additionalOpportunityFieldsToInsert;
            }
            
        } catch(Exception ex) {
                //this will happen if any exception apart from DML exception has occurred
                UtilityClass.createApexLogRecord(ex, 'OpportunityMethods', 'setOpportunityAdditionalFieldsObject');
              
        }
    }
    
    //-----------------------------
    // @author: Uttam Arya
    // @date: 11 Sep 2018
    // @param: TriggerParameters tp
    // @description: SFM-159 Whenever a opportunity is created, whether manually by a user or through an integration/data migration, 
    //              an "Additional Opportunity Fields" record is automatically created and a link to this record is populated in the opportunity record.
    //              This field should not be editable by anyone except System Admin. This function changes AdditionalOpportunityFields object's Name when Opportunity's Name changes.
    //------------------------------
    public static void changeAdditionalOpportunityFieldsNameWhenOpportunityFieldChanges(TriggerParameters tp) {

        try {
        
            // List of Additional Opportunity Fields thats needs to be inserted 
            List<AdditionalOpportunityFields__c> additionalOpportunityFieldsToUpdate = new List<AdditionalOpportunityFields__c>();
            
            // Map of old values and new values
            Map<Id,Opportunity> mapNewOpportunity = (Map<Id,Opportunity>) tp.newMap;
            Map<Id,Opportunity> mapOldOpportunity = (Map<Id,Opportunity>) tp.oldMap;
            
            System.debug('@@@UA: changeAdditionalOpportunityFieldsNameWhenOpportunityFieldChanges');
            
            for(Opportunity newOpportunity: mapNewOpportunity.values()) {
                    
                if(tp.tEvent == TriggerParameters.TriggerEvent.afterUpdate) {
                    Opportunity oldOpportunity = mapOldOpportunity.get(newOpportunity.Id);
                    if(newOpportunity.AdditionalOpportunityFields__c != null
                       && (newOpportunity.Name != oldOpportunity.Name
                            || newOpportunity.LegacyID__c != oldOpportunity.LegacyID__c
                            || newOpportunity.LegacyIDUnique__c != oldOpportunity.LegacyIDUnique__c 
                            || newOpportunity.LegacySystem__c != oldOpportunity.LegacySystem__c)) {
                                String additionalOpportunityName = ('Additional Fields - ' + newOpportunity.Name).left(80);
                                AdditionalOpportunityFields__c aof = new AdditionalOpportunityFields__c(Name = additionalOpportunityName,
                                                                                                        Id = newOpportunity.AdditionalOpportunityFields__c,
                                                                                                        LegacyID__c= newOpportunity.LegacyID__c,
                                                                                                        LegacyIDUnique__c = newOpportunity.LegacyIDUnique__c,
                                                                                                        LegacySystem__c = newOpportunity.LegacySystem__c,
                                                                                                        LegacyReference__c = newOpportunity.LegacyReference__c);
                                additionalOpportunityFieldsToUpdate.add(aof);  
                    }
                }
            }
            
            // update if the list has any records
            if(additionalOpportunityFieldsToUpdate != null && additionalOpportunityFieldsToUpdate.size() > 0) {
                update additionalOpportunityFieldsToUpdate;
            }
            
        } catch(Exception ex) {
                //this will happen if any exception apart from DML exception has occurred
                UtilityClass.createApexLogRecord(ex, 'OpportunityMethods', 'changeAdditionalOpportunityFieldsObjectNameWhenOpportunityNameChanges');
              
        }
    }

    
    //-----------------------------
    // @author: Mohit Modi
    // @date: 28 March 2018
    // @param: TriggerParameters
    // @description: SFDC1-7635 Update Opportunity Team based on the 'Referred By' field on Opportunity.
    //                This method will be called in afterupdate and afterInsert trigger Events.
    // @return: None
    //------------------------------
    public static void updateReferredByOnOpportunityTeam(TriggerParameters tp) {
        Map<Id,Id> opportunityRefferedByMap = new Map<Id,Id>();
        Map<Id,Opportunity> mapNewOpportunity = (Map<Id,Opportunity>)tp.newMap;
        Map<Id,Opportunity> mapOldOpportunity = (Map<Id,Opportunity>)tp.oldMap;
        Map<Id,OpportunityTeamMember> mapOppIdAndTeamMember = new Map<Id,OpportunityTeamMember>();
        
        List<OpportunityTeamMember> listTeamToBeInserted = new List<OpportunityTeamMember>();
        List<OpportunityTeamMember> listTeamToBeDeleted = new List<OpportunityTeamMember>();        
        try{
            // Checking for the After Update and if Opportunity ReferredBy field has been updated.
            if(tp.tEvent == TriggerParameters.TriggerEvent.afterUpdate) {
                for(Opportunity newOpp: mapNewOpportunity.values()) {
                    if(newOpp.ReferredBy__c != mapOldOpportunity.get(newOpp.Id).ReferredBy__c) {
                        opportunityRefferedByMap.put(newOpp.Id, newOpp.ReferredBy__c);
                    }
                }
            }
            // Checking for the After Insert and if Opportunity created with ReferredBy field filled.
            if(tp.tEvent == TriggerParameters.TriggerEvent.afterInsert) {
                for(Opportunity newOpp: mapNewOpportunity.values()) {
                    if(newOpp.ReferredBy__c != NULL) {
                        opportunityRefferedByMap.put(newOpp.Id, newOpp.ReferredBy__c);
                    }
                }
            }
            
            if(!opportunityRefferedByMap.isEmpty()) {
                // Querying the existing Team Members with the same Role
                for(OpportunityTeamMember oppTeamMember : [Select Id,TeamMemberRole,UserId,OpportunityId from OpportunityTeamMember where opportunityId IN: opportunityRefferedByMap.keyset() AND TeamMemberRole=: 'Referred By' ]) {
                    mapOppIdAndTeamMember.put(oppTeamMember.OpportunityId,oppTeamMember);
                }
                
                for(Id oppId: opportunityRefferedByMap.keyset()) {
                    // AlreadyExist = TRUE &&  ChangedUser == TRUE : Delete the Existing and Create NEW TeamMember
                    if(mapOppIdAndTeamMember.containsKey(oppId) && opportunityRefferedByMap.get(oppId)!=null) {
                        OpportunityTeamMember oppTeamMember = createOpportunityTeamMember(oppId,opportunityRefferedByMap.get(oppId),'Edit','Referred By'); 
                        listTeamToBeInserted.add(oppTeamMember);
                        listTeamToBeDeleted.add(mapOppIdAndTeamMember.get(oppId));
                    }
                    // AlreadyExist = FALSE &&  ChangedUser == TRUE : Only Create NEW TeamMember
                    else if(!mapOppIdAndTeamMember.containsKey(oppId) && opportunityRefferedByMap.get(oppId)!=null) {
                        OpportunityTeamMember oppTeamMember = createOpportunityTeamMember(oppId,opportunityRefferedByMap.get(oppId),'Edit','Referred By');                
                        listTeamToBeInserted.add(oppTeamMember);
                    }
                    // AlreadyExist = TRUE &&  ChangedUser == FALSE , Removed the Existing User : Only Delete Existing TeamMember
                    else if(mapOppIdAndTeamMember.containsKey(oppId) && opportunityRefferedByMap.get(oppId) == null) {
                        OpportunityTeamMember oppTeamMember = mapOppIdAndTeamMember.get(oppId);
                        listTeamToBeDeleted.add(oppTeamMember);
                    }           
                }
                
                if(listTeamToBeInserted.size()>0) {
                    insert listTeamToBeInserted;
                }
                if(listTeamToBeDeleted.size()>0) {
                    delete listTeamToBeDeleted;
                }
            }
        }
        catch(Exception e) {
            UtilityClass.createApexLogRecord(e, 'OpportunityMethods', 'updateReferredByOnOpportunityTeam');
        }
    }
    //-----------------------------
    // @author: Sruti Srivastava
    // @date: 9th April 2018
    // @param: TriggerParameters
    // @description: SFDC1-7027 - Update Contract Start Date and End Date on Opportunity Line Items if 'ContractStartDate__c' 
    // and 'ContractEndDate__c' field on Opportunity are updated
    // This method will be called in afterupdate trigger Events.
    // @return: None
    //------------------------------
    public static void updateContractStartDateAndEndDateOnOpportunityLineItem(TriggerParameters tp) {
        
        Map<Id, Opportunity> mapNewOpportunity = (Map<Id, Opportunity>)tp.newMap;
        Map<Id, Opportunity> mapOldOpportunity = (Map<Id, Opportunity>)tp.oldMap;
        Map<Id, OpportunityLineItem> mapOpportunityLineItems = new Map<Id, OpportunityLineItem>();
        Set<Id> setOpportunityIds = new Set<Id>();
        
        try{
            // Add all opportunity to a set, if Contract Start Date or End Date has been modified
            if(tp.tEvent == TriggerParameters.TriggerEvent.afterUpdate) {
                for(Opportunity newOpp: mapNewOpportunity.values()) {
                    if(newOpp.ContractStartDate__c != mapOldOpportunity.get(newOpp.Id).ContractStartDate__c
                      || newOpp.ContractEndDate__c != mapOldOpportunity.get(newOpp.Id).ContractEndDate__c) {
                        setOpportunityIds.add(newOpp.Id);
                    }
                }
            }
            //If Contract Start Date or End Date on Opportunity have been updated, update Opportunity Products too
            if(!setOpportunityIds.isEmpty()) {
                // Querying related Opportunity Line Items 
                for(OpportunityLineItem oli : [Select Id, ContractStartDate__c, ContractEndDate__c, OpportunityId,
                                               Opportunity.ContractStartDate__c, Opportunity.ContractEndDate__c
                                               from OpportunityLineItem 
                                               where opportunityId IN: setOpportunityIds ]) {
                    if(oli.ContractEndDate__c !=  oli.Opportunity.ContractEndDate__c ||
                       oli.ContractStartDate__c !=  oli.Opportunity.ContractStartDate__c) {                                         
                            mapOpportunityLineItems.put(oli.Id, new OpportunityLineItem(Id = oli.Id,
                                                            ContractStartDate__c = oli.Opportunity.ContractStartDate__c, 
                                                            ContractEndDate__c = oli.Opportunity.ContractEndDate__c));
                       }
                }
                
                //Update opportunity Products
                if(!mapOpportunityLineItems.isEmpty()) {
                    update mapOpportunityLineItems.values();
                }
            }
        }
        catch(Exception e) {
            UtilityClass.createApexLogRecord(e, 'OpportunityMethods', 'updateContractStartDateAndEndDateOnOpportunityLineItem');
        }
    }
    //-----------------------------
    // @author: Anjani Shukla
    // @date: 09 April 2018
    // @param: TriggerParameters
    // @description: SFDC1-7667 : Added Method 'updateOpportunityRiskRecordStatus' to update Opportunity Risk Record Status when New Business Opportunity is 
    //                            being set to 6L - Closed Lost and an Opportunity at Risk record exists with the status = "Open - Pending Resolution", then 
    //                            set the Status field to “Closed - Opportunity Lost”.
    // @return: None
    //------------------------------
    public static void updateOpportunityRiskRecordStatus(TriggerParameters tp) {
        
        // stores risk renewal record (Opportunity at Risk).
        Map<Id,RenewalatRisk__c> mapOpportunityRiskRecord;
        
        // Map of old values and new values
        Map<Id,Opportunity> mapNewOpportunity = (Map<Id,Opportunity>) tp.newMap;
        Map<Id,Opportunity> mapOldOpportunity = (Map<Id,Opportunity>) tp.oldMap;
        
        // Store opportunity id which has status updated to 6L-Closed Lost, Record Type is New Business and Renewal Record exist.
        Set<Id> validOptyIds = new Set<Id>();
        
        // Checking for the After Update and if Opportunity ReferredBy field has been updated.
        if(tp.tEvent == TriggerParameters.TriggerEvent.afterUpdate) {  
            if(!mapNewOpportunity.isEmpty() && !mapOldOpportunity.isEmpty()) {
                for(Opportunity checkOptyStatus: mapNewOpportunity.values()) {
                    //Check if Status is updated to 6L-Closed Lost and record type is new Business.
                    if(checkOptyStatus.OpportunityRecordType__c == 'New Business' && 
                       checkOptyStatus.StageName == '6L-Closed Lost' && 
                       mapOldOpportunity.get(checkOptyStatus.id).StageName != '6L-Closed Lost' &&
                       checkOptyStatus.Countofrenewalatrisk__c != 0 ) {
                          validOptyIds.add(checkOptyStatus.id);     
                      }    
                }
            }
            
            
            // Null check for Set created above.
            if(validOptyIds != null && !validOptyIds.isEmpty()) {
                //get Opportuntiy Risk Record if Opportunity from New Map has status update.
                mapOpportunityRiskRecord = new Map<Id,RenewalatRisk__c> ( [select id,Account__c,OpportunityAtRisk__c,Status__c 
                                                                           from RenewalatRisk__c where OpportunityAtRisk__c IN : validOptyIds 
                                                                           and Status__c ='Open - Pending Resolution'] );
               
            } 
            
            try {
                if( mapOpportunityRiskRecord != null && !mapOpportunityRiskRecord.isEmpty()) {
                    // update status for Opportunity risk record.
                    for(RenewalatRisk__c updateStatusOptyRiskRecord: mapOpportunityRiskRecord.values()) {
                        updateStatusOptyRiskRecord.status__c = 'Closed - Opportunity Lost';     
                    }    
                }
            
                // Initiate DML operation.
                if(mapOpportunityRiskRecord != null && !mapOpportunityRiskRecord.isEmpty() ) {
                    update mapOpportunityRiskRecord.values();
                    system.debug('mapOpportunityRiskRecord---->'+mapOpportunityRiskRecord);
                }
            } catch(Exception e) {
                UtilityClass.createApexLogRecord(e, 'OpportunityMethods', 'updateOpportunityRiskRecordStatus');
            }
        }             
    }
    //-----------------------------
    // @Author : Prachi Bhasin
    // @Date : 6 June 2018
    // @Description :SFDC1-5785 Copy Bill to and Ship to fields to Renewal Opportunity from 
    // Originating contract(SFDC1-7542: converting process builder 'CopyBilltoShiptoFromOriginatingContractToRenewalOpportunity ' 
    // to this method
    // @param : TriggerParameters Contains the trigger parameters which includes the record(s) that got updated.
    // @Company: Vertiba
    // @return : Void
    //-----------------------------
    public static void  copyBilltoShiptoFromOriginatingContractToRenewalOpportunity(TriggerParameters tp) {
        
        if(tp.tEvent == TriggerParameters.TriggerEvent.beforeInsert ||
           tp.tEvent == TriggerParameters.TriggerEvent.beforeUpdate)
        { 
            try {
                Set<id> setContractId = new set<id>();
                Id renewalRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Renewal').getRecordTypeId();
                List<Opportunity> listOpportunities = new List<Opportunity>();
                Map<Id,Opportunity> mapOldOpportunity = (Map<Id,Opportunity>)tp.oldMap;
                for (Opportunity a:(List<Opportunity>)tp.newList) {
                    Opportunity oldOpportunity;
                    if (tp.oldMap != null && tp.oldMap.get(a.Id) != null) {
                        oldOpportunity = (Opportunity)tp.oldMap.get(a.Id);
                    }
                    if (tp.oldMap == null && a.ContractBeingRenewed__c != null && a.RecordTypeId == renewalRecordTypeId) {
                        listOpportunities.add(a);
                        setContractId.add(a.ContractBeingRenewed__c);
                    }
                    else if (tp.oldMap != null && oldOpportunity.ContractBeingRenewed__c != a.ContractBeingRenewed__c && a.RecordTypeId == renewalRecordTypeId) {
                        listOpportunities.add(a);
                        setContractId.add(a.ContractBeingRenewed__c);
                    }
                }
                
                if(listOpportunities!=NULL && listOpportunities.size()>0) {
                    
                    Map<Id,Contract> mapContract = new Map<Id,Contract>([Select id,BillToCity__c, BillToClientName__c, BillToCompanySAP__c, BillToContactEmailAddress__c, BillToContactFirstName__c, BillToContactLastName__c, BillToContactSAP__c, BillToContactTelephoneNumber__c, BillToCountryCodeLookup__c, BillToPostalZipCode__c, BillToStateProvince__c, BillToStreet__c, ShipToCity__c, ShipToClientName__c, ShipToCompanySAP__c, ShipToContactEmailAddress__c, ShipToContactFirstName__c, ShipToContactLastName__c, ShipToContactSAP__c, ShipToContactTelephoneNumber__c, ShipToCountryCodeLookup__c, ShipToPostalZipCode__c, ShipToStateProvince__c, ShipToStreet__c from Contract where Id IN : setContractId]);
                    
                    for(Opportunity opp : listOpportunities ) {
                        Contract  contractObj = mapContract.get(opp.ContractBeingRenewed__c);                        
                            opp.BillToCity__c=contractObj.BillToCity__c;                      
                            opp.BillToClientName__c=contractObj.BillToClientName__c;                       
                            opp.BillToCompanySAP__c=contractObj.BillToCompanySAP__c;                       
                            opp.BillToContactEmailAddress__c=contractObj.BillToContactEmailAddress__c;                       
                            opp.BillToContactFirstName__c=contractObj.BillToContactFirstName__c;                       
                            opp.BillToContactLastName__c=contractObj.BillToContactLastName__c;                        
                            opp.BillToContactSAP__c=contractObj.BillToContactSAP__c;                       
                            opp.BillToContactTelephoneNumber__c=contractObj.BillToContactTelephoneNumber__c;                       
                            opp.BillToPostalZipCode__c=contractObj.BillToPostalZipCode__c;                       
                            opp.BillToStateProvince__c=contractObj.BillToStateProvince__c;                        
                            opp.BillToStreet__c=contractObj.BillToStreet__c;                      
                            opp.ShipToCity__c=contractObj.ShipToCity__c;                       
                            opp.ShipToClientName__c=contractObj.ShipToClientName__c;                        
                            opp.ShipToCompanySAP__c=contractObj.ShipToCompanySAP__c;                       
                            opp.ShipToContactEmailAddress__c=contractObj.ShipToContactEmailAddress__c;                        
                            opp.ShipToContactFirstName__c=contractObj.ShipToContactFirstName__c;                       
                            opp.ShipToContactLastName__c=contractObj.ShipToContactLastName__c;                       
                            opp.ShipToContactSAP__c=contractObj.ShipToContactSAP__c;                        
                            opp.ShipToContactTelephoneNumber__c=contractObj.ShipToContactTelephoneNumber__c;                       
                            opp.ShipToPostalZipCode__c=contractObj.ShipToPostalZipCode__c;                       
                            opp.ShipToStateProvince__c=contractObj.ShipToStateProvince__c;                       
                            opp.ShipToStreet__c=contractObj.ShipToStreet__c;                       
                            opp.BillToCountryNew__c=contractObj.BillToCountryCodeLookup__c!=null?UtilityClass.getCountryById(contractObj.BillToCountryCodeLookup__c).Name:'';  
                            opp.ShipToCountryNew__c=contractObj.ShipToCountryCodeLookup__c!=null?UtilityClass.getCountryById(contractObj.ShipToCountryCodeLookup__c).Name:'';                       
                    }     
                }
            }
            catch (Exception e) {
                UtilityClass.createApexLogRecord(e,'OpportunityMethods','CopyBilltoShiptoFromOriginatingContractToRenewalOpportunity'); 
            }
            
        }
        
    }
    
    //-----------------------------
    // @author: Anjani Shukla
    // @date: 09 April 2018
    // @param: TriggerParameters
    // @description: SFDC1-8392 : Update Account Manager on Opportunity when Account is updated.  
    // @return: None
    //------------------------------
    public static void updateOpportunityGAM(TriggerParameters tp) {
    	// Map of old values and new values
        Map<Id,Opportunity> mapNewOpportunity = (Map<Id,Opportunity>) tp.newMap;
        Map<Id,Opportunity> mapOldOpportunity = (Map<Id,Opportunity>) tp.oldMap;  
        
        // Opportunity Ids.
        Set<Id> accountIdsLstToUpdate = new Set<Id>();
        Map<Id,Account> accountMaptoUpdate;
		// Checking for the After Update and if Opportunity ReferredBy field has been updated.
        if(tp.tEvent == TriggerParameters.TriggerEvent.beforeUpdate) {  
        	if(!mapNewOpportunity.isEmpty() && !mapOldOpportunity.isEmpty()) {
            	//verify if opportunity account is updated.
                for(Opportunity newOpp: mapNewOpportunity.values()) {
                    if(newOpp.AccountId != null && mapOldOpportunity.get(newOpp.id).AccountId != null && newOpp.AccountId != mapOldOpportunity.get(newOpp.id).AccountId) {
                        if(newOpp.StageName != '6L-Closed Lost' && 
                           newOpp.StageName != '6W-Renewal Won' && 
                           newOpp.StageName != '6W-Closed Won'  && 
                           newOpp.StageName != '6L-Renewal Lost' &&
                           newOpp.StageName != '6WP-Closed Won/Order Processed'
                          ) {
                        	// Capture list opty
                        	accountIdsLstToUpdate.add(newOpp.AccountId);
                        } 
                    }    
                }
            }
            
            if(accountIdsLstToUpdate != null && !accountIdsLstToUpdate.isEmpty()) {
            	accountMaptoUpdate = new Map<Id,Account>([select id,GlobalAccountManager__c
                                                           from Account where id IN: accountIdsLstToUpdate ]);    
            }
            
            if(accountMaptoUpdate != null && !accountMaptoUpdate.isEmpty()) {
                for(opportunity updateGAM: mapNewOpportunity.values()) {
                	//Assign GAM for Updated account.        
                	updateGAM.GAM__c = accountMaptoUpdate.get(updateGAM.Accountid).GlobalAccountManager__c;
                }     
            }
        }
    }
    //-----------------------------
    // @author: Prachi Bhasin
    // @date: 13 June 2018
    // @param: TriggerParameters
    // @description: SFDC1-8434 : An Order Management case will need to be generated when an Opportunity is set to 6W.  
    // @return: None
	// @Last Modified By : Prachi Bhasin
	// @Last Modified Date : 26 July 2018
	// @Last Modified Description - SFDC1-9411 - Mapping more fields for case creation	
    //------------------------------
    public static void createOMCaseOnRenewalOpportunityClosure(TriggerParameters tp) {
        // Map of old values and new values        
        if(GlobalVariables.preventRecursiveTranstion) {                       
            try {
                Map<Id,Opportunity> mapNewOpportunity = (Map<Id,Opportunity>) tp.newMap;
                Map<Id,Opportunity> mapOldOpportunity = (Map<Id,Opportunity>) tp.oldMap;  
                List<Case> lstOMCaseToBeCreated = new List<Case>();
                Id OMRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Order Management').getRecordTypeId();
                Id innerYearRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Inner Year').getRecordTypeId();
                // Opportunity Ids.
                Set<Id> accountIdsLstToUpdate = new Set<Id>();
                Map<Id,Account> accountMaptoUpdate;                
                // Checking for the After Update
                if(tp.tEvent == TriggerParameters.TriggerEvent.afterUpdate) {                 
                    if(!mapNewOpportunity.isEmpty() && !mapOldOpportunity.isEmpty()) {               
                        for(Opportunity newOpp: mapNewOpportunity.values()) {                                           
                            if((newOpp.StageName != mapOldOpportunity.get(newOpp.id).StageName && newOpp.StageName == '6W-Renewal Won' && newOpp.AutoRenewal__c==TRUE && newOpp.DoesThisAutoRenewalHaveChanges__c== FALSE && newOpp.SourceSystem__c!= 'SAP') 
                                || (newOpp.RecordTypeId == innerYearRecordTypeId && newOpp.StageName != mapOldOpportunity.get(newOpp.id).StageName && newOpp.StageName == '6W-Renewal Won' && newOpp.PORequired__c)) {
                                
                                system.debug('inside if');
                                Case cse = new Case( AutoRenewalWithChange__c = newOpp.DoesThisAutoRenewalHaveChanges__c,ComplianceRestrictions__c = newOpp.ComplianceRestrictions__c,AutoRenewal__c = newOpp.AutoRenewal__c,PORequired__c = newOpp.PORequired__c,Contract__c=newOpp.ContractBeingRenewed__c,Opportunity__c = newOpp.Id,RecordTypeId = OMRecordTypeId,AccountId = newOpp.AccountId,Status = 'New',Subject = 'Closed Won - Auto Renewal');
                                if(newOpp.RecordTypeId == innerYearRecordTypeId && newOpp.PORequired__c) {
                                   cse.Subject = 'Inner Year - PO Required';     
                                }
                                if(UtilityClass.OrderManagementQueueId!= NULL) {
                                    cse.OwnerId=UtilityClass.OrderManagementQueueId ;
                                }
                                else {
                                    cse.OwnerId = UserInfo.getUserId();
                                }   
                                lstOMCaseToBeCreated.add(cse);
                                
                            }    
                        }
                    }         
                    if(lstOMCaseToBeCreated != null && lstOMCaseToBeCreated.size()>0) {                        
                        GlobalVariables.preventRecursiveTranstion = false; 
                        insert lstOMCaseToBeCreated;                      
                    }            
                }
            }
            catch (Exception e) {
                UtilityClass.createApexLogRecord(e,'OpportunityMethods','createOMCaseOnRenewalOpportunityClosure'); 
            }
        }
    }
	
	//-----------------------------
    // @author: Anjani Shukla
    // @date: 21 June 2018
    // @param: TriggerParameters
    // @description: SFDC1-8147 : .  
    // @return: None
    //------------------------------
    public static void updateOpportunityProductRestriction(TriggerParameters tp) {
    	// Map of old values and new values
        Map<Id,Opportunity> mapNewOpportunity = (Map<Id,Opportunity>) tp.newMap;
        Map<Id,Opportunity> mapOldOpportunity = (Map<Id,Opportunity>) tp.oldMap;  
        
        // Opportunity Ids.
        Set<Id> accountIdsLstToUpdate = new Set<Id>();
        Map<Id,Account> accountMaptoUpdate;
        
        Id NewBusinessOppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('New Business').getRecordTypeId();
		Id renewOppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Renewal').getRecordTypeId();
        Id ForecastPlaceOppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Forecasting Placeholder').getRecordTypeId();
        
        
        //Check if opportunity has bad product 
        List<String> prodErrOptyLst = new List<String>();
        // Checking for the Before Update and if Opportunity Stage - Need To Confirmed.
        if(tp.tEvent == TriggerParameters.TriggerEvent.beforeUpdate) {  
        	if(!mapNewOpportunity.isEmpty() && !mapOldOpportunity.isEmpty()) {
            	//verify if opportunity is updated.
                for(Opportunity newOpp: mapNewOpportunity.values()) {
                    if(newOpp.RecordTypeId == NewBusinessOppRecordTypeId &&
                       newOpp.StageName != mapOldOpportunity.get(newOpp.id).StageName ) {
                        	// Getting the list of Products for which Stage can not be Changed.
                            prodErrOptyLst = WarningMsgProductCrossPlantStatus.getOptyProdLineDetails(newOpp.id);
                           if(prodErrOptyLst != null && prodErrOptyLst.size() > 0) {
                               newOpp.addError('Stage can not be modified until '+ prodErrOptyLst + ' '+' product(s) is not removed.Please remove Opportunity Product to proceed further.');    
                           }
                    }

					// Validate Renewal and stageName is changed.
                    if(newOpp.RecordTypeId == renewOppRecordTypeId &&
                       newOpp.StageName != mapOldOpportunity.get(newOpp.id).StageName) {
                        	// Getting the list of Products for which Stage can not be Changed.
                            prodErrOptyLst = WarningMsgProductCrossPlantStatus.getOptyProdLineDetails(newOpp.id);
                           if(prodErrOptyLst != null && prodErrOptyLst.size() > 0) {
                               newOpp.addError('Stage can not be modified until '+ prodErrOptyLst + ' '+' product(s) is not removed.Please remove Opportunity Product to proceed further.');    
                           }
                    }			
                }
            }           
        }
    }
    //-----------------------------
    // @author: Paras Dhingra
    // @date: 23rd Jun 2018
    // @param: TriggerParameters
    // @description: SFDC1-8243 - Update Opportunity product shedules on change of close date 
    // and when contract start and contract end date are not populated
    // This method will be called in afterupdate trigger Events.
    // @return: None
    //------------------------------
    public static void updateFiscalOnChangeOfCloseDate(TriggerParameters tp) {
        if(!GlobalConstants.hasUpdatedProductSchedules) {
            GlobalConstants.hasUpdatedProductSchedules=true;
            try {
                //fetch the opportunities where closed date is changed
                Map<Id,Opportunity> mapNewOpportunity = (Map<Id,Opportunity>) tp.newMap;
                Map<Id,Opportunity> mapOldOpportunity = (Map<Id,Opportunity>) tp.oldMap; 
                List<OpportunityLineItemSchedule__c> lstOLISToBeChanged = new List<OpportunityLineItemSchedule__c>();
                Integer fiscalStartMonth = UtilityClass.FiscalStartMonth;
                List<opportunityLineItemSchedule__c> lstOppyProdScheduleToUpdate = new List<opportunityLineItemSchedule__c>();
                Set<String> setPricingYear = new Set<String>();
                Set<Id> setProductIds = new Set<Id>();
                Map<Id,String> mapOppyFiscal = new Map<Id,String>();
                for(Opportunity oppy : mapNewOpportunity.values()) {
                    Opportunity oldOppy = mapOldOpportunity.get(oppy.Id);
                    if(oldOppy!=null && oldOppy.CloseDate!=oppy.CloseDate && oppy.contractStartDate__c==null) {
                        //calculate fiscal year of old closedate and new close date
                        //Integer oldOppyFiscal = UtilityClass.calculateFYFromDate(oldOppy.closeDate, fiscalStartMonth);
                        //if(oldOppyFiscal!=newOppyFiscal) {
                        Integer newOppyFiscal = UtilityClass.calculateFYFromDate(oppy.closeDate, fiscalStartMonth);
                        mapOppyFiscal.put(oppy.Id,String.valueOf(newOppyFiscal));
                        //}
                    }
                    
                }
                System.debug('@PD--mapOppyFiscal--'+ mapOppyFiscal);
                if(mapOppyFiscal!=null && !mapOppyFiscal.IsEmpty()) {
                    //query related opportunity product schedule records to update
                    Map<String,ProductSchedule__c> mapMultiKeyProductSchedule = new Map<String,ProductSchedule__c>();
                    lstOLISToBeChanged = [Select id, DiscountPercent__c,DiscountAmount__c,DiscountType__c,ExternalListPrice__c,
                                                 InstallmentYears__c, OpportunityProductID__c,PriceBookListPrice__c, ProductSchedule__r.Product__c,ProductSchedule__c,
                                                 ProductSchedule__r.ProductTerm__c, ProductSchedule__r.Year__c,
                                                 SalesPrice__c, TotalPrice__c, Quantity__c,AnnualizedDiscountAmount__c, AnnualizedUnitPrice__c, 
                                                 AnnualizedTotalAmount__c, ProRatedDiscountAmount__c, ProRatedUnitPrice__c,Opportunity__c
                                                 from OpportunityLineItemSchedule__c
                                                 where Opportunity__c IN: mapOppyFiscal.keyset()
                                                 order by InstallmentYears__c ASC];
                    System.debug('@PD--lstOLISToBeChanged--'+lstOLISToBeChanged);
                    List<ProductSchedule__c> lstProdSchedules = [Select id,Product__c,InstallmentYear__c,PricingYear__c,Year__c,ProductTerm__c,ListPrice__c 
                                                                    from ProductSchedule__c  
                                                                    where isactive__c = true AND PricingYear__c IN:mapOppyFiscal.values() 
                                                                    AND Product__c IN (Select Product2ID from OpportunityLineItem where OpportunityID in:mapOppyFiscal.keyset() ) 
                                                                    order by InstallmentYear__c,ProductTerm__c ASC];
                    System.debug('@PD--lstProdSchedules--'+lstProdSchedules);
                    if(lstProdSchedules!=null && !lstProdSchedules.isEmpty()) {
                        for(ProductSchedule__c ps : lstProdSchedules) {
                            String PSKey = String.valueOf(ps.Product__c) + ps.PricingYear__c + ps.Year__c + ps.ProductTerm__c ;
                            mapMultiKeyProductSchedule.put(PSKey,ps);
                        }
                        System.debug('@PD--mapMultiKeyProductSchedule--'+mapMultiKeyProductSchedule);
                        for(OpportunityLineItemSchedule__c olis : lstOLISToBeChanged) {
                            String OlisPSKey = String.valueOf(olis.ProductSchedule__r.Product__c) + mapOppyFiscal.get(olis.Opportunity__c) + olis.ProductSchedule__r.Year__c + olis.ProductSchedule__r.ProductTerm__c;
                            System.debug('--@PD OlisPSKey--'+OlisPSKey );
                             if(mapMultiKeyProductSchedule!=null && mapMultiKeyProductSchedule.containsKey(OlisPSKey)) {
                             
                                ProductSchedule__c ps = mapMultiKeyProductSchedule.get(OlisPSKey);
                                olis.ProductSchedule__c = ps.Id;
                                olis.InstallmentYears__c = ps.InstallmentYear__c;
                                olis.PriceBookListPrice__c = ps.ListPrice__c; 
                                lstOppyProdScheduleToUpdate.add(olis);
                            }
                        }
                        System.debug('@PD--lstOppyProdScheduleToUpdate--'+lstOppyProdScheduleToUpdate);
                        update lstOppyProdScheduleToUpdate;
                    
                    }                             
                 
                }
            }
            catch(Exception ex) {
               UtilityClass.createApexLogRecord(ex,'OpportunityMethods','updateFiscalOnChangeOfCloseDate');  
            }            
        }

    }
    //-----------------------------
    // @author: Paras Dhingra
    // @date: 21st July 2018
    // @param: TriggerParameters
    // @description: SFDC1-7059, SFDC1-7060 - Adding validations for auto renew and opening certain fields from editing
    // This method will be called in before update trigger Events.
    // @return: None
    //------------------------------
    public static void opportunityValidations(TriggerParameters tp) {
        //the validation is not fired directly from opportunity change
        if(GlobalConstants.hasTriggeredFromOpportunityProduct) {
            return;
        }
        if(GlobalConstants.hasBeenValidatedOnce) {
            return;
        }
        GlobalConstants.hasBeenValidatedOnce = true;
        //get logged in user profile name
        String profileName = UtilityClass.LoggedInUserProfileName;
        System.debug('@PD--Profilename--'+profileName);
        //get all the valid fields on this object
        Map <String, Schema.SobjectField > oppyFields = Opportunity.sObjectType.getDescribe().fields.getMap();
        //check if user is admin then do not process further
        if(profileName=='IHSMarkit System Admin' || profileName =='System Administrator') {
            //no validation checks are required for system admins
            return;
        }
        //control reached here not admin
        //fetch custom opportunity validation custom settings
        List<OpportunityValidationFields__c> oppyValidationFields = OpportunityValidationFields__c.getAll().values();
        Set<String> setHasChangesAPIs = new Set<String>();
        Set<String> setDoesNotHaveChangesAPIs = new Set<String>();
        for(OpportunityValidationFields__c ovf : oppyValidationFields) {
            String apiname = ovf.APIName__c.toLowerCase();
            if(ovf.RuleName__c=='AutoRenewHasChanges') {
                setHasChangesAPIs.add(apiname);
            }
            if(ovf.RuleName__c=='AutoRenewDoesNotHaveChanges') {
                setDoesNotHaveChangesAPIs.add(apiname);
            }
        }
        //iterate the opportunity and validate each of them
        for(Opportunity oppy : (List<Opportunity>) tp.newList) {
            Boolean hasError = false;
            Boolean isAllowed = false;
            //fetch old opportunity
            Opportunity oldOppy = (Opportunity) tp.OldMap.get(oppy.Id);
            //check if the auto-renew is checked then proceed for further checks
            if(oppy.AutoRenewal__c==true) {
               //make further checks
               System.debug('@pd--profilename--'+profileName);
               if(profileName.containsIgnoreCase('General') || profileName.containsIgnoreCase('Sales Ops') || profileName.containsIgnoreCase('Sales Coordinator') ) {
                   isAllowed=true;
               }
               if(!isAllowed) {
                   //not allowed to edit the opportunity
                   oppy.addError(System.Label.AutoRenewOppyAccessError);// TODO add label
                   //no further processing required on this oppy record
                   continue;
               }
               for(string fieldName : oppyFields.keySet()) {
                    Schema.DescribeFieldResult dfr = oppyFields.get(fieldName).getDescribe();
                    if(oldOppy.get(fieldName)!=oppy.get(fieldName) && !dfr.IsCalculated()) {
                    //locked field edited
                        if(oppy.DoesThisAutoRenewalHaveChanges__c && !setHasChangesAPIs.contains(fieldName)) {
                            //rule specific custom message can be added later on
                            System.debug('@PD--Error Field--'+fieldName);
                            hasError = true;
                            break;
                        }
                        if(!oppy.DoesThisAutoRenewalHaveChanges__c && !setDoesNotHaveChangesAPIs.contains(fieldName)) {
                            //rule specific custom message can be added later on
                            System.debug('@PD--Error Field2--'+fieldName);
                            hasError = true;
                            break;
                        }
                    }
                }
            }
            //check if if oppy has error
            if(hasError) {
                oppy.addError(System.Label.AutoRenewHasChangesOppyError); // todo add label    
            }
            
        }
    
    }
	
	//-----------------------------
    // @author: Anjani Shukla
    // @date: 23 July 2018
    // @param: TriggerParameters
    // @description: SFDC1-5864 - Cumulative Contract Value
    //                            Migrating Process builder "Cumulative Contract Value" &  
    //                            "Clear Total Cumulative Contract Value". 
	//
    // This method will be called in afterupdate trigger Events.
    // @return: None
    //------------------------------
    public static void updateCumulativeContract(TriggerParameters tp) {
        try {
            if(tp.tEvent == TriggerParameters.TriggerEvent.AfterUpdate) {  
            //fetch the opportunities where closed date is changed
            List<Opportunity> newOptyLst = (List<Opportunity>) tp.newList;
            Map<Id,Opportunity> mapOldOpportunity = (Map<Id,Opportunity>) tp.oldMap; 
            Set<Id> contractBeingRenewedLst = new Set<Id>();
            
            //The Cumulative Contract Value should update on the Contract when 
            //Auto Renewal = True and Stage = Completed.
                if(newOptyLst != null) {
                    for(Opportunity newOpty: newOptyLst) {
                        //Addition Renewal Contract Value from Originating Contract Cumulative Contract Value.
                        if(newOpty.AutoRenewal__c && !newOpty.DoesThisAutoRenewalHaveChanges__c &&
                           newOpty.StageName != mapOldOpportunity.get(newOpty.id).StageName &&
                           newOpty.StageName == '6W-Renewal Won' &&
                           newOpty.ContractBeingRenewed__c != null
                          ) {
                        	//update
                        	contractBeingRenewedLst.add(newOpty.ContractBeingRenewed__c);
                            
                        }
                        //Subtract Renewal Contract Value from Originating Contract Cumulative Contract Value.
                        else if(newOpty.AutoRenewal__c && !newOpty.DoesThisAutoRenewalHaveChanges__c &&
                           newOpty.StageName != mapOldOpportunity.get(newOpty.id).StageName &&
                           (newOpty.StageName == '3-Renewal Pending' || newOpty.StageName == '5-Renewal Contracting') &&
                           newOpty.ContractBeingRenewed__c != null
                          ) {
                        	//update
                        	contractBeingRenewedLst.add(newOpty.ContractBeingRenewed__c);
                            
                              
                        }
                    }    
                }
                
                
                //get Contract details
                Map<Id,Contract> contractRenewedMap = new Map<Id,Contract>();
                //get Details for Contract being Renewed
                if(contractBeingRenewedLst != null && !contractBeingRenewedLst.isEmpty() ) {
                	contractRenewedMap = new Map<Id,Contract>([select Id,AllAssociatedTotalOpportunityValue__c,
                                                               AutoRenewal__c,ContractStatus__c,
                                                               FirstYearContractValue__c,
                                                               Name,Opportunity__c,Status,
                                                               Opportunity__r.ContractBeingRenewed__c,
                                                               Opportunity__r.StageName,
                                                               Opportunity__r.DoesThisAutoRenewalHaveChanges__c,
                                                               Opportunity__r.Amount__c,TotalContractValue__c
                                                               from Contract 
                                                               where ID IN: contractBeingRenewedLst ]);	    
                }
                
                system.debug('contractRenewedMap==>'+contractRenewedMap);
                
                
                //List to update
                List<Contract> updateContractLst = new List<Contract>();
                
                if(newOptyLst != null) {
                    for(Opportunity opty: newOptyLst) {
                        //Addition - when renewal opporutnity is moved to 6W, then add opty amount to contract cumulative field 
                        if(contractBeingRenewedLst != null && opty.StageName == '6W-Renewal Won') {
                            	Contract updateContract = new Contract(id=contractRenewedMap.get(opty.ContractBeingRenewed__c).id);   
                                updateContract.AllAssociatedTotalOpportunityValue__c = contractRenewedMap.get(opty.ContractBeingRenewed__c).AllAssociatedTotalOpportunityValue__c 
                                                                                       + opty.Amount__c; 
                                updateContractLst.add(updateContract);
                                system.debug('updateContract==>'+updateContract);
                            }
                            //Subtract - when renewal opporutnity is moved to renewal contracting or renewal pending from 6W, then subtract opty amount from //contract cumulative field
                            else if(contractBeingRenewedLst != null && 
                               mapOldOpportunity.get(opty.id).stagename == '6W-Renewal Won' &&
                               opty.StageName != mapOldOpportunity.get(opty.id).stagename && 
                               (opty.StageName == '3-Renewal Pending' || 
                                opty.StageName == '5-Renewal Contracting')
                              ) {
                                Contract updateContract = new Contract(id=contractRenewedMap.get(opty.ContractBeingRenewed__c).id);   
                                updateContract.AllAssociatedTotalOpportunityValue__c = contractRenewedMap.get(opty.ContractBeingRenewed__c).AllAssociatedTotalOpportunityValue__c 
                                                                                       - opty.Amount__c; 
                                updateContractLst.add(updateContract);
                                system.debug('updateContract==>'+updateContract);
                            }
                       }
                    } 
                
                    if(updateContractLst != null) {
                    	update updateContractLst;    
                    }
                } 
        }
        catch(Exception ex) {
            UtilityClass.createApexLogRecord(ex,'OpportunityMethods','updateCumulativeContract');  
        }            
    }
    //-----------------------------
    // @author: Prachi Bhasin
    // @date: 1st August 2018
    // @param: TriggerParameters
    // @description: SFDC1-9500 - When 'Revisit' checkbox is unchecked, the probability of opportunity should be rolled back to previous value
    // This method will be called in before update trigger Events.
    // @return: None
    //------------------------------
    public static void revisitOpportunityStageChanges(TriggerParameters tp) {
        try {
            Map<Id,Opportunity> mapNewOpportunity = (Map<Id,Opportunity>) tp.newMap;
            Map<Id,Opportunity> mapOldOpportunity = (Map<Id,Opportunity>) tp.oldMap;
            List<Opportunity> lstOppToBeUpdated = new List<Opportunity>();
            for(Opportunity opp: mapNewOpportunity.values()) {
                if(opp.Revisit__c ==FALSE && opp.Revisit__c != mapOldOpportunity.get(opp.Id).Revisit__c) {
                    lstOppToBeUpdated.add(opp);
                }           
            }
            if(lstOppToBeUpdated!= NULL && lstOppToBeUpdated.size()>0) {
                //List<OpportunityStage> oppStage = [Select Id, ApiName, DefaultProbability, MasterLabel from OpportunityStage];
                Map<String, Decimal> mapStageProbability = new Map<String,Decimal>();
                for(OpportunityStage oppStage: [Select Id, ApiName, DefaultProbability, MasterLabel from OpportunityStage]) {
                    mapStageProbability.put(oppStage.MasterLabel, oppStage.DefaultProbability);
                }
                System.debug('mapStageProbability---'+mapStageProbability);
                for(Opportunity opp:lstOppToBeUpdated) {
                    opp.Probability = mapStageProbability.get(opp.StageName);               
                }
            }
        }
        catch(Exception ex) {
            UtilityClass.createApexLogRecord(ex,'OpportunityMethods','updateCumulativeContract');  
        }
    }
    //-----------------------------
    // @author: Prachi Bhasin
    // @date: 1st August 2018
    // @param: TriggerParameters
    // @description: SFDC1-9500 - When 'Revisit' checkbox is unchecked, the task corresponding to 'Revisit' should be marked as completed.
    // This method will be called in after update trigger Events.
    // @return: None
    //------------------------------
    public static void revisitOpportunityTaskChanges(TriggerParameters tp) {
        try {
            Map<Id,Opportunity> mapNewOpportunity = (Map<Id,Opportunity>) tp.newMap;
            Map<Id,Opportunity> mapOldOpportunity = (Map<Id,Opportunity>) tp.oldMap;
            List<Opportunity> lstOppWhereRevisitUnchecked = new List<Opportunity>();
            for(Opportunity opp: mapNewOpportunity.values()) {
                if(opp.Revisit__c ==FALSE && opp.Revisit__c != mapOldOpportunity.get(opp.Id).Revisit__c) {
                    lstOppWhereRevisitUnchecked.add(opp);
                }           
            }
            if(lstOppWhereRevisitUnchecked!=null && lstOppWhereRevisitUnchecked.size()>0) {
                List<Task> lstTaskToBeUpdated = new List<Task>();
                lstTaskToBeUpdated = [Select Id, Status, TaskToRevisitOpportunity__c from Task where WhatId IN :lstOppWhereRevisitUnchecked And TaskToRevisitOpportunity__c = true];
                for(Task taskObj : lstTaskToBeUpdated) {
                    taskObj.Status = 'Completed';
                }
                if(lstTaskToBeUpdated!= NULL && lstTaskToBeUpdated.size()>0) {
                    update lstTaskToBeUpdated;
                }
            }
        }
        catch(Exception ex) {
            UtilityClass.createApexLogRecord(ex,'OpportunityMethods','updateCumulativeContract');  
        }
    }
	//-----------------------------
    // @author: Jagadesh Kumar
    // @date: 31 Jul 2018
    // @param: TriggerParameters
    // @description: SFDC1-5228 - Populate Primary Contact Name on Opportunity 
    // @return: None
    //------------------------------
    public static void setContactRolePrimary(TriggerParameters tp) {
        System.debug('@HS setContactRolePrimary() Trigger Method Begins');
        Set<Id> opptyIds = new Set<Id>();
        for(Opportunity oppy : (List<Opportunity>) tp.newList) {
            if(oppy.IsClosed == false) {
                opptyIds.add(oppy.Id);
            }
        }
        if(opptyIds.size() > 0) {
            // retrieve all Opportunity Contact Role against the Opportunities
            Map<Id,OpportunityContactRole> mapOppCR = new Map<ID,OpportunityContactRole>([Select Id, IsPrimary, OpportunityId, Contact.Name from OpportunityContactRole where IsPrimary = true and OpportunityId in :opptyIds]);
            // if Opportunity Contact Role records found
            if(!mapOppCR.isEmpty()) {
                // loop through all Opportunity Contact Role records found
                for(OpportunityContactRole oppCR : mapOppCR.values()) {
                    Opportunity opp = (Opportunity)tp.newMap.get(oppCR.OpportunityId);
                    if(opp!= null && opp.PrimaryContact__c != oppCR.Contact.Name) {
                        opp.PrimaryContact__c = oppCR.Contact.Name;
                    }
                }
            }
        }
        System.debug('@HS setContactRolePrimary() Trigger Method Ends');
    }
}