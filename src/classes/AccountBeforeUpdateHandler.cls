//***************************************
// @author Uttam Arya
// @date 7th Feb 2017
// @description Re-structuring the trigger methods by using Trigger Handler framework. Org assessment 2016.
// @Last Modified By : Tran-Vu Tran
// @Last Modified Date : 12nd April 2018
// @Last Modified Description : SFDC1-7718 add method to update child accounts' Compliance Restriction value from Parent account if Exception is not checked
// 
// @Last Modified by: Harshit Singhal
// @Last Modified Date: 07 Jun 2018
// @Last Modified Description: SFDC1-8537 Added setAccountOwnerOnAccountManagerChangeAndUpdatePreviousOwner() method to convert:
// 								- Process Builder flow "Populate Account Owner on GAM update" created in SFDC1-1166(Update Account owner as GAM user on GAM update) to a trigger.
// 								- Process Builder flow "Account Owner Change Notification" created in SFDC1-470(Update previous owner and send notification email when there is change in Account Owner) + SFDC1-8131(do not send notification upon Owner changes) to a trigger.
//***************************************
public class AccountBeforeUpdateHandler extends TriggerHandlerBase {
    public override void mainEntry(TriggerParameters tp) {
        
        AccountMethods.updateNAICSHierarchyLookup(tp);
        AccountMethods.updateCountryLookup(tp);
        AccountMethods.setAccountOwnerOnAccountManagerChangeAndUpdatePreviousOwner(tp);
        // 20-April-2016 comment out codes - will be replaced by formula fields
        // AccountMethods.getComplianceRestrictionFromParent(tp);
    }
}