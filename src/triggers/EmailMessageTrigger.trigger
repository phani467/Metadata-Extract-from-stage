//-------------------------------------
//@author: Sruti Srivastava
//@date: 27 June 2018
//@param: Trigger events
//@description: EmailMessage trigger 
//-----------------------------

Trigger EmailMessageTrigger on EmailMessage (after insert) {
    //call trigger factory to create EmailMessage trigger dispatcher
    TriggerFactory.createTriggerDispatcher(EmailMessage.sObjectType);
}