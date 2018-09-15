//-----------------------------
// @author: Sruti Srivastava
// @date: 7 July 2018
// @description: SFDC1-6833 This scheduler class will be used to scheduled the BatchUpdateAccountOwnership batch class 
// @companyname: Vertiba
//------------------------------
global class BatchToUpdateProductDetailsScheduler implements Schedulable {
   global void execute(SchedulableContext sc) {
      BatchToUpdateProductDetailsOnContact batchClass = new BatchToUpdateProductDetailsOnContact(); 
      database.executebatch(batchClass, 100);
   }
}