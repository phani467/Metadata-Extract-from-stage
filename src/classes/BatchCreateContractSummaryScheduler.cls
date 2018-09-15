//-----------------------------
// @author: Harshit Singhal
// @date: 30 Jul 2018
// @description: SFDC1-5228 This scheduler class will be used to scheduled the BatchCreateContractSummary batch class 
//------------------------------
global class BatchCreateContractSummaryScheduler implements Schedulable {
    global void execute(SchedulableContext ctx) {
        Database.executeBatch(new BatchCreateContractSummary(), 200);
    }
}