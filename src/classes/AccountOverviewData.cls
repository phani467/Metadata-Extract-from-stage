//-----------------------------
// @author: Harshit Singhal
// @date: 17 July 2018
// @description: SFDC1-5228 This class is used in some relationships under Account Overview Report DocGen package.
// @companyname: IHS Markit
//-----------------------------
global class AccountOverviewData implements Loop.IApexDataSource {
    
    //Interface Method 1 Implementation: getGlobalDescribe()
    public Set <String> getGlobalDescribe() {
        return new Set <String>{'AccountOverviewParameters','NoContracts','NoOppies','NoOppiesNoContract'};
    }
    
    //Interface Method 2 Implementation: describeObjects()
    public List <Loop.ExternalData.DataObject> describeObjects(List<String> objNames) {
        List <Loop.ExternalData.DataObject> output = new List <Loop.ExternalData.DataObject>();
        for (String objectName :objNames) {
            List <Loop.ExternalData.FieldInfo> outputFields = new List <Loop.ExternalData.FieldInfo>();
            if (objectName == 'AccountOverviewParameters') {
                outputFields.add(new Loop.ExternalData.FieldInfo('AccountIDS', Schema.DisplayType.String));
                outputFields.add(new Loop.ExternalData.FieldInfo('OppyswithoutOwnerSelectedIDS', Schema.DisplayType.String));
                outputFields.add(new Loop.ExternalData.FieldInfo('OppyswithOwnerSelectedIDS', Schema.DisplayType.String));
                outputFields.add(new Loop.ExternalData.FieldInfo('ContractswithoutRRSelectedIDS', Schema.DisplayType.String));
                outputFields.add(new Loop.ExternalData.FieldInfo('ContratswithRRSelectedIDS', Schema.DisplayType.String));
                outputFields.add(new Loop.ExternalData.FieldInfo('KeyContactsIDS', Schema.DisplayType.String));
                outputFields.add(new Loop.ExternalData.FieldInfo('ContractsAtRiskIDS', Schema.DisplayType.String));
                outputFields.add(new Loop.ExternalData.FieldInfo('AccountAndOppiesTop5IDS', Schema.DisplayType.String));
            }
            if (objectName == 'NoContracts' || objectName == 'NoOppies' || objectName == 'NoOppiesNoContract') {
                outputFields.add(new Loop.ExternalData.FieldInfo('Error', Schema.DisplayType.String));
            }
            output.add(new Loop.ExternalData.DataObject(objectName, outputFields));
        }
        return output;
    }
    
    //Interface Method 3 Implementation: getChildRelationships()
    public Set <String> getChildRelationships(String objectName) {
        return null;
    }
    
    //Interface Method 4 Implementation: query()
    public Loop.ExternalData.QueryResultSet query(Loop.ExternalData.QueryRequestInfo requestInfo) {
        
        Loop.ExternalData.QueryResultSet results = new Loop.ExternalData.QueryResultSet();
        
        Integer contractCount = 0;
        Integer oppiesCount = 0;
        Integer contractatRiskCount = 0;
        
        if (string.valueOf(requestInfo.RecordId).startswith(Schema.sObjectType.AccountOverview__c.keyprefix)) {
            AccountOverview__c rootAO = [SELECT  Id,Account1__c,Account1__r.Name,Account1__r.GlobalUltimateAccount__c,OppQueryAmount__c,OppQueryProbabilty__c, 
                                         ExcludeSubsidiaries__c,
                                         IncludeRRRColumn__c,IncludeOpportunitiesOwner__c,IncludeAccountTeam__c,IncludeContractsatRisk__c,IncludeKeyContacts__c,IncludeUpcomingTopRenewals__c                                          
                                         FROM AccountOverview__c 
                                         WHERE Id = :requestInfo.RecordId];
                        
            String idStringEmpty = '(\'\')';
            
            //HS
            String accIdStrings = '(\'\')';
            String accIdOpptyStrings = '(\'\')';
            List<String> accIdList = new List<String>();
            List<String> accIdOpptyList = new List<String>();
            
            if(rootAO != null) {
                if(!rootAO.ExcludeSubsidiaries__c && rootAO.Account1__c != null) {
                    System.debug('@HS Do not exclude Subsidiaries');
                    
                    Map <Id, Account > accountsSubsidaries = new Map <Id, Account>();
                    
                    if(rootAO.Account1__r.GlobalUltimateAccount__c != null) {
                        //For Level2,Level3,Level4, and so forth... accounts which have Global Ultimate not as null
                        accountsSubsidaries.putAll(new List<Account>([SELECT Id FROM Account WHERE GlobalUltimateAccount__c = :rootAO.Account1__r.GlobalUltimateAccount__c OR Id = :rootAO.Account1__r.GlobalUltimateAccount__c ]));
                    }
                    else {
                        //For Top-level accounts which have Global Ultimate as null
                        accountsSubsidaries.putAll(new List<Account>([SELECT Id FROM Account WHERE Id = :rootAO.Account1__c OR GlobalUltimateAccount__c = :rootAO.Account1__c]));
                    }
                    
                    
                    /*
                    //Get subsidiary Accounts' IDs
                    Map <Id, Account > accountsSubsidaries = new Map <Id, Account >([SELECT Id
                                                                                     FROM Account 
                                                                                     WHERE GlobalUltimateAccount__c = :rootAO.Account1__r.GlobalUltimateAccount__c ]);
                    */
                    
                    System.debug('@HS accountsSubsidaries Map size='+accountsSubsidaries.size());
                    for (Id thisId : accountsSubsidaries.keySet()) {                        
                        accIdList.add('\''+thisId+'\'');	//HS
                    }
                                        
                    //Get ApprovedContractSummary count
                    contractCount = [SELECT count() 
                                     FROM ApprovedContractSummary__c 
                                     WHERE Account__c in :accountsSubsidaries.keySet()];                      
                    //Get Opp at risk count
                    contractatRiskCount = [SELECT Count() FROM RenewalatRisk__c WHERE ContractatRisk__c != null and Account__c in :accountsSubsidaries.keySet() and Status__c = 'Open - Pending Resolution'];	//?? Some doubt between 'OpportunityAtRisk__c'/'ContractatRisk__c' lookup fields
                    
                    //Get Account IDs from valid new business opportunities
                    Map <Id, Opportunity> oppiesMap = new Map <Id, Opportunity>([SELECT AccountId 
                                                                                 FROM Opportunity 
                                                                                 WHERE RecordType.Name = 'New Business' 
                                                                                 AND IsClosed != true 
                                                                                 AND Probability >= :rootAO.OppQueryProbabilty__c 
                                                                                 AND Amount != null 
                                                                                 AND Amount >= :rootAO.OppQueryAmount__c 
                                                                                 AND AccountId in :accountsSubsidaries.keySet()]);
                    Set <Id> accountIds = new Set <Id>();
                    for(Opportunity opp :oppiesMap.values()) {
                        accountIds.add(opp.AccountId);
                    }
                    for (Id thisId : accountIds) {
                        accIdOpptyList.add('\''+thisId+'\'');	//HS
                    }                    
                                        
                    //HS                    
                    if(accIdList.size()>0) {
                        accIdStrings = String.valueOf(accIdList);
                    }
                    if(accIdOpptyList.size()>0) {
                        accIdOpptyStrings = String.valueOf(accIdOpptyList);
                    }                    
                    
                    oppiesCount = accountIds.size();
                }
                else if(rootAO.ExcludeSubsidiaries__c && rootAO.Account1__c != null) {
                    System.debug('@HS Exclude Subsidiaries');
                    //HS                    
                    accIdList.add('\''+rootAO.Account1__c+'\'');	//HS
                    
                    contractCount = [SELECT count() 
                                     FROM ApprovedContractSummary__c 
                                     WHERE Account__c = :rootAO.Account1__c];  
                    //Get Opp at risk count
                    contractatRiskCount = [SELECT Count() 
                                           FROM RenewalatRisk__c 
                                           WHERE ContractatRisk__c != null AND Account__c = :rootAO.Account1__c AND Status__c = 'Open - Pending Resolution'];		//?? Some doubt between 'OpportunityAtRisk__c'/'ContractatRisk__c' lookup fields
                    Map <Id, Opportunity> oppiesMap = new Map <Id, Opportunity>([SELECT AccountId 
                                                                                 FROM Opportunity
                                                                                 WHERE RecordType.Name = 'New Business' 
                                                                                 AND IsClosed != true 
                                                                                 AND Probability >= :rootAO.OppQueryProbabilty__c 
                                                                                 AND Amount != null 
                                                                                 AND Amount >= :rootAO.OppQueryAmount__c
                                                                                 AND AccountId = :rootAO.Account1__c]);
                    Set <Id> accountIds = new Set <Id>();
                    for(Opportunity opp:oppiesMap.values()) {
                        accountIds.add(opp.AccountId);
                    }
                    
                    for (Id thisId : accountIds) {
                        accIdOpptyList.add('\''+thisId+'\'');	//HS
                    }
                    
                    //HS                    
                    if(accIdList.size()>0) {
                        accIdStrings = String.valueOf(accIdList);
                    }
                    if(accIdOpptyList.size()>0) {
                        accIdOpptyStrings = String.valueOf(accIdOpptyList);
                    }
                    
                    oppiesCount = accountIds.size();
                }
                System.debug('@HS idStringEmpty='+idStringEmpty);
                System.debug('@HS accIdStrings='+accIdStrings);
                System.debug('@HS accIdOpptyStrings='+accIdOpptyStrings);
                //Prepare data for 'AccountOverviewParameters' fields
                String AccountIDSString = accIdStrings;
                
                String OppyswithoutOwnerSelectedIDSString = rootAO.IncludeOpportunitiesOwner__c == false ? accIdOpptyStrings : idStringEmpty;
                String OppyswithOwnerSelectedIDSString = rootAO.IncludeOpportunitiesOwner__c == true ? accIdOpptyStrings : idStringEmpty;
                
                String ContractswithoutRRSelectedIDSString = rootAO.IncludeRRRColumn__c == false ? accIdStrings : idStringEmpty;
                String ContratswithRRSelectedIDSString = rootAO.IncludeRRRColumn__c == true ? accIdStrings : idStringEmpty;
                
                String KeyContactsIDSString = rootAO.IncludeKeyContacts__c == true ? accIdStrings : idStringEmpty;
                
                String ContractsAtRiskIDSString = rootAO.IncludeContractsatRisk__c == true ? accIdStrings : idStringEmpty;
                
                String AccountAndOppiesTop5IDSString = rootAO.IncludeUpcomingTopRenewals__c == true ? accIdStrings : idStringEmpty;
                
                String NoContractsError = '';
                String NoOppiesError = '';
                String NoOppiesNoContractError = '';
                
                System.debug('@HS Debugging field values calculated for AccountOverviewParameters...');
                System.debug('@HS AccountIDSString=' + AccountIDSString );
                System.debug('@HS OppyswithoutOwnerSelectedIDSString=' + OppyswithoutOwnerSelectedIDSString );
                System.debug('@HS OppyswithOwnerSelectedIDSString=' + OppyswithOwnerSelectedIDSString );
                System.debug('@HS ContractswithoutRRSelectedIDSString=' + ContractswithoutRRSelectedIDSString );
                System.debug('@HS ContratswithRRSelectedIDSString=' + ContratswithRRSelectedIDSString );
                System.debug('@HS KeyContactsIDSString=' + KeyContactsIDSString);
                System.debug('@HS ContractsAtRiskIDSString=' + ContractsAtRiskIDSString);
                System.debug('@HS AccountAndOppiesTop5IDSString=' + AccountAndOppiesTop5IDSString );
                System.debug('@HS NoContractsError1=' + NoContractsError );
                System.debug('@HS NoOppiesError1=' + NoOppiesError );
                System.debug('@HS NoOppiesNoContractError1=' + NoOppiesNoContractError );
                
                if(contractCount == 0 && oppiesCount == 0 && rootAO.ExcludeSubsidiaries__c == true) {
                    NoOppiesNoContractError = 'IHS Markit currently does not have any active contracts or open opportunities with '+ rootAO.Account1__r.Name + '.';
                }
                else if(contractCount > 0 && oppiesCount == 0 && rootAO.ExcludeSubsidiaries__c == true) {
                    NoOppiesError = 'IHS Markit currently does not have any open opportunities with this customer.';
                }
                else if(contractCount == 0 && oppiesCount > 0 && rootAO.ExcludeSubsidiaries__c == true) {
                    NoContractsError = 'IHS Markit currently does not have any active contracts with this customer.';
                }
                else if(contractCount == 0 && oppiesCount == 0 && rootAO.ExcludeSubsidiaries__c == false) {
                    NoOppiesNoContractError = 'IHS Markit currently does not have any active contracts or open opportunities with '+ rootAO.Account1__r.Name + ' and any of its subsidiaries.';
                }
                else if(contractCount > 0 && oppiesCount == 0 && rootAO.ExcludeSubsidiaries__c == false) {
                    NoOppiesError = 'IHS Markit currently does not have any open opportunities with this customer and any of its subsidiaries.';
                }
                else if(contractCount == 0 && oppiesCount > 0 && rootAO.ExcludeSubsidiaries__c == false) {
                    NoContractsError = 'IHS Markit currently does not have any active contracts with this customer and any of its subsidiaries.';
                }
                
                System.debug('@HS NoContractsError2=' + NoContractsError );
                System.debug('@HS NoOppiesError2=' + NoOppiesError );
                System.debug('@HS NoOppiesNoContractError2=' + NoOppiesNoContractError );
                
                if (Schema.sObjectType.AccountOverview__c.isAccessible()) {
                    
                    for(string objectName :requestInfo.GetObjectNames()) {
                        
                        if (objectName == 'AccountOverviewParameters') {
                            Loop.ExternalData.QueryResult accountOverviewParameterResult = new Loop.ExternalData.QueryResult(objectName, new List <string >{'AccountIDS','OppyswithoutOwnerSelectedIDS','OppyswithOwnerSelectedIDS','ContractswithoutRRSelectedIDS','ContratswithRRSelectedIDS','KeyContactsIDS', 'ContractsAtRiskIDS','AccountAndOppiesTop5IDS'});
                            accountOverviewParameterResult.rows.add(new List <string>{AccountIDSString,OppyswithoutOwnerSelectedIDSString,OppyswithOwnerSelectedIDSString,ContractswithoutRRSelectedIDSString,ContratswithRRSelectedIDSString,KeyContactsIDSString,ContractsAtRiskIDSString,AccountAndOppiesTop5IDSString});      
                            results.add(accountOverviewParameterResult);
                            System.debug('@HS Results' + accountOverviewParameterResult);
                        }
                        
                        if (objectName == 'NoContracts' || objectName == 'NoOppies' || objectName == 'NoOppiesNoContract') {
                            Loop.ExternalData.QueryResult oppiesandContractsCountResult = new Loop.ExternalData.QueryResult(objectName, new List <string >{'Error'});
                            if(objectName == 'NoContracts' && NoContractsError != '') {
                                oppiesandContractsCountResult.rows.add(new List<string>{NoContractsError});
                            }
                            if(objectName == 'NoOppies' && NoOppiesError != '') {
                                oppiesandContractsCountResult.rows.add(new List<string>{NoOppiesError});
                            }
                            if(objectName == 'NoOppiesNoContract' && NoOppiesNoContractError != '') {
                                oppiesandContractsCountResult.rows.add(new List<string>{NoOppiesNoContractError});
                            }
                            
                            results.add(oppiesandContractsCountResult);                            
                            System.debug('@HS oppiesandContractsCountResult=' + oppiesandContractsCountResult);
                        }
                    }
                }
            }
            
        }
        System.debug('@HS results=' + results);
        return results;
    }
}