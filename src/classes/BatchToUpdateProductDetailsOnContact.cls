//-----------------------------
// @author: Sruti Srivastava
// @date: 7 July 2018
// @description: SFDC1-6833 This batch class will update license and product information on Contact
// @companyname: Vertiba
//------------------------------

global class BatchToUpdateProductDetailsOnContact implements Database.Batchable<sObject>{
    
    //-----------------------------
    // @author: Sruti Srivastava
    // @date: 7 July 2018
    // @description: SFDC1-6833- start method for the batch, queries Contacts with product login 
    // @return: list of Contacts
    //--------------------
    global Database.QueryLocator start(Database.BatchableContext BC) {
        String strQuery = 'Select Id, NumberOfLicenses__c, Licenses__c,ProductUsageLast30days__c,'+
                            ' ProductUsageLast60days__c, ProductUsageLast90days__c From Contact '+
                            ' where NumProductLoginContactAssociation__c > 0 ';
        return Database.getQueryLocator(strQuery);
    }
    
    //-----------------------------
    // @author: Sruti Srivastava
    // @date: 7 July 2018
    // @description: execute method for the batch, updates Contacts with product and license information
    // @return: NA
    //--------------------
    global void execute(Database.BatchableContext BC, List<Contact> scope) {
        Set<Id> setProdLoginIds = new Set<Id>();
        Map<Id, Contact> contactsToUpdate = new Map<Id, Contact>();
        Map<Id, Set<Id>> mapContactIdToSetProdLogin = new Map<Id, Set<Id>>();
        //Sets and maps to store License informatiom
        Set<Id> setLicenseIds = new Set<Id>();
        Map<Id, Set<Id>> mapProdLoginIdToSetLicenseId = new Map<Id, Set<Id>>();//To store number of License for each prod login
        Map<Id, Integer> mapProdLoginIdToSetLicenseCount = new Map<Id, Integer>();//To store count of License for each prod login
        Map<Id, Set<Id>> mapProdLoginIdToSetLicenseIdWithEntitlement = new Map<Id, Set<Id>>();
        //Date variables to compare product usage for each contact
        Date dt30Days = Date.today().addDays(-30);
        Date dt60Days = Date.today().addDays(-60);
        Date dt90Days = Date.today().addDays(-90);
        //Maps to store Licenses with recent usage
        Map<Id, Set<Id>> mapLoginIdToLicenseWith30DaysUsage = new Map<Id, Set<Id>>();
        Map<Id, Set<Id>> mapLoginIdToLicenseWith60DaysUsage = new Map<Id, Set<Id>>();        
        Map<Id, Set<Id>> mapLoginIdToLicenseWith90DaysUsage = new Map<Id, Set<Id>>();
        //Maps to store product group information
        Map<Id, Set<Id>> mapLicenseIdToProdGroupIds = new Map<Id, Set<Id>>();//To store Prod Families for each license
        Map<Id, String> mapProdGroupIdToName = new Map<Id, String>();////To store Prod Group Id and name      
        
        Map<Id, Contact> mapOldContacts = new Map<Id, Contact>();
        mapOldContacts.putAll(scope);//Storing contacts in a map
        
        //Preparing mapContactIdToSetProdLogin for storing all product logins for a Contact
        for(ProductLoginContactAssociation__c prodLoginCon: [Select Contact__c, ProductLogin__c 
                                                             FROM ProductLoginContactAssociation__c 
                                                             Where Contact__c IN: mapOldContacts.keyset()] ) {
            
            if(!mapContactIdToSetProdLogin.containsKey(prodLoginCon.Contact__c)) {
                mapContactIdToSetProdLogin.put(prodLoginCon.Contact__c, new Set<Id>());
            }
            mapContactIdToSetProdLogin.get(prodLoginCon.Contact__c).add(prodLoginCon.ProductLogin__c); 
            setProdLoginIds.add(prodLoginCon.ProductLogin__c);                                                    
        }
        
        //Quering and storing Product license inofrmation for each product login Id
        if(!setProdLoginIds.isEmpty()) {
             
            for(ProductEntitlement__c prodEnt: [Select IsValid__c, ProductLicense__c, ProductLogin__c, ProductLicense__r.Name  
                                                FROM ProductEntitlement__c
                                                Where ProductLogin__c IN: setProdLoginIds AND IsValid__c = true
                                                AND ProductLicense__c != null] ) {
                if(!mapProdLoginIdToSetLicenseId.containsKey(prodEnt.ProductLogin__c)) {
                    mapProdLoginIdToSetLicenseId.put(prodEnt.ProductLogin__c, new set<Id>{prodEnt.ProductLicense__c});
					mapProdLoginIdToSetLicenseIdWithEntitlement.put(prodEnt.ProductLogin__c, new set<Id>{prodEnt.ProductLicense__c});
                }
                else {
                    mapProdLoginIdToSetLicenseId.get(prodEnt.ProductLogin__c).add(prodEnt.ProductLicense__c);
					mapProdLoginIdToSetLicenseIdWithEntitlement.get(prodEnt.ProductLogin__c).add(prodEnt.ProductLicense__c);
                }
				
                                                    
            }
			
            if(!mapProdLoginIdToSetLicenseId.isEmpty()) {
                //mapProdLoginIdToSetLicenseIdWithEntitlement.putAll(mapProdLoginIdToSetLicenseId);
                for(Id loginId: mapProdLoginIdToSetLicenseId.keyset() ) {
                    mapProdLoginIdToSetLicenseCount.put(loginId, mapProdLoginIdToSetLicenseId.get(loginId).size());
                    setLicenseIds.addAll(mapProdLoginIdToSetLicenseId.get(loginId));
                }
            }
            
            //Querying Product usage related to Product logins//product date+ license 
            for(ProductUsageStatistics__c prodUsage: [Select ProductLicense__c, ProductLogin__c , UsageDate__c,ProductLicense__r.Name
                                                      FROM ProductUsageStatistics__c
                                                      Where ProductLogin__c IN: setProdLoginIds AND ProductLicense__c != null
                                                      AND UsageDate__c != null AND UsageDate__c>= :dt90Days 
                                                      Order By UsageDate__c DESC] ) {// for last 90 days
                                                          
                setLicenseIds.add(prodUsage.ProductLicense__c);
                
                if(!mapProdLoginIdToSetLicenseId.containsKey(prodUsage.ProductLogin__c)) {
                    mapProdLoginIdToSetLicenseId.put(prodUsage.ProductLogin__c, new set<Id>{prodUsage.ProductLicense__c});
                }
                else {
                    mapProdLoginIdToSetLicenseId.get(prodUsage.ProductLogin__c).add(prodUsage.ProductLicense__c);
                }                                         
                //storing usage for last 30, 60 and 90 days                                          
                if(prodUsage.UsageDate__c != null && prodUsage.UsageDate__c >=dt30Days) {
                    if(!mapLoginIdToLicenseWith30DaysUsage.containsKey(prodUsage.ProductLogin__c)) {
                        mapLoginIdToLicenseWith30DaysUsage.put(prodUsage.ProductLogin__c, new set<Id> {prodUsage.ProductLicense__c});
                    }
                    else {
                        mapLoginIdToLicenseWith30DaysUsage.get(prodUsage.ProductLogin__c).add(prodUsage.ProductLicense__c);
                    }
                } 
                                                          
                if(prodUsage.UsageDate__c != null && prodUsage.UsageDate__c >= dt60Days ) {
                    if(!mapLoginIdToLicenseWith60DaysUsage.containsKey(prodUsage.ProductLogin__c)) {
                        mapLoginIdToLicenseWith60DaysUsage.put(prodUsage.ProductLogin__c, new set<Id> {prodUsage.ProductLicense__c});
                    }
                    else {
                        mapLoginIdToLicenseWith60DaysUsage.get(prodUsage.ProductLogin__c).add(prodUsage.ProductLicense__c);
                    }
                                              
                }
                 // remove range                                        
                if(prodUsage.UsageDate__c != null && prodUsage.UsageDate__c >= dt90Days ) {
                    if(!mapLoginIdToLicenseWith90DaysUsage.containsKey(prodUsage.ProductLogin__c)) {
                        mapLoginIdToLicenseWith90DaysUsage.put(prodUsage.ProductLogin__c, new set<Id> {prodUsage.ProductLicense__c});
                    }
                    else {
                        mapLoginIdToLicenseWith90DaysUsage.get(prodUsage.ProductLogin__c).add(prodUsage.ProductLicense__c);
                    }
                } 
            }
            
            if(!setLicenseIds.isEmpty()) {
                //Storing product group information for each License
                for(ProductGroupLicenseAssociation__c prodGroupLA: [Select ProductLicense__c, ProductGroup__c, 
                                                                        ProductGroup__r.Name
                                                                        FROM ProductGroupLicenseAssociation__c
                                                                        Where (ProductLicense__c IN: setLicenseIds )] ) {
                                                       
                    if(!mapLicenseIdToProdGroupIds.containsKey(prodGroupLA.ProductLicense__c)) {
                        mapLicenseIdToProdGroupIds.put(prodGroupLA.ProductLicense__c, new set<Id>{prodGroupLA.ProductGroup__c});
                        
                    }
                    else {
                        mapLicenseIdToProdGroupIds.get(prodGroupLA.ProductLicense__c).add(prodGroupLA.ProductGroup__c);
                    }
                    mapProdGroupIdToName.put(prodGroupLA.ProductGroup__c, prodGroupLA.ProductGroup__r.Name);
                }
            }
        }
        
        //Iterating the map to update Contacts with product license and usage information
        for(Id conId : mapOldContacts.keyset()) {
            Integer licenseCount = 0;
            String licenseNames = '';
            String usageInLast30Days = '';
            String usageInLast60Days = '';
            String usageInLast90Days = '';
            //Sets to prevent duplicate product group nam einformation
            Set<Id> productGroupIdToAvoidDuplicatesForLicences =  new Set<Id> ();
            Set<Id> productGroupIdToAvoidDuplicatesForLast30Days =  new Set<Id> ();
            Set<Id> productGroupIdToAvoidDuplicatesForLast60Days =  new Set<Id> ();
            Set<Id> productGroupIdToAvoidDuplicatesForLast90Days =  new Set<Id> ();
            
            if(mapContactIdToSetProdLogin != null && mapContactIdToSetProdLogin.containsKey(conId)) {
                for(Id loginId : mapContactIdToSetProdLogin.get(conId)) {
                    if(mapProdLoginIdToSetLicenseId.containsKey(loginId)) {
                        //Calculating number of License 
                        licenseCount += mapProdLoginIdToSetLicenseCount.containsKey(loginId)? mapProdLoginIdToSetLicenseCount.get(loginId) : 0;
                        
                        //Calculating product group  
                        if(mapProdLoginIdToSetLicenseIdWithEntitlement.containsKey(loginId)) {
                            for(Id licenseId : mapProdLoginIdToSetLicenseIdWithEntitlement.get(loginId)) {
                                
                                if(mapLicenseIdToProdGroupIds.containsKey(licenseId)) {
                                    for(Id prodGroupId : mapLicenseIdToProdGroupIds.get(licenseId)) {
                                        
                                        if(!productGroupIdToAvoidDuplicatesForLicences.contains(prodGroupId)) {
                                            licenseNames = licenseNames + ', ' +mapProdGroupIdToName.get(prodGroupId) ;
                                        }
                                    }
                                    productGroupIdToAvoidDuplicatesForLicences.addAll(mapLicenseIdToProdGroupIds.get(licenseId));
                                }
                            }
                        }
                        
                        //Calculating licenses with last 30 days usage
                        if(mapLoginIdToLicenseWith30DaysUsage.containsKey(loginId)) {
                            
                            for(Id licenseId : mapLoginIdToLicenseWith30DaysUsage.get(loginId)) {
                                
                                if(mapLicenseIdToProdGroupIds.containsKey(licenseId)) {
                                    for(Id prodGroupId : mapLicenseIdToProdGroupIds.get(licenseId)) {
                                        
                                        if(!productGroupIdToAvoidDuplicatesForLast30Days.contains(prodGroupId)) {
                                            usageInLast30Days = usageInLast30Days + ', ' +mapProdGroupIdToName.get(prodGroupId) ;
                                        }
                                    }
                                    
                                    productGroupIdToAvoidDuplicatesForLast30Days.addAll(mapLicenseIdToProdGroupIds.get(licenseId));
                                }
                            }
                        }
                        //Calculating licenses with last 60 days usage
                        if(mapLoginIdToLicenseWith60DaysUsage.containsKey(loginId)) {
                            for(Id licenseId : mapLoginIdToLicenseWith60DaysUsage.get(loginId)) {
                                
                                if(mapLicenseIdToProdGroupIds.containsKey(licenseId)) {
                                    for(Id prodGroupId : mapLicenseIdToProdGroupIds.get(licenseId)) {
                                        if(!productGroupIdToAvoidDuplicatesForLast60Days.contains(prodGroupId)) {
                                            usageInLast60Days = usageInLast60Days + ', ' +mapProdGroupIdToName.get(prodGroupId) ;
                                        }
                                    }
                                    productGroupIdToAvoidDuplicatesForLast60Days.addAll(mapLicenseIdToProdGroupIds.get(licenseId));
                                }
                            }
                        }
                        //Calculating licenses with last 90 days usage
                        if(mapLoginIdToLicenseWith90DaysUsage.containsKey(loginId)) {
                            for(Id licenseId : mapLoginIdToLicenseWith90DaysUsage.get(loginId)) {
                                if(mapLicenseIdToProdGroupIds.containsKey(licenseId)) {
                                    for(Id prodGroupId : mapLicenseIdToProdGroupIds.get(licenseId)) {
                                        if(!productGroupIdToAvoidDuplicatesForLast90Days.contains(prodGroupId)) {
                                            usageInLast90Days = usageInLast90Days + ', ' +mapProdGroupIdToName.get(prodGroupId) ;
                                        }
                                    }
                                    productGroupIdToAvoidDuplicatesForLast90Days.addAll(mapLicenseIdToProdGroupIds.get(licenseId));
                                }
                            }
                        }
                         
                    } 
                }
            }   
            licenseNames =  licenseNames == null ? '' : (licenseNames.length() > 1000 ? licenseNames.left(1000) : licenseNames.trim());
            licenseNames =  String.isBlank(licenseNames) ? licenseNames :  (licenseNames.startsWith(',') ? licenseNames.removeStart(','): licenseNames);
            usageInLast30Days =  usageInLast30Days == null ? '' : (usageInLast30Days.length() > 32000 ? usageInLast30Days.left(32000) : usageInLast30Days.trim());
            usageInLast30Days =  String.isBlank(usageInLast30Days) ? usageInLast30Days :  (usageInLast30Days.startsWith(',') ? usageInLast30Days.removeStart(','): usageInLast30Days);
            usageInLast60Days =  usageInLast60Days == null ? '' : (usageInLast60Days.length() > 32000 ? usageInLast60Days.left(32000) : usageInLast60Days.trim());
            usageInLast60Days =  String.isBlank(usageInLast60Days) ? usageInLast60Days :  (usageInLast60Days.startsWith(',') ? usageInLast60Days.removeStart(','): usageInLast60Days);   
            usageInLast90Days =  usageInLast90Days == null ? '' : (usageInLast90Days.length() > 32000 ? usageInLast90Days.left(32000) : usageInLast90Days.trim());
            usageInLast90Days =  String.isBlank(usageInLast90Days) ? usageInLast90Days :  (usageInLast90Days.startsWith(',') ? usageInLast90Days.removeStart(','): usageInLast90Days);
            
            //Sorting texts 
            licenseNames = sortStrings(licenseNames);    
            usageInLast30Days = sortStrings(usageInLast30Days);    
            usageInLast60Days = sortStrings(usageInLast60Days);    
            usageInLast90Days = sortStrings(usageInLast90Days);  
            
            //Comparing Contacts, to find out if there is any update needed
            Contact oldContact = mapOldContacts.get(conId);
            oldContact.NumberOfLicenses__c  = oldContact.NumberOfLicenses__c == null? 0 : oldContact.NumberOfLicenses__c;
            licenseCount = licenseCount == null? 0: licenseCount;
            oldContact.Licenses__c = oldContact.Licenses__c == null? '' : oldContact.Licenses__c;
            oldContact.ProductUsageLast30days__c = oldContact.ProductUsageLast30days__c == null? '' : oldContact.ProductUsageLast30days__c;
            oldContact.ProductUsageLast60days__c = oldContact.ProductUsageLast60days__c == null? '' : oldContact.ProductUsageLast60days__c;
            oldContact.ProductUsageLast90days__c = oldContact.ProductUsageLast90days__c == null? '' : oldContact.ProductUsageLast90days__c;
            
            if( oldContact.NumberOfLicenses__c != licenseCount
             || !licenseNames.equalsIgnoreCase(oldContact.Licenses__c)
             || !usageInLast30Days.equalsIgnoreCase(oldContact.ProductUsageLast30days__c)
             || !usageInLast60Days.equalsIgnoreCase(oldContact.ProductUsageLast60days__c) 
             || !usageInLast90Days.equalsIgnoreCase(oldContact.ProductUsageLast90days__c)) {
                 contactsToUpdate.put(conId, new Contact(Id = conId, NumberOfLicenses__c = licenseCount, 
                                                    Licenses__c = licenseNames, 
                                                    ProductUsageLast30days__c = usageInLast30Days,
                                                    ProductUsageLast60days__c = usageInLast60Days,
                                                    ProductUsageLast90days__c = usageInLast90Days));
            }
        }
        //Updating contacts 
        if(!contactsToUpdate.isEmpty()) {
            update contactsToUpdate.values();
        }
    }
    
    //-----------------------------
    // @author: Sruti Srivastava
    // @date: 27 July 2018
    // @description: Sorts the string in ascending manner
    // @return: String 
    //--------------------
    private string sortStrings(String valuesToSort) {
        List<String> listToSort = new List<String>();
        String strSortedString = '';
        
        if(!String.isBlank(valuesToSort)) {
            listToSort.addAll(valuesToSort.split(','));
            listToSort.sort();
            
            for(String strToAdd : listToSort) {
                if(!String.isBlank(strToAdd) ) {
                	strSortedString = strSortedString + ', '+ strToAdd;
                }
            }
            if(!String.isBlank(strSortedString) && strSortedString.startsWith(',')) {
                strSortedString = strSortedString.removeStart(',');
            }
        }    
        return strSortedString;
    }
    global void finish(Database.BatchableContext BC){
    }
}