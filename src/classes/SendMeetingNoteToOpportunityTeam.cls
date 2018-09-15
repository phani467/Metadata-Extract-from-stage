/**
 * @author Modified By: Vinod Merwade
 * @description: Migrated class from existing Markit System and added comments. 
 * 		 Sending meeting notes to opportunity team
 * @date 7th Jul 2017
 */
public with sharing class SendMeetingNoteToOpportunityTeam {
        
    public MeetingNote__c meeting {get;set;}
    //Our collection of the class/wrapper objects cContact
    public List<cRecipient> recipientList {get; set;}
    public Integer deleteNum {get;set;}
    public List<RelatedOpportunity__c> relatedOppyList {get;set;}
    public Set<Id> oppyIds = new Set<Id>();
    
    public SendMeetingNoteToOpportunityTeam() {
        meeting = [select Id, Name, When__c, InternalContactLookup__c, UserLookup__c, ContactLookup__c, Opportunity__c from MeetingNote__c where Id =: System.currentPageReference().getParameters().get('meetingId')];
        relatedOppyList = [select Opportunity__c from RelatedOpportunity__c where MeetingNote__c =: System.currentPageReference().getParameters().get('meetingId')];
        for(RelatedOpportunity__c ro : relatedOppyList) {
            oppyIds.add(ro.Opportunity__c);
        }
    }    
    
    /**
     * @Author: Vishnu Vardhan
     * @date: 7 Jul 2017
     * @description: This method return a List of recipients for a given opportunity
     * @param: null
     * @return: List<cReceipent>
     */
    public List<cRecipient> getRecipients() {
        if(recipientList == null) {
            recipientList = new List<cRecipient>();
			Map<Id,OpportunityTeamMember> uniqueTeamMembers = new Map<Id,OpportunityTeamMember>();
            
            for(OpportunityTeamMember otm: [SELECT Id,Name,OpportunityId,TeamMemberRole,UserId, User.Name, User.Email FROM OpportunityTeamMember WHERE OpportunityId IN: oppyIds]) {
                // avoid duplication over multiple opportunities
                if(uniqueTeamMembers.get(otm.UserId) == null) {
                    uniqueTeamMembers.put(otm.UserId,otm);
                }                
            }            
            for(OpportunityTeamMember otm: uniqueTeamMembers.values()) {
                // As each contact is processed we create a new cContact object and add it to the contactList
                recipientList.add(new cRecipient(otm));
                recipientList[recipientList.size()-1].emailOfUser = recipientList[recipientList.size()-1].oppyTeamMember.User.Email;
                recipientList[recipientList.size()-1].numberInList = recipientList.size();
            }            
        }
        return recipientList;
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
        System.debug('Which is Recipient: '+recipientList[deleteNum-1]);        
        recipientList.remove(deleteNum-1);
        
        for(cRecipient c : recipientList) {
            if(c.numberInList >= deleteNum) {
                c.numberInList--;
            }   
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
        if(meeting.UserLookup__c != null){
           User tempUser = [select Email from User where Id =: meeting.UserLookup__c];
           recipientList.add(new cRecipient(new OpportunityTeamMember(UserId = meeting.UserLookup__c)));
           recipientList[recipientList.size()-1].emailOfUser = tempUser.Email; 
           recipientList[recipientList.size()-1].numberInList = recipientList.size();
           meeting.UserLookup__c = null;       
        }   
    
        if(meeting.InternalContactLookup__c != null){
            Contact tempUser = [select Email, Name from Contact where Id =: meeting.InternalContactLookup__c];
            recipientList.add(new cRecipient(tempUser));
            recipientList[recipientList.size()-1].emailOfUser = tempUser.Email; 
            recipientList[recipientList.size()-1].numberInList = recipientList.size();
            meeting.ContactLookup__c = null;        
        } 

    }
    
    /**
     * @Author: Vishnu Vardhan
     * @date: 7 Jul 2017
     * @description: This method is called when cancelled button is clicked on the page.
     * @param: null
     * @return: pageReference
     */
    public pageReference cancel() {
        PageReference pRef = new PageReference('/'+meeting.Id);
        return pRef.setRedirect(true);
    }
    
    /**
     * @Author: Vishnu Vardhan
     * @date: 7 Jul 2017
     * @description: This method is sends email to receipients/meeting attendes.
     * @param: null
     * @return: pageReference
     */
    public pageReference sendEmail() {
        
        // set up the attendees 
        List<MeetingAttendee__c> maList = [Select Id, MeetingNote__c, Contact__r.Name, Contact__r.Title, IHSMarkitEmployee__c  from MeetingAttendee__c where MeetingNote__c =:meeting.Id];
    	
        meeting.IHSMarkitAttendeeNames__c = '';
        meeting.AttendeeNames__c = '';
            
		for(MeetingAttendee__c ma : maList) {
            if(ma.IHSMarkitEmployee__c) {
                meeting.IHSMarkitAttendeeNames__c += ma.contact__r.Name+', ';
            } else {
                meeting.AttendeeNames__c += ma.contact__r.Name +', ';
            }
        }
        
        if( meeting.AttendeeNames__c != '') {
            meeting.AttendeeNames__c = meeting.AttendeeNames__c.substring(0, meeting.AttendeeNames__c.length() - 2);
        }
        if(meeting.IHSMarkitAttendeeNames__c != '') {
            meeting.IHSMarkitAttendeeNames__c = meeting.IHSMarkitAttendeeNames__c.substring(0, meeting.IHSMarkitAttendeeNames__c.length() - 2);
        }
        
        update meeting;
        
        // Get the email template
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        EmailTemplate template = [select id, HtmlValue, Body from EmailTemplate where DeveloperName = 'MeetingNotesTemplate' LIMIT 1];
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage(); 
        list<String> toAddresses = new List<String>(); 
        // need dummy contact
        Contact dummy = [select id, email from Contact where email = 'sfadmin@markit.com' limit 1];
        
        for(cRecipient rec : recipientList) {
            if(rec.emailOfUser != null) {
                toAddresses.add(rec.emailOfUser);
            }
        }
        
        toAddresses.add(UserInfo.getUserEmail());
        
        if(toAddresses.size() > 0) {
            mail.setTargetObjectId(dummy.id);
            mail.setTemplateId(template.Id);            
            mail.setToAddresses(toAddresses);
            mail.setWhatId(meeting.Id);
            mails.add(mail);
        }
        
        // Send the emails in a transaction, then roll it back, doesn't actually send email that way
        Savepoint sp = Database.setSavepoint();
        // This actually populates the template into the email message (#winning http://opfocus.com/blog/sending-emails-in-salesforce-to-non-contacts-using-apex/)
        Messaging.sendEmail(mails);
        Database.rollback(sp);
        
         List<Messaging.SingleEmailMessage> lstMsgsToSend = new List<Messaging.SingleEmailMessage>();
        Messaging.SingleEmailMessage emailToSend = new Messaging.SingleEmailMessage();
        emailToSend.setToAddresses(mail.getToAddresses());
        emailToSend.setPlainTextBody(mail.getPlainTextBody());
        emailToSend.setHTMLBody(mail.getHTMLBody());
        emailToSend.setSubject(mail.getSubject());
        emailToSend.setSaveAsActivity(false);

        lstMsgsToSend.add(emailToSend);
        Messaging.sendEmail(lstMsgsToSend);
        
        PageReference pRef = new PageReference('/'+meeting.Id);
        return pRef.setRedirect(true);
    }
    
    /**
     * @author Modified By: Vinod Merwade
     * @description Wrapper class
     * @date 7th Jul 2017
     */
    public class cRecipient {
        public OpportunityTeamMember oppyTeamMember {get;set;}
        public Contact contact{get;set;}
        public Integer numberInList {get;set;}
        public String emailOfUser {get;set;}
        
        public cRecipient(OpportunityTeamMember otm) {
            oppyTeamMember = otm;
        }
        
        public cRecipient(Contact c) {
            contact = c;
        }
    }
}