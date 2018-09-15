//-----------------------------
// @author: Uttam Arya
// @date: 22 June 2017
// @param: NA
// @description: SFDC1-834, SFDC1-281 LiveChatPreChatController for Pre chat page. Remote action serach for the contact match based on supplied email
// @return: NA
// @lastModifiedBy: Vishnu
// @LastModifiedDate: 29 Mar 2018
// @LastModifiedDescription: SFDC1-7721: Internal__C=false was used in SOQL while fetching prodcut group. Since the field was created as
// 						part of Internal Case record type, and not valid any more, So deleting the field and related code.
//-----------------------------
global without sharing class LiveChatPreChatController {
    
    public String suppliedemail { get; set; }
    public static Contact contact { get; set; }
    public String selectedProduct {get; set;}
    public List<SelectOption> productFamily {get;set;}
    public Map <Id, ProductGroup__c> productGroupMap {get; set;}
    public String productIdSecuritiesFinance {get;set;}
    
    public LiveChatPreChatController() {
        
        productFamily = new List<SelectOption>();
        productFamily.add(new SelectOption('none','Choose item from the list'));
        productGroupMap = new Map <Id, ProductGroup__c>([SELECT Id, Name FROM ProductGroup__c WHERE VisibleInLiveChat__c = true AND Status__c  = 'Active' ORDER BY Name ASC NULLS LAST]);
        
        for (ProductGroup__c pg : productGroupMap.values()) {
            productFamily.add(new SelectOption(pg.Id,pg.name));
            if(pg.name == 'Securities Finance-Equity') {
                productIdSecuritiesFinance = pg.Id;
            }
        }
    } 
    
    @RemoteAction
    global static Contact getContact(String suppliedemail) {
        System.debug('@@@UA' + suppliedemail);
        Contact = [select firstname, lastname, name, email from contact where email = :suppliedemail limit 1];
        return Contact;
    }
    
    @RemoteAction
    global static String getProductId(String prodName) {
        System.debug('@@@UA' + prodName);
        ProductGroup__c prd = [select Id, name from ProductGroup__c where Name = :prodName limit 1];
        if(prd != null) {
            return prd.Id;
        } else {
            return 'none';
        }
    }
}