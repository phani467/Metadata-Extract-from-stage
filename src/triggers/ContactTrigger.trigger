//***************************************************
// @author Tran-Vu Tran
// @date 26th June 2017
// @description SFDC1-402 Trigger for Contact object
//***************************************************
trigger ContactTrigger on Contact(before insert, before update, before delete, after insert, after update, after delete){

    TriggerFactory.createTriggerDispatcher(Contact.sObjectType);
}