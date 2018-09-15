/**
 * @author Modified By: Vishnu Vardhan
 * @date: 7 Jul 2017
 * @description: Migrated class from existing Markit System and added comments. 
 * 		Class to Test SendMeetingNoteToAccountTeam and SendMeetingNoteToOpportunityTeam
 * @Updated By: Hemant Shukla
 * @Updated On: 23 Jan, 2018
 * @Description: SFDC1-6727, Updated the lookup filter for InternalContactLookup__c hence need to change the email of contact. 
 **/
@IsTest(SeeAllData=false)
public class TestSendMeetingNote {
	
    /**
     * @Author: Vishnu Vardhan
     * @date: 7 Jul 2017
     * @description: method to test weather meeting note is sent to opportunity and account team.
     * @param: null
     * @return: void
     */
    static testmethod void testCreateMeetingNoteFromAccount() {

        User u = TestUtility.createAdminUser('testmeetingnotesuser@markit.com',true);
        User u2 = TestUtility.createAdminUser('testmeetingnotesuserother@markit.com',true);
        
        System.runAs(u) {
            Account a = TestUtility.createTestAccount('Meeting Notes Account 123',true);
            Opportunity o = TestUtility.createOpportunity(a.id, 'Test Opportunity',null,true);
            TestUtility.createOpportunityTeamMember(o.Id, u2.Id, 'Edit',true);
            Contact markitContact = TestUtility.createContact(a.Id,'testingmeetingnotes@ihsmarkit.com',true, 'FirstName', 'LastName');
            Contact sfAdmin = TestUtility.createContact(a.id,'sfadmin@markit.com',true, 'NameFirst', 'NameLast');
            MeetingNote__c mn = new MeetingNote__c(Account__c = a.Id, Name = 'test1243', Opportunity__c = o.Id,InternalContactLookup__c = markitContact.Id);
            insert mn;
            RelatedOpportunity__c testRO = new RelatedOpportunity__c(MeetingNote__c=mn.Id,Opportunity__c=o.Id);
            insert testRO;
            MeetingAttendee__c ma = new MeetingAttendee__c(IHSMarkitEmployee__c = true, MeetingNote__c = mn.Id, Contact__c = markitContact.Id);
            insert ma;
            AccountTeamMember atm = new AccountTeamMember(AccountId = a.Id ,TeamMemberRole = 'Pending Update',UserId = u2.Id);
            insert atm;
            Test.startTest();
            
            Test.setCurrentPage(Page.SendMeetingNoteToAccountTeam);
            Apexpages.currentPage().getParameters().put('meetingId', mn.Id);
            
            SendMeetingNoteToAccountTeam ctrl = new SendMeetingNoteToAccountTeam();
            
            List<SendMeetingNoteToAccountTeam.cRecipient> assertRecepients= ctrl.getRecipients();
            System.assertNotEquals(0,assertRecepients.size());
            ctrl.meeting.UserLookup__c = u2.Id;
            
            ctrl.addRow();
            Integer listSize = ctrl.recipientList.size();
            system.assert(listSize>2);
            ctrl.sendEmail();
            MeetingNote__c assertMeeting = [Select id, AttendeeNames__c, IHSMarkitAttendeeNames__c from MeetingNote__c where id =: mn.Id limit 1];
            System.debug('assertMeeting'+assertMeeting);
            system.assertEquals(null, assertMeeting.AttendeeNames__c);
            System.assertNotEquals(null, assertMeeting.IHSMarkitAttendeeNames__c);
            ctrl.deleteNum = 1;
            ctrl.deleteRow();
            System.debug('ctrl '+ctrl);
            system.assert(ctrl.recipientList.size()<listSize);
            ctrl.cancel();
            Test.setCurrentPage(Page.SendMeetingNoteToOpportunityTeam);
            Apexpages.currentPage().getParameters().put('meetingId', mn.Id);
            
            SendMeetingNoteToOpportunityTeam ctrl2 = new SendMeetingNoteToOpportunityTeam();
            
            List<SendMeetingNoteToOpportunityTeam.cRecipient> assertRecepients2= ctrl2.getRecipients();
            System.assertNotEquals(0,assertRecepients2.size());
            ctrl2.meeting.UserLookup__c = u2.Id;
            ctrl2.addRow();
            Integer listSize2 = ctrl2.recipientList.size();
            system.assert(listSize2>2);
            ctrl2.sendEmail();
            ctrl2.deleteNum = 1;
            ctrl2.deleteRow();
            system.assert(ctrl2.recipientList.size()<listSize2);
            ctrl2.cancel();
            Test.stopTest();
        }
    }
}