/**
 * @Author:  Hemant Shukla
 * @Date:    30-Nov-2017
 * @description: Apex class which is being used as controller for Quick Actions on Meeting Note to Send email.
 * @lastModifiedSprint: Sprint 16 SFDC1-710 -  Modified method sendEmail, to update the MN record link with Org base URL And to avoid the Null entry into To address set.
 * @lastModifiedBy : Hemant Shukla in Sprint 16
 * @lastModifiedSprint: Sprint 16 SFDC1-710 -  Removed the cRecipient inner class and made it separate class after issue on winter 18 for inner wrapper class taken as LC attribute. 
 * @lastModifiedBy : Hemant Shukla in Sprint 16
**/
public with sharing class SendMeetingNoteEmailToTeamMembers {
	
	/**
     * @Author: Hemant Shukla
     * @date: 30-Nov-2017
     * @description: To validate if Email could be send to Team members based on current MN record
     * @param: mnId, Meeting Note Id
     * @param: launchedFrom,  action it launched from
     * @return: String, appropriate message
    */
    @AuraEnabled
    public static String validateEmailSending (String mnId, String launchedFrom) {
        
    	MeetingNote__c meetingNote = [Select Id, Account__c, NumberOfOpportunities__c, (Select Id From RelatedOpportunities__r) 
    								  From MeetingNote__c 
    								  Where Id = :mnId 
    								  Limit 1
    								  ];
    	String message = 'SendEmail';							  
    	if(launchedFrom == 'AccountTeam' && meetingNote.Account__c == null) {							  
    		message = 'Please link an Account to this Meeting note to send an email to Account Team.';
    	}	
    	else if(launchedFrom == 'OpportunityTeam' && meetingNote.NumberOfOpportunities__c < 1) {
    		message = 'Please link any Opportunity to this Meeting note to send an email to Opportunity Team.';
    	}
    	
    	return message;							
    }

    /**
     * @Author: Hemant Shukla
     * @date: 30-Nov-2017
     * @description: This method return a List of recipients for a given Account
     * @param: mnId, Meeting Note Id
     * @param: launchedFrom,  action it launched from
     * @return: List<cReceipent>, AccountTeamMembers or OpportunityTeamMembers based on selected action. 
    */
    @AuraEnabled
    public static List<cRecipient> getRecipientsOnLoad(String mnId, String launchedFrom) {

    	MeetingNote__c meetingNote = [Select Id, Account__c, NumberOfOpportunities__c, (Select Id, Opportunity__c From RelatedOpportunities__r) 
    								  From MeetingNote__c 
    								  Where Id = :mnId 
    								  Limit 1
    								  ];
    	
    	List<cRecipient> recipients = new List<cRecipient>();

    	if(launchedFrom == 'AccountTeam') {
						          
	        for(AccountTeamMember atm: [Select Id,AccountId,TeamMemberRole,UserId, User.Name, User.Email 
	        							From AccountTeamMember 
	        							Where AccountId =: meetingNote.Account__c]) {

	            recipients.add(new cRecipient(atm.User.Name, atm.User.Email));
	        }
	    }
        else if(launchedFrom == 'OpportunityTeam') {

            Set<Id> setAlreadyAddedUsers = new Set<Id>();
            Set<Id> oppIds = new Set<Id>();
            for(RelatedOpportunity__c ro : meetingNote.RelatedOpportunities__r) {
                oppIds.add(ro.Opportunity__c);
            }   
            for(OpportunityTeamMember otm:  [Select Id,Name,OpportunityId,TeamMemberRole,UserId, User.Name, User.Email 
                                              From OpportunityTeamMember 
                                              Where OpportunityId IN: oppIds]) {
                
                //To avoid same users to get added twice in list. As one user can be a part of Two Opportunity team.
                if(!setAlreadyAddedUsers.contains(otm.UserId)) {
                    recipients.add(new cRecipient(otm.User.Name, otm.User.Email));
                    setAlreadyAddedUsers.add(otm.UserId);
                }
            }
        }     	
	    
	    return recipients;
    }

    /**
     * @Author: Hemant Shukla
     * @date: 30-Nov-2017
     * @description: This method creates a intance of recipient to add into final list
     * @param: mnId, Meeting Note Id
     * @return: cReceipent, instance of recently added Recipien
    */
    @AuraEnabled
    public static cRecipient addEmailRecipient(String contactId) {
    	
        List<Contact> cList = [select Id, Name, JobTitle__c, Title, Email, Account.Name 
        					   From Contact 
        					   where Id =: contactId AND 
        					   		 Email != null	
        					   limit 1		 
        					   ];
        
        cRecipient recipient;

        if(!cList.isEmpty()) {
            Contact c = cList[0];
            recipient = new cRecipient(c.Name, c.Email);
        }

        return recipient;
    }

    /**
     * @Author: Hemant Shukla
     * @date: 1-Dec-2017
     * @description: This method adds a recipient into list to send an email
     * @param: mnId, Meeting Note Id
     * @param: jsonLstRecipients, Json list of all recipients to whom email need to be sent
     * @return: List<cReceipent>
    */
    @AuraEnabled
    public static String sendEmail(String mnId, String jsonLstRecipients) {

        MeetingNote__c mn = [Select Id, Account__c, Account__r.Owner.Email
                             From  MeetingNote__c
                             Where Id = :mnId];

        List<cRecipient> lstRecipients = new List<cRecipient>();
        if(!String.isEmpty(jsonLstRecipients)) {
            lstRecipients = (List<cRecipient>) JSON.deserializeStrict(jsonLstRecipients, List<cRecipient>.class);
        }    
        else {
            return 'No Recipients';
        }    
        
        try {   

            List<MeetingAttendee__c> attendees = [Select Id, MeetingNote__c, Contact__r.Name, Contact__r.Title, IHSMarkitEmployee__c 
                                                  From MeetingAttendee__c 
                                                  where MeetingNote__c =:mn.Id
                                                 ];

            Set<String> markitAttendees = new Set<String>();
            Set<String> nonMarkitAttendees = new Set<String>();

            for(MeetingAttendee__c ma : attendees) {
                if(ma.IHSMarkitEmployee__c) {
                    markitAttendees.add(ma.contact__r.Name);
                } else {
                    nonMarkitAttendees.add(ma.contact__r.Name);
                }
            }
            
            mn.IHSMarkitAttendeeNames__c = !(new List<String>(markitAttendees)).isEmpty() ? 
                                                 String.join((new List<String>(markitAttendees)), ',') : '';
            mn.AttendeeNames__c = !(new List<String>(nonMarkitAttendees)).isEmpty() ? 
                                                 String.join((new List<String>(nonMarkitAttendees)), ',') : '';                                     
            
            update mn;

            // Get the email template
            EmailTemplate template = [select id, HtmlValue, Body 
                                      From EmailTemplate 
                                      Where DeveloperName = 'MeetingNotesTemplate' 
                                      LIMIT 1];

            set<String> toAddressesSet = new set<String>(); 
            // need dummy contact
            Contact dummy = [select id, email from Contact limit 1]; /* where email = 'sfadmin@markit.com' */

            for(cRecipient rec : lstRecipients) {
                toAddressesSet.add(rec.email);
            }
            
            //Adding the additional users into set to send the email. Current user and Owner of Associated account to MN. 
            toAddressesSet.add(UserInfo.getUserEmail());
            if(mn.Account__c != null) {
                toAddressesSet.add(mn.Account__r.Owner.Email);
            }
            
            List<String> toAddresses = new List<String>(toAddressesSet);

            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage(); 
            if(toAddresses.size() > 0) {
                mail.setTargetObjectId(dummy.id);
                mail.setTemplateId(template.Id);            
                mail.setToAddresses(toAddresses);
                mail.setWhatId(mn.Id);
            }
            
            // Send the emails in a transaction, then roll it back, doesn't actually send email that way
            Savepoint sp = Database.setSavepoint();
            // This actually populates the template into the email message (#winning http://opfocus.com/blog/sending-emails-in-salesforce-to-non-contacts-using-apex/)
            Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{mail});
            Database.rollback(sp);

            Messaging.SingleEmailMessage emailToSend = new Messaging.SingleEmailMessage();
            emailToSend.setToAddresses(mail.getToAddresses());
            emailToSend.setPlainTextBody(mail.getPlainTextBody());
            String emailBody = mail.getHTMLBody();
            emailBody = emailBody.replace('BASE__URL', URL.getSalesforceBaseUrl().toExternalForm());
            emailToSend.setHTMLBody(emailBody);
            emailToSend.setSubject(mail.getSubject());
            emailToSend.setSaveAsActivity(true);

            Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{emailToSend});

            return 'Success';
        }
        Catch(exception e) {
            System.debug('=================Error:' + e.getMessage());
            return e.getMessage();
        }    
    }	
		
}