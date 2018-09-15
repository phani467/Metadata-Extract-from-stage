/**
 * @Author: Hemant Shukla
 * @date: 8-Jan-2018
 * @description: A wrapper class for Recipients. Used in SendMeetingNoteEmail Lightning component.
*/   
public class cRecipient {
	@AuraEnabled
    public String name {get;set;}

    @AuraEnabled
    public String email {get;set;}
    
    public cRecipient(String name, string email) {
        this.name = name;
        this.email = email;
    }
}