//-----------------------------
// @author: Uttam Arya
// @date: 14 Sept 2017
// @param: NA
// @description: SFDC1-442 Used in custom console component, provides Account and Contact average quality ratings (past 3 months) 
//                    and link  to lastest Account OID record
// @return: NA
//-----------------------------
public class ServiceCloudSurveyScoreController {
    private final Case c;
    public String accountOID {get; set;}
    public Integer accountOverallQuality {get; set;}
    public Integer customerOverallQuality {get; set;}
    
    public ServiceCloudSurveyScoreController(ApexPages.StandardController stdController) {
        accountOverallQuality = 0;
        customerOverallQuality = 0;
        this.c = (Case)stdController.getRecord();
        if(this.c.AccountId != null) {
            List<Case> tmpList = [select Id, OIDTicket__c from Case where AccountId = :this.c.AccountId and OIDTicket__c != null order by LastModifiedDate desc limit 1];
            if(!tmpList.isEmpty()) {
                accountOID = tmpList[0].OIDTicket__c;
            }
            AggregateResult[] groupedResults = [SELECT AVG(Score__c) averageScore FROM SurveyResponse__c where Account__c = :this.c.AccountId and SurveyType__c ='Customer Care' and CreatedDate = LAST_90_DAYS];
            accountOverallQuality = Integer.valueOf(groupedResults[0].get('averageScore'));
            List<SurveyResponse__c> lastcustomercase = [SELECT Score__c FROM SurveyResponse__c where Contact__c  = :this.c.ContactId and Score__c != null and SurveyType__c = 'Customer Care' order by CreatedDate limit 1];
            if(lastcustomercase != null && !lastcustomercase.isEmpty()){
                customerOverallQuality = Integer.valueOf(lastcustomercase[0].Score__c);
            }
            if(accountOverallQuality == null) {
                accountOverallQuality = 0;
            }
            
            if(customerOverallQuality == null) {
                customerOverallQuality = 0;
            }
            
        }
    }
}