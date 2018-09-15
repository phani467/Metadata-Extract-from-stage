//-------------------------------------
//@Author: Sruti Srivastava
//@Date: 24 July 2018
//@Description: SFDC1-5233- Controller for component ViewEntitlement. Displays license and usage information for 
//related contacts 
//@companyname: VERTIBA
//-------------------------------------

public class ViewEntitlementsController {
	
    //-------------------------------------
    //@Author: Sruti Srivastava
    //@Date: 24 July 2018
    //@param: Id AccountId and Boolean showHierarchy
    //@Description: SFDC1-5233- Initialize method, which return LicenseWrapper with Product License information and contact 
    //             information binded
    //@return: LicenseWrapper
    //-------------------------------------    
    @AuraEnabled
    public static LicenseWrapper initialize(String recordId, Boolean showHierarchy) {
        
        Set<Id> setAccountIds = new Set<Id>();
        Map<Id, Contact> mapContactsForCSV = new Map<Id, Contact>();
        Set<Id> contactSet = new Set<Id>();
		List<ProductLicenseWrapper> tempProdLicenseWrapper = new List<ProductLicenseWrapper>();  
		Set<Id> setProdLoginIds = new Set<Id>();
		Map<Id, Contact> contactsToUpdate = new Map<Id, Contact>();
		Map<Id, Set<Id>> mapContactIdToSetProdLogin = new Map<Id, Set<Id>>();
		//Sets and maps to store License informatiom
		Set<Id> setLicenseIds = new Set<Id>();
		Map<Id, Set<Id>> mapProdLoginIdToSetLicenseId = new Map<Id, Set<Id>>();//To store number of License for each prod login
		Map<Id, set<Id>> mapContactToSetOfGroupId =  new Map<Id, Set<Id>> ();//Maps to store product group information
		Map<Id, Set<Id>> mapLicenseIdToProdGroupIds = new Map<Id, Set<Id>>();//To store Prod Families for each license
		Map<Id, String> mapProdGroupIdToName = new Map<Id, String>();////To store Prod Group Id and name      
		map<Id, Integer> mapProductGroupToLicenseCount = new map<Id, Integer>();
            
        LicenseWrapper objLicenseWrapper = new LicenseWrapper(tempProdLicenseWrapper, new List<Contact>());
		
        if(!String.isBlank(recordId)) {
            setAccountIds.add(recordId);
            String strQuery = 'Select Id, Account.Name, FirstName, LastName, Email, Licenses__c '+
                			' from Contact where NumProductLoginContactAssociation__c > 0 AND ';
            
            if(!showHierarchy) {
                strQuery = strQuery + '  AccountId IN: setAccountIds LIMIT 10000';
            }
            else {
                Set<Id> accIds = new Set<Id>();
                accIds= getRecursiveHierarchyAccountIds(setAccountIds);
                system.debug(accIds+'==accIds');
                if(accIds != null && accIds.size() > 0) {
                    setAccountIds.addAll(accIds);
                }
                strQuery = strQuery + '  AccountId IN: setAccountIds LIMIT 10000';
            }
            list<Contact> listContacts = database.query(strQuery);
            
            Map<Id, Contact>  contactMap = new map<Id, Contact>();
			
			if(listContacts != null && !listContacts.isEmpty()) {
				contactMap.putAll(listContacts);
				//Preparing mapContactIdToSetProdLogin for storing all product logins for a Contact
				for(ProductLoginContactAssociation__c prodLoginCon: [Select Contact__c, ProductLogin__c 
																	 FROM ProductLoginContactAssociation__c 
																	 Where Contact__c IN: contactMap.keyset() 
																	 order by Contact__r.Name] ) {
					if(!mapContactIdToSetProdLogin.containsKey(prodLoginCon.Contact__c)) {
						mapContactIdToSetProdLogin.put(prodLoginCon.Contact__c, new Set<Id>());
					}
					mapContactIdToSetProdLogin.get(prodLoginCon.Contact__c).add(prodLoginCon.ProductLogin__c); 
					setProdLoginIds.add(prodLoginCon.ProductLogin__c);                                                    
				}
			}
            
            //Quering and storing Product license information for each product login Id from ProductEntitlement
            if(!setProdLoginIds.isEmpty()) {
                 
                for(ProductEntitlement__c prodEnt: [Select IsValid__c, ProductLicense__c, ProductLogin__c, 
                                                    StartDate__c, EndDate__c, 
                                                    ProductLicense__r.Name  
                                                    FROM ProductEntitlement__c
                                                    Where ProductLogin__c IN: setProdLoginIds AND IsValid__c = true
                                                    AND ProductLicense__c != null] ) {
                    if(!mapProdLoginIdToSetLicenseId.containsKey(prodEnt.ProductLogin__c)) {
                        mapProdLoginIdToSetLicenseId.put(prodEnt.ProductLogin__c, new set<Id>{prodEnt.ProductLicense__c});
                    }
                    else {
                        mapProdLoginIdToSetLicenseId.get(prodEnt.ProductLogin__c).add(prodEnt.ProductLicense__c);
                    }
                    setLicenseIds.add(prodEnt.ProductLicense__c);
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
                
                //Iterating the map to update Contacts with product license and usage information
                for(Id conId : contactMap.keyset()) {
                    if(mapContactIdToSetProdLogin != null && mapContactIdToSetProdLogin.containsKey(conId)) {
                        for(Id loginId : mapContactIdToSetProdLogin.get(conId)) {
                            if(mapProdLoginIdToSetLicenseId.containsKey(loginId)) {
                                for(Id licenseId : mapProdLoginIdToSetLicenseId.get(loginId)) {
                                    if(mapLicenseIdToProdGroupIds.containsKey(licenseId)) {
                                        for(Id prodGroupId : mapLicenseIdToProdGroupIds.get(licenseId)) {
											//Storing Product group ids for each Contact
                                            if(!mapContactToSetOfGroupId.containsKey(conId)) {
                                                mapContactToSetOfGroupId.put(conId, new set<Id>{prodGroupId});
                                            }
                                            else {
                                                mapContactToSetOfGroupId.get(conId).add(prodGroupId);
                                            }
											//Adding contact information to CSV
                                            if(!mapContactsForCSV.containsKey(conId)) {
                                                mapContactsForCSV.put(conId, contactMap.get(conId));
                                            }
                                        }
									}
                                }                         
                            } 
                        }
                    }   
                }
				//Calculating number of License for each product group
				if(!mapContactToSetOfGroupId.isEmpty()) {
					for(Id conId : mapContactToSetOfGroupId.keyset()) {
						for(Id PGId : mapContactToSetOfGroupId.get(conId)) {
							if(!mapProductGroupToLicenseCount.containsKey(PGId)) {
								mapProductGroupToLicenseCount.put(PGId, 1);
							}
							else {
								Integer countLicense = mapProductGroupToLicenseCount.get(PGId);
								countLicense ++;
								mapProductGroupToLicenseCount.put(PGId, countLicense);
							}
						}
					}
				}
				//Adding product group and license count to list of ProductLicenseWrapper
				if(!mapContactToSetOfGroupId.isEmpty()) {
					for(Id PGId : mapProductGroupToLicenseCount.keyset()) {
						tempProdLicenseWrapper.add( new ProductLicenseWrapper(PGId,mapProdGroupIdToName.get(PGId), mapProductGroupToLicenseCount.get(PGId)));
					}
				}
			}
        }
        
        List<ProductLicenseWrapper> listProductLicenseWrapper = new List<ProductLicenseWrapper>();
        //Sorting list of ProductLicenseWrapper based on Contact Name
        if(!tempProdLicenseWrapper.isEmpty()) { 
            List<WrapperSorter> listWrapperSorter = new List<WrapperSorter>();
            for(ProductLicenseWrapper wrapper : tempProdLicenseWrapper) {
                listWrapperSorter.add(new WrapperSorter(wrapper));
            }
            listWrapperSorter.sort(); 
            
            for(WrapperSorter objwrapperSorter : listWrapperSorter) {
                listProductLicenseWrapper.add(objwrapperSorter.objProductLicenseWrapper);
            }
        }
        //Returning LicenseWrapper
        if(mapContactsForCSV != null && !mapContactsForCSV.isEmpty()) {
            objLicenseWrapper = new LicenseWrapper(listProductLicenseWrapper,	mapContactsForCSV.values());
        }
        else {
            objLicenseWrapper = new LicenseWrapper(listProductLicenseWrapper,	new List<Contact>());
        }
        return objLicenseWrapper;
    }

    //-------------------------------------
    //@Author: Sruti Srivastava
    //@Date: 24 July 2018
    //@param: Id AccountId, Id productGroupId and Boolean showHierarchy
    //@Description: SFDC1-5233- showUsageInformation method, which returns list ProductUsageSummary 
    //@return: LicenseWrapper
    //-------------------------------------    
	@AuraEnabled
    public static List<ProductUsageSummary> showUsageInformation(String accountId, String productGroupId, Boolean showHierarchy) {
        Date last30Days = Date.Today().addDays(-30);//Variable used for finding usage within last 30 days
        Set<Id> setAccountIds = new Set<Id>();//Set of Parent Account Ids
        Set<Id> setProdLicenseIds =  new Set<Id>();//Product License Ids
        Set<Id> setProductLoginIds =  new Set<Id>();// Product login ids
        List<ProductUsageSummary> templistUsageSummary = new List<ProductUsageSummary>();//Product usage summary list
		Map<Id, Id> mapProdLogintoContactsId = new Map<Id, Id>();//Map of product login Id to Contact Id
		Map<Id, Set<Id>> mapProdGrouptoLicenseIds = new Map<Id, Set<Id>>();//To store License ids for each prod groups
        Map<Id, String> mapProdGroupIdToName = new Map<Id, String>();////To store Prod Group Id and name  
        Map<Id, List<ProductEntitlement__c>> mapLicenseIdToEntitlements = new Map<Id, List<ProductEntitlement__c>>();//To store number of License for each prod login
        Map<Id, Set<Id>> mapIdEntitlementsToSetLogins = new Map<Id, Set<Id>>();//To store number of License for each prod login
        Map<string, Set<Id>> mapLoginLicenseIdToUsageIds = new Map<string, Set<Id>>();//To store number of License for each prod login
        
        if(!String.isBlank(accountId) && !String.isBlank(productGroupId)) {
            setAccountIds.add(accountId);
            String strQuery = 'Select Id from Contact where NumProductLoginContactAssociation__c > 0 ';
            
            if(showHierarchy) {
                Set<Id> accIds = new Set<Id>();
                accIds= getRecursiveHierarchyAccountIds(setAccountIds);
                if(accIds != null && accIds.size() > 0) {
                    setAccountIds.addAll(accIds);
                }
            }
            strQuery = strQuery + ' AND AccountId IN: setAccountIds LIMIT 10000';
            
            //Querying Product License from ProductGroupLicenseAssociation
            for(ProductGroupLicenseAssociation__c prodGroupLA: [Select ProductLicense__c, ProductGroup__c, 
                                                                ProductGroup__r.Name
                                                                FROM ProductGroupLicenseAssociation__c
                                                                Where ProductGroup__c =: productGroupId ]) {
                if(!mapProdGrouptoLicenseIds.containsKey(prodGroupLA.ProductGroup__c)) {
                    mapProdGrouptoLicenseIds.put(prodGroupLA.ProductGroup__c, new set<Id>{prodGroupLA.ProductLicense__c});
                }
                else {
                    mapProdGrouptoLicenseIds.get(prodGroupLA.ProductGroup__c).add(prodGroupLA.ProductLicense__c);
                }
                mapProdGroupIdToName.put(prodGroupLA.ProductGroup__c, prodGroupLA.ProductGroup__r.Name);
                setProdLicenseIds.add(prodGroupLA.ProductLicense__c);
            }
			
			if(!setProdLicenseIds.isEmpty()) {
				//Querying Product Entitlement based on Product License
				for(ProductEntitlement__c prodEnt: [Select IsValid__c, ProductLicense__c, ProductLogin__c, 
														StartDate__c, EndDate__c, 
														ProductLicense__r.Name  
														FROM ProductEntitlement__c
														Where ProductLicense__c IN: setProdLicenseIds 
														AND IsValid__c = true
														AND ProductLogin__c != null] ) {
						
					if(!mapLicenseIdToEntitlements.containsKey(prodEnt.ProductLicense__c)) {
						mapLicenseIdToEntitlements.put(prodEnt.ProductLicense__c, new List<ProductEntitlement__c>{prodEnt});
					}
					else {
						mapLicenseIdToEntitlements.get(prodEnt.ProductLicense__c).add(prodEnt);
					}
					if(!mapIdEntitlementsToSetLogins.containsKey(prodEnt.Id)) {
						mapIdEntitlementsToSetLogins.put(prodEnt.Id, new set<Id>{prodEnt.ProductLogin__c});
					}
					else {
						mapIdEntitlementsToSetLogins.get(prodEnt.Id).add(prodEnt.ProductLogin__c);
					}
					setProductLoginIds.add(prodEnt.ProductLogin__c); 
				}
			}
            if(!setProductLoginIds.isEmpty()) {
				//Querying usage information for each license from ProductUsageStatistics
				for(ProductUsageStatistics__c prodUsage: [Select ProductLicense__c, ProductLogin__c , UsageDate__c,	
															ProductLicense__r.Name FROM ProductUsageStatistics__c
															Where ProductLogin__c IN: setProductLoginIds 
															AND ProductLicense__c != null
															AND UsageDate__c != null AND UsageDate__c>=  :last30Days] ) {
					if(!mapLoginLicenseIdToUsageIds.containsKey(prodUsage.ProductLogin__c + ''+prodUsage.ProductLicense__c)) {
						mapLoginLicenseIdToUsageIds.put(prodUsage.ProductLogin__c + ''+prodUsage.ProductLicense__c, new set<Id>{prodUsage.Id});
					}
					else {
						mapLoginLicenseIdToUsageIds.get(prodUsage.ProductLogin__c + ''+prodUsage.ProductLicense__c).add(prodUsage.Id);
					}
				}
			}
            
			if(!setProductLoginIds.isEmpty()) {
				//Preparing mapContactIdToSetProdLogin for storing all product logins for a Contact
				for(ProductLoginContactAssociation__c prodLoginCon: [Select Contact__c, ProductLogin__c 
																	 FROM ProductLoginContactAssociation__c 
																	 Where ProductLogin__c IN: setProductLoginIds
																	and Contact__r.AccountId IN: setAccountIds] ) {
					mapProdLogintoContactsId.put(prodLoginCon.ProductLogin__c, prodLoginCon.Contact__c);
				}
			}
			//Querying account and contact details from Contact records
            Map<Id, Contact> mapOldContacts = new Map<Id, Contact>([Select Id, Name, AccountId, Account.Name FROM Contact 
                                                                   WHERE ID IN: mapProdLogintoContactsId.values()]);

			//Adding data to Adding to list of ProductUsageSummary	to be displayed into page												
            if(mapOldContacts != null && !mapOldContacts.isEmpty()) {  
				for(Id productGroup : mapProdGrouptoLicenseIds.keyset()) {
					for(Id productLicenseId: mapProdGrouptoLicenseIds.get(productGroup)) {
						if(mapLicenseIdToEntitlements != null && mapLicenseIdToEntitlements.containsKey(productLicenseId)) {
							for(ProductEntitlement__c productEntitlement: mapLicenseIdToEntitlements.get(productLicenseId)) {
								if(mapIdEntitlementsToSetLogins != null && mapIdEntitlementsToSetLogins.containsKey(productEntitlement.Id)) {
									for(Id loginId: mapIdEntitlementsToSetLogins.get(productEntitlement.Id)) {
										if(mapProdLogintoContactsId.containsKey(loginId) && mapProdLogintoContactsId.get(loginId) != null ) {
											if(mapOldContacts != null && mapOldContacts.containsKey(mapProdLogintoContactsId.get(loginId))) {
												Contact objContact = mapOldContacts.get(mapProdLogintoContactsId.get(loginId));
												Integer countUsageInLast30Days = 0;
												//Calculating usage
												if(mapLoginLicenseIdToUsageIds!= null && mapLoginLicenseIdToUsageIds.containsKey(loginId +''+productLicenseId) && 
												   mapLoginLicenseIdToUsageIds.get(loginId +''+productLicenseId) != null) {
													 countUsageInLast30Days = mapLoginLicenseIdToUsageIds.get(loginId +''+productLicenseId).size();
												}
												//Preparing a list ProductUsageSummary to bind with page
												ProductUsageSummary objProductUsageSummary = new ProductUsageSummary( objContact.Id, 
													objContact.Name,objContact.AccountId, 
													objContact.Account.Name,productEntitlement.StartDate__c,
													productEntitlement.EndDate__c, countUsageInLast30Days);
												//Adding to temporary list of ProductUsageSummary
												templistUsageSummary.add(objProductUsageSummary);
											}
										}
									}  
								}
							}
						}
					}   
				}
			}
        }
        List<ProductUsageSummary> listProductUsageSummary = new List<ProductUsageSummary>();
        //Sorting the list based on Product group name
        if(!templistUsageSummary.isEmpty()) {
            List<WrapperSorter> listWrapperSorter = new List<WrapperSorter>();
			for(ProductUsageSummary wrapper : templistUsageSummary) {
                listWrapperSorter.add(new WrapperSorter(wrapper));
            }
            listWrapperSorter.sort();
            
            for(WrapperSorter objwrapperSorter : listWrapperSorter) {
                listProductUsageSummary.add(objwrapperSorter.objProductUsageSummary);
            }
        }
       	return listProductUsageSummary; 
    }
	
    //-------------------------------------
    //@Author: Sruti Srivastava
    //@Date: 24 July 2018
    //@param: Set of Parent Account Id
    //@Description: SFDC1-5233- returns Set of child Account Ids
    //@return: Set of Account Id
    //-------------------------------------
    private static Set<Id> getRecursiveHierarchyAccountIds(Set<Id> setAccountId) {
        Set<Id> setAccIds = new Set<Id>();
        
        if(setAccountId != null) {
            Map<ID,Account> mapAccount = new Map<ID,Account>([Select Id, Name from Account WHERE ID not IN: setAccountId AND
                                                              (Parent.ParentId IN:setAccountId OR ParentId IN:setAccountId
															   OR Parent.Parent.ParentId IN:setAccountId
															   OR Parent.Parent.Parent.ParentId IN:setAccountId )]); 
            if(!mapAccount.isEmpty()) {
                Set<Id> accountIds = getRecursiveHierarchyAccountIds(mapAccount.keyset());
                setAccIds.addAll(accountIds);
            }
            setAccIds.addAll(setAccountId);
        }
        return setAccIds;
    }
	
    //-------------------------------------
    //@Author: Sruti Srivastava
    //@Date: 24 July 2018
    //@Description: Wrapper class to bind Contact, Entitlement and Usage information to be displayed in lightning component
    //-------------------------------------
    public class ProductUsageSummary {
        @AuraEnabled
        public String ContactId ;
        @AuraEnabled
        public String ContactName ;
        @AuraEnabled
        public String AccountId ;
        @AuraEnabled
        public String AccountName ;
        @AuraEnabled
        public Date startDate ;
        @AuraEnabled
        public Date endDate ;
        @AuraEnabled
        public Integer usageCount;
        
        public ProductUsageSummary(String ContactId, String ContactName, String AccountId, string AccountName, Date startDate, 
                               Date endDate, Integer usageCount) {
            this.AccountId = AccountId;
            this.ContactId = ContactId;
            this.ContactName = ContactName;
            this.AccountName = AccountName;
            this.startDate = startDate;
            this.endDate = endDate;
            this.usageCount = usageCount;
         }
    }
    
    //-------------------------------------
    //@Author: Sruti Srivastava
    //@Date: 24 July 2018
    //@Description: SFDC1-5233- Wrapper class to bind Product License information to be displayed in lightning component
    //-------------------------------------
    public class ProductLicenseWrapper {
        @AuraEnabled
        public String productId ;
        @AuraEnabled
        public String productName ;
        @AuraEnabled
        public Integer licenseCount ;
        public ProductLicenseWrapper(String productId, String productName, Integer licenseCount) {
            this.licenseCount = licenseCount;
            this.productName = productName;  
            this.productId =  productId;
        }
    } 
    
    //-------------------------------------
    //@Author: Sruti Srivastava
    //@Date: 24 July 2018
    //@Description: SFDC1-5233- Wrapper class to bind Product License information and contact information
    //-------------------------------------
    public class LicenseWrapper {
        @AuraEnabled 
        public List<ProductLicenseWrapper> listProductLicense;
        
        @AuraEnabled
        public List<Contact> conList;
        
        public LicenseWrapper(List<ProductLicenseWrapper> plist, List<Contact> clist) {
            listProductLicense = plist;
            conList = clist;
        }
    }
}