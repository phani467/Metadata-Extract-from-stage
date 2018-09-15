//-----------------------------
// @author: Uttam Arya
// @date: 22 June 2017
// @param: NA
// @description: SFDC1-834, SFDC1-281 LiveChatOfflineFormController - visualforce controller for LiveChatOfflineForm page.
//                         Enables customers to log a case when there are no agents available to service Live Agent chats
// @return: NA
// @lastModifiedBy: Vishnu
// @LastModifiedDate: 29 Mar 2018
// @LastModifiedDescription: SFDC1-7721: Internal__C=false was used in SOQL while fetching prodcut group. Since the field was created as 
// 						part of Internal Case record type, and not valid any more, so deleting the field and related code.
//-----------------------------
public without sharing class LiveChatOfflineFormController {
    
    public String contactName {get; set;}
    public String accountName {get; set;}
    public String email {get; set;}
    public String phone {get; set;} 
    public String selectedProduct {get; set;}
    public String message {get; set;}
    public List<SelectOption> productFamily {get;set;}
    public List<SelectOption> productFamilyMSF {get;set;}
    
    private Map <Id, ProductGroup__c> productGroupMap {get; set;}
    private Map <String, MSFProduct> msfProductMap {get; set;}
    private String productIdSecuritiesFinance {get;set;}
    private String suppliedProductCode {get; set;}
    private String buttonOrigin {get; set;}
    
    public LiveChatOfflineFormController() {
        
        productFamily = new List<SelectOption>();
        productFamilyMSF = new List<SelectOption>();
        msfProductMap = new Map <String, MSFProduct>();
        
        PageReference pageRef = ApexPages.currentPage(); 
        
        if(pageRef.getParameters().get('suppliedProduct') != null) {
            suppliedProductCode = pageRef.getParameters().get('suppliedProduct');
        } else {
            suppliedProductCode = null;
        }
        
        if(pageRef.getParameters().get('buttonOrigin') != null) {
            buttonOrigin = pageRef.getParameters().get('buttonOrigin');
        } else {
            buttonOrigin = 'MCS';
        }
        
        productFamily.add(new SelectOption('none','Choose item from the list'));
        productFamilyMSF.add(new SelectOption('none','Choose item from the list'));
        
        //make default Value Selected as none from Product List
        selectedProduct = 'none';
        
        productGroupMap = new Map <Id, ProductGroup__c>([SELECT Id, Name FROM ProductGroup__c WHERE VisibleInLiveChat__c = true AND Status__c  = 'Active' ORDER BY Name ASC NULLS LAST]);
        
        for (ProductGroup__c pg : productGroupMap.values()) {
            productFamily.add(new SelectOption(pg.Id,pg.name));
            if(pg.name == 'Securities Finance-Equity') {
                productIdSecuritiesFinance = pg.Id;
            }
            if(suppliedProductCode != null && suppliedProductCode.escapeHtml4().equalsIgnoreCase(pg.name) && buttonOrigin == 'MCS') {
                selectedProduct = pg.Id;
            }
        }
        
        List<MSFPlatform__c> msfPlatforms = MSFPlatform__c.getall().values();
        
        for(MSFPlatform__c msfp: msfPlatforms) {
            productFamilyMSF.add(new SelectOption(msfp.Name,msfp.Platform__c));
            msfProductMap.put(msfp.Name, new MSFProduct(productIdSecuritiesFinance, msfp.Name, msfp.Platform__c, msfp.DeliveryMechanism__c));
        }
        
        if(suppliedProductCode != null && buttonOrigin == 'MSF') {
            if(msfProductMap.get(suppliedProductCode) != null) {
                selectedProduct = suppliedProductCode; 
            } 
        }
    }
    
    public PageReference submit() {
        try{
            
            String description = '';
            String selectedProductGroupId = null;
            
            if(contactName != null) {
                description = description +'Contact Name: ' + contactName;
            }
            
            if(accountName != null) {
                description = description +'\nAccount Name: ' + accountName;
            }
            
            if( selectedProduct != null && selectedProduct != 'none' && buttonOrigin == 'MCS' && productGroupMap.get(selectedProduct) != null) {
                description = description +'Product: ' + productGroupMap.get(selectedProduct).Name;
                selectedProductGroupId = selectedProduct;
            }
            
            if( selectedProduct != null && selectedProduct != 'none' && buttonOrigin == 'MSF' && msfProductMap.get(selectedProduct) != null) {
                description = description +'Product: ' + msfProductMap.get(selectedProduct).platform;
                selectedProductGroupId = msfProductMap.get(selectedProduct).msfProductId; 
            }
            
            List<Contact> myContact = [select Id, Email from Contact where email =: email limit 1];
            Group q = [select Id from Group where DeveloperName = 'FMCustomerCare' and Type = 'Queue']; // queue = Custom Support Team
            
            description =  description + '\nEmail Address= ' + email + '\nPhone= ' + phone +'\nMessage= ' + message;

            if(buttonOrigin == 'MSF' && msfProductMap.get(selectedProduct) != null) {
                
            }
            
            Case c = new Case(Origin = 'Web Chat Offline',
                              Subject = 'Web Chat Offline Message',
                              description =  description,
                              ProductGroup__c = selectedProductGroupId,
                              OwnerId = q.Id,
                              Suppliedemail = email,
                              RecordTypeId = System.Label.CustomerCareRecordtypeId); //Custom label is used in other part of the Live Chat Javascript Form. So skipping it querying actual Recordtype id using SOQL      
            
            if(!myContact.isEmpty())
                c.ContactId = myContact[0].Id;
            
            insert c;
            
            Case insertedCase = [Select CaseNumber, AdditionalFields__c from Case where id = :c.id];
            
            if(insertedCase.AdditionalFields__c != null && selectedProduct != null && selectedProduct != 'none' && buttonOrigin == 'MSF' && msfProductMap.get(selectedProduct) != null) {
                AdditionalCaseFields__c msfAdditionalCaseFields = new AdditionalCaseFields__c(Id = insertedCase.AdditionalFields__c, DeliveryMechanism__c = msfProductMap.get(selectedProduct).deliveryMechanism, Platform__c = msfProductMap.get(selectedProduct).platform);
                update msfAdditionalCaseFields;
            }
            
            // no exception thrown so redirect to confirmation page providing text to display
            PageReference pr = Page.LiveChatConfirmation;
            pr.getParameters().put('confirmationtitle','Thank you');
            String confirmationmsg = 'Thank you, your case with a unique case reference number ' + insertedCase.CaseNumber +' has been submitted. In order to allow you to track the progress of your enquiry, please quote the case reference number when contacting us. Someone will be in touch with you shortly to ensure that your request is handled to your satisfaction.';
            pr.getParameters().put('confirmationmsg',confirmationmsg);
            return pr;
            
        } catch(Exception e) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, e.getMessage()));
        }
        return Page.LiveChatOfflineForm;
    }
    
    // This is our wrapper/container class to hold MSF Product informatioon
    public class MSFProduct {
        
        public String msfProductId {get; set;}
        public String msfProductCode {get; set;}
        public String platform {get; set;}
        public String deliveryMechanism  {get; set;}
        
        public MSFProduct(String msfProductId, String msfProductCode, String platform, String deliveryMechanism) {
            this.msfProductId = msfProductId;
            this.msfProductCode = msfProductCode;
            this.platform = platform;
            this.deliveryMechanism = deliveryMechanism;
        }
    }
}