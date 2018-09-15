//-----------------------------
// @author: Uttam Arya
// @created: 23-May-2016
// @param: NA
// @description: Class to hold trigger methods for AccountRanking
// @return: NA
// 
// @updated: 30-March-2018
// @updatedBy: Tran-Vu Tran
//-----------------------------

trigger AccountRankingTrigger on AccountRanking__c (after insert, after update) {

    TriggerFactory.createTriggerDispatcher(AccountRanking__c.sObjectType);
}