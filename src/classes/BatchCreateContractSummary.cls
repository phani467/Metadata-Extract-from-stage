//-----------------------------
// @author: Harshit Singhal
// @date: 12 July 2018
// @description: SFDC1-5228 This class creates Approved Contract Summary data for all accounts.
//-----------------------------
global class BatchCreateContractSummary implements Database.Batchable<sObject> {
    global String errorMsgs = '';
    public Database.QueryLocator start(Database.BatchableContext BC) {
        //return Database.getQueryLocator('SELECT Id FROM Account WHERE Number_of_Approved_Contracts__c >= 0');
        System.debug('@HS BATCH START()');
        return Database.getQueryLocator('SELECT Id FROM Account');
    }
    
    public void execute(Database.BatchableContext BC, List<sObject> scope) {
        System.debug('@HS BATCH EXECUTE() BEGINS');
        //PART 1 Variables
        Set<id> accountIDs = new Set<Id>();
        Map<String, ApprovedContractSummary__c> acsMap = new Map<String, ApprovedContractSummary__c>();
        List<ApprovedContractSummary__c> acsMapBillingSchedule = new List<ApprovedContractSummary__c>();
        
        //PART 1
        System.debug('@HS scope size='+scope.size());
        for(sObject acc: scope) {
            Account a = (Account) acc;
            accountIDs.add(a.id);
        }
        
        if(accountIDs != null && accountIDs.size() > 0) {
            //Pre clean all the Aproved Contract Summary data
            List<ApprovedContractSummary__c> acsToDeletePreClean = [SELECT id FROM ApprovedContractSummary__c WHERE Account__c in :accountIDs];            
            System.debug('@HS acsToDeletePreClean='+acsToDeletePreClean);
            if(acsToDeletePreClean != null && acsToDeletePreClean.size() > 0) {
                delete acsToDeletePreClean;
            }
			
			//Fetch valid Contract records            
            List<Contract> contractsList = [SELECT Id, AccountId, EndDate, ContractNumber, BillingFrequency__c, 
                                            (SELECT ContractLineItem__r.AssociatedProduct__r.ProductGroup__r.Name FROM ContractLineItemSchedules__r), 
                                            (Select Id From Contract_Line_Items__r)                                            
                                            FROM Contract 
                                            WHERE Account.Id in :accountIDs AND ContractApproved__c = true
                                            ORDER BY EndDate DESC
                                           ];
            System.debug('@HS contractsList size='+contractsList.size());
            System.debug('@HS contractsList='+contractsList);
            
            Map<Id, Contract> mapContracts =  new Map <Id, Contract>();            
            //Prepare unique Approved Contract Summary records from CLI Schedules
            for (Contract con : contractsList) {
                if(con.Contract_Line_Items__r != null && con.Contract_Line_Items__r.size() > 0) {							//Added a condition to check atleast one child line item to properly implement ContractAprroved=true condition in new org
                    mapContracts.put(con.Id,con);
                    for(ContractLineItemSchedule__c  cbs: con.ContractLineItemSchedules__r) {
                        String prodGroupName = cbs.ContractLineItem__r.AssociatedProduct__r.ProductGroup__r.Name;		//?? Add null checkS
                        String Key = con.AccountId + prodGroupName;
                        System.debug('@HS Contract Id: ' + Con.Id + 'Product Group: ' + prodGroupName);
                        acsMap.put(key, new ApprovedContractSummary__c( Account__c = con.AccountId, AnnualContractValue__c = null, ProductFamily__c = prodGroupName
                                                                       , EarliestContractEndDate__c = con.EndDate, BillingFrequency__c = con.BillingFrequency__c
                                                                       , Key__c = Key,ContractNumber__c = con.ContractNumber));
                    }
                }
            }
            System.debug('@HS mapContracts size='+mapContracts.size());
            System.debug('@HS mapContracts='+mapContracts);
            System.debug('@HS acsMap size='+acsMap.size());
            System.debug('@HS acsMap='+acsMap);
            
            //Insert Approved Contract Summary records
            if(acsMap != null && acsMap.size() > 0) {
                Schema.SObjectField f = ApprovedContractSummary__c.Fields.Key__c;
                List<Database.UpsertResult> upsertResult = Database.upsert(acsMap.values(), f, false);
                for(Integer i=0;i< upsertResult.size();i++) {
                    if(!upsertResult.get(i).isSuccess()) {
                        Database.Error error = upsertResult.get(i).getErrors().get(0);
                        String failedDML = error.getMessage();
                        errorMsgs += 'ACS rec: '+', '+failedDML+'<\br>';
                        System.debug('@HS Error during acs record upsert. DML Error='+failedDML);
                    }
                }
                System.debug('@HS After acsMap upsert Error Messages='+errorMsgs);
                System.debug('@HS UPSERT1 complete.');                
            }
            
            //PART 2: Fetch current year Schedules
            /*
            AggregateResult[] groupedContractsBillingScheduleMaxDatePast = [SELECT Contract__c contractId, ContractLineItem__r.AssociatedProduct__c productid
                                                                            	//, MAX(Billing_Date__c) billingDate					//??
                                                                            FROM   ContractLineItemSchedule__c 
                                                                            WHERE  Contract__r.AccountId = :accountIDs 
                                                                            //AND Contract__r.RecordType_Name__c = 'Approved Contract' 	//??
                                                                            //AND Billing_Date__c <= Today								//??
                                                                            //AND Revenue_Type_del__c= 'Recurring'						//??
                                                                            GROUP BY Contract__c, ContractLineItem__r.AssociatedProduct__c]; 
            AggregateResult[] groupedContractsBillingScheduleMinDateFuture = [SELECT Contract__c contractId, ContractLineItem__r.AssociatedProduct__c productid
                                                                              	//,MIN(Billing_Date__c) billingDate						//??
                                                                              FROM   ContractLineItemSchedule__c 
                                                                              WHERE  Contract__r.AccountId = :accountIDs 
                                                                              //AND Contract__r.RecordType_Name__c = 'Approved Contract' 	//??
                                                                              //AND Billing_Date__c > Today									//??
                                                                              //AND Revenue_Type_del__c= 'Recurring'						//??
                                                                              GROUP BY Contract__c, ContractLineItem__r.AssociatedProduct__c];
            
            for (AggregateResult ar : groupedContractsBillingScheduleMaxDatePast) {
                Date MaxBillingDate = ar.get('billingDate') != null? Date.valueOf(ar.get('billingDate')): null;
                String ContractId  = ar.get('contractId') != null? String.valueof(ar.get('contractId')): '';
                String ProductId  = ar.get('productid') != null? String.valueof(ar.get('productid')): '';
                if(billingDateMap.get(ContractId + ProductId) == null) {
                    billingDateMap.put(ContractId + ProductId, MaxBillingDate);
                    System.debug('Contract Id: ' + ContractId + ' Billing date: ' + MaxBillingDate); 
                }
            }            
            for (AggregateResult ar : groupedContractsBillingScheduleMinDateFuture) {                
                Date MinBillingDate = ar.get('billingDate') != null? Date.valueOf(ar.get('billingDate')): null;
                String ContractId  = ar.get('contractId') != null? String.valueof(ar.get('contractId')): '';
                String ProductId  = ar.get('productid') != null? String.valueof(ar.get('productid')): '';
                if(billingDateMap.get(ContractId + ProductId) == null) {
                    billingDateMap.put(ContractId + ProductId, MinBillingDate);
                    System.debug('Contract Id: ' + ContractId + ' Billing date: ' + MinBillingDate); 
                }
            }
            */
			String CURRENTYEAR = String.valueOf(System.today().year());
            
            /*
            List<ContractLineItemSchedule__c> cbsList = [SELECT Id, Contract__c, ContractLineItem__r.AssociatedProduct__c, ContractLineItem__r.AssociatedProduct__r.ProductGroup__r.Name                                                         
                                                         FROM ContractLineItemSchedule__c 
                                                         WHERE Contract__r.AccountId = :accountIDs                                                         
                                                         AND ContractLineItem__c != null                                                         
                                                         AND Contract__r.ContractApproved__c = true
                                                         AND ContractLineItem__r.AssociatedProduct__r.ProfitCenters__r.SaleType__c = 'Subscription'			//'Subscription' in new org means 'Recurring' in LMarkit
                                                         AND InstallmentYear__c = :CURRENTYEAR];
            System.debug('@HS current year cbsList='+cbsList);
            for(ContractLineItemSchedule__c cbs: cbsList){
                billigScheduleIds.add(cbs.Id);                
            }
            System.debug('@HS Current Year billigScheduleIds= ' + billigScheduleIds);
            */
            
            //PART 3:
            //Fetch totals of Recurring and Non-Recurring CLIS records
            Map<String, ApprovedContractSummary__c> mapACSContractValue = new Map<String, ApprovedContractSummary__c>();
            AggregateResult[] groupedContractsBillingScheduleTotalsRecurring = [SELECT SUM(SalesPrice__c) sumAnnualRev, Contract__r.AccountId accountid,  ContractLineItem__r.AssociatedProduct__r.ProductGroup__r.Name pf
                                                                                FROM ContractLineItemSchedule__c 
                                                                                WHERE Contract__r.AccountId = :accountIDs 
                                                                                AND Contract__r.ContractApproved__c = true
                                                                                AND ContractLineItem__c != null    
                                                                                AND ContractLineItem__r.AssociatedProduct__r.ProfitCenters__r.SaleType__c = 'Subscription' 
                                                                                AND InstallmentYear__c = :CURRENTYEAR
                                                                                GROUP BY Contract__r.AccountId, ContractLineItem__r.AssociatedProduct__r.ProductGroup__r.Name];
            
            AggregateResult[] groupedContractsBillingScheduleTotalsNonRecurring = [SELECT SUM(SalesPrice__c) sumAnnualRev, Contract__r.AccountId accountid,  ContractLineItem__r.AssociatedProduct__r.ProductGroup__r.Name pf
                                                                                   FROM ContractLineItemSchedule__c 
                                                                                   WHERE Contract__r.AccountId = :accountIDs 
                                                                                   AND Contract__r.ContractApproved__c = true
                                                                                   AND ContractLineItem__c != null    
                                                                                   AND ContractLineItem__r.AssociatedProduct__r.ProfitCenters__r.SaleType__c = 'Onetime'
                                                                                   //AND InstallmentYear__c <= Today		//??
                                                                                   AND InstallmentYear__c = :CURRENTYEAR
                                                                                   GROUP BY Contract__r.AccountId, ContractLineItem__r.AssociatedProduct__r.ProductGroup__r.Name];
                                                                                   
           AggregateResult[] groupedContractsBillingScheduleTotalsConsulting = [SELECT SUM(SalesPrice__c) sumAnnualRev, Contract__r.AccountId accountid,  ContractLineItem__r.AssociatedProduct__r.ProductGroup__r.Name pf
                                                                                   FROM ContractLineItemSchedule__c 
                                                                                   WHERE Contract__r.AccountId = :accountIDs 
                                                                                   AND Contract__r.ContractApproved__c = true
                                                                                   AND ContractLineItem__c != null   
                                                                                   AND ContractLineItem__r.AssociatedProduct__r.ProfitCenters__r.SaleType__c = 'Consulting'
                                                                                   //AND InstallmentYear__c <= Today		//??
                                                                                   AND InstallmentYear__c = :CURRENTYEAR
                                                                                   GROUP BY Contract__r.AccountId, ContractLineItem__r.AssociatedProduct__r.ProductGroup__r.Name];
            
            //Process Contracts that contain Subscription/Recurring type products
            for (AggregateResult ar : groupedContractsBillingScheduleTotalsRecurring) {
                Decimal SumAnnualRevenue = ar.get('sumAnnualRev') != null? Decimal.valueOf(double.valueOf(ar.get('sumAnnualRev'))): 0;
                String AccountId = ar.get('accountid') != null? String.valueof(ar.get('accountid')): '';
                String PFamlies = ar.get('pf') != null? String.valueof(ar.get('pf')): '';
                List<String> familyList  = PFamlies.split(',');					//?? Is this split on prod group name required?
                for(String pf: familyList) {
                    String Key = AccountId + pf;
                    mapACSContractValue.put(Key, new ApprovedContractSummary__c(RevenueType__c= 'Subscription', Account__c=AccountId,AnnualContractValue__c=SumAnnualRevenue,ProductFamily__c=pf, Key__c = Key));
                }                
                System.debug('@HS PF: ' + PFamlies + ' Subscription Amount: ' + SumAnnualRevenue);            
            }
            
            //Process Contracts that contain One off/Non-Recurring type products
            for(AggregateResult ar : groupedContractsBillingScheduleTotalsNonRecurring) { 
                
                Decimal SumAnnualRevenue = ar.get('sumAnnualRev') != null? Decimal.valueOf(double.valueOf(ar.get('sumAnnualRev'))): 0;
                String AccountId = ar.get('accountid') != null? String.valueof(ar.get('accountid')): '';
                String PFamlies = ar.get('pf') != null? String.valueof(ar.get('pf')): '';
                List<String> familyList  = PFamlies.split(',');
                for(String pf: familyList) {
                    String Key = AccountId + pf;
                    if(mapACSContractValue.get(Key) == null){
                        mapACSContractValue.put(Key, new ApprovedContractSummary__c(RevenueType__c= 'Onetime',Account__c=AccountId,AnnualContractValue__c=SumAnnualRevenue,ProductFamily__c=pf, Key__c = Key));
                    }
                    else {
                        String revenueTypeStr = mapACSContractValue.get(Key).RevenueType__c;
                        revenueTypeStr += ' & Onetime';
                        mapACSContractValue.put(Key, new ApprovedContractSummary__c(RevenueType__c= revenueTypeStr,Account__c=AccountId,AnnualContractValue__c= (SumAnnualRevenue + mapACSContractValue.get(Key).AnnualContractValue__c),ProductFamily__c=pf, Key__c = Key));
                    }
                }                
                System.debug('PF: ' + PFamlies + ' Onetime Amount: ' + SumAnnualRevenue);             
            }
            
            //Process Contracts that contain Consulting type products
            for(AggregateResult ar : groupedContractsBillingScheduleTotalsConsulting) { 
                
                Decimal SumAnnualRevenue = ar.get('sumAnnualRev') != null? Decimal.valueOf(double.valueOf(ar.get('sumAnnualRev'))): 0;
                String AccountId = ar.get('accountid') != null? String.valueof(ar.get('accountid')): '';
                String PFamlies = ar.get('pf') != null? String.valueof(ar.get('pf')): '';
                List<String> familyList  = PFamlies.split(',');
                for(String pf: familyList) {
                    String Key = AccountId + pf;
                    if(mapACSContractValue.get(Key) == null){
                        mapACSContractValue.put(Key, new ApprovedContractSummary__c(RevenueType__c= 'Consulting',Account__c=AccountId,AnnualContractValue__c=SumAnnualRevenue,ProductFamily__c=pf, Key__c = Key));
                    }
                    else {
                        String revenueTypeStr = mapACSContractValue.get(Key).RevenueType__c;
                        revenueTypeStr += ' & Consulting';
                        mapACSContractValue.put(Key, new ApprovedContractSummary__c(RevenueType__c= revenueTypeStr,Account__c=AccountId,AnnualContractValue__c= (SumAnnualRevenue + mapACSContractValue.get(Key).AnnualContractValue__c),ProductFamily__c=pf, Key__c = Key));
                    }
                }                
                System.debug('PF: ' + PFamlies + ' Consulting Amount: ' + SumAnnualRevenue);             
            }
            
            //Fetch Remaining Contracts
            Set<Id> contractProcessed = new Set<Id>();
            Set<Id> remainingContract = new Set<Id>();
            list <ContractLineItemSchedule__c> cbsRecurring = [SELECT Contract__r.Id
                                                                FROM ContractLineItemSchedule__c 
                                                                WHERE Contract__r.AccountId = :accountIDs 
                                                                AND Contract__r.ContractApproved__c = true
                                                                AND ContractLineItem__c != null    
                                                                AND InstallmentYear__c = :CURRENTYEAR 
                                                                AND ContractLineItem__r.AssociatedProduct__r.ProfitCenters__r.SaleType__c = 'Subscription'];
            System.debug('@HS cbsRecurring='+cbsRecurring);
            
            list <ContractLineItemSchedule__c> cbsNonRecurring = [SELECT Contract__r.Id
                                                                  FROM     ContractLineItemSchedule__c 
                                                                  WHERE    Contract__r.AccountId = :accountIDs 
                                                                  AND Contract__r.ContractApproved__c = true 
                                                                  AND ContractLineItem__c != null    
                                                                  AND ContractLineItem__r.AssociatedProduct__r.ProfitCenters__r.SaleType__c = 'Onetime'		////'Onetime' in new org means 'Non-recurring' in LMarkit
                                                                  //AND Billing_Date__c <= Today					//??
                                                                  AND InstallmentYear__c = :CURRENTYEAR];      
            System.debug('@HS cbsNonRecurring='+cbsNonRecurring);
            
            list <ContractLineItemSchedule__c> cbsConsulting = [SELECT Contract__r.Id
                                                                  FROM     ContractLineItemSchedule__c 
                                                                  WHERE    Contract__r.AccountId = :accountIDs 
                                                                  AND Contract__r.ContractApproved__c = true 
                                                                  AND ContractLineItem__c != null    
                                                                  AND ContractLineItem__r.AssociatedProduct__r.ProfitCenters__r.SaleType__c = 'Consulting'		////'Consulting' is new 3rd category in new org
                                                                  //AND Billing_Date__c <= Today					//??
                                                                  AND InstallmentYear__c = :CURRENTYEAR];      
            System.debug('@HS cbsConsulting='+cbsConsulting);
            
            for(ContractLineItemSchedule__c cbs : cbsRecurring) {
                contractProcessed.add(cbs.Contract__r.Id);
            }
            
            for(ContractLineItemSchedule__c cbs : cbsNonRecurring) {
                contractProcessed.add(cbs.Contract__r.Id);
            }
            
            for(ContractLineItemSchedule__c cbs : cbsConsulting) {
                contractProcessed.add(cbs.Contract__r.Id);
            }
            
            System.debug('@HS contractProcessed='+contractProcessed);
            
            for (Id conId : mapContracts.keySet()) {
                if(!contractProcessed.contains(conId)) {
                    remainingContract.add(conId);
                }
            }
            System.debug('@HS remainingContract='+remainingContract);
            
            //Fetch totals of remaining CLIS records		//?? Why are we calculating SUM of remaining records as they are not used anywhere?
            AggregateResult[] groupedContractsBillingScheduleRemining = [SELECT  SUM(SalesPrice__c) sumAnnualRev, Contract__r.AccountId accountid,  ContractLineItem__r.AssociatedProduct__r.ProductGroup__r.Name pf
                                                                         FROM ContractLineItemSchedule__c 
                                                                         WHERE Contract__r.Id = :remainingContract 
                                                                         AND Contract__r.ContractApproved__c = true
                                                                         GROUP BY Contract__r.AccountId, ContractLineItem__r.AssociatedProduct__r.ProductGroup__r.Name];  
            //Process Remaining Contracts
            for (AggregateResult ar : groupedContractsBillingScheduleRemining) {                
                Decimal SumAnnualRevenue = ar.get('sumAnnualRev') != null? Decimal.valueOf(double.valueOf(ar.get('sumAnnualRev'))): 0;
                String AccountId = ar.get('accountid') != null? String.valueof(ar.get('accountid')): '';
                String PFamlies = ar.get('pf') != null? String.valueof(ar.get('pf')): '';
                List<String> familyList  = PFamlies.split(',');						//??
                for(String pf: familyList) {
                    String Key = AccountId + pf;
                    if(mapACSContractValue.get(Key) == null) {
                        mapACSContractValue.put(Key, new ApprovedContractSummary__c(RevenueType__c = 'Remaining', Account__c = AccountId, AnnualContractValue__c = 0, ProductFamily__c = pf, Key__c = Key));
                    }
                }                
                System.debug('PF: ' + PFamlies + ' Remaining Amount: ' + SumAnnualRevenue);          
            }
            System.debug('@HS mapACSContractValue size='+mapACSContractValue.size());
            System.debug('@HS mapACSContractValue='+mapACSContractValue);
            
            //Finally Update ACS records
            acsMapBillingSchedule.addAll(mapACSContractValue.values());
            
            if(acsMapBillingSchedule != null && acsMapBillingSchedule.size() > 0) {
                Schema.SObjectField f = ApprovedContractSummary__c.Fields.Key__c;
                List<Database.UpsertResult> upsertResult = Database.upsert(acsMapBillingSchedule, f, false);
                for(Integer i=0;i< upsertResult.size();i++) {
                    if(!upsertResult.get(i).isSuccess()) {
                        Database.Error error = upsertResult.get(i).getErrors().get(0);
                        String failedDML = error.getMessage();
                        errorMsgs += 'ACS rec: ' + acsMapBillingSchedule.get(i).Id+', '+failedDML+'<\br>';
                        System.debug('@HS Failure in acsMapBillingSchedule Map UPSERT2. Error='+failedDML);
                    }
                }
                System.debug('@HS UPSERT2 complete.');                
            }
        }
        System.debug('@HS BATCH EXECUTE() ENDS');
    }
    
    public void finish(Database.BatchableContext BC) {
        System.debug('@HS BATCH FINISH()');
        //Call Support Overview Batch here in next phase
        //Database.executeBatch(new BatchCalCasesSummarySupportOverview(), 1);        
    }
}