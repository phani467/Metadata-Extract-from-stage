/**
 * @author Paras Dhingra
 * @date 26th Jun 2017
 * @description Utility class for creating test data in test classes including  POLK
 * 
 * @last modified by: Tran-Vu Tran
 * @date: 6 Aug 2017 (Sprint 8)
 * @description: adding pre-populated fields to createTestAccount methods
 **/
@isTest 
public class TestUtility {
    /**
     * @author Paras Dhingra
     * @date 26th Jun 2017
     * @description utility class to load country data from static resources
     * @param null
     * @return (Country__C)List<sObject>
     * */
    public static List<sObject> loadCountryData() {
        List<sObject> lstCountry = Test.loadData(Country__c.sObjectType, 'CountryData');
        return lstCountry;
    }
    
    /**
     * @author Paras Dhingra
     * @date 05 Jul 2017
     * @description Create test account for test classes
     * @param String,boolean
     * @return: Account
     */
    public static Account createTestAccount(String AccountName, Boolean shouldInsert) {
        
        Account testAccount  = new Account(Name = accountName,
                                           BillingStreet = 'Test street 1',
                                           BillingCity = 'Toronto',
                                           //BillingState = 'Ontario',
                                           BillingStateCode = 'ON',
                                           //BillingCountry = 'Canada',
                                           BillingCountryCode = 'CA',
                                           DataGovernanceStatus__c = 'Approved',
                                           Website = 'www.test' + Math.random() +'.us',
                                           Type = 'Direct',
                                           Priority__c = 'Priority Prospect'
                                          );            
        if(shouldInsert) {
            insert testAccount;
        }
            
        return testAccount;
    }

    /**
     * @author Tran-Vu Tran
     * @date 6 Aug 2017
     * @description Create test account for test classes with Billing Address's Street
     * @param String, String, boolean
     * @return Account
     */
    public static Account createTestAccountWithStreet(String accountName, 
                                            String billingStreet,
                                            Boolean shouldInsert) {
        
        Account testAccount  = new Account(Name = accountName,
                                           BillingStreet = billingStreet,
                                           BillingCity = 'Toronto',
                                           //BillingState = 'Ontario',
                                           BillingStateCode = 'ON',
                                           //BillingCountry = 'Canada',
                                           BillingCountryCode = 'CA',
                                           DataGovernanceStatus__c = 'Approved',
                                           Website = 'www.test' + Math.random() +'.us',
                                           Type = 'Direct',
                                           Priority__c = 'Priority Prospect'
                                          );            
        if(shouldInsert) {
            insert testAccount;
        }
            
        return testAccount;
    }

    /**
     * @author Tran-Vu Tran
     * @date 20 Jul 2017
     * @description Create test account for test classes with Billing Address info
     * @param String, String, String, String, String, boolean
     * @return Account
     */
    public static Account createTestAccountWithAddress(String accountName, 
                                            String billingStreet, String billingCity,
                                            String billingStateCode, String billingCountryCode,
                                            Boolean shouldInsert) {
        
        Account testAccount  = new Account(Name = accountName,
                                           BillingStreet = billingStreet,
                                           BillingCity = billingCity,
                                           BillingStateCode = billingStateCode,
                                           BillingCountryCode = billingCountryCode,
                                           DataGovernanceStatus__c = 'Approved',
                                           Website = 'www.test' + Math.random() +'.us',
                                           Type = 'Direct',
                                           Priority__c = 'Priority Prospect'
                                          );
        if(shouldInsert) {
            insert testAccount;
        }
            
        return testAccount;
    }

    /**
     * @author Paras Dhingra
     * @date 05 Jul 2017
     * @description Create NAICS hierarchy data
     * @param String,boolean
     * @return NAICSHierarchy__c
     */
     public static NAICSHierarchy__c createNAICSData(String NAICS4digit, String Industry, String subIndustry, Boolean shouldInsert) {
         
         NAICSHierarchy__c naics = new NAICSHierarchy__c();
         naics.name = NAICS4digit;
         naics.NAICSIndustry__c = Industry;
         naics.NAICSSubIndustry__c = subIndustry;
         
         if(shouldInsert) {
             insert naics;
         }
         return naics;
     }
    
    /**
     * @Author: Vishnu Vardhan
     * @date: 7 Jul 2017
     * @description: Creates an admin user for test classes
     * @param: string, boolean
     * @return: User
     */
    public static User createAdminUser(String eMail, Boolean shouldInsert) {
        User user = new User();
        user.Username = eMail;
        user.LastName = 'Last2TestName';
        user.FirstName = 'TestFirstName';
        user.Email = eMail;
        user.alias = 'testA';
        user.TimeZoneSidKey = 'America/New_York';
        user.LocaleSidKey = 'en_US';
        user.EmailEncodingKey = 'ISO-8859-1';
        user.ADID__c='test'+system.now().millisecond();
        user.EmployeeNumber=String.valueOf(Math.round(Math.random()*10000));
        user.EmployeeNumber__c=String.valueOf(Math.round(Math.random()*10000));
        user.HRManager__c='manager';
        user.ProfileId = [select id from Profile where Name='System Administrator'].Id;
        user.LanguageLocaleKey = 'en_US';
        user.CompanyName = 'IHSMarkit';
        if(shouldInsert)
            insert user;
        return user;
    }

    /**
     * @Author: Vishnu Vardhan
     * @date: 7 Jul 2017
     * @description: Creates an contact for test classes
     * @param: string, string, boolean, string, string
     * @return: Contact
     */
    public static Contact createContact(String accountID, String email, Boolean shouldInsert,
                                        String FirstName, String LastName) {
        Contact con = new Contact();
        con.AccountId = accountID;
        con.FirstName = FirstName;
        con.LastName = LastName;
        con.Email = email;
        if(shouldInsert)
            insert con;
        return con;
    }

    /**
     * @Author: Vishnu Vardhan
     * @date: 7 Jul 2017
     * @description: Creates an Opportunity for test classes
     * @param: Id, string, Id, boolean
     * @return: Opportunity
     */
    public static Opportunity createOpportunity(Id accountID, String name,Id sellToCountry,Boolean shouldInsert) {
        
        Opportunity opp = new Opportunity();
        opp.AccountId = accountID;
        opp.Name = Name;
        opp.StageName= '1-Sales Qualified';
        opp.CloseDate = Date.today()+2;
        if(shouldInsert)
            insert opp;
        return opp;
    }
    
    /**
     * @Author: Vishnu Vardhan
     * @date: 7 Jul 2017
     * @description: Creates an Opportunity team member for test classes
     * @param: string, string, string, boolean
     * @return: OpportunityTeamMember
     */
     public static OpportunityTeamMember createOpportunityTeamMember(String oppId, String userId, string OpportunityAccessLevel,Boolean shouldInsert) {
         OpportunityTeamMember otm = new OpportunityTeamMember();
         otm.OpportunityAccessLevel = OpportunityAccessLevel;
         otm.OpportunityId = oppId;
         otm.UserId = UserId;
         if(shouldInsert)
            insert otm;
        return otm;
     }
     
   /**
     * @author Paras Dhingra
     * @date 19 Jul 2017
     * @description Create Product2 record
     * @param String,boolean
     * @return Product2
     */
    public static Product2 createProduct(String productName, boolean shouldInsert) {
        Product2 prod = new Product2();
        prod.name = productName;
        prod.IsActive = true;
        prod.ProductStatus__c = availableForSale;
        if(shouldInsert) {
            insert prod;
        }
        return prod;
            
    }
    
    /**
     * @author Paras Dhingra
     * @date 19 Jul 2017
     * @description Create pricebookEntry record
     * @param Id, Id, Boolean
     * @return PricebookEntry
     */
    public static PricebookEntry createPriceBookEntry(Id pricebookId, Id prodID, boolean shouldInsert) {
         PricebookEntry standardPrice = new PricebookEntry(
            Pricebook2Id = pricebookId, Product2Id = prodID,
            UnitPrice = 10000, IsActive = true);
        if(shouldInsert) {
            insert standardPrice;
        }
        return standardPrice;
    }
    
    /**
     * @author Paras Dhingra
     * @date 19 Jul 2017
     * @description Create pricebookEntry record
     * @param String, PricebookEntry, Boolean
     * @return PricebookEntry
     */
    public static OpportunityLineItem createOpportunityLineItem(String OppId, PricebookEntry pbEntry, Boolean shouldInsert) {
        
        OpportunityLineItem oli = new OpportunityLineItem (
        OpportunityId = OppId,
        Quantity = 5,
        LicenseType__c = 'N/A',
        PricebookEntryId = pbEntry.Id,
        TotalPrice = 5 * pbEntry.UnitPrice
        );
        if(shouldInsert) {
            insert oli;
        }
        return oli;
    }
    /**
     * @author Vinod Merwade
     * @date 20 Jul 2017
     * @description Lead conversion Mapping
     * @param None
     * @return List of sObject
     */
    public static List<sObject> loadLeadConversionFieldMapping() {
        List<sObject> lstFieldMapping = Test.loadData(LeadConversionFieldMapping__c.sObjectType, 'LeadConversionFieldMapping');
        return lstFieldMapping ;
    }
    
    /**
     * @author Paras Dhingra
     * @date 31 Jul 2017
     * @description Create standard user with provided profile name
     * @param String, String, Boolean
     * @return User
     */
     public static User createTestUser(String profileName, String username, Boolean shouldInsert) {
         
         Profile p = [SELECT Id FROM Profile WHERE Name =: profileName];
         
         User testUser = new User(Alias = 'standt', Email=username, 
                                  EmailEncodingKey='UTF-8', firstName='testFirstName', HRManager__c='testManager', LastName='testLastName',
                                  LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id,
                                  TimeZoneSidKey='America/Los_Angeles', UserName=username, ADID__c='test'+system.now().millisecond(),
                                  EmployeeNumber=String.valueOf(Math.round(Math.random()*10000)),EmployeeNumber__c=String.valueOf(Math.round(Math.random()*10000)));
         
         if (shouldInsert) {
             insert testUser;
         }
         
         return testUser;
     }

    /**
     * @author Tran-Vu Tran
     * @date 24th April 2018
     * @description Create standard user with provided profile name and country code
     * @param String, String, String, Boolean
     * @return User
     */
     public static User createTestUserWithCountryCode(String profileName, String username, String countryCode, Boolean shouldInsert) {
         
         Profile p = [SELECT Id FROM Profile WHERE Name =: profileName];
         
         User testUser = new User(Alias = 'standt', Email=username, 
                                  EmailEncodingKey='UTF-8', firstName='testFirstName', HRManager__c='testManager', LastName='testLastName',
                                  CountryCode = countryCode,
                                  LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id,
                                  TimeZoneSidKey='America/Los_Angeles', UserName=username, ADID__c='test'+system.now().millisecond(),
                                  EmployeeNumber=String.valueOf(Math.round(Math.random()*10000)),EmployeeNumber__c=String.valueOf(Math.round(Math.random()*10000)));
         System.debug('testUser:' + testUser);

         if (shouldInsert) {
             insert testUser;
         }
         return testUser;
     }
    
     /**
     * @author Paras Dhingra
     * @date 31 Jul 2017
     * @description Creates an Opportunity for test class
     * @param Id, string, boolean
     * @return Opportunity
     */
    public static Opportunity createOpportunity(Id accountID, String name,Boolean shouldInsert) {
        
        Opportunity opp = new Opportunity();
        opp.AccountId = accountID;
        opp.Name = Name;
        opp.StageName= '1-Sales Qualified';
        opp.CloseDate = Date.today()+2;
        if(shouldInsert) {
            insert opp;
        }
        return opp;
    }
    
    /**
     * @author Paras Dhingra
     * @date 08th Aug 2017
     * @description Creates a lead for test classes
     * @param 
     * @return lead
     */
    public static Lead createLead(String firstName, String LastName, String CompanyName, String CountryCode, Boolean shouldInsert) {
        Lead led = new Lead();
        led.firstName = firstName;
        led.LastName = LastName;
        led.Company = CompanyName;
        led.CountryCode = CountryCode;
        
        if(shouldInsert) {
            insert led;
        }
        return led;
    }
    /**
     * @author Vishnu Vardhan Chowdary Andra
     * @date 08th Sep 2017
     * @description Creates a legal entity object and returns it.
     * @param String, String
     * @return LegalEntity__c
     */  
    public static LegalEntity__c createLegalEntity(String name, String CurrISOCode) {
        LegalEntity__c legalEntity = new LegalEntity__c();
        legalEntity.Name = name;
        legalEntity.CurrencyIsoCode = CurrISOCode;
        legalEntity.Status__c = 'Active';
        insert legalEntity;
        return legalEntity;
    }
    //-----------------------------/
    // @author:Ankita
    // @date: 13 June 2018
    // @param: String, String
    // @description: SFDC1-8051: Creates a legal entity object along with set of Eligible fields 
    // 				 which implies the contract record type it is availble for.
    // @return: LegalEntity__c
    //------------------------------  
    
    public static LegalEntity__c createLegalEntityWithEligibleFields(String name, String CurrISOCode,Boolean shouldInsert) {
        LegalEntity__c legalEntity = new LegalEntity__c();
        legalEntity.Name = name;
        legalEntity.CurrencyIsoCode = CurrISOCode;
        legalEntity.Status__c = 'Active';
        legalEntity.EligibleforDPA__c = 'No';
		legalEntity.EligibleforMangedServiceTerms__c = 'No';
        legalEntity.EligibleforMasterAgreement__c = 'No';
        legalEntity.EligibleforContinuation__c = 'No';
        legalEntity.EligibleforTrial__c = 'No';
        legalEntity.EligibleforStatementofWork__c = 'No';
        if(shouldInsert) {
          insert legalEntity;  
        }
        return legalEntity;
    } 
    /**
* @author Vishnu Vardhan Chowdary Andra
* @date 08th Sep 2017
* @description Creates a Contract object and returns it.
* @param Id, Id, Id, Id
* @return Contract
*/    
    public static Contract createContract(Id accountId, Id legalEntityId, Id countryId, Id priceBoodId ) {
        Contract cntrct = new Contract();
        cntrct.AccountId = accountId;
        cntrct.IHSMarkitLegalEntity__c = legalEntityId;
        // 2017-10-27 Sonam Raju: IHSMarkitCountryOfIncorporation__c has been converted to formula field as per SFDC1-5203
        // cntrct.IHSMarkitCountryOfIncorporation__c = countryId;
        cntrct.CurrencyIsoCode = 'USD';
        cntrct.StartDate = System.today();
        cntrct.Status = 'Draft';
        cntrct.Pricebook2Id = priceBoodId;
        cntrct.ContractTerm = 10;
        // 2017-10-25 Tran-Vu Tran: ClientLegalEntityContact__c field is deprecated per SFDC1-4980
        // cntrct.ClientLegalEntityContact__c = 'testContact';
        // 2018-02-2 Ayan: ClientLegalEntity__c field is deprecated per SFDC1-6814
        //cntrct.ClientLegalEntity__c = 'testLegalEntity';
        //cntrct.ClientCountryOfIncorporation__c = 'testCOI';
        //cntrct.ClientStateOfIncorporation__c = 'testSOI';
        insert cntrct;
        return cntrct;
    }
    
     /**
     * @author Ankita Singh
     * @date 14th March 2018
     * @description Creates a Contract object if isInsert TRUE and returns it.
     * @param Id, Id, Id, Id,Boolean
     * @return Contract
     */    
    public static Contract createContractWithInsertOptional(Id accountId, Id legalEntityId, Id countryId, Id priceBoodId,Boolean isInsert ) {
        Contract cntrct = new Contract();
        cntrct.AccountId = accountId;
        cntrct.IHSMarkitLegalEntity__c = legalEntityId;
        // 2017-10-27 Sonam Raju: IHSMarkitCountryOfIncorporation__c has been converted to formula field as per SFDC1-5203
        // cntrct.IHSMarkitCountryOfIncorporation__c = countryId;
        cntrct.CurrencyIsoCode = 'USD';
        cntrct.StartDate = System.today();
        cntrct.Status = 'Draft';
        cntrct.Pricebook2Id = priceBoodId;
        cntrct.ContractTerm = 10;
        // 2017-10-25 Tran-Vu Tran: ClientLegalEntityContact__c field is deprecated per SFDC1-4980
        // cntrct.ClientLegalEntityContact__c = 'testContact';
        // 2018-02-2 Ayan: ClientLegalEntity__c field is deprecated per SFDC1-6814
        //cntrct.ClientLegalEntity__c = 'testLegalEntity';
        //cntrct.ClientCountryOfIncorporation__c = 'testCOI';
        //cntrct.ClientStateOfIncorporation__c = 'testSOI';
        if(isInsert) {
        insert cntrct;
        }
        return cntrct;
    }
    
    /**
     * @author Vishnu Vardhan Chowdary Andra
     * @date 08th Sep 2017
     * @description Creates a ContractLineItem__c object and returns it.
     * @param String, Id, Id
     * @return ContractLineItem__c
     */    
    public static ContractLineItem__c createContractLineItem(String name, Id contractId, Id productId, boolean shouldInsert) {
        ContractLineItem__c cli = new ContractLineItem__c();
        cli.Name = name;
        cli.Contract__c = contractId;
        cli.Quantity__c = 10;
        cli.TotalPriceFromOpportunityLineItem__c=1000.0;
        cli.CurrencyIsoCode = 'USD';
        cli.Product__c = productId;
        if(shouldInsert){
            insert cli;
        }
        return cli;
    }
    
    /**
     * @author Vishnu Vardhan Chowdary Andra
     * @date 12th Sep 2017
     * @description Creates a ProductGroup__c object and returns it.
     * @param String, boolean, boolean
     * @return ProductGroup__c
	 * @LastModifiedDate: 29 Mar 2018
	 * @LastModifiedDescription: SFDC1-7721: Internal__C was used to indicate if a product group was part of Internal Case
	 *						  record type, Since that record type is deleted, we are removing fields used specifically for it.
     */    
    public static ProductGroup__c createProductGroup(String name, boolean additionalFields, boolean internal) {
        ProductGroup__c pg = new ProductGroup__c();
        pg.Name = name;
        //pg.CaseProductRecordType__c = name;
        //pg.ContainsAdditionalFields__c = additionalFields;
        //pg.Internal__c = internal;
        insert pg;
        return pg;
    }
        /**
     * @author Paras Dhingra
     * @date 17 Sep 2017
     * @description Creates a ProductSchedule__c for test Class
     * @param 
     * @return ProductSchedule__c
     */
    public static ProductSchedule__c createProductSchedule(Decimal listPrice, String PricingYear, String ProductTerm, String InstallmentYear, String prodId, Boolean shouldInsert) {
        ProductSchedule__c prodSchd = new ProductSchedule__c(
                                        ListPrice__c =listPrice ,
                                        PricingYear__c =PricingYear ,
                                        ProductTerm__c = ProductTerm,
                                        InstallmentYear__c = InstallmentYear,
                                        Product__c = prodId,
                                        isactive__c = True
                                        );
        if(shouldInsert) {
            insert prodSchd;
        }
        return prodSchd;
    }
    /**
     * @author Paras Dhingra
     * @date 17 Sep 2017
     * @description Creates a OpportunityLineItemSchedule__c for test Class
     * @param 
     * @return OpportunityLineItemSchedule__c
     */
     public static OpportunityLineItemSchedule__c createOpportunityProductSchedule(String OpportunityId,String productScheduleId,Decimal externalListPrice,Decimal salesPrice,
                                                String discountType, Decimal discountAmount, Decimal discountPercent, string productId, string installmentYear, decimal qty, 
                                                String OppyProdId, Boolean shouldInsert) {
         OpportunityLineItemSchedule__c olis = new OpportunityLineItemSchedule__c();
            olis.Opportunity__c = opportunityId;
            olis.ProductSchedule__c = productScheduleId;
            olis.ExternalListPrice__c = externalListPrice;
            olis.SalesPrice__c = salesPrice;
            
            olis.DiscountType__c = discountType;
            olis.DiscountPercent__c = discountPercent;
            olis.DiscountAmount__c = discountAmount;
            olis.Product__c = productId;
            olis.InstallmentYears__c = installmentYear;
            olis.OpportunityProductScheduleKey__c = OpportunityId + ' - ' +  productScheduleId+' - ' +installmentYear ;
            olis.Quantity__c = qty;
            olis.TotalPrice__c = salesPrice*olis.Quantity__c;
            olis.OpportunityProductID__c = OppyProdId;
            
            if(shouldInsert) {
                insert olis;
            }
            return olis;
     }
     /**
     * @author Paras Dhingra
     * @date 09 Oct 2017
     * @description Load and return list of CrossPlantStatus__c records 
     * @param 
     * @return List<sObject>
     */
     public static List<sObject> loadCrossPlantStatus() {
        List<sObject> lstCPSData = Test.loadData(CrossPlantStatus__c.sObjectType, 'CrossPlantStatusData');
        return lstCPSData;
    }
    /**
     * @author Paras Dhingra
     * @date 09 Oct 2017
     * @description property to return CrossPlantStatus__c Id for available for sale record
     * @param void
     * @return Id
     */
     public static Id availableForSale {
         get{
             if(availableForSale==null) {
                 List<sObject> lstCPSData= loadCrossPlantStatus();
                 for(CrossPlantStatus__c cps : (List<CrossPlantStatus__c>)lstCPSData) {
                     if(cps.Sapcode__c =='04') {
                         availableForSale = cps.Id;
                         break;
                     }
                 }
             }
             return availableForSale;
         }
         set;
     }
     /**
     * @author: Paras Dhingra
     * @date: 01 Nov 2017
     * @description: to create OpportunitySPlit record
     * @param: String, String, Decimal, String, Boolean
     * @return: Id
     */
     public static OpportunitySplit createOppySplit(String oppyId, String userId, Decimal splitPercentage,String splitTypeId ,Boolean shouldInsert) {
         OpportunitySplit oppySplit = new OpportunitySplit();
         oppySplit.OpportunityId = oppyId;
         oppySplit.SplitOwnerId = userId;
         oppySplit.splitPercentage = splitPercentage;
         oppySplit.SplitTypeId = SplitTypeId;
         if(shouldInsert) {
             insert oppySplit;
         }
         return oppySplit;
         
     }
    // Utility methods for POLK starts here 
    
     public static WorkRequestForm__c newWRF() {
        return newWRF(true);
    }
    
    public static WorkRequestForm__c newWRF(boolean saveRecord){
        WorkRequestForm__c wrf = new WorkRequestForm__c();
        if(saveRecord){
            insert wrf;     
        }
        
        return wrf;
    
    }
    public static WorkRequestForm__c newWRF(WorkRequestForm__c wrf) {
        insert wrf;  
        string soql = 'select '+XedeUtility.wrfFieldstr()+' from WorkRequestForm__c where id=\''+wrf.id+'\'';
        return database.query(soql);
        //return [select id,form_type__c,job_type__c,ownerid from WorkRequestForm__c where id=:wrf.id];
    }
    
    public static WorkRequestForm__c fillJobOverview(WorkRequestForm__c wrf) {
        wrf.JobType__c = 'Ad Hoc';
        wrf.RoyaltyVendor__c='No Royalty Data';
        wrf.ReturnToSales__c=true;
        wrf.PrimarySalesContact__c=UserInfo.getUserId();
        wrf.RequestedDueDate__c = System.today() + 7;
        wrf.OutputType__c='Comma Delimited (CSV)';
        wrf.OutputMedium__c='CD ROM/DVD';
        upsert wrf;
        return wrf;
    }
    
    public static PLCJob__c newPLC(WorkRequestForm__c wrf) {
        PLCJob__c plc = new PLCJob__c(WorkRequestForm__c = wrf.Id);
        insert plc;
        return plc;
    }
    
    public static PLCJob__c newCompletedPLC(WorkRequestForm__c wrf) {
        PLCJob__c plc = new PLCJob__c(WorkRequestForm__c = wrf.Id);
        plc.DateTimeOfDelivery__c = System.now();
        plc.NegotiatedDate__c = System.today() + 1;
        plc.JobCompletedDelivered__c = true;
        plc.TotalDeliverables__c = 1;
        plc.DefectiveDeliverables__c = 0;
        plc.LateDeliverables__c = 0;
        Blob hash = Crypto.generateDigest('MD5', Blob.valueOf(System.now().format()));
        String unique = EncodingUtil.convertToHex(hash);
        plc.JobName__c = unique;
        plc.Team1__c = 'PolkConnect System';
        insert plc;
        return plc;
    }
    
    public static PLCJob__c newPLC(PLCJob__c plc) {
        insert plc;
        return plc;
    }
    
    public static Contact newContact() {
        //Commenting this since it can cause errors with DupeCatcher in prod
        //Contact c=new Contact(lastname='test',email='test@test.com');
        Blob hash = Crypto.generateDigest('MD5', Blob.valueOf(System.now().format()));
        String unique = EncodingUtil.convertToHex(hash);
        Contact c = new Contact(firstname='testContact',lastName=unique,email='test@test.com' );
        insert c;
        return c;
    }
    
    public static Opportunity newOpportunity() {
        Contact c=newContact();
        //Making name unique because of DupeCatcher in prod
        Blob hash = Crypto.generateDigest('MD5', Blob.valueOf(System.now().format()));
        String unique = EncodingUtil.convertToHex(hash);
        Opportunity o=new Opportunity(name=unique,closedate=system.today()+180,stagename='Discovery'/*Remove ,customer_contact__c=c.id */);
        //Opportunity o=new Opportunity(name='test',closedate=system.today()+180,stagename='Discovery',/* Remove customer_contact__c=c.id*/);
        insert o;
        return o;
    }
    
    public static OpportunityWorkRequestForm__c newOpptyWRF(Opportunity o, WorkRequestForm__c wrf) {
        OpportunityWorkRequestForm__c opptywrf = new OpportunityWorkRequestForm__c();
        opptywrf.WorkRequestForm__c = wrf.Id;
        opptywrf.Opportunity__c = o.Id;
        upsert opptywrf;
        return opptywrf;
    }
    
    public static User createStandardUser(Profile adminProfile,string rolename, string lname,string fname,boolean saveRecord){
                User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
                        User newUser;
                        System.runAs ( thisUser ) {
                                if(adminProfile == null){
                        adminProfile = [select Id, Name from Profile where name = 'System Administrator' limit 1];
                    }
                    UserRole r;
                    if(rolename==null){
                        r = new UserRole(name = 'Sales Rep');   
                    }else{
                        r = new UserRole(name = rolename);  
                    }
                    
                    insert r;
                    String unikey = String.valueOf(System.currentTimeMillis());
                newUser = new User(
                    profileId = adminProfile.Id,
                    username = 'testUser'+unikey+'@ihs.com',
                    email = 'testUser'+unikey+'@ihs.com',
                    emailencodingkey = 'UTF-8',
                    localesidkey = 'en_US',
                    languagelocalekey = 'en_US',
                    timezonesidkey = 'America/New_York',
                    alias='sysae',
                    lastname=lname,
                    firstname=fname,
                    userroleid=r.id,
                    ADID__c = 'EQA0011',
                    EmployeeNumber=String.valueOf(Math.round(Math.random()*10000)),
                    EmployeeNumber__c=String.valueOf(Math.round(Math.random()*10000)),
                    HRManager__c = 'Test'
                );
                if(saveRecord){
                    insert newUser; 
                }
            }
            return newUser;
    }
    
    //Creates a fresh Account object with minimal data and puts it in the database to populate ID.
    //Returns: A near-empty Account from the database complete with Id.
    public static Account newAccount() {
        //Making name unique because of DupeCatcher in prod
        Blob hash = Crypto.generateDigest('MD5', Blob.valueOf(System.now().format()));
        String unique = EncodingUtil.convertToHex(hash);
        Account a = new Account(Name=unique);
        insert a;
        return a;
    }
    
    //Creates a near-empty Draft Ad Claim and stores it in the database.
    //Returns: a near-empty Ad Claim in Draft status with Id and auto-number
    //  fields populated.
    

    public static AdClaim__c newAdClaim() {
        AdClaim__c ac = new AdClaim__c(ClaimsStatus__c='Draft');
        insert ac;
        return ac;
    }
    
    //Creates either a near-empty Ad Claim or one that is filled and ready for
    //validation, based upon the passed parameter.
    //Parameter: A boolean indicating whether or not to fill the Ad Claim's 
    //required fields.
    //  True fills them, False leaves them blank.
    //Returns: The newly created Ad Claim.


    public static AdClaim__c newAdClaim(boolean filled) {
        AdClaim__c ac = newAdClaim();
        
        if(filled) {
            fillRequiredFields(ac, newContact(), newOpportunity(), newAccount());
            update ac;
        } 
        return ac;
    }
    
    //Fills all the required fields on an ad claim just so that 
    //it passes validation rules.
    //Parameters: 
    //  ac: The Ad Claim to fill
    //  c : The Contact to associate with the claim
    //  o : The Opportunity to associate with the claim
    //  a : The Account to associate with the claim
    //Note: the data is all garbage!
    //Reference: User lookups set to current user
    //           Other lookups passed in
    //           Numbers set to 0
    //           Strings set to 'Test'
    //           Dates set to System.today()
    //           Claims Status set to 'Draft' only if blank
 
    private static void fillRequiredFields(AdClaim__c ac, Contact c, Opportunity o, Account a) {
        //Fields for submission        
        ac.RequestingOrganization__c = a.Id;
        ac.RepresentedOrganization__c = a.Id;
        ac.RequestDate__c = System.today();
        ac.ContactName__c = c.Id;
        ac.PhoneNumber__c = 'Test';
        ac.AdDurationStartDate__c = System.today();
        ac.AdDurationEndDate__c = System.today() + 1;
        ac.MediaType__c = 'Test';
        ac.ProposedClaimLanguage__c = 'Test';
        ac.ProposedDisclaimerLanguage__c = 'Test';
        ac.IHSAccountRepresentative__c = UserInfo.getUserId();
        ac.TypeOfClaim__c = 'Test';
        ac.Opportunity__c = o.Id;
        ac.FeeForClaim__c = 0;
        ac.AnnualSubscriptionOrContract__c = 'Test';
        ac.DoesSubstantiatingDataExist__c = 'Test';
        ac.UpdateOfAPriorClaim__c = 'Test';
        ac.SourceFileUsed__c = 'Test';
        
        //Fields for approval
        ac.DataValidated__c = true;
        ac.DataValidationCompletedBy__c = UserInfo.GetUserId();
        ac.ClaimTitle__c = 'Test';
        //only fill claims status if its not set already
        ac.ClaimsStatus__c = ac.ClaimsStatus__c == null ? 'Draft' : ac.ClaimsStatus__c;
        ac.ApprovingParty__c = UserInfo.GetUserId();
        ac.ClaimExpirationDate__c = System.today();
        ac.ApprovedClaimLanguage__c = 'Test';
        ac.ApprovedDisclaimerLanguage__c = 'Test';
        //Approved Date is here because the workflow rule executes too slowly for tests
        //Even refreshing data doesn't give it enough time to fill and save first
        ac.ApprovedDate__c = System.today();
    }
    
    //Prints the error messages for the current page.
    public static void printPageMessages() {
        for(ApexPages.Message msg : ApexPages.getMessages())
            System.debug(msg);
    }
    
    //-----------------------------
    // @author: Hemant Shukla
    // @company: VERTIBA
    // @date: 23-Oct-2017
    // @param:
    //      name        : Name of Opportunity Attachment
    //      oppId       : Id of Parent Opportunity 
    //      type        : Type of Attachment
    //      comments    : Comments, if any
    //      shouldInsert: True, if record need to be inserted else false.
    // @description: SFDC1-5436, checking the End user certificate Attchment if Opp is marked as 6W
    // @return: NA
    //----------------------------- 
    public static OpportunityAttachment__c createOpportunityAttachment(String name, Id oppId, String type, String comments, boolean shouldInsert) {
        OpportunityAttachment__c oppAttc = new OpportunityAttachment__c(name = name, Opportunity__c = oppId, AttachmentType__c = type, Comments__c = comments);
        if(shouldInsert) {
            insert oppAttc;
        }
        return oppAttc;
    }
    
    //-----------------------------
    // @author: Hemant Shukla
    // @company: VERTIBA
    // @date: 23-Oct-2017
    // @param:
    //      name        : Name of Attachment
    //      parentId    : Id of Parent record 
    //      body        : blob body of attachment
    //      shouldInsert: True, if record need to be inserted else false.
    // @description: SFDC1-5436, checking the End user certificate Attchment if Opp is marked as 6W
    // @return: NA
    //----------------------------- 
    public static Attachment createAttachment(String name, Id parentId, blob body, boolean shouldInsert) {
        Attachment attach = new Attachment(name = name, parentId = parentId, body = body);      
        if(shouldInsert) {
            insert attach;
        }
        return attach;
    }

    /**
     * @author: Vishnu Vardhan Chowdary Andra
     * @date: 06 Nov 2017
     * @description: to create case 
     * @param: id, id, id, id, String, Boolean
     * @return: case
     * @company: Vertiba
     */
    public static case createCase(id caseRecordTypeId, id AccountId, id contactId, 
                                  id OwnerId, String subject, boolean isInsert) {
        Case testCase = new Case();
        testCase.RecordTypeId = caseRecordTypeId;
        testCase.subject = subject;
        testCase.AccountId = AccountId;
        testCase.contactId = contactId;
        testCase.OwnerId = OwnerId;
        if(isInsert) {
            insert testCase;
        }
        return testCase;
    }

   	/**
     * @author: Vishnu Vardhan Chowdary
     * @date: 12 Mar 2018
     * @description: Create Product2 record
     * @param: String,Id,boolean
     * @return: Product2
     */
    public static Product2 createProductWithLoadingGroup(String productName, Id loadingGroupId, boolean shouldInsert) {
        Product2 prod = createProduct(productName, false);
        prod.LoadingGroup__c = loadingGroupId;
        if(shouldInsert) {
            insert prod;
        }
        return prod;
    }
    
    /**
     * @author: Vishnu Vardhan Chowdary
     * @date: 12 Mar 2018
     * @description: Create LoadingGroup__c record
     * @param: String, String
     * @return: LoadingGroup__c
     */
    public static LoadingGroup__c createLoadingGroup(String category, String loadingGroupName, boolean shouldInsert) {
        LoadingGroup__c lg = new LoadingGroup__c();
        lg.LoadingGroupCategory__c = category;
        if(shouldInsert) {
            insert lg;
        }
        return lg;
    }
    
     /**
     * @author: Uttam Arya
     * @date: 13 April 2018
     * @description: Create ProductLogin__c test record
     * @param: String [username]
     * @return: ProductLogin__c
     */
    public static ProductLogin__c createProductLogin(String username, boolean shouldInsert) {
        ProductLogin__c ProductLogin = new ProductLogin__c();
        ProductLogin.Username__c = username;
        if(shouldInsert) {
            insert ProductLogin;
        }
        return ProductLogin;
    }
    /**
     * @author: Jagadesh Kumar
     * @date: 30 July 2018
     * @description: Create ContractLineItemSchedule__c test record
     * @param: ID [contractId], ID[contractLineItemId], boolean[shouldInsert]
     * @return: ContractLineItemSchedule__c
     */
    public static ContractLineItemSchedule__c createContractLineItemSchedule(Id contractId,Id contractLineItemId, boolean shouldInsert) {
        ContractLineItemSchedule__c contractLineItemSchedule = new ContractLineItemSchedule__c();
        contractLineItemSchedule.Contract__c = contractId;
        contractLineItemSchedule.ContractLineItem__c = contractLineItemId;
        if(shouldInsert) {
            insert contractLineItemSchedule;
        }
        return contractLineItemSchedule;
    }
    
}