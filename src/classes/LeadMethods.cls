//-----------------------------
// @author : Paras Dhingra
// @date : 8th Aug 2017
// @description : SFDC1-1081 common class for Lead trigger
// @companyname : IHS Markit
//-----------------------------
public class LeadMethods {
    
      //-----------------------------
      // @author : Paras Dhingra
      // @date : 8th Aug 2017
      // @description : SFDC1-1081 update Country lookup 
      //             based on the OOB country picklist
      // @param : TriggerParameters
      // @return : void
      // @companyname :IHS Markit
      // @lastupdated : SFDC1-192 : Mohit Modi : Updated the complete logic to move from after events to before updates as it was causing the issue 
      // Validation rule created newly.Country field will be updated in before insert and after Events.
      //-----------------------------
      
    public static void updateCountryLookup(TriggerParameters tp) {
          
        if (tp.tEvent == TriggerParameters.TriggerEvent.beforeInsert || tp.tEvent == TriggerParameters.TriggerEvent.beforeUpdate) {

            Map<Id, Lead> oldMap = (Map<Id, Lead>)tp.oldMap;

            for(lead newlead : (list<lead>)tp.newList)
            {
                // Checking if it is Insert or Update Event
                if(oldMap == NULL || (oldMap != NULL && newlead.CountryCode != oldMap.get(newlead.id).CountryCode))
                {
                    if(newlead.CountryCode != NULL)
                    {
                        Country__c country = UtilityClass.getCountryByIsoCode(newlead.CountryCode);
                        System.debug('country-----'+country);
                        // Adding the Country if found else keep the blank value.
                        newlead.Country__c = country!=null ? country.Id : NULL ;
                    }
                    else {
                        // Clearing the Country field if Country is removed.
                        newlead.Country__c = NULL;
                    }
                }
            }
        }   
    }
    
    
      //-----------------------------
      // @author : Anjani Shukla
      // @date : 14th May 2018
      // @description : SFDC1-6570 : This Method will update Lead Description 
      //                on opportunity after lead conversion process.
      //              : SFDC1-8536 - Move all Lead object related Process Builder logic in the trigger.
      //              : PB Story - 4551 -IsConvertedLeads() && IsConvertedOpportunityId not NULL Only,Update Oportunity 
      //              : Closed Date - Original to Today() + 14; 
      // @param : TriggerParameters
      // @return : void
      // @companyname :Vertiba
      //-----------------------------
      
    public static void updateLeadDescriptionOnOpty(TriggerParameters tp) {
        
        if (tp.tEvent == TriggerParameters.TriggerEvent.afterUpdate) {
            //Get Details for Leads and Converted Opportunity
            Map<Id, Lead> oldMap = (Map<Id, Lead>)tp.oldMap;
            Map<Id, Lead> newMap = (Map<Id, Lead>)tp.newMap;
            list<opportunity> lstopportunity = new list<Opportunity>();
            for(lead newlead : (list<lead>)tp.newList) {
                if(newlead.IsConverted && !oldMap.get(newlead.id).IsConverted && newlead.ConvertedOpportunityId != null) {
                    Opportunity objOpp = new Opportunity (id = newlead.ConvertedOpportunityid, 
                                                          Description = newLead.Description,
                                                         CloseDateOriginal__c = System.today() + 14);
                    system.debug('objOpp-->'+objOpp);
                    lstopportunity.add(objOpp);
                }    
            }
            
            // Update Opportunity
            if(!lstopportunity.isEmpty()) {
                system.debug('lstopportunity-->'+lstopportunity);
                update lstopportunity;
            }
            
        }   
    }
    
      //-----------------------------
      // @author : Anjani Shukla
      // @date : 06 Jun 2018
      // @description : SFDC1-8536 - Move all Lead object related Process Builder logic in the trigger.
      //              : PB Story - SFDC1-2305 - IsNew() Only,Update to Lead Source field (Marketing Profile - Marketing Generated,
      //              : Sales Profile - Rep Generated,Customer Care profile - Customer Care)
      //              : SFDC1-192 : Setting LeadStatus based on LoggedinUser Profile
      // @param : TriggerParameters
      // @return : void
      // @companyname :vertiba
      // @lastupdatedby : Mohit Modi
      // @lastupdateddescription : SFDC1-9490 , Updated the Code for correct PicklistValues.
      //-----------------------------
      
    public static void updatetoNewLeadSourcefield(TriggerParameters tp) {
        List<Lead> newLeadList = (List<Lead>)tp.newList;
        
        if (tp.tEvent == TriggerParameters.TriggerEvent.BeforeInsert) {
            Id profileId = UserInfo.getProfileId();
            String profileName =[Select Id, Name from Profile where Id=:profileId].Name;
            system.debug('profileName==>'+profileName);
            //Validate Criteria
            for(Lead leadObj: newLeadList) { 
                // If created by Marketing User, then update Lead Source to Marketing Generated & Status to Pre-Sales Working.
                if(profileName.contains('IHSMarkit Sales: Marketing') || profileName.contains('Marketing')) {
                    leadObj.LeadSource = 'Marketing Generated';
                    leadObj.Status = 'Pre-SalesWorking';
                }
                // If created by Sales User, then update Lead Source to Rep Generated & Status to Sales Working.
                else if(profileName.contains('IHSMarkit Sales: General') || profileName.contains('General')) {
                    leadObj.LeadSource = 'Rep Generated';
                    leadObj.Status = 'SalesWorking';
                }
                // If created by Sales User, then update Lead Source to Rep Generated & Status to Sales Working.
                else if(profileName.contains('Customer Care')) {
                    leadObj.LeadSource = 'Customer Care';
                }
            }
        }    
    }       
    
    
    //-----------------------------
    // @author: Anjani Shukla
    // @date: 04 July 2018
    // @param:  Lead Object and converted Opportunity Id 
    // @description: SFDC1-8326 Update Campaign Influence to Work with OoB Lead Conversion and for Equal Attribution
    // @return: NA
    // @Company: Vertiba
    //------------------------------    
    public static void campaignFromLeadToOpportunity(TriggerParameters tp) {        
      try {  
        if (tp.tEvent == TriggerParameters.TriggerEvent.afterUpdate) {
            //Get Details for Leads and Converted Opportunity
            Map<Id, Lead> oldMap = (Map<Id, Lead>)tp.oldMap;
            Map<Id, Lead> newMap = (Map<Id, Lead>)tp.newMap;
            Set<Id> leadIds = new Set<Id>();
            
            //get Campaign Influence Model 
            List<CampaignInfluenceModel> CampaignModelLst = [select Id from CampaignInfluenceModel where IsDefaultModel= true limit 1];
            
            Id CampaignModel = CampaignModelLst[0].id;
            
            
            //get converted lead id details.
            
            for(lead newlead : (list<lead>)tp.newList) {
                if(newlead.IsConverted && !oldMap.get(newlead.id).IsConverted && newlead.ConvertedOpportunityId != null) {
                    leadIds.add(newlead.id);    
                }
            }
            
            Map<id,CampaignMember> campMembers;
            
            if(leadIds != null) {
                //get Campaign details for converted lead.
                campMembers = new Map<id,CampaignMember>([select Id,CampaignId,CompanyOrAccount,ContactId,
                                                         LeadId,Lead.convertedOpportunityid,LeadOrContactId from CampaignMember
                                                         where LeadId IN: leadIds]);
            }    
            
            Set<id> campIds = new Set<Id>();
            //Map contains key as leadid and values as list of campaign members 
            Map<Id,List<CampaignMember>> leadCampaignMemberMap = new Map<Id,List<CampaignMember>>();
            if(campMembers != null) {
                for (CampaignMember cm : campMembers.values()) {
                    List<CampaignMember> campMemberLst = leadCampaignMemberMap.get(cm.LeadId);
                    if (campMemberLst == null) {
                        campMemberLst = new List<CampaignMember>();
                    }
                    campMemberLst.add(cm);
                    leadCampaignMemberMap.put(cm.Leadid, campMemberLst);
                }
                
            }    
            //List for campaign influence record.
            List<CampaignInfluence> campaignInfluenceList = new List<CampaignInfluence>();
            
            
            //check if lead has campaigns
            if(leadCampaignMemberMap != null) {
                for(Id leadObj :newMap.keyset()) {
                    for(CampaignMember campaignMembers: leadCampaignMemberMap.get(leadObj)) {
                        CampaignInfluence campInfluence = new CampaignInfluence();
                        campInfluence.OpportunityId = campaignMembers.Lead.convertedOpportunityid;
                        campInfluence.CampaignId = campaignMembers.CampaignId;
                        campInfluence.ModelId = CampaignModel;
                        campInfluence.Influence = (Double)0;
                        campaignInfluenceList.add(campInfluence);
                    }                        
                }   
            }
            
            if(!campaignInfluenceList.isEmpty()) {
                    insert campaignInfluenceList;
            }
        }
      } catch(Exception ex) {
            UtilityClass.createApexLogRecord(ex,'LeadMethods','campaignFromLeadToOpportunity');  
      }  
    }
}