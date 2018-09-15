Trigger OpportunitySplitTrigger on OpportunitySplit (after insert, after update, after delete, before update) {
    
     TriggerFactory.createTriggerDispatcher(OpportunitySplit.sObjectType);
     
    
}