/**
* @author Paras Dhingra
* @date 3rd August 2017
* @description SFDC1-775 scheduler class for BatchUpdateAccountRelationship
* @companyname IHS Markit
*/
global class BatchUpdateAccountRelationshipScheduler implements Schedulable {
    
    global void execute(SchedulableContext ctx) {
        BatchUpdateAccountRelationship batchUpdate = new BatchUpdateAccountRelationship();
        batchUpdate.query = 'SELECT ID from Account';
        ID batchprocessId = Database.executeBatch(batchUpdate,100);
    }
    
}