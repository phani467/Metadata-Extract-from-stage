/**
* @author Hari Krishnan
* @date 07/17/2013
* @description This factory creates the correct dispatcher and dispatches the trigger event(s) to the appropriate 
*        event handler(s). The dispatchers are automatically created using the Type API, hence dispatcher 
*        registration is not required for each dispatchers.
* @edits: 25/7/217 Adding without sharing to class TriggerFactory. All trigger should run in system context to avaoid any system errors. 
*/
public without sharing class TriggerFactory
{
    /** 
  * @author : Hari Krishnan
  * @date : 07/17/2013
  * @description : Checks custom setting to determine whether to run the trigger or not for the user in context
  * @param : Schema.sObjectType Object type to process (SObject.sObjectType)
  * @modification date : 12 April 2018
  * @modified by : Ankita Singh
  * @modification description : to remove underscores from api name while creating trigger on managed package object as per 7213
  */
    public static boolean doNotRunTrigger(Schema.sObjectType soType) {
        Boolean doNotRunTrigger = false;
        String originalTypeName = soType.getDescribe().getName();
        SystemMutedTriggers__c cs = SystemMutedTriggers__c.getInstance();
        if(originalTypeName.endswith('__c')) {
            // ensure we can retrieve the custom setting field for a custom object
            originalTypeName = originalTypeName.replace('__c', '');
            originalTypeName = originalTypeName.replaceAll( '_', '');
            System.debug('Object' + originalTypeName);
        }
        if(cs.get(originalTypeName + '__c') != null) {
            doNotRunTrigger = Boolean.valueOf(cs.get(originalTypeName + '__c'));
        }
        return doNotRunTrigger;
    }
  /** 
  * @author Hari Krishnan
  * @date 07/17/2013
  * @description Creates the appropriate dispatcher and dispatches the trigger event to the dispatcher's event handler method.
  * @param Schema.sObjectType Object type to process (SObject.sObjectType)
  */
    public static void createTriggerDispatcher(Schema.sObjectType soType)
    {
        if(!doNotRunTrigger(soType)) {
            ITriggerDispatcher dispatcher = getTriggerDispatcher(soType);
            
            if (dispatcher == null)
                throw new TriggerException('No Trigger dispatcher registered for Object Type: ' + soType);
            execute(dispatcher);
      }
    }

    /** 
  * @author Hari Krishnan
  * @date 07/17/2013
  * @description Dispatches to the dispatcher's event handlers.
  * @param ITriggerDispatcher A Trigger dispatcher that dispatches to the appropriate handlers
  */ 
    private static void execute(ITriggerDispatcher dispatcher)
    {
      TriggerParameters tp = new TriggerParameters(Trigger.old, Trigger.new, Trigger.oldMap, Trigger.newMap,
                  Trigger.isBefore, Trigger.isAfter, Trigger.isDelete, 
                  Trigger.isInsert, Trigger.isUpdate, Trigger.isUnDelete, Trigger.isExecuting);
        // Handle before trigger events
        if (Trigger.isBefore) {
            dispatcher.bulkBefore();
            if (Trigger.isDelete)
                dispatcher.beforeDelete(tp);
            else if (Trigger.isInsert)
                dispatcher.beforeInsert(tp);
            else if (Trigger.isUpdate)
                dispatcher.beforeUpdate(tp);         
        }
        else  // Handle after trigger events
        {
            dispatcher.bulkAfter();
            if (Trigger.isDelete)
                dispatcher.afterDelete(tp);
            else if (Trigger.isInsert)
                dispatcher.afterInsert(tp);
            else if (Trigger.isUpdate)
                dispatcher.afterUpdate(tp);
            else if(Trigger.isUnDelete)
                dispatcher.afterUndelete(tp);
        }
        dispatcher.andFinally();
    } 

    /** 
  * @author Hari Krishnan
  * @date 07/17/2013
  * @description Gets the appropriate dispatcher based on the SObject. It constructs the instance of the dispatcher
  *        dynamically using the Type API. The name of the dispatcher has to follow this format:
  *        <ObjectName>TriggerDispatcher. For e.g. for the Feedback__c object, the dispatcher has to be named
  *        as FeedbackTriggerDispatcher.
  * @param Schema.sObjectType Object type to create the dispatcher
  * @return ITriggerDispatcher A trigger dispatcher  if one exists or null.
  * @modification date : 12 April 2018
  * @modified by : Ankita Singh
  * @modification description : to remove underscores from api name while creating trigger on managed package object as per 7213
  */
    private static ITriggerDispatcher getTriggerDispatcher(Schema.sObjectType soType)
    {
      String originalTypeName = soType.getDescribe().getName();
        System.debug('####+'+originalTypeName);
      String dispatcherTypeName = null;
      if (originalTypeName.toLowerCase().endsWith('__c')) {
        Integer index = originalTypeName.toLowerCase().indexOf('__c');
        dispatcherTypeName = originalTypeName.substring(0, index);
        dispatcherTypeName = dispatcherTypeName.replaceAll( '_', '');
        dispatcherTypeName = dispatcherTypeName+ 'Dispatcher';
      }
      else
        dispatcherTypeName = originalTypeName + 'Dispatcher';
      
    Type obType = Type.forName(dispatcherTypeName);
    ITriggerDispatcher dispatcher = (obType == null) ? null : (ITriggerDispatcher)obType.newInstance();
      return dispatcher;
    }
}