//-----------------------------
// @author: Anjani Shukla
// @date: 29 Sept 2017
// 
// @description: Class to hold trigger methods. This class is used in WRF POLK. 
// 
//-----------------------------
public class PLCJobMethods {

        //-----------------------------
        // @author: Anjani Shukla
        // @date: 29 Sept 2017
        // @param: TriggerParameters tp
        // @description: Update Start Date or Negotiated Date if differs.
        // @return: None
        //------------------------------
        public static void updatePLCTaskStartNegotiatedDate(TriggerParameters tp) {
        List<JobTask__c> allChildrenToUpdate = new List<JobTask__c>();
        // for the updated parents
        //query all job tasks with parent fields (PLCJob__r.Field_Name__c)
        //Loop through job tasks individually for ALL plcs in the batch
        //  recreate the inner Job Task loop basically
        
        List<JobTask__c> children = [SELECT Id, PLCJob__r.Name, StartDate__c, DueDate__c, JobStatusOverride__c,
                                    Status__c, PLCJob__r.StartDate__c, PLCJob__r.NegotiatedDate__c,
                                    PLCJob__r.JobStatusOverride__c 
                                    from JobTask__c 
                                    where PLCJob__c IN :Trigger.new];
        //System.debug('children count = ' + children.size());
        
        //loop through all children and determine which need to be updated
        for(JobTask__c thischild: children )
        {
            //if the start date or negotiated date is different from a PLC, it will automatically
            //populate the child Job Task with the new start and due dates.  These can be edited on 
            //the job task later if need be
            if(  (thischild.StartDate__c !=  thischild.PLCJob__r.StartDate__c || 
            thischild.DueDate__c !=  thischild.PLCJob__r.NegotiatedDate__c ||
            thischild.JobStatusOverride__c != thischild.PLCJob__r.JobStatusOverride__c )
            && thischild.Status__c != 'Complete')
            {
                //assign the fields that are different to the parent field
                thischild.StartDate__c =  thischild.PLCJob__r.StartDate__c;
                thischild.DueDate__c =  thischild.PLCJob__r.NegotiatedDate__c;
                thischild.JobStatusOverride__c =  thischild.PLCJob__r.JobStatusOverride__c;
                
                //add to the list of children to update
                allChildrenToUpdate.add(thischild);
            }
        }
        
        update allChildrenToUpdate;
        }
        
        
        //-----------------------------
        // @author: Anjani Shukla
        // @date: 29 Sept 2017
        // @param: TriggerParameters tp
        // @description: Update Start Date or Negotiated Date if differs.
        // @return: None
        //------------------------------
        public static void createDeliveryTaskOnJobInsert(TriggerParameters tp) {
            
            List<JobTask__c> newTasks = new List<JobTask__c>();
            List<PLCJob__c > newPLCRecords = (List<PLCJob__c >)tp.newlist;

            //For each position processed by the trigger, add a new  
            //interviewer record for the specified hiring manager.  
            //Note that Trigger.New is a list of all the new positions  
            //that are being created.  
            
            for (PLCJob__c newJob: newPLCRecords){
                 newTasks.add(new JobTask__c(        
                        TaskName__c = 'Deliverable',
                        PLCJob__c = newJob.id,
                        EstimatedHours__c = newJob.TotalJobEstimate__c,
                        Status__c = 'Open',
                        Assignedto__c = newJob.OwnerId));
            }
            insert newTasks;
          }
}