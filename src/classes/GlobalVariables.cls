//-----------------------------
// @author: Uttam Arya
// @date: unknown
// @param: NA
// @description: Class to hold Global variables which can be used for different classes 
// @return: NA
// @updated: SFDC1-7592 migrated from Markit legacy codes
// @updateBy: Tran-Vu Tran on 30 March 2018
//-----------------------------

public without sharing class GlobalVariables
{
    public static boolean skipAccountRanking = false;
    
    // keeping the list of accounts waiting to be updated, to avoid being updated multiple times
    public static Set<Id> AccountsWaitingForUpdate = new Set<Id>();
    // To stop oppty trigger from firing multiple times
    public static boolean preventRecursiveTranstion = true;
    // To stop oppty trigger from firing multiple times
    public static boolean preventRecursiveExecution = true;
}