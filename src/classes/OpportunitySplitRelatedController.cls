//
 // @Author: Paras Dhingra
 // @Date: 11th Oct 2017
 // @Description: SFDC1-692 Controller for OpportunitySplitRelatedList lightning component 
 // @company: IHS Markit
 //
public class OpportunitySplitRelatedController {
      //
      // @author: Paras Dhingra
      // @date: 11th Oct 2017
      // @description: SFDC1-692 method to wrap oppy and splits for lightning component
      // @param: String
      // @return: OppySplitWrapper
      // @companyname: IHS Markit
      //
    @auraEnabled 
    public static OppySplitWrapper getRelatedOppySplits(String oppyId) {
    List<Opportunity> lstOppy = [Select id, Name, Amount,CurrencyIsoCode, Owner.Name, OwnerId, (Select Id, SplitAmount, SplitOwnerId, SplitOwner.Name, SplitPercentage,
                        SplitType.DeveloperName,SplitNote,SalesRegion__c from OpportunitySplits order by SplitOwner.Name asc) 
                        from Opportunity where Id=:oppyId];
    OppySplitWrapper oppySplitWrapObj = new OppySplitWrapper();
    oppySplitWrapObj.oppy = lstOppy[0];
    oppySplitWrapObj.mapSplitTypes = getSplitTypeIds();
    return oppySplitWrapObj;
    
    }
      //
      // @author: Paras Dhingra
      // @date: 11th Oct 2017
      // @description: SFDC1-692 method returns a map os splitTypes
      // @param: null
      // @return:  Map<String,Id>
      // @companyname: IHS Markit
      //
    public static Map<String,Id> getSplitTypeIds() {
        List<OpportunitySplitType> lstOppySplitTypes = [Select Id, DeveloperName from OpportunitySplitType where IsActive=true];
        Map<String,Id> mapSplitTypes = new Map<String,Id>();
        for(OpportunitySplitType oppySplitType :lstOppySplitTypes) {
            mapSplitTypes.put(oppySplitType.DeveloperName, oppySplitType.Id);
        }
        return mapSplitTypes;
    }
    
      //
      // @author: Paras Dhingra
      // @date: 26th Oct 2017
      // @description: SFDC1-692 method to save all overlay opportunity splits
      // @param: List<OpportunitySplit>, String, List<OpportunitySplit>
      // @return: OppySplitResultWrapper
      // @companyname: IHS Markit
      //
    @auraEnabled
    public static OppySplitResultWrapper saveOverlaySplits(List<OpportunitySplit> lstOppySplit, String oppyId, List<OpportunitySplit>lstOppySplitDel) {
        String message = 'Splits updated successfully!!';
        System.debug('-lstOppySplitDel--'+lstOppySplitDel);
        OppySplitResultWrapper resultWrapper = new OppySplitResultWrapper();
        Savepoint sp = Database.setSavepoint();
        try{
            List<OpportunitySplit> lstOppySplitToInsert = new List<OpportunitySplit>();
            List<OpportunitySplit> lstOppySplitToUpdate = new List<OpportunitySplit>();
             if(lstOppySplit!=null && !lstOppySplit.isEmpty()) {
                for(OpportunitySplit oppySplit: lstOppySplit) {
                    if(oppySplit.Id==null) {
                        lstOppySplitToInsert.add(oppySplit);
                    }else {
                        lstOppySplitToUpdate.add(oppySplit);
                    }
                }
                if(lstOppySplitToInsert!=null && !lstOppySplitToInsert.isEmpty()) {
                    insert lstOppySplitToInsert;
                }
                if(lstOppySplitToUpdate!=null && !lstOppySplitToUpdate.isEmpty()) {
                    update lstOppySplitToUpdate;
                }
            }
            if(lstOppySplitDel!=null && !lstOppySplitDel.isEmpty()) {
                delete lstOppySplitDel;
            }
             // return updated result wrapper
            resultWrapper.message = message;
            resultWrapper.lstResultOppySplits = returnUpdatedOppySplits(oppyId, 'Overlay');
            updateOppyTeamMemberAccess(resultWrapper.lstResultOppySplits, oppyId);
            
        }catch(Exception e) {
            message = 'Error occurred!! Please contact salesforce helpdesk for more information. Error details: '+e;
            
            Database.rollback(sp);
        }
        resultWrapper.message = message;
        return resultWrapper;
    }
      //
      // @author: Paras Dhingra
      // @date: 27th Oct 2017
      // @description: SFDC1-692 method to save all revenue opportunity splits
      // @param: List<OpportunitySplit>, String,  List<OpportunitySplit>
      // @return:  OppySplitResultWrapper
      // @companyname: IHS Markit
      //
    @auraEnabled 
    public static OppySplitResultWrapper saveRevenueSplits(List<OpportunitySplit> lstOppySplit, String oppyId) {
        String message = 'Splits updated successfully!!';
        Savepoint SP = Database.setSavepoint();
        Map<String,Decimal> mapSplitOwnerPercentage = new Map<String,Decimal>();
        OppySplitResultWrapper resultWrapper = new OppySplitResultWrapper();
        Set<Id> setSplitOwnerRemoved = new Set<Id>();
        Set<Id> setSplitOwnerAdded = new Set<Id>();
        Set<Id> setSplitOwnerUpdated = new Set<Id>();
        try {
            //Query Opportunity owner
            Opportunity oppy = [Select id,OwnerId from Opportunity where Id=:oppyId];
            //First clear all the existing revenue splits except that of owner
            List<OpportunitySplit> lstOppySplitToDelete = [Select id,SplitOwnerId from OpportunitySplit where opportunityId=:oppyId and SplitOwnerId!=:oppy.OwnerId
                                                            and splitType.DeveloperName = 'Revenue'];
            if(lstOppySplitToDelete!=null && !lstOppySplitToDelete.isEmpty()) {
                for(OpportunitySplit oppySplit:lstOppySplitToDelete ) {
                    setSplitOwnerRemoved.add(oppySPlit.SplitOwnerId);
                }
                delete lstOppySplitToDelete;
            }
            // create a map of SplitOwnerId and SplitPercentage
            List<OpportunitySplit> lstOppySplitToInsert = new List<OpportunitySplit>();
            for(OpportunitySplit os: lstOppySplit) {
                mapSplitOwnerPercentage.put(os.SplitOwnerId, os.SplitPercentage);
                if(os.SplitOwnerId!=oppy.OwnerId) {
                    OpportunitySplit oppySplitToAdd = new OpportunitySplit();
                    oppySplitToAdd.SplitOwnerId = os.SplitOwnerId;
                    oppySplitToAdd.opportunityId = oppy.Id;
                    oppySplitToAdd.SplitPercentage = 0.0;
                    lstOppySplitToInsert.add(oppySplitToAdd);
                    setSplitOwnerUpdated.add(os.SplitOwnerId);
                    //if the split owner id is not present in already present set of Ids
                    if(!setSplitOwnerRemoved.contains(os.SplitOwnerId)) {
                        setSplitOwnerAdded.add(os.SplitOwnerId);
                    }
                    
                }
            }
            if(lstOppySplitToInsert!=null && !lstOppySplitToInsert.isEmpty()) {
                insert lstOppySplitToInsert;
            }
            // now update the OpportunitySplit based on SplitOwnerId
            List<OpportunitySplit> lstOppySplitFreshInserts = [Select Id, SplitOwnerId, SplitPercentage from OpportunitySplit where opportunityId=:oppyId
                                                                and splitType.DeveloperName = 'Revenue'];
            if(lstOppySplitFreshInserts!=null && !lstOppySplitFreshInserts.isEmpty()) {
                List<OpportunitySplit> lstOppySplitToUpdate = new List<OpportunitySplit>();
                for(OpportunitySplit os: lstOppySplitFreshInserts) {
                    if(mapSplitOwnerPercentage.containsKey(os.SplitOwnerId)) {
                        os.SplitPercentage = mapSplitOwnerPercentage.get(os.SplitOwnerId);
                        System.debug('--SplitPercentage--'+ os.SplitPercentage);
                        lstOppySplitToUpdate.add(os);
                    }
                }
                if(lstOppySplitToUpdate!=null && !lstOppySplitToUpdate.isEmpty()) {
                    update lstOppySplitToUpdate;
                }
            }
            // return updated result wrapper
            
            resultWrapper.lstResultOppySplits = returnUpdatedOppySplits(oppyId, 'Revenue');
            updateOppyTeamMemberAccess(resultWrapper.lstResultOppySplits, oppyId);
            // send email to split owners for the update
           //first remove the new inserts from 
           setSplitOwnerRemoved.removeAll(setSplitOwnerUpdated);
           
           System.debug('--setSplitOwnerRemoved--'+setSplitOwnerRemoved);
           System.debug('--setSplitOwnerAdded--'+setSplitOwnerAdded);
           sendNotificationToSplitOwners(setSplitOwnerRemoved,setSplitOwnerAdded,oppyId);
        }catch(Exception ex) {
            Database.rollback(SP);
            message='Error occurred!! Please contact salesforce helpdesk. Error details: '+ex;
            System.debug(ex.getMessage() + ex.getCause()+ ex.getLineNumber());
        }
        resultWrapper.message = message;
        return resultWrapper;
    }
      //
      // @author: Paras Dhingra
      // @date: 30th Oct 2017
      // @description: SFDC1-692 method to return list of updated oppySplits
      // @param: String,String
      // @return:  List<OpportunitySplit>
      // @companyname: IHS Markit
      //
    @TestVisible
    private static List<OpportunitySplit> returnUpdatedOppySplits(String oppyId, String developerName) {
      List<OpportunitySplit> lstUpdatedOppySplit = new List<OpportunitySplit>();
      lstUpdatedOppySplit = [Select Id, SplitAmount, SplitOwnerId, SplitOwner.Name, SplitPercentage,
                    SplitType.DeveloperName,SplitNote,SalesRegion__c from OpportunitySplit where opportunityId=:oppyId and SplitType.DeveloperName=:developerName order by SplitOwner.Name asc];
      return lstUpdatedOppySplit;
    }
      //
      // @author: Paras Dhingra
      // @date: 31st Oct 2017
      // @description: SFDC1-692 Update team role access to read/write for oppy split members
      // @param: List<OpportunitySplit>
      // @return:  null
      // @companyname: IHS Markit
      //
    @TestVisible
    private static void updateOppyTeamMemberAccess(List<OpportunitySplit> lstOppySplit, String OppyId) {
        Set<Id> setOppySplitMembers = new Set<Id>();
        if(lstOppySplit!=null && !lstOppySplit.isEmpty()) {
            for(OpportunitySplit os : lstOppySplit) {
                setOppySplitMembers.add(os.SplitOwnerId);
            }
            
            //query opportunity team members with read only access
            List<OpportunityTeamMember> lstOppyMemberToUpdate = [Select Id, OpportunityAccessLevel, UserId, OpportunityId from
                                                                OpportunityTeamMember where OpportunityId =:OppyId AND OpportunityAccessLevel ='Read'
                                                                AND UserId IN:setOppySplitMembers];
            if(lstOppyMemberToUpdate!=null && !lstOppyMemberToUpdate.isEmpty()) {
                for(OpportunityTeamMember otm : lstOppyMemberToUpdate) {
                    otm.OpportunityAccessLevel = 'Edit';
                }
                update lstOppyMemberToUpdate;
            }
        }
    }
      //
      // @author: Paras Dhingra
      // @date: 11th Jan 2018
      // @description: SFDC1-4326 Send notification to new and old split owners on split changes
      // @param: Set<Id>, Set<Id>, Id 
      // @return:  null
      // @companyname: IHS Markit
      //
      @TestVisible
      private static void sendNotificationToSplitOwners(Set<Id> deletedSplitOwners, Set<Id> insertedSplitOwners, Id oppyId) {
          if(deletedSplitOwners!=null || insertedSplitOwners!=null) {
              Map<Id,User> emailRecepientDetails = new Map<Id,User>([Select Id, Name, Email from User where Id IN:deletedSplitOwners OR Id IN:insertedSplitOwners ]);
              if(emailRecepientDetails!=null && !emailRecepientDetails.isEmpty()) {
                 //process names of the users to add to email
                 String []deletedUserNames=getUsersAsString(deletedSplitOwners,emailRecepientDetails,'Name');
                 String []addedUsernames = getUsersAsString(insertedSplitOwners,emailRecepientDetails,'Name');
                 //get information from Opportunity
                 List<Opportunity> oppy = [Select Id, Name, Account.Name, CloseDate, CreatedDate,Owner.Email,Description from Opportunity where Id=:oppyId];
                 //prepare and send email
                 String Description = oppy[0].Description==null?'':oppy[0].Description;
                 Messaging.SingleEmailMessage oppySplitUpdateEmail = new Messaging.SingleEmailMessage();
                 String messageBody = 'Hi All,<br/><p>Changes have been made to the Opportunity Split section for the following Opportunity.<br/>';  
                 messageBody+='The email is being sent to Team Members who have been added or removed from the Opportunity Split.</p><br/>';
                 messageBody+='<b>Opportunity Link:</b> <a href=\''+URL.getSalesforceBaseUrl().toExternalForm()+'/'+oppy[0].Id + '\'>'+oppy[0].Name+'</a> <br/>';
                 messageBody+='<b>Opportunity ID:</b> '+oppy[0].Id+ ' <br/>';
                 messageBody+='<b>Opportunity Name:</b> '+oppy[0].Name+ ' <br/>';
                 messageBody+='<b>Account:</b> '+oppy[0].Account.Name+ ' <br/>';
                 messageBody+='<b>Close Date:</b> '+oppy[0].CloseDate.format()+ ' <br/>';
                 messageBody+='<b>Created On:</b> '+oppy[0].CreatedDate.format()+ ' <br/>';
                 messageBody+='<b>Removed from Split:</b> '+deletedUserNames+ ' <br/>';
                 messageBody+='<b>Added to Split:</b> '+addedUsernames+ ' <br/>';
                 messageBody+='<b>Description:</b> <p>'+Description+ '</p> <br/>';
                 messageBody+='<br/>Thank You<br/><br/>';
                 messageBody+='<br/><h6>***This email has been automatically generated by Salesforce.com***</h6>';
                 //setup to addresses
                 String []deletedUserEmails = getUsersAsString(deletedSplitOwners,emailRecepientDetails,'Email');
                 String []addedUserEmails= getUsersAsString(insertedSplitOwners,emailRecepientDetails,'Email');
                 String []toAddress = new String[]{};
                 toAddress.addAll(deletedUserEmails);
                 toAddress.addAll(addedUserEmails);
                 oppySplitUpdateEmail.setToAddresses(toAddress);
                 oppySplitUpdateEmail.setHTMLBody(messageBody);
                 String[] ccAddress = new String[]{''+oppy[0].Owner.email};
                 oppySplitUpdateEmail.setCcAddresses(ccAddress);
                 oppySplitUpdateEmail.setSubject('Opportunity Split(s) have been updated for Opportunity:'+oppy[0].Name);
                 oppySplitUpdateEmail.setSenderDisplayName('IHS Markit Salesforce Support');
                 Messaging.sendEmail(new Messaging.SingleEmailMessage[] {oppySplitUpdateEmail});
                 
              } 
          }
      }
      //
      // @author: Paras Dhingra
      // @date: 11th Jan 2018
      // @description: SFDC1-4326 Helper method to process emails and user names from given user map
      // @param: Set<Id>, Map<Id, User>, String
      // @return:  String[]
      // @companyname: IHS Markit
      //
      private static String[] getUsersAsString(Set<Id> setUserId, Map<Id,User> mapUsers,String field) {
          String [] userNames = new String[]{};
          for(Id userId : setUserId ) {
              if(mapUsers.containsKey(userId)) {
                  if(field=='Name') {
                      userNames.add(mapUsers.get(userId).Name);
                  }
                  else {
                      userNames.add(mapUsers.get(userId).email);
                  }
                  
              }
          }
          return userNames;
          
      }
    public class OppySplitWrapper {
        @auraEnabled public Map<String,Id> mapSplitTypes;
        @auraEnabled public Opportunity oppy;
    }
    
    public class OppySplitResultWrapper {
        @auraEnabled public String message;
        @auraEnabled public List<OpportunitySplit> lstResultOppySplits;
    }
}