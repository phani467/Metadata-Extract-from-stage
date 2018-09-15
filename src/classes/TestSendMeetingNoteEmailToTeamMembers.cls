/**
 * @Author:  Hemant Shukla
 * @Date:    30-Nov-2017
 * @Updated By: Hemant Shukla
 * @Updated On: 23 Jan, 2018
 * @Description: SFDC1-6727, Updated the lookup filter for InternalContactLookup__c hence need to change the email of contact. 
**/
@isTest
public with sharing class TestSendMeetingNoteEmailToTeamMembers {
	
	@testSetup 
	static void setup() {

		User u = TestUtility.createAdminUser('testmeetingnotesuser@markit.com',true);
        User u2 = TestUtility.createAdminUser('testmeetingnotesuserother@markit.com',true);   

        Account a = TestUtility.createTestAccount('Meeting Notes Account 123',true);
        Opportunity o = TestUtility.createOpportunity(a.id, 'Test Opportunity',null,true);
        OpportunityTeamMember otm = TestUtility.createOpportunityTeamMember(o.Id, u2.Id, 'Edit',true);
        Contact markitContact = TestUtility.createContact(a.Id,'testingmeetingnotes@ihsmarkit.com',true, 'FirstName', 'LastName');
        Contact sfAdmin = TestUtility.createContact(a.id,'sfadmin@markit.com',true, 'NameFirst', 'NameLast');
        
        MeetingNote__c mn1 = new MeetingNote__c(Account__c = a.Id, Name = 'MN With Acc And Opp', Opportunity__c = o.Id, InternalContactLookup__c = markitContact.Id);
        insert mn1;

        MeetingNote__c mn2 = new MeetingNote__c(Account__c = a.Id, Name = 'MN With only Acc', InternalContactLookup__c = markitContact.Id);
        insert mn2;

        MeetingNote__c mn3 = new MeetingNote__c(Name = 'MN Without Acc And Opp', InternalContactLookup__c = markitContact.Id);
        insert mn3;

        RelatedOpportunity__c testRO = new RelatedOpportunity__c(MeetingNote__c=mn1.Id, Opportunity__c=o.Id);
        insert testRO;
        MeetingAttendee__c ma = new MeetingAttendee__c(IHSMarkitEmployee__c = true, MeetingNote__c = mn1.Id, Contact__c = markitContact.Id);
        insert ma;

        MeetingAttendee__c ma2 = new MeetingAttendee__c(IHSMarkitEmployee__c = false, MeetingNote__c = mn1.Id, Contact__c = markitContact.Id);
        insert ma2;

        AccountTeamMember atm = new AccountTeamMember(AccountId = a.Id ,TeamMemberRole = 'Pending Update',UserId = u2.Id);
        insert atm;

    }


	/**
     * @Author: Hemant Shukla
     * @date: 30-Nov-2017
     * @description: Test method for ValidateEmailSending. 
     * @return: void
    */
    @isTest 
	static void testValidateEmailSending() {

		MeetingNote__c mn1, mn2, mn3;

		for(MeetingNote__c mn : [Select Id, Name From MeetingNote__c]) {

			if(mn.Name == 'MN With Acc And Opp')
				mn1 = mn;
			else if(mn.Name == 'MN With only Acc')
				mn2 = mn;
			else if(mn.Name == 'MN Without Acc And Opp')
				mn3 = mn;
		}

		String message;
		message = SendMeetingNoteEmailToTeamMembers.validateEmailSending(mn2.Id, 'OpportunityTeam');
		System.assertEquals(message, 'Please link any Opportunity to this Meeting note to send an email to Opportunity Team.');

		message = SendMeetingNoteEmailToTeamMembers.validateEmailSending(mn3.Id, 'AccountTeam');
		System.assertEquals(message, 'Please link an Account to this Meeting note to send an email to Account Team.');

		message = SendMeetingNoteEmailToTeamMembers.validateEmailSending(mn1.Id, 'AccountTeam');
		System.assertEquals(message, 'SendEmail');

		message = SendMeetingNoteEmailToTeamMembers.validateEmailSending(mn1.Id, 'OpportunityTeam');
		System.assertEquals(message, 'SendEmail');
	}

	/**
     * @Author: Hemant Shukla
     * @date: 30-Nov-2017
     * @description: Test method for getRecipientsOnLoad. 
     * @return: void
    */
    @isTest 
	static void testGetRecipientsOnLoad() {

        List<cRecipient> lst = new List<cRecipient>();
		MeetingNote__c mn1, mn2, mn3;
		for(MeetingNote__c mn : [Select Id, Name From MeetingNote__c]) {

			if(mn.Name == 'MN With Acc And Opp')
				mn1 = mn;
			else if(mn.Name == 'MN With only Acc')
				mn2 = mn;
			else if(mn.Name == 'MN Without Acc And Opp')
				mn3 = mn;
		}

		lst = SendMeetingNoteEmailToTeamMembers.getRecipientsOnLoad(mn3.Id, 'AccountTeam');
		System.assertEquals(lst.size(), 0);
        lst = new List<cRecipient>();

		lst = SendMeetingNoteEmailToTeamMembers.getRecipientsOnLoad(mn3.Id, 'OpportunityTeam');
		System.assertEquals(lst.size(), 0);
        lst = new List<cRecipient>();

		//Total 2 team members. One who created which will Test Runnig user and second we added manually
		lst = SendMeetingNoteEmailToTeamMembers.getRecipientsOnLoad(mn1.Id, 'AccountTeam');
		System.assertEquals(lst.size(), 2);
        lst = new List<cRecipient>();

		lst = SendMeetingNoteEmailToTeamMembers.getRecipientsOnLoad(mn1.Id, 'OpportunityTeam');
		System.assertEquals(lst.size(), 2);
	}

	/**
     * @Author: Hemant Shukla
     * @date: 30-Nov-2017
     * @description: Test method for addEmailRecipient. 
     * @return: void
    */
    @isTest 
	static void testAddEmailRecipient() {

		Contact con = [Select Id From Contact limit 1];
        cRecipient rcp = SendMeetingNoteEmailToTeamMembers.addEmailRecipient(con.Id);

		System.assertNotEquals(rcp, null);

	}

	/**
	 * @Author: Hemant Shukla
     * @date: 30-Nov-2017
     * @description: Test method for sendEmail. 
     * @return: void
    */
    @isTest 
	static void testSendEmail() {

		MeetingNote__c mn1 = [Select Id, Name From MeetingNote__c where Name = 'MN With Acc And Opp'];

        List<cRecipient> lst = new List<cRecipient>();

        lst.add(new cRecipient('Account Team Member1', 'atm1@markit.com'));
        lst.add(new cRecipient('Account Team Member2', 'atm2@markit.com'));           

		String message;
		message = SendMeetingNoteEmailToTeamMembers.sendEmail(mn1.Id, '');
		System.assertEquals(message, 'No Recipients');

		String jsonLstRecipients = JSON.serialize(lst);
		message = SendMeetingNoteEmailToTeamMembers.sendEmail(mn1.Id, jsonLstRecipients);
		System.assertEquals(message, 'Success');

	}	
}