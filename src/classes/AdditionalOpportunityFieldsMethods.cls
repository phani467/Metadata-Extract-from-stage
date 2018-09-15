//-----------------------------
// @author: Sonam Raju
// @date: 8 Mar 2018
// @param: NA
// @description: SFDC1-6937 Class to hold Additional Opportunity Fields trigger methods 
// @Last Modified By : Sruti Srivastava
// @Last Modified Date: 27 April 2018
// @Last Modified Description: SFDC1-8090 - Added exception handling
//-----------------------------
public class AdditionalOpportunityFieldsMethods {

//-----------------------------
// @author: Sonam Raju
// @date: 8 Mar 2018
// @param: TriggerParameters tp
// @description: SFDC1-6937 Whenever a 'New Business' record type opportunity is created via an integration/data migration or manually, an "Additional Opportunity Fields" 
//                          record belonging to the opportunity is automatically created and a link to the record is populated in the "Additional Opportunity Fields" field. 
//                          This function populate the Additional Fields lookup in Opportunity.
//
// @return: None
// @Modification : Added exception handling
// @Modified by : Sruti Srivastava
// @Last Modified Date: 27 April 2018
//------------------------------
    public static void populateAdditionalFieldsLookupInOpportunity(TriggerParameters tp) {
    
		//List of Opportunities that needs to be updated    
		List <Opportunity> opportunitiesToUpdate = new List <Opportunity>(); 
		
		for(AdditionalOpportunityFields__c aof: (List <AdditionalOpportunityFields__c>) tp.newList) {
			if(aof.OpportunityReference__c != null) {
				opportunitiesToUpdate.add(new Opportunity(Id = aof.OpportunityReference__c, AdditionalOpportunityFields__c = aof.Id));
			}
		}
		
		//update if list has any records
		if(opportunitiesToUpdate!= null && opportunitiesToUpdate.size() > 0) {
			try {
				update opportunitiesToUpdate;
			}
			//Logging errors and displaying to user
			catch(Exception exp) {
                String errMessage = exp.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION')? 
                    				exp.getMessage().substringAfterLast('FIELD_CUSTOM_VALIDATION_EXCEPTION,'):exp.getMessage();
				UtilityClass.createApexLogRecord(exp, 'AdditionalOpportunityFieldsMethods', 'populateAdditionalFieldsLookupInOpportunity');  
				tp.newList[0].addError('Error: '+errMessage);
			} 
		}
    }
}