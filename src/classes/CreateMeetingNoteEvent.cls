/**
 * @Author: Twan v.d. Loo
 * @Date: 24-09-2015
 * @Purpose: Adds meeting note to Event
 * 
 * @author Modified By: Vishnu Vardhan
 * @date: 7 Jul 2017
 * @description: Migrated class from existing Markit System and added comments. 
 * @lastModifiedBy: Prachi Bhasin for SFDC1-2017 bug fix
 * @lastModifiedSprint: Sprint 7
 * @lastModifiedBy: Mohit Modi ,10 April 2018
 * @lastmodified description : SFDC1-3843, Changing the Field Type of ProductFamily__c from Picklist to Lookup
**/
public class CreateMeetingNoteEvent {
    
    public List<cAttendee> attendeeList {get;set;}
    public List<cRelatedOpportunity> relatedOpportunitiesList {get;set;}
    
    public Integer deleteNum {get;set;}
    public Integer deleteOpp {get;set;}
    
    public string infoType {get;set;}
    public Account account {get;set;}
    public string eventId {get;set;}
    public Opportunity opportunity {get;set;}
    public MeetingNote__c meeting {get;set;}
    public Boolean displayOppySelection {get;set;}
    public Event event {get;set;}
    
    
    // OPPY RELATED
    public List<Opportunity> oppyList = new List<Opportunity>();
    public String selectedOpportunity {get;set;}
    
    public CreateMeetingNoteEvent () {
        
        meeting = new MeetingNote__c();
        infoType = System.currentPageReference().getParameters().get('infoType');        
        eventId = System.currentPageReference().getParameters().get('eventId');
        
        event = [select Id, Owner.Email, Location, StartDateTime, /*ProductFamily__c*/ ProductFamilyLookup__c, Street__c, ZipPostalCode__c, StateProvince__c, City__c, Country__c from Event where id =: eventId]; 
        
        if(event != null) {
            meeting.Street__c = event.Street__c;
            meeting.ZipPostalCode__c = event.ZipPostalCode__c;
            meeting.StateProvince__c = event.StateProvince__c;
            meeting.City__c = event.City__c;
            meeting.Country__c = event.Country__c;
            meeting.When__c = Date.valueof(event.StartDateTime);
        }
        
        if(infoType == 'accOnly') {
            account = [select id, name from Account where id =: System.currentPageReference().getParameters().get('accId')];
            meeting.Name = 'Meeting with '+account.name;
            
            oppyList = [select Id, AccountId, Account.Name, Name, RecordType.Name, StageName from Opportunity where AccountId =: account.Id and IsClosed = false LIMIT 100]; 
            
            displayOppySelection = true;            
        } else if (infoType == 'oppOnly' || infoType == 'bothFilled') {
            opportunity = [select Id, AccountId, Account.Name, Name, RecordType.Name, StageName from Opportunity where id =: System.currentPageReference().getParameters().get('oppId')];            
            meeting.Name = System.now().date().format() +': Meeting for Opportunity: '+opportunity.name;
            displayOppySelection = false;
            oppyList = [select Id, AccountId, Account.Name, Name, RecordType.Name, StageName from Opportunity where AccountId =: opportunity.AccountId and Id != :opportunity.Id and IsClosed = false LIMIT 100];
        }          
    }
    
    /**
     * @Author: Vishnu Vardhan
     * @date: 7 Jul 2017
     * @description: This method adds a recipient to the list.
     * @param: null
     * @return: void
     */
    public void addRow() {
        List<Contact> cList = [select Id, Name, JobTitle__c, Title, Email, Account.Name from Contact where Id =: meeting.ContactLookup__c and Account.Name != null];
        
        if(cList.size() == 1) {
            Contact c = cList[0];
            if(c.Email != null){
                if(c.Email.contains('markit.com') || c.Email.contains('markitserv.com') || c.Email.contains('ihsmarkit.com') || c.Email.contains('ihs.com')) {  
                    attendeeList.add(New cAttendee(new MeetingAttendee__c(),c,true)); 
                }else{
                    attendeeList.add(New cAttendee(new MeetingAttendee__c(),c,false));
                }
                attendeeList[attendeeList.size()-1].numberInList = attendeeList.size();            
                meeting.Contactlookup__c = null;
            }    
        }
    }
    
    /**
     * @Author: Vishnu Vardhan
     * @date: 7 Jul 2017
     * @description: This method adds a opportunity as related opportunity
     * @param: null
     * @return: void
     */
    public void addOppy() {
        if(meeting.Opportunity__c != null) {
            Opportunity o = [select Id, AccountId, Account.Name, Name, RecordType.Name, StageName from Opportunity where Id =: meeting.Opportunity__c];
            relatedOpportunitiesList.add(New cRelatedOpportunity(o,new RelatedOpportunity__c()));
            relatedOpportunitiesList[relatedOpportunitiesList.size()-1].numberInList = relatedOpportunitiesList.size();
            meeting.Opportunity__c = null;
        } else if(selectedOpportunity != null && selectedOpportunity != '--None--') {
            for(Opportunity o : oppyList) {
                if(o.Id == selectedOpportunity) {
                    relatedOpportunitiesList.add(New cRelatedOpportunity(o,new RelatedOpportunity__c()));
                    relatedOpportunitiesList[relatedOpportunitiesList.size()-1].numberInList = relatedOpportunitiesList.size();
                }
            }            
        }  
    }
    
    /**
     * @Author: Vishnu Vardhan
     * @date: 7 Jul 2017
     * @description: This method deletes a recipient from the list.
     * @param: null
     * @return: void
     */
    public void deleteRow() {
        System.debug('Now deleting number: '+deleteNum);
        System.debug('Which is Recipient: '+attendeeList[deleteNum-1]);        
        attendeeList.remove(deleteNum-1);
        
        for(cAttendee c : attendeeList) {
            if(c.numberInList >= deleteNum) {
                c.numberInList--;
            }   
        }        
    }
    
    /**
     * @Author: Vishnu Vardhan
     * @date: 7 Jul 2017
     * @description: This method deletes a related opportunity
     * @param: null
     * @return: void
     */
    public void deleteOppy() {
        System.debug('Now deleting number: '+deleteOpp);
        System.debug('Which is Recipient: '+relatedOpportunitiesList[deleteOpp-1]);        
        relatedOpportunitiesList.remove(deleteOpp-1);
        
        for(cRelatedOpportunity c : relatedOpportunitiesList) {
            if(c.numberInList >= deleteOpp) {
                c.numberInList--;
            }   
        }        
    }
    
    /**
     * @Author: Vishnu Vardhan
     * @date: 7 Jul 2017
     * @description: This method return a List of related opportunity
     * @param: null
     * @return: List<cRelatedOpportunity>
     */
    public List<cRelatedOpportunity> getRelatedOpportunities() {
        if(relatedOpportunitiesList == null) {
            relatedOpportunitiesList = new List<cRelatedOpportunity>();
            if(opportunity != null) {
                relatedOpportunitiesList.add(New cRelatedOpportunity(opportunity,new RelatedOpportunity__c()));
                relatedOpportunitiesList[relatedOpportunitiesList.size()-1].numberInList = relatedOpportunitiesList.size();
            }
        }
        return relatedOpportunitiesList;
    }
    
    /**
     * @Author: Vishnu Vardhan
     * @date: 7 Jul 2017
     * @description: This method return a List of recipients for a given event
     * @param: null
     * @return: List<cAttendee>
     */
    public List<cAttendee> getAttendees() {
        Set<Id> contactIdSet = new Set<Id>();
        if(attendeeList == null) {
            attendeeList = new List<cAttendee>();
            
            // get all contacts from a meeting
            for(EventRelation er : [select RelationId, EventId, Relation.FirstName, Relation.LastName, Relation.Email from EventRelation where IsWhat = false and EventId =: eventId]) {
                contactIdSet.add(er.RelationId);
            }
            
            List<Contact> currentUserContactList = [select Id, Name, JobTitle__c, Title, Email from Contact where Email =: event.Owner.Email];
            
            if(currentUserContactList.size() == 1) {
                attendeeList.add(New cAttendee(new MeetingAttendee__c(),currentUserContactList[0],true));
                attendeeList[attendeeList.size()-1].numberInList = attendeeList.size();
            }
            
            for(Contact c : [select Id, Name, JobTitle__c, Title, Email, Account.Name from Contact where Id IN: contactIdSet and Account.Name != null]) {
                System.debug(c);
                System.debug(attendeeList.size());
                if(attendeeList.size() == 1) {                    
                    if(c.Id != attendeeList[0].contact.Id) {
                        if(c.Email != null) {
                            if(c.Email.contains('markit.com') || c.Email.contains('markitserv.com') || c.Email.contains('ihsmarkit.com') || c.Email.contains('ihs.com')){
                                attendeeList.add(New cAttendee(new MeetingAttendee__c(),c,true));
                            } else {
                                attendeeList.add(New cAttendee(new MeetingAttendee__c(),c,false));
                            }
                                attendeeList[attendeeList.size()-1].numberInList = attendeeList.size();     
                        }
                                               
                    }
                } else {
                    if(c.Email != null) {
                        if(c.Email.contains('markit.com') || c.Email.contains('markitserv.com')) {
                            attendeeList.add(New cAttendee(new MeetingAttendee__c(),c,true));
                        } else {
                                attendeeList.add(New cAttendee(new MeetingAttendee__c(),c,false));
                        }
                        attendeeList[attendeeList.size()-1].numberInList = attendeeList.size();
                    }
                }                
            }
        }
        return attendeeList;
    }
    
    /**
     * @Author: Vishnu Vardhan
     * @date: 7 Jul 2017
     * @description: This method adds a newly created meeting.
     * @param: null
     * @return: PageReference
     */
    public PageReference save() {
        if (meeting.Achieved__c == null || meeting.Info__c == null || meeting.NextSteps__c == null) {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please populate mandatory fields'));
                return null;
        }        
        // SAVE OPPY IN MEETING               
        if(infoType == 'oppOnly' || infoType == 'bothFilled') {
            meeting.Account__c = opportunity.AccountId;
            meeting.Opportunity__c =opportunity.Id;
        } else {
            meeting.Account__c = account.Id;
        }
        
        /* if(event.ProductFamily__c != null) {
            meeting.ProductFamily__c= event.ProductFamily__c;
        } */
        if(event.ProductFamilyLookup__c != null) {
            meeting.ProductFamilyLookup__c= event.ProductFamilyLookup__c;
        }
        insert meeting;
        
        // SAVE EVENT AS RELATED EVENT
        event.MeetingNote__c = meeting.Id;
        update event;
        
        List<MeetingAttendee__c> maList = new List<MeetingAttendee__c>();
        List<RelatedOpportunity__c> roList = new List<RelatedOpportunity__c>();
        
        meeting.IHSMarkitAttendeeNames__c = '';
        meeting.AttendeeNames__c = '';
        
        // SAVE RELATED OPPORTUNITIES
        for(cRelatedOpportunity ro : relatedOpportunitiesList) {
            ro.relatedOppy.MeetingNote__c = meeting.Id;
            ro.relatedOppy.Opportunity__c = ro.oppy.Id;
            roList.add(ro.relatedOppy);
        }
        
        
        for(cAttendee c : attendeeList) {
            c.attendee.MeetingNote__c = meeting.Id;
            maList.add(c.attendee);
            if(c.attendee.IHSMarkitEmployee__c) {
                meeting.IHSMarkitAttendeeNames__c += c.contact.Name + ' ('+c.contact.Title+'), ';
            } else {
                meeting.AttendeeNames__c += c.contact.Name + ' ('+c.contact.Title+'), ';
            }
        }
        
        insert maList;
        insert roList;
        update meeting;
        
        PageReference pRef = new PageReference('/' + meeting.Id);
        return pRef.setRedirect(true);
    }
    
    /**
     * @Author: Vishnu Vardhan
     * @date: 7 Jul 2017
     * @description: Removes all attendees from the meeting
     * @param: null
     * @return: void
     */
    public void clearList() {
        attendeeList.clear();
    }
    
    /**
     * @Author: Vishnu Vardhan
     * @date: 7 Jul 2017
     * @description: This method is called when cancelled button is clicked on the page.
     * @param: null
     * @return: pageReference
     */
    public pageReference cancel() {
        PageReference pRef = new PageReference('/'+eventId);
        return pRef.setRedirect(true);
    }
    
    /**
     * @Author: Vishnu Vardhan
     * @date: 7 Jul 2017
     * @description: Returns list of opportunities available for account
     * @param: null
     * @return: List<SelectOption>
     */
    public List<SelectOption> getOpportunities() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('--None--', '--None--'));
        for(Opportunity o : oppyList) {
            options.add(new SelectOption(o.Id,o.Name));
        }        
        return options;
    }
    
    /**
     * @author Modified By: Vinod Merwade
     * @description Wrapper class
     * @date 7th Jul 2017
     */
    public class cRelatedOpportunity {
        public Opportunity oppy {get;set;}
        public RelatedOpportunity__c relatedOppy {get;set;}
        public Integer numberInList {get;set;}
        
        public cRelatedOpportunity(Opportunity o, RelatedOpportunity__c ro) {
            oppy = o;
            relatedOppy = ro;
        }
    }
    
    /**
     * @author Modified By: Vinod Merwade
     * @description Wrapper class
     * @date 7th Jul 2017
     */
    public class cAttendee {
        public MeetingAttendee__c attendee {get;set;}
        public Contact contact {get;set;}
        public Integer numberInList {get;set;}
        
        public cAttendee(MeetingAttendee__c ma, Contact con, boolean employee) {
            attendee = ma;
            contact = con;
            ma.Contact__c = con.Id;
            
            if(employee) {
                attendee.IHSMarkitEmployee__c = true;
            } else {
                attendee.IHSMarkitEmployee__c = false;
            }
        }
    }
}