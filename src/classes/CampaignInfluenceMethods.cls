//-----------------------------
// @author: Anjani Shukla
// @date: 06 Feb 2018
// @param: NA
// @description: SFDC1-6636 & SFDC1-6657 - Before Insert - This will call CampaignInfluenceMethods class 
//                where record will be verified to diplay relevant error message
//           	  for duplicate and opportunity close date if over 90 days. 
// @return: NA
//-----------------------------
public class CampaignInfluenceMethods {
    //-----------------------------
    // @author: Anjani Shukla
    // @date: 06 Feb 2018 
    // @param: TriggerParameters tp
    // @description: Before Insert - This will call CampaignInfluenceMethods class 
	//               where record will be verified to diplay relevant error message
	//           	 for duplicate and opportunity close date if over 90 days. 
    // @return: None
    //------------------------------
    public static void checkDuplicateandOptyCloseDuration(TriggerParameters tp) {
        if(tp.tEvent == TriggerParameters.TriggerEvent.BeforeInsert) {   
        String avoidDupeMessage = 'This Campaign Influence Record already exists on this Opportunity.';
        String avoidOptyOver90Days='Please verify - Opportunity Close Date is over 90 days. You cannot add New Campaign Influence Record.';
        String finalMessage;
        list<CampaignInfluence> campaignInfList = (list<CampaignInfluence>)tp.newList; 
        
        // Capture Model Id from above list.
        List<Id> campInfluenceModelIds = new List<Id>();
		List<Id> oppIds = new List<Id>();
        for(CampaignInfluence c : campaignInfList) {
         	 campInfluenceModelIds.add(c.CampaignId); 
			 oppIds.add(c.OpportunityId);
        }
        Map<Id,CampaignInfluence> existingCampaignInfluenceMap;
        // Get Campaign Influence details.
	   if(campInfluenceModelIds.size() > 0 && oppIds.size() > 0 ) {
           existingCampaignInfluenceMap = new  Map<Id,CampaignInfluence>([SELECT Id,ModelId,CampaignId,ContactId,
                                                                          OpportunityId,Opportunity.campaignid,
                                                                          Opportunity.MarketingCampaign__c
                                                                          FROM CampaignInfluence 
                                                                          where CampaignId IN: campInfluenceModelIds AND 
                                                                          OpportunityId IN: oppIds ]); 
	   }
	   system.debug('existingCampaignInfluenceMap -->'+existingCampaignInfluenceMap.values() );
	   // Create to build map where key will be ModelId and Values will be Oppty Id,Contact Id and Campaign Id.
        Map<Id,CampaignInfluence> campInflMap = new Map<Id,CampaignInfluence>();
        
        // Create List to store Oppty Id,Contact Id and Campaign Id associated to one Model Id.
        List<Id> allIdsLst = new List<Id>();
        
        // Create List to store opportunity id.
        Set<Id> opportunityIds = new Set<Id>();
        
        // Get Opportunity Details to get duration details.
        Map<Id,Opportunity> opptyMap = new Map<Id,Opportunity>([select id,DurationfromClosedDate__c,CloseDate from Opportunity where id IN: oppIds]);
        system.debug('opptyMap==>'+opptyMap.values()); 
        boolean checkIfavoidDupeMessage = false;
		// Iterate to build map where key will be ModelId and Values will be Oppty Id,Contact Id and Campaign Id.
        for(CampaignInfluence c: existingCampaignInfluenceMap.values()) {
            opportunityIds.add(c.OpportunityId);
            for(CampaignInfluence clst:campaignInfList) {
                if( c.OpportunityId == clst.OpportunityId && 
                    c.Opportunity.MarketingCampaign__c == clst.CampaignId) {
                    finalMessage = avoidDupeMessage;
                    checkIfavoidDupeMessage= true;
                	clst.adderror(finalMessage);
                }
                
                //check opportunity 90 days from close date.
                if (Integer.valueOf(opptyMap.get(clst.OpportunityId).CloseDate.daysBetween(System.today())) > 90) {
                    if (checkIfavoidDupeMessage) {
                    	finalMessage = avoidDupeMessage +'\n'+avoidOptyOver90Days;
                    } 
					else {
                        finalMessage = '\n'+avoidOptyOver90Days;
                    }    
                    clst.adderror(finalmessage);                
                }    
            }
        } 
       }       
    } 
    
    
        
    //-----------------------------
    // @author: Anjani Shukla
    // @date: 06 July 2018
    // @param: TriggerParameters tp
    // @description: After Insert - This will call CampaignInfluenceMethods class 
	//               where record campaign influence % is recalculated. 
    // @return: None
    //------------------------------
    public static void updateCampaignInfluencePercent(TriggerParameters tp) {
        try {  
           if(tp.tEvent == TriggerParameters.TriggerEvent.AfterInsert ||tp.tEvent == TriggerParameters.TriggerEvent.AfterDelete ) {
             list<CampaignInfluence> campaignInfList = new  list<CampaignInfluence> ();
                if(tp.tEvent == TriggerParameters.TriggerEvent.AfterInsert ) {
                    campaignInfList = (list<CampaignInfluence>)tp.newList;
                }
                
                if(tp.tEvent == TriggerParameters.TriggerEvent.AfterDelete ) {
                    campaignInfList = (list<CampaignInfluence>)tp.oldList;
                }
                  set<Id> opptyId = new Set<id>();
                  set<Id> modelId = new Set<id>();
                  //get opportunity id and Model id
                  if(campaignInfList != null) {
                      for(CampaignInfluence newCamp: campaignInfList) {
                      		opptyId.add(newCamp.opportunityId); 
                            modelId.add(newCamp.ModelId);                            
                      }        
                  }
                  
                  Map<Id,CampaignInfluence> existingCampaignInfluenceMap = new Map<Id,CampaignInfluence>();
                  
                  //get existing campaign influence
                  if(opptyId != null && modelId != null ) {
                  	existingCampaignInfluenceMap = new  Map<Id,CampaignInfluence>([SELECT Id,ModelId,CampaignId,ContactId,
                                                                                   OpportunityId,Opportunity.campaignid,
                                                                                   Opportunity.MarketingCampaign__c
                                                                                   FROM CampaignInfluence 
                                                                                   where 
                                                                                   OpportunityId IN: opptyId AND    
                                                                                   ModelId IN: modelId 
                                                                                   ]);
                    															    	     
                  	
                  }
                
                  system.debug('existingCampaignInfluenceMap-->'+existingCampaignInfluenceMap);
                  
                  // Map opportunity as key and list of Campaign Influence records.
                  Map<Id,List<CampaignInfluence>> optyCampInflMap = new Map<Id,List<CampaignInfluence>>();
                                  
                  //get count of record with same opportunity id,campaign id for created campign influence records
                  if( existingCampaignInfluenceMap != null) {
                      for(CampaignInfluence existCamp: existingCampaignInfluenceMap.values()) {
                          List<CampaignInfluence> campInflLst = optyCampInflMap.get(existCamp.OpportunityId);
                                if (campInflLst == null) {
                                    campInflLst = new List<CampaignInfluence>();
                                    
                                }
                          //update map -optyCampInflMap
                          campInflLst.add(existCamp);
                          optyCampInflMap.put(existCamp.OpportunityId, campInflLst);   
                      }
                  }    
               
                system.debug('optyCampInflMap-->'+optyCampInflMap);
                for(CampaignInfluence existCamp: existingCampaignInfluenceMap.values()) {
                	existCamp.Influence = ((Double)100/optyCampInflMap.get(existCamp.OpportunityId).size());
                }
                update existingCampaignInfluenceMap.values();                
           }     
        }
        catch(Exception ex) {
            UtilityClass.createApexLogRecord(ex,'CampaignInfluenceMethods','updateCampaignInfluencePercent');  
        } 
    }        
}