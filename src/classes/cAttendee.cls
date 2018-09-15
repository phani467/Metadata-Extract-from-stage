/**
 * @Author:  Hemant Shukla
 * @Date:    08-Jan-2018
 * @description: Wrapper class to show the attendees on Meeting Notes Lightning component
**/
public class cAttendee {
    @AuraEnabled
    public MeetingAttendee__c attendee;
    @AuraEnabled
    public Contact contact ;
    @AuraEnabled
    public String isIHSEmployee ;
    
    public cAttendee(MeetingAttendee__c ma, Contact con, boolean employee) {
        attendee = ma;
        contact = con;
        ma.Contact__c = con.Id;
        
        if(employee) {
            attendee.IHSMarkitEmployee__c = true;
            isIHSEmployee = 'Yes';
        } else {
            attendee.IHSMarkitEmployee__c = false;
            isIHSEmployee = 'No';
        }
    }
}