/**
* @author: Mohit Modi
* @date: 27 September 2017
* @param: Trigger events
* @description: SFDC1-4363. trigger for Contract 
* @companyname: VERTIBA
* @LastModifiedby: Prachi Bhasin
* @ModifiedDate: 26 Feb 2018
* @description: SFDC1-4739: Adding before delete event
* @LastModifiedby: Vishnu Vardhan Chowdary
* @ModifiedDate: 14 Mar 2018
* @description: SFDC1-4702: Adding after update event
* @LastModifiedby: Harshit Singhal
* @ModifiedDate: 22 Jun 2018
* @description: SFDC1-8533: Adding after insert event
*/
trigger ContractTrigger on Contract (before insert, before update, before delete, after update, after insert) {
    //call trigger factory to create Contract trigger dispatcher
    TriggerFactory.createTriggerDispatcher(Contract.sObjectType);
}