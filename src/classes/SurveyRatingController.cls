//-----------------------------
// @author: Ankita Singh
// @date: 20 Feb 2018
// @param: NA
// @description: SFDC1-6011 --Survey Response - Display CES on case console for Contact and Account
// @return: NA
// @company: VERTIBA
//-----------------------------
public class SurveyRatingController {
     //-----------------------------
    // @author: Ankita Singh
    // @date: 20 Feb 2018 
    // @param:case Id 
    // @description:This method retrieves CE Score for Contact associated with the case
    // @return:CE Score for associated with the case id  
    //------------------------------
	@AuraEnabled
        public static SurveyResponse__c getContactScore(Id caseId) {
        String SurveyType = 'Customer Care';
        String conId = [Select id,contactid from Case where  id=:caseId Limit 1].ContactId;
        list<SurveyResponse__c> cesContact = [select Contact__c,Contact__r.FirstName,Contact__r.LastName,CreatedDate,CESScore__c from SurveyResponse__c where Contact__c =:conId AND CESScore__c!=NULL AND SurveyType__c=:SurveyType ORDER BY CreatedDate DESC LIMIT 1];  
        if(cesContact.size() >0 && !cesContact.isEmpty()) {
        	return cesContact[0];
         }
         else {
           return null; 
         }
    }
    //-----------------------------
    // @author: Ankita Singh
    // @date: 20 Feb 2018 
    // @param:case Id 
    // @description:This method retrieves CE Score for all surveys for the account associated with the case
    // @return:Average CE Score ,Account id and Account Name(of type wrapper class AccountScoreWrapper)for all surveys for the account associated with the case id  
    //------------------------------
	@AuraEnabled
        public static SurveyRatingController.AccountScoreWrapper getAccountScore(Id caseId) {
        String SurveyType = 'Customer Care';
		double avgCESScore =0;
		AccountScoreWrapper asw = new AccountScoreWrapper();
        List<Case> acc = [Select id,accountid,Account.Name from Case where  id=:caseId  AND accountid!=NULL Limit 1]; 
		if(acc.size() > 0 && acc != null) {
			AggregateResult[] groupedResults = [SELECT AVG(CESScore__c) averageScore FROM SurveyResponse__c where Account__c = :acc[0].accountid and CESScore__c!=null and SurveyType__c ='Customer Care' and CreatedDate = LAST_90_DAYS];
            if(double.valueOf(groupedResults[0].get('averageScore')) != null && double.valueOf(groupedResults[0].get('averageScore'))>0) {
                avgCESScore = double.valueOf(groupedResults[0].get('averageScore'));
            }
			asw.avgscore = avgCESScore;
			asw.accountId= acc[0].accountid;
            asw.accName= acc[0].Account.Name;
			return asw;
		}
		else {
            asw.avgscore = avgCESScore;
            asw.accountId= '';
            asw.accName= '';
			return asw;
		}
    }
   
    //-----------------------------
    // @author: Ankita Singh
    // @date: 23 Feb 2018 
    // @param:case Id 
    // @description:This method retrieves Last Incident Ticket associated with the account
    // @return:Case related to Last Incident Ticket associated with the account
    //------------------------------
	@AuraEnabled
        public static Case getLastIncidentTicket(Id caseId) {
        String SurveyType = 'Customer Care';
        String accId = [Select id,accountid from Case where  id=:caseId Limit 1].AccountId;
		if(accId!=null && accId!='') {
			List<Case> lastIncidentTicket = [select Id, OIDTicket__c,ServiceLink__c from Case where AccountId = :accId AND OIDTicket__c != null order by LastModifiedDate desc limit 1];
			if(lastIncidentTicket.size()>0 && lastIncidentTicket!=null) {
				return lastIncidentTicket[0];
			}
			else {
				return null;
			}
		}
		else {
			return null;
		}
    }
    //-----------------------------
    // @author: Ankita Singh
    // @date: 28 Feb 2018 
    // @param:NA 
    // @description:This is a wrapper class
    // @return:NA
    //------------------------------	
	public class AccountScoreWrapper {
        @AuraEnabled public double avgscore;
        @AuraEnabled public String accountId;
        @AuraEnabled public String accName;

    }
}