//***************************************************************************************************************
// @author Tran-Vu Tran (adapted from Uttam's code in Markit Legacy AccountRankingTrigger class)
// @date 02nd April 2018
// @description SFDC1-7592 Account Ranking Lift & Shift from Legacy Markit
// Class created to add common methods to be used by Account Ranking trigger handler classes
//***************************************************************************************************************

public class AccountRankingMethods {

    public static void CalculateRanking (TriggerParameters tp) {
        
        if (tp.tEvent == TriggerParameters.TriggerEvent.afterInsert ||
            tp.tEvent == TriggerParameters.TriggerEvent.afterUpdate) {
            
            Boolean recalculateAccountrankings = false;
                
            set <String> countryMetricKeys = new set <String>();
            
            List <AccountRanking__c> newList = tp.newList;
                
            if (!GlobalVariables.skipAccountRanking) {
                
                if (tp.tEvent == TriggerParameters.TriggerEvent.afterInsert) {
                    for (AccountRanking__c arr : newList) {

                        if (arr.Value__c != null && arr.MetricsKey__c != null) {
                            recalculateAccountrankings = true;
                            countryMetricKeys.add(arr.MetricsKey__c);
                            //System.debug('@@@@@@UA arr' + arr);
                        }
                    }
                }
                else if (tp.tEvent == TriggerParameters.TriggerEvent.afterUpdate) {
                    for (AccountRanking__c arr : newList) {
                        
                        AccountRanking__c oldAR = (AccountRanking__c) tp.oldMap.get(arr.id);
                        
                        if (arr.Value__c != null && arr.MetricsKey__c != null
                            && (arr.Value__c <> oldAR.Value__c
                                || arr.MetricsKey__c <> oldAR.MetricsKey__c
                               )
                           ) {
                               recalculateAccountrankings = true;
                               countryMetricKeys.add(arr.MetricsKey__c);
                               //System.debug('@@@@@@UA arr' + arr);
                               
                               if (oldAR.MetricsKey__c != null) {
                                   countryMetricKeys.add(oldAR.MetricsKey__c);
                                   //System.debug('@@@@@@UA arr' + arr);
                               }
                           } else {
                               continue;
                           }
                    }
                }
            }
            
            if (recalculateAccountrankings) {
                AccountMethods.recalculateAccountRankings(countryMetricKeys);
            }
        }
    }
    
}