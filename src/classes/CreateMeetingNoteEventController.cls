/**
 * @Author:  Vishnu Vardhan
 * @Date:    12-oct-2017
 * @description: Apex class which is being used as controller for Meeting-Note's lightning components
 * 
 * @author Modified By: Hemant Shukla
 * @date: 2-Nov-2017
 * @description: Updated methods, removed unwanted legacy code and made necessary changes so MN get saved only at last step. 
 * @author Modified By: Hemant Shukla
 * @date: 11-Nov-2017
 * @description: Updated validateEventForMeetingCreation() method to add the object access check. 
 * @author Modified By: Hemant Shukla
 * @date: 8-Jan-2018
 * @description: Removed the inner cAttendee class and make it separate class after encountering issue on winter 18 for inner wrapper class taken as LC attribute. 
**/
public class CreateMeetingNoteEventController {
    
    /**
     * @Author:  Hemant Shukla
     * @Date:    31-oct-2017
     * @description: Inner class to return the response after sacing the MN data
    **/
    public class ResponseWrapper {
        @AuraEnabled
        public String mnId;
        
        @AuraEnabled
        public String message ;
        
        public ResponseWrapper(String mnId, String message) {
            
            this.mnId = mnId;
            this.message = message;
        }
    }
    
    /**
     * @Author: Hemant Shukla
     * @date: 27-oct-2017
     * @description: To validate if MN record can be created for an event
     * @param: recordId, event record Id
     * @return: String, appropriate message
    */
    @AuraEnabled
    public static String validateEventForMeetingCreation (String recordId) {
        Event eventObject = [Select e.WhatId, e.MeetingNote__c, e.IsChild, e.Id, e.AccountId From Event e where e.id =: recordId];
        String WhatId = eventObject.WhatId;
        String accountId = eventObject.AccountId;
        if (eventObject.isChild) {
            return 'This is a shared meeting that is automatically generated. '+
                'You can only create meeting notes on the original meeting event.';
        } else if (eventObject.MeetingNote__c!=null) {
            return 'This event is already linked to a meeting note.';
        } else if(String.isBlank(accountId) && String.isBlank(WhatId) ) {
            return 'Please link this event to an Account or Opportunity.';
        } else if(String.isNotBlank(WhatId) && 
                  !(WhatId.startsWith('001') || WhatId.startsWith('006'))) {
                      return 'Please link this event to an Account or Opportunity.'; 
        } else if(!Schema.SObjectType.MeetingNote__c.isCreateable() || !Schema.SObjectType.MeetingAttendee__c.isCreateable() || !Schema.SObjectType.RelatedOpportunity__c.isCreateable()) {
            return 'Insufficient access to create Meeting Note.';
                  } 
        return 'Create Meeting Note';
    }
    
    /**
     * @Author: Hemant Shukla
     * @date: 27-oct-2017
     * @description: To fill the name and few other fields in the back end of MN record
     * @param: eventId, event record Id
     * @return: MN instance
	 * @lastModifiedBy: Mohit Modi ,10 April 2018
	 * @lastmodified description : SFDC1-3843, Changing the Field Type of ProductFamily__c from Picklist to Lookup
    */
    @AuraEnabled
    public static MeetingNote__c getPrePopulatedMeetingNote (String eventId) { 
        
        Event event = [Select e.WhatId, e.AccountId, StartDateTime, /*ProductFamily__c */ ProductFamilyLookup__c,
                       Street__c, ZipPostalCode__c, StateProvince__c, City__c, Country__c From Event e 
                       where e.id =: eventId];
        
        MeetingNote__c meeting = new MeetingNote__c(Street__c = event.Street__c,
                                                    ZipPostalCode__c = event.ZipPostalCode__c,
                                                    StateProvince__c = event.StateProvince__c,
                                                    City__c = event.City__c,
                                                    Country__c = event.Country__c,
                                                    When__c = Date.valueof(event.StartDateTime)
                                                    );
        Account account = null;
        Opportunity opportunity = null;
        String accountId = event.AccountId;
        String whatId = event.whatid;
        
        if (WhatId != null && WhatId.startsWith('006')) {
            opportunity = [select Id, AccountId, Name from Opportunity where id =: WhatId];
            
        } else if (WhatId != null && WhatId.startsWith('001')) {
            //Both whatId and accountId will be almost same, but this will help in case
            // accountId is not populated for some reason
            accountId = WhatId;
        }
        
        if(accountId!=null){
            account = [select id, name from account where id = :accountId];
        }
        
        if (account !=null ) {
            meeting.Account__c = account.Id;
            meeting.Name = 'Meeting with '+account.name;
        } 
        
        if(opportunity !=null){
            meeting.Account__c = opportunity.AccountId;
            meeting.Opportunity__c =opportunity.Id;
            meeting.Name = System.now().date().format() +': Meeting for Opportunity: '+opportunity.name;
        } 
        
        /*if(event.ProductFamily__c != null) {
            meeting.ProductFamily__c = event.ProductFamily__c;
        }*/
        if(event.ProductFamilyLookup__c != null) {
            meeting.ProductFamilyLookup__c = event.ProductFamilyLookup__c ;
        }
        
        return meeting;
    }
    
    /**
     * @Author: Hemant Shukla
     * @date: 30-oct-2017
     * @description: To list the Opps in drop down so user can add them easily into MN as related Opps
     * @param: meetingNote, instance of MN
     * @return: Opportunity list to display on Lightning Component - 2nd screen
    */
    @AuraEnabled
    public static List<Opportunity> getOpportunititesListToAdd (MeetingNote__c meetingNote){
        List<Opportunity> oppyList;
        //MeetingNote__c meetingNote = [select id, Account__c, Opportunity__c from MeetingNote__c where id =: meetingNoteId];
        if(meetingNote.Opportunity__c!=null){
            oppyList = [select Id, Name 
                        from Opportunity where AccountId =: meetingNote.Account__c and 
                        Id != : meetingNote.Opportunity__c and IsClosed = false LIMIT 100];
            
        } else {
            oppyList = [select Id, Name 
                        from Opportunity where AccountId =: meetingNote.Account__c and IsClosed = false LIMIT 100]; 
        }
        Opportunity opp= new Opportunity(Name='--None--');
        if(oppyList.isEmpty()){
            oppyList.add(opp);
        } else {
            oppyList.add(0,opp);
        }
        return oppyList;
    }
    
    /**
     * @Author: Hemant Shukla
     * @date: 30-Oct-2017
     * @description: To add the Opp into Related Opps section of MN record
     * @param: 
     *  meetingNoteId: MN Id, if there
     *  opportunityId: Id of Opp to add
     * @return: Instance of Related Opp which is added in screen - 2nd screen
    */
    @AuraEnabled
    public static RelatedOpportunity__c addRelatedOpportunitiesForMeetingId(Id meetingNoteId, Id opportunityId){
        
        Opportunity opp = [Select id, Name, RecordType.Name, StageName 
                          From Opportunity 
                          Where id = :opportunityId];

        RelatedOpportunity__c ro = new RelatedOpportunity__c();
        ro.Opportunity__c = opp.id;
        ro.Opportunity__r = opp;
        return ro;
    }
    
    /**
     * @Author: Hemant Shukla
     * @date: 31-Oct-2017
     * @description: To add the attendees into MN
     * @param: meetingContactId, Id of user selected contact
     * @return: instance of cAttendee inner class which is used to display the addition on page - 3rd screen
    */
    @AuraEnabled
    public static cAttendee addMeetingAttendee(Id meetingContactId) { //, id meetingId removed param
    
        List<Contact> cList = [select Id, Name, JobTitle__c, Title, Email, Account.Name from Contact where Id =: meetingContactId and Account.Name != null];
        List<cAttendee> attendeeList = new List<cAttendee>();
        
        if(cList.size() == 1) {
            Contact c = cList[0];
            if(c.Email != null){
                MeetingAttendee__c ma = new MeetingAttendee__c();
                if(c.Email.contains('markit.com') || c.Email.contains('markitserv.com') || c.Email.contains('ihsmarkit.com') || c.Email.contains('ihs.com')) {  
                    attendeeList.add(New cAttendee(ma,c,true)); 
                }else{
                    attendeeList.add(New cAttendee(ma,c,false));
                }
            }
        }
        
        if(!attendeeList.isEmpty())
            return attendeeList[0] ;
        else
            return null;
    }
    
    /**
     * @Author: Hemant Shukla
     * @date: 31-Oct-2017
     * @description: To add the attendees into MN
     * @param: 
     *  eventId: Event Id from where its launched 
     *  meetingNote: Instance of MN record
     * @return: list of cAttendee inner class which is used to display the addition on page - 3rd screen
    */
    @AuraEnabled
    public static List<cAttendee> getMeetingAttendees (Id eventId, MeetingNote__c meetingNote){
        
        Set<Id> contactIdSet = new Set<Id>();
        Event event = [select Owner.Email, id from event where id =: eventId];
        List<Contact> currentUserContactList = [select Id, Name, JobTitle__c, Title, Email from Contact where Email =: event.Owner.Email];
        
        if(!currentUserContactList.isEmpty() && currentUserContactList.size() == 1)
            contactIdSet.add(currentUserContactList[0].id);
        
        List<cAttendee> attendeeList = new List<cAttendee>();
        for(EventRelation er : [select RelationId, EventId, Relation.FirstName, Relation.LastName, Relation.Email 
                                from EventRelation where IsWhat = false and EventId =: eventId]) {
                                    
            contactIdSet.add(er.RelationId);
        }
        
        //This block will never run for new MN
        List<MeetingAttendee__c> alreadyAddedAttendees = new List<MeetingAttendee__c>();
        if(meetingNote.id !=null)
            alreadyAddedAttendees = [select id, Contact__c from MeetingAttendee__c where MeetingNote__c =: meetingNote.id];
        
        
        // Creating for the first time, Insert event owner and EventRelation contact into attendees
        if(alreadyAddedAttendees.isEmpty()){
             
            Map<Id,Contact> contactMap = new Map<Id,Contact>([select Id, Name, Email from Contact where Id IN: contactIdSet and Account.Name != null]);
            for (Contact c : contactMap.values()){
                MeetingAttendee__c ma = new MeetingAttendee__c();
                if(!String.isEmpty(c.Email)) {
                    if(c.Email.contains('markit.com') || c.Email.contains('markitserv.com') || c.Email.contains('ihsmarkit.com') || c.Email.contains('ihs.com')){
                        attendeeList.add(New cAttendee(ma,c,true));
                    }
                    else{
                        attendeeList.add(New cAttendee(ma,c,false));
                    }
                }
            }
        } 
        
        return attendeeList;
    }
    
    /**
     * @Author: Hemant Shukla
     * @date: 2-Nov-2017
     * @description: To add the attendees into MN
     * @param: 
     *  meetingNote: instance of MN
     *  lstRelatedOppIds: Ids of Opps which are need to be added as Related Opps
     *  jsonLstAttendees: JSON of List<cAttendee>, sent from LC
     *  eventId: Id of event from where its launched
     * @return: instance of cAttendee inner class which is used to display the addition on page - 3rd screen
    */
    @AuraEnabled
    public static ResponseWrapper saveMeetingNotesAndRelatedData (MeetingNote__c meetingNote,  List<String> lstRelatedOppIds, String jsonLstAttendees, String eventId){
        
        List<cAttendee> lstAttendees = new List<cAttendee>();
        
        if(!String.isEmpty(jsonLstAttendees))
            lstAttendees = (List<cAttendee>) JSON.deserializeStrict(jsonLstAttendees, List<cAttendee>.class);
        
        //Setting the default
        ResponseWrapper response = new ResponseWrapper(null, 'success');
        
        //Creating a savepoint for rolling back if there is any error in DML for related records
        Savepoint sp = Database.setSavepoint();
        
        try{
            
            insert meetingNote;
            
            //Create relatedOpportunites record
            List<RelatedOpportunity__c> relatedOpps = new List<RelatedOpportunity__c>();
            if(!lstRelatedOppIds.isEmpty()){
                for(String oppId : lstRelatedOppIds){
                    RelatedOpportunity__c ro = new RelatedOpportunity__c(Opportunity__c = oppId, MeetingNote__c = meetingNote.Id);
                    relatedOpps.add(ro);
                }
                
                insert relatedOpps;
            }
            
            //Create attendees
            if(!lstAttendees.isEmpty()){
                List<MeetingAttendee__c> MNAttendees = new List<MeetingAttendee__c>();
                for(cAttendee c : lstAttendees){
                    
                    c.attendee.MeetingNote__c = meetingNote.Id; 
                    MNAttendees.add(c.attendee);
                    
                    if(c.attendee.IHSMarkitEmployee__c) {
                        meetingNote.IHSMarkitAttendeeNames__c += c.contact.Name + ' ('+c.contact.Title+'), ';
                    } else {
                        meetingNote.AttendeeNames__c += c.contact.Name + ' ('+c.contact.Title+'), ';
                    }
                }
                
                insert MNAttendees;
                update meetingNote;
            }
            
            //Update event record to relate with newly created Meeting Note
            if(!string.isEmpty(eventId)){
                update new Event(Id = eventId, MeetingNote__c = meetingNote.id); 
            }
            
            response.mnId = meetingNote.Id; 
            return response;
            
        }
        catch(exception e){
            system.debug('======================exception e' + e.getMessage());
            Database.rollback(sp);
            response.message = e.getMessage();
            return response;
        }
    }    
}