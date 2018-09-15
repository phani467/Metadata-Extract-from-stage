/**
 * @Author:  Twan v.d. Loo
 * @Date:    24-09-2015
 * @Purpose: Test class for CreateMeetingNoteEvent
 * 
 * @author Modified By: Vishnu Vardhan
 * @date: 7 Jul 2017
 * @description: Migrated class from existing Markit System and added comments. 
**/
@IsTest
public class TestCreateMeetingNotes {

    /**
     * @Author: Vishnu Vardhan
     * @date: 7 Jul 2017
     * @description: method to test creation of meeting note from an event.
     * @param: null
     * @return: void
     */
    static testmethod void testCreateMeetingNoteFromEvent() {
        Account a = TestUtility.createTestAccount('Meeting Notes Account 123',true);
        Opportunity o = TestUtility.createOpportunity(a.Id,'Test oppy meeting notes 123',null,true);

        Opportunity opp = new Opportunity();
        opp.AccountId = a.Id;
        opp.Name = 'test oppy yo';
        opp.StageName = '1-Sales Qualified';
        opp.CloseDate = Date.today().addDays(10);
        insert opp;
        
        Contact markitContact = TestUtility.createContact(a.Id,'testingmeetingnotes@markit.com',true,'TestFirst','TestLast');
        
        Event e = new Event(Account__c = a.Id, Subject = 'blabla', DurationInMinutes = 60, ActivityDateTime = Datetime.now());
        insert e;
        
        EventRelation evr1 = new EventRelation(EventId = e.Id, RelationId = markitContact.Id);
        insert evr1;
        
        Test.startTest();
        Test.setCurrentPage(Page.CreateMeetingNoteEvent);
        Apexpages.currentPage().getParameters().put('infoType', 'accOnly');
        Apexpages.currentPage().getParameters().put('accId', a.Id);
        Apexpages.currentPage().getParameters().put('eventId', e.Id);
    
        CreateMeetingNoteEvent ctrl = new CreateMeetingNoteEvent();
        ctrl.meeting.Achieved__c = 'Test';
        ctrl.meeting.Info__c = 'Test';
        ctrl.meeting.NextSteps__c = 'Test';
        ctrl.getOpportunities();
        ctrl.getAttendees(); 
        ctrl.meeting.ContactLookup__c = markitContact.Id;
        
        ctrl.addRow();       
        ctrl.cancel();
        
        Test.setCurrentPage(Page.CreateMeetingNoteEvent);
        Apexpages.currentPage().getParameters().put('infoType', 'bothFilled');
        Apexpages.currentPage().getParameters().put('accId', a.Id);
        Apexpages.currentPage().getParameters().put('eventId', e.Id);
        Apexpages.currentPage().getParameters().put('oppId', o.Id);
        
        CreateMeetingNoteEvent secondCtrl = new CreateMeetingNoteEvent();
        secondCtrl.getOpportunities();
        secondCtrl.getAttendees(); 
        secondCtrl.getRelatedOpportunities();
        secondCtrl.clearList();
        secondCtrl.meeting.ContactLookup__c = markitContact.Id;
        secondCtrl.meeting.Achieved__c = 'Test';
        secondCtrl.meeting.Info__c = 'Test';
        secondCtrl.meeting.NextSteps__c = 'Test';
        secondCtrl.meeting.Opportunity__c = opp.Id;
        secondCtrl.addOppy();
        secondCtrl.addRow();             
        secondCtrl.save();
        
        System.assertEquals(1,[select Id from MeetingNote__c].size());
    }
}