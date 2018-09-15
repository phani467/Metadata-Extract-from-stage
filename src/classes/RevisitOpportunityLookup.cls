//-----------------------------
// @author: Prachi Bhasin
// @date: 30 July 2018
// @param: NA
// @description: Class which acts as controller for revisitOpportunity quick action 
// @return: NA
// @company: VERTIBA
//--------------------------------
public without sharing class RevisitOpportunityLookup{

    
    //-----------------------------
    // @author: Prachi Bhasin
    // @date: 30 July 2018
    // @param: instance of task Object with values populated from component, Id of parent opportunity
    // @description: SFDC1 - 9500 : When clicking the revisit opportunity button a task should be created
    // @return: Id of task created
    // @company: VERTIBA
    //------------------------------
    @AuraEnabled
    public static Id creatTask(Task taskObj,Id parentId){ 
        Opportunity opp = [Select id,Probability,Revisit__c,CloseDate,CurrencyISOCode,ByPassValidation__c from Opportunity where Id =: parentId];       
        opp.ByPassValidation__c = true;
        opp.Revisit__c = TRUE;
        update opp;
        
        taskObj.OwnerId = UserInfo.getUserId();
        taskObj.WhatId =parentId ;
        taskObj.TaskToRevisitOpportunity__c = true;
        taskObj.CurrencyISOCode = opp.CurrencyISOCode ;
        insert taskObj;
        
        opp.Probability = 0;      
        if(opp.CloseDate < taskObj.ActivityDate) {
            opp.CloseDate = taskObj.ActivityDate.addDays(90);
        }
        opp.ByPassValidation__c = false;
        update opp;
        return taskObj.Id;
    }
}