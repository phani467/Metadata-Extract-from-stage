/**************************************************
 * Name - CampaignInfluenceTrigger
 * Event - Before Insert
 * Description - SFDC1-6636 - The owner of an 
 * 				 opportunity needs to be allowed to 
 * 				 add a Campaign to a closed Opp (Won or lost) 
 *               up to 90 days after it has closed.  
 * Author - 
 * Created by - Anjani Shukla
 * Date - 06 Feb 2018
 * Version/Modifications -
 * ***********************************************/
trigger CampaignInfluenceTrigger on CampaignInfluence (before insert, before update, before delete, after insert, after update, after delete) {
	TriggerFactory.createTriggerDispatcher(CampaignInfluence.sObjectType); 
}