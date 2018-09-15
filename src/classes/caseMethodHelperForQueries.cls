//-----------------------------
// @author: Uttam Arya
// @date: 22 June 2017
// @param: NA
// @description: Class to hold trigger methods 
// @return: NA
//-----------------------------
global class caseMethodHelperForQueries { 
//
    // @author: Prachi Bhasin
    // @date: 15 May 2018
    // @description: SFDC1-7574 method returns a query with all fields of sobject
    // @param: String - name of object
    // @return:  String
    // @companyname: Vertiba
    //
    global static List<TriageCriteria__c> allTriageList {
          get {
               if (allTriageList == null) {
                List<CaseTriageExecutionOrder__c> listSortOrderFields = new List<CaseTriageExecutionOrder__c>();
                listSortOrderFields = CaseTriageExecutionOrder__c.getall().values();
                    //Dynamic query building starts here
                    String SELECTClause = UtilityClass.queryBuilder('TriageCriteria__c');
                    String SORTINGClause ='';
                    if(!listSortOrderFields.isEmpty()) {
                        SORTINGClause =' ORDER BY ';
                        for(CaseTriageExecutionOrder__c sortObj :listSortOrderFields ) { 
                            if(sortObj.ASC__c) {
                                SORTINGClause = SORTINGClause + sortObj.Field__c +' ASC,';
                            }
                            else if(sortObj.DESC__c) {
                                SORTINGClause = SORTINGClause + sortObj.Field__c +' DESC,';
                            }
                        }
                        SORTINGClause =SORTINGClause.removeEnd(',');
                    }
                    String query = SELECTClause + SORTINGClause;
                    System.debug('query--'+query);
                    allTriageList = Database.query(query);
                    //Dynamic query building ends here  
                                  
               }
                 return allTriageList;   
               
          }
          set;
     }
}