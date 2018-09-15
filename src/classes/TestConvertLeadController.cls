//-----------------------------
// @author: Vinod Merwade
// @date: 19 July 2017
// @param: NA
// @description: SFDC1-45 and SFDC1-186 Test class for ConvertLeadController
// @return: NA
// @Company: Vertiba
// @Last Modified Date : 8 Sept 2017
// @Modification -Anjani Shukla - SFDC1-7580 - Country isn't Required for Lead Creation
//-----------------------------
@isTest
public class TestConvertLeadController {

     //-----------------------------
    // @author: Vinod Merwade
    // @date: 19 July 2017
    // @param: NA
    // @description:SFDC1-45 and SFDC1-186 Test data for the test class
    // @return: NA
    // @Company: Vertiba
    //-----------------------------
    @testSetup public static void setup() {
        
        TestUtility.loadLeadConversionFieldMapping();
        List<Country__c> lstCountry = TestUtility.loadCountryData();
        Account accSobj = TestUtility.createTestAccount('Test Account', false);
        accSobj.Status__c = 'Active';                                              
        accSobj.DataGovernanceStatus__c = 'Approved';
        insert accSobj;
        Opportunity oppSobj = new Opportunity(
            Amount = 100.00,
            Name = 'Test opportunity',
            CloseDate = system.Today(),
            StageName = '1-Sales Qualified', 
            Probability = 10,
            AccountId = accSobj.id,
            ForecastCategoryName = 'Pipeline',
            // Modified by Sonam Raju : Moved PORequired__c field to deletion list as per SFDC1-959
            // PORequired__c = false,
            SourceSystem__c = 'Manually Generated',
            budgetRange__c = '< 25,000'
        );
        insert oppSobj;
        Campaign campSobj = new Campaign(
            Name = 'camp1 ',
            StartDate = system.today(), 
            Status = 'In Progress', 
            Description = 'camp1', 
            IsActive = true,
            Commissionable__c = true
        );
        insert campSobj;
       
       
        List<Lead> leadSobjList = new List<Lead>();
        for(integer i=0;i<5;i++){
        Lead leadSobj = new Lead(
            Status = 'New', 
            Company = 'ABC Company'+i, 
            Account__c = accSobj.id,
            Email = 'care@abc'+i+'.com', 
            Phone = '1234567890', 
            BusinessLineInterest__c = 'Test Opportunity ABC',   
            Description = 'This is test Lead',
            RequestedInteraction__c = false,
            LastName =i+'TestLastName'+i,
            FirstName=i+'TestFirstName'+i,
            BudgetRange__c ='< 25,000',
            Country__c = lstCountry[0].id,
            CallingCountryCode__c = 'IN',
            CountryCode = 'IN'
        );
            leadSobjList.add(leadSobj);
        }        
        system.debug('leadSobjList==>'+leadSobjList);
        insert leadSobjList;
        
         CampaignMember memberSobj = new CampaignMember(
            CampaignId = campSobj.id, 
            LeadId = leadSobjList[4].id,
            Status = 'Sent' 
        );
        insert memberSobj;
        Lead FalseLeadSobj = new Lead(
            Status = 'New', 
            Company = 'flase', 
            Email = 'false@false.com', 
            Phone = '1234567890', 
            BusinessLineInterest__c = 'Test Opportunity False',   
            Description = 'This is test Lead',
            RequestedInteraction__c = false,
            LastName ='TestLastName',
            FirstName='TestFirstName',
            Account__c = accSobj.id,
            Country__c = lstCountry[0].id,
            CountryCode = 'IN'
        );
        
        insert FalseLeadSobj;
    }
    
     //-----------------------------
    // @author: Vinod Merwade
    // @date: 19 July 2017
    // @param: NA
    // @description:SFDC1-45 and SFDC1-186 Test method for convertLead on conversion convert the Lead
    // @return: NA
    // @Company: Vertiba
    //-----------------------------
    
    public static testmethod void converLeadControllerTest() {
        
        List<Lead> leadObject = [select id,Name from Lead  ];
        Account accountObject = [select id,Name from Account where Name =:'Test Account'  Limit 1];
        Opportunity opportunityObject = [select id,Name from Opportunity where Name =: 'Test opportunity' Limit 1];
        
        ApexPages.StandardController sc = new ApexPages.StandardController(leadObject[0]);
        ConvertLeadController cLC4 =  new ConvertLeadController(sc);
        cLC4.selectedValue = 'Activity';
        cLC4.leadOpportunity.ExistingOpportunity__c=opportunityObject.id;
        cLC4.convertLead();
        List<Task> taskCreated = [Select id,subject from Task] ;
        system.assertEquals(taskCreated.size(),1,'Task Created');
        
        test.startTest();
        ApexPages.StandardController sc1 = new ApexPages.StandardController(leadObject[1]);
        ConvertLeadController cLC1 =  new ConvertLeadController(sc1);
        cLC1.selectedValue = 'Case';
        cLC1.convertLead();
        List<Case> caseCreated = [Select id,subject from Case] ;
        system.assertEquals(caseCreated.size(),1,'Case Created');
         
        ApexPages.StandardController sc3 = new ApexPages.StandardController(leadObject[3]);
        ConvertLeadController cLC3 =  new ConvertLeadController(sc3);
        cLC3.selectedValue = 'Contact';
        cLC3.convertLead();
        Lead converted = [select id,name,isConverted from lead where isConverted=true and id=:leadObject[3].id];
        system.assertEquals(converted.id, leadObject[3].id, 'Lead Converted');
        
        ApexPages.StandardController sc4 = new ApexPages.StandardController(leadObject[4]);  
        ConvertLeadController cLC5 =  new ConvertLeadController(sc4);
        cLC5.selectedValue = 'OppCont';
        cLC5.convertLead();
        converted = [select id,name,isConverted from lead where isConverted=true and id=:leadObject[3].id];
        system.assertEquals(converted.IsConverted, true);
        test.stopTest();
    }
    
     //-----------------------------
    // @author: Vinod Merwade
    // @date: 19 July 2017
    // @param: NA
    // @description: SFDC1-45 and SFDC1-186 Test method for convertLead on conversion convert the Lead
    // @return: NA
    // @Company: Vertiba
    //-----------------------------

    public static testmethod void converLeadControllerTest2() {
        
        Lead FalseLeadSobj = [select id,Name from Lead where Company =:'flase' limit 1];
        ApexPages.Message[] pageMessages = ApexPages.getMessages();
        Account accountObject = [select id,Name from Account where Name =:'Test Account'  Limit 1];
        Opportunity opportunityObject = [select id,Name from Opportunity where Name =: 'Test opportunity' Limit 1];
        
        test.startTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(FalseLeadSobj);
        ConvertLeadController cLC4 =  new ConvertLeadController(sc);
        cLC4.selectedValue = 'Activity';
        cLC4.leadOpportunity.ExistingOpportunity__c=opportunityObject.id;
        cLC4.convertLead();
        List<Task> taskCreated = [Select id,subject from Task] ;
        system.assertEquals(taskCreated.size(),1,'Task  Created');
        
        ApexPages.StandardController sc1 = new ApexPages.StandardController(FalseLeadSobj);
        ConvertLeadController cLC1 =  new ConvertLeadController(sc1);
        cLC1.selectedValue = 'Case';
        cLC1.convertLead();
        List<Case> caseCreated = [Select id,subject from Case] ;
      //  system.assertEquals(caseCreated.size(),1,'Case Created');
              
        ApexPages.StandardController sc3 = new ApexPages.StandardController(FalseLeadSobj);
        ConvertLeadController cLC3 =  new ConvertLeadController(sc3);
        cLC3.selectedValue = 'Contact';
        cLC3.convertLead();
        System.assertEquals(0, pageMessages.size());
        
        ApexPages.StandardController sc4 = new ApexPages.StandardController(FalseLeadSobj);  
        ConvertLeadController cLC5 =  new ConvertLeadController(sc4);
        cLC5.selectedValue = 'OppCont';
        cLC5.convertLead();
        System.assertEquals(0, pageMessages.size());
        cLC5.backToLead();
        test.stopTest();
    }
    
     //-----------------------------
    // @author: Vinod Merwade
    // @date: 25 October 2017
    // @param: NA
    // @description: Test Method to cover the duplicate contacts while conversion.
    // @return: NA
    // @Company: Vertiba
    //-----------------------------
    
    public static testmethod void converLeadControllerTest3() {
        Lead FalseLeadSobj = [select id,Name from Lead where Company =:'flase' limit 1];
        ApexPages.Message[] pageMessages = ApexPages.getMessages();
        Account accountObject = [select id,Name from Account where Name =:'Test Account'  Limit 1];
        Opportunity opportunityObject = [select id,Name from Opportunity where Name =: 'Test opportunity' Limit 1];
        contact con = new contact();
        con.FirstName = 'TestFirstName';
        con.LastName = 'TestLastName';
        con.Email = 'false@false.com';
        con.Phone = '123456789';
        con.AccountId =accountObject.id;
        insert con;
        test.startTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(FalseLeadSobj);
        ConvertLeadController cLC4 =  new ConvertLeadController(sc);
        cLC4.selectedValue = 'Contact';
        cLC4.convertLead();
        cLc4.selectedContact = con.Id;
        cLC4.convertLead();
        test.stopTest();
        
    }
    
}