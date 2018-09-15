//-----------------------------
// @author: Jagadesh Kumar
// @date: 01 June 2018
// @param: NA
// @description: Class to hold trigger methods 
// @return: NA
//-----------------------------
public class ProductUsageStatisticsMethods {
    //-----------------------------
    // @author: Jagadesh Kumar
    // @date: 01 June 2018
    // @param: TriggerParameters tp
    // @description: SFDC1-7109 Contact Creation Trigger based on Product User & Product Usage
    // @return: NA
    //------------------------------
	public static void productUserContactCreation(TriggerParameters tp) {
        Set<Id> productLoginIds = new Set<Id>();
        Map<String,ProductLoginContactAssociation__c> associationMap = new Map<String,ProductLoginContactAssociation__c>();
        Map<String,Contact> newContactDetailsMap = new Map<String,Contact>();
        Map<String,Contact> insertContactMap = new Map<String,Contact>();
        Map<String,Contact> emailContactMap = new Map<String,Contact>();
        List<ProductLogin__c> productLoginEmptyContactList = new List<ProductLogin__c>();
        List<ProductLogin__c> productLoginInsertContactList = new List<ProductLogin__c>();
        if(tp.tEvent==TriggerParameters.TriggerEvent.afterInsert) {
            try {
                for (ProductUsageStatistics__c pu : (List<ProductUsageStatistics__c>)tp.newList) {
                    productLoginIds.add(pu.ProductLogin__c);                
                }
                List<ProductLogin__c> productloginList = [SELECT Id,Email__c,FirstName__c,LastName__c,
                                             (SELECT Contact__c,ProductLogin__c FROM ProductLoginContactAssociations1__r) 
                                             FROM ProductLogin__c WHERE ID IN : productLoginIds];
                Account acc = [SELECT Id from Account where Name =: System.Label.CaseUnknownAccountName];
                for(ProductLogin__c login : productloginList) {
                    //Check product login Email null
                    if(login.Email__c != null) {
                        productLoginEmptyContactList.add(login);
                        Contact c = new Contact();
                        if(String.isBlank(login.LastName__c)) {
                            c.lastName = System.Label.ContactLastNameUnknown;
                        }else {
                            c.lastName = login.LastName__c;
                        }
                        c.firstName = login.FirstName__c;
                        c.Email = login.Email__c;
                        c.AccountId = acc.Id;
                        newContactDetailsMap.put(login.Email__c, c);                           
                    }
                } 
                if(newContactDetailsMap.size() > 0) {
                    //Fetch the contacts by email.
                    for(Contact con : [SELECT Id,Email,lastName from Contact where Email IN : newContactDetailsMap.keyset()]) {
                        emailContactMap.put(con.Email,con);
                    }
                    for(ProductLogin__c pl : productLoginEmptyContactList) {
                        //Product login Email Contact existis in DB,
                        //check for association, if not available need to insert association record.
                        if(emailContactMap.get(pl.Email__c) != null) { //Contact exists for the Email
                            checkPLContactAssociation(pl, emailContactMap, associationMap);
                            System.debug('--------associationMap---------****'+associationMap);
                        } else { //Create new contact
                            //Product login Email Contact NOT existis in DB,
                            //Create the contact first, then create/insert the association.
                            insertContactMap.put(pl.Email__c,newContactDetailsMap.get(pl.Email__c));
                            productLoginInsertContactList.add(pl);
                        }  
                    }
                    if(insertContactMap.size() > 0) {
                        System.debug('--------insertContactMap------'+insertContactMap);
                        insert insertContactMap.values();
                    }
                    for(ProductLogin__c pl : productLoginInsertContactList) {
                        ProductLoginContactAssociation__c lcAsso = new ProductLoginContactAssociation__c();
                        lcAsso.ProductLogin__c = pl.Id;
                        lcAsso.Contact__c = insertContactMap.get(pl.Email__c).Id;
                        String key = pl.Id + ':' + insertContactMap.get(pl.Email__c).Id;
                        associationMap.put(key,lcAsso);
                    }
                }
                System.debug('-----final associationMap ---'+associationMap);
                if(associationMap.size() > 0) {
                    insert associationMap.values();
                }
            } catch(Exception e) {
                UtilityClass.createApexLogRecord(e,'ProductUsageStatisticsMethods','productUserContactCreation'); 
            }
        }        
    }
    
    //Check for Product login and Contact association exists or not.
    private static void checkPLContactAssociation(ProductLogin__c login, Map<String,Contact> emailContactMap, Map<String,ProductLoginContactAssociation__c> associationMap) {
        boolean existsAsso = false;
        if(login.ProductLoginContactAssociations1__r != null && login.ProductLoginContactAssociations1__r.size() > 0) {
            for(ProductLoginContactAssociation__c plcAsso : login.ProductLoginContactAssociations1__r) {
                if(login.Id == plcAsso.ProductLogin__c && emailContactMap.get(login.Email__c).Id == plcAsso.Contact__c) {
                    existsAsso = true;
                }  
            }
        }
        if(!existsAsso) {
            ProductLoginContactAssociation__c lcAsso = new ProductLoginContactAssociation__c();
            lcAsso.ProductLogin__c = login.Id;
            lcAsso.Contact__c = emailContactMap.get(login.Email__c).Id;
            String key = login.Id + ':' + emailContactMap.get(login.Email__c).Id;
            associationMap.put(key,lcAsso);
        }
    }
     
}