//
//@author: Paras Dhingra
//@date: 8th Sep 2017 
//@description : SFDC1-1837 Controller class for 
//				Opportunity product edit page
//@company : IHS Markit
//@lastmodifiedBy: Hemant Shukla on 8 Jan 2018, Removed the OPSWrapper class and make it separate due to winter 18 change: Inner wrapper class taken as LC attribute are not allowed to save.
//
public without sharing class OpportunityProductEditController  {
    //
    //@author : Paras Dhingra
    //@date: 8th Sep 2017
    //@description : SFDC1-1837 apex method to fetch Opportunity product and schedules for lightning 
    //@company : IHS Markit
    //@param : String
    //@return : OpportunityProductEditController.OppyWrapper
    //
    @AuraEnabled
    public static OppyWrapper getOpportunityOPS(String OppyId) {
        Id userId = UserInfo.getUserId();
        //query Opportunity with Opportunity Products and Opportunity Product Schedules
        Opportunity Oppy = [Select Id, Name, LegalEntity__c, LegalEntity__r.name, CurrencyISOCode, CloseDate,ContractStartDate__c,ContractEndDate__c,RecordType.DeveloperName,
                            IsProRated__c,AutoRenewal__c, DoesThisAutoRenewalHaveChanges__c,
                            (Select id, DiscountPercent__c,DiscountAmount__c,DiscountType__c,ExternalListPrice__c,
                                         InstallmentYears__c,  Opportunity__c,Opportunity__r.name, OpportunityProductID__c, OpportunityProductScheduleKey__c,
                                         PriceBookListPrice__c, Product__c,ProductSchedule__c, SalesPrice__c, TotalPrice__c, Quantity__c,Status__c, CurrencyIsoCode,
                                         AnnualizedDiscountAmount__c, AnnualizedUnitPrice__c, AnnualizedTotalAmount__c, ProRatedDiscountAmount__c, ProRatedUnitPrice__c from
                                         OpportunityProductSchedules__r order by InstallmentYears__c ASC),
                                         (Select id, Product2Id,Status__c,MaterialCode__c,Description,NumberofConcurrentUsersSeats__c,NumberofLocationsSites__c,
                                                    NumberofPotentialUsers__c,PriorYearTotalSalesPrice__c,LicenseType__c,Product2.Name, RecommendedUnitPrice__c, ProductType__c,
                                                    ContractStartDate__c,ContractEndDate__c
                                                from OpportunityLineItems )
                                         from Opportunity where id=:oppyId];
        List<OPSWrapper> opsWrap = new List<OPSWrapper>();
        if(Oppy.OpportunityLineItems==null || Oppy.OpportunityLineItems.isEmpty()) {
            //no products associated with Opportunity return empty wrapper
            OppyWrapper blankOpyWrap = new OppyWrapper();
            blankOpyWrap.hasOpportunityEditAccess = userHasEditAccess(userId,oppyId);
            return  blankOpyWrap;
        }
        //create a map for Oppy product and its oppyproductSchedules
        Map<String,List<OpportunityLineItemSchedule__c>> mapOppyProductandSchedules = new Map<String,List<OpportunityLineItemSchedule__c>>();
        for(OpportunityLineItemSchedule__c ops : oppy.OpportunityProductSchedules__r) {
            if(mapOppyProductandSchedules.containsKey(ops.opportunityProductID__c)) {
                mapOppyProductandSchedules.get(ops.opportunityProductID__c).add(ops);
            }
            else {
                mapOppyProductandSchedules.put(ops.opportunityProductID__c,new List<OpportunityLineItemSchedule__c>{ops});
            }
            
        }
        //As closeDate is never null assigning it as the pricingDate
        Date pricingDate = Oppy.CloseDate;
        //assign the pricing date to ContractStartDate__c if it is not null
        if(Oppy.ContractStartDate__c!=null) {
            pricingDate = Oppy.ContractStartDate__c;
        } 
        String oppyFiscalYear = [SELECT FiscalYearSettings.Name FROM Period WHERE Type = 'Year' AND StartDate <=:pricingDate AND EndDate >=:pricingDate].FiscalYearSettings.Name;
        //create map for opportunitylineitem
        System.debug('--oppyFiscalYear--'+oppyFiscalYear);
        Map<Id,OpportunityLineItem> mapOLI = new Map<Id,OpportunityLineItem>(Oppy.OpportunityLineItems);
        
        //query Opportunity product schedules
        List<Product2> lstRelatedOPS = [Select id, name, 
                                        (Select id, Name, ListPrice__c, PricingYear__c, Product__c, ProductTerm__c,CurrencyIsoCode, 
                                         InstallmentYear__c, Year__c from ProductSchedules__r  where isactive__c = true AND PricingYear__c=:oppyFiscalYear  order by InstallmentYear__c,ProductTerm__c ASC)
                                        from Product2
                                        where Id IN (Select Product2Id from OpportunityLineItem where OpportunityId=:oppyId)];
        System.debug('--oppyId--'+oppyId);
        System.debug('--lstRelatedOPS--'+lstRelatedOPS);
        Map<Id,Product2> mapProducts = new Map<Id,Product2>(lstRelatedOPS);                                
        //create a map for Products and ProductSchedules with product term as key
        Map<Id,Map<String,List<ProductSchedule__c>>> mapProductWithSchedules = new Map<Id,Map<String,List<ProductSchedule__c>>>();
        for(Product2 prod: lstRelatedOPS) {
            Map<String,List<ProductSchedule__c>> tempMapProdTermSchedule = new Map<String,List<ProductSchedule__c>>();
            for(ProductSchedule__c prodSchd : prod.ProductSchedules__r) {
                String productTerm = prodSchd.ProductTerm__c.substring(0,1);
                if(tempMapProdTermSchedule.containsKey(productTerm)) {
                    tempMapProdTermSchedule.get(productTerm).add(prodSchd);
                } 
                else {
                    tempMapProdTermSchedule.put(productTerm,new List<ProductSchedule__c>{prodSchd});
                }
            }
            mapProductWithSchedules.put(prod.Id,tempMapProdTermSchedule);
        }
        
        for(OpportunityLineItem oli: mapOLI.values()) {
            System.debug('--product Id--'+ oli.Product2Id );
            System.debug('--mapProducts--' + mapProducts );
            Product2 prod = mapProducts.get(oli.Product2Id);
            System.debug('--prod--'+prod);
            OPSWrapper opsWrapObj = new OPSWrapper();
            opsWrapObj.Status = oli.Status__c;
            opsWrapObj.oppyProduct = new OpportunityLineItem();
            opsWrapObj.oppyProduct = oli;
            String existingTerm = '';
            if(mapOppyProductandSchedules.containsKey(oli.Id)) {
                opsWrapObj.lstOPS = mapOppyProductandSchedules.get(oli.Id);
                existingTerm = String.valueOf(opsWrapObj.lstOPS.size());
            }
            opsWrapObj.mapOPSAll = new Map<String,List<OpportunityLineItemSchedule__c>>();
            opsWrapObj.productTermSelected = existingTerm;
            String currencyIsoCode = Oppy.CurrencyIsoCode;
            opsWrapObj.lstOPS = mapOppyProductandSchedules.get(oli.Id);
            opsWrapObj.mapOPSAll.put(existingTerm,opsWrapObj.lstOPS);
            //fetch related product schedules and convert them to oppyschedules and add them to the map
            if(mapProductWithSchedules.containsKey(oli.Product2Id)) {
                Map<String,List<ProductSchedule__c>> tempMapProductWithSchedule = new Map<String,List<ProductSchedule__c>>();
                tempMapProductWithSchedule = mapProductWithSchedules.get(oli.Product2Id);
                //now process for each product term and add to mapOPSAll
                for(String term : tempMapProductWithSchedule.keySet()) {
                    if(term!=existingTerm) {
                        List<OpportunityLineItemSchedule__c> tempOppyScheduleList= convertProdSchdsToOppySchds(currencyIsoCode, tempMapProductWithSchedule.get(term),opsWrapObj.lstOPS[0], oppy.RecordType.DeveloperName);
                        if(tempOppyScheduleList!=null && !tempOppyScheduleList.isEmpty()) {
                            opsWrapObj.mapOPSAll.put(term,tempOppyScheduleList);
                        }
                    }
                }
                
            }
            
            opsWrapObj.productQty = 0.0;
            opsWrapObj.isDeleted = false;
            opsWrapObj.productQty = opsWrapObj.lstOPS[0].Quantity__c;
            opsWrapObj.discountType = opsWrapObj.lstOPS[0].discountType__c;
            opsWrapObj.productTermSelected = String.valueOf(opsWrapObj.lstOPS.size());
            opsWrapObj.lstMapOPSIndex = new List<String>();
            opsWrapObj.lstMapOPSIndex.addAll(opsWrapObj.mapOPSAll.keySet());
            opsWrapObj.lstMapOPSIndex.sort();
            opsWrap.add(opsWrapObj);
            
        }
        
        OppyWrapper opyWrap = new OppyWrapper();
        
        opyWrap.oppy = oppy;
        opyWrap.canBeProRated = false;// by default the opportunty products cannot be pro-rated
        if(oppy.ContractStartDate__c!=null && oppy.ContractEndDate__c!=null) {
            List<OpportunityLineItem> lstSubscriptionProducts = [Select Id from OpportunityLineItem where ProductType__c='Subscription' and OpportunityID=:oppy.Id];
            if(lstSubscriptionProducts!=null && lstSubscriptionProducts.size()>0) {
                opyWrap.canBeProRated = true;    
            }
            
        }
        System.debug('--canBeProRated--'+opyWrap.canBeProRated);
        opyWrap.lstOPSWrapper = opsWrap;
        opyWrap.hasOpportunityEditAccess = userHasEditAccess(userId,oppyId);
        System.debug('--hasOpportunityEditAccess--'+ opyWrap.hasOpportunityEditAccess);
        opyWrap.hasRemoveProductAccess = getHasRemoveProductAccess(oppy.RecordType.DeveloperName);
        opyWrap.isAdmin = false;
        String profileName = UtilityClass.LoggedInUserProfileName;
        if(profileName=='IHSMarkit System Admin' || profileName =='System Administrator') {
            //no validation checks are required for system admins
            opyWrap.isAdmin = true;
        }
        return opyWrap;
    }
    //
    //@author : Paras Dhingra
    //@date: 29th Jan 2018
    //@description : SFDC1-4789 code optimization for duplicate products in opportunity
    //@company : IHS Markit
    //@param : String, List<ProductSchedule__c>,OpportunityLineItemSchedule__c
    //@return : List<OpportunityLineItemSchedule__c>
    //
    @TestVisible
    private static List<OpportunityLineItemSchedule__c> convertProdSchdsToOppySchds(String oppyCurrencyISOCode, List<ProductSchedule__c> lstProdSchedules,OpportunityLineItemSchedule__c existingSchedule, String oppyRecordType) {
        List<OpportunityLineItemSchedule__c> lstOPSToReturn = new List<OpportunityLineItemSchedule__c>();
        for(ProductSchedule__c ps : lstProdSchedules) {
            Decimal psListPrice = ps.ListPrice__c>0?ps.ListPrice__c:0.0;
            if(psListPrice!=null && psListPrice>0 && oppyCurrencyISOCode!=ps.CurrencyIsoCode) {
                psListPrice = ProductEditController.getConvertedCurrencyRate(ps.CurrencyIsoCode,oppyCurrencyISOCode,psListPrice);
            }
            OpportunityLineItemSchedule__c ops = new OpportunityLineItemSchedule__c();
            ops.PriceBookListPrice__c = psListPrice>0?psListPrice:0;
            ops.InstallmentYears__c = ps.InstallmentYear__c;
            ops.ExternalListPrice__c = oppyRecordType=='Gratis'?0:ops.PriceBookListPrice__c;
            ops.DiscountPercent__c = 0.00;
            ops.DiscountAmount__c = 0.00;
            ops.DiscountType__c  = existingSchedule.discountType__c;
            ops.Quantity__c = existingSchedule.Quantity__c;
            ops.ProductSchedule__c = ps.Id;
            ops.SalesPrice__c = oppyRecordType=='Gratis'?0:ops.PriceBookListPrice__c;
            ops.TotalPrice__c = oppyRecordType=='Gratis'?0:ops.PriceBookListPrice__c;
            ops.OpportunityProductID__c = existingSchedule.OpportunityProductID__c;
            ops.Opportunity__c = existingSchedule.Opportunity__c;
            ops.Product__c = existingSchedule.Product__c;
            ops.CurrencyIsoCode = oppyCurrencyISOCode;
            lstOPSToReturn.add(ops);
        }
        return lstOPSToReturn;
    }
    
    //@author : Paras Dhingra
    //@date: 8th Sep 2017
    //@description : SFDC1-1837 apex method to save oppy products and schedules post edit
    //@company : IHS Markit
    //@param : String, String
    //@return : String
    //@Update Author : Mohit Modi
    //@date : 23 March 2018
    //@Description : SFDC1-5722 : Added Global Constant check for bypassing the opportunitylineItem before deletion trigger
    
    @AuraEnabled
    public static String saveProducts(String oppyId, String wrapperJson) {
        String message = '';
        List<OPSWrapper> lstOPSWrapper = (List<OPSWrapper>)JSON.deserialize(wrapperJson, List<OPSWrapper>.class);
        if(lstOPSWrapper!=null && !lstOPSWrapper.isEmpty()) {
            //traverse to collect records for deletion
            Map<Id,OpportunityLineItemSchedule__c> mapOPSToDelete = new Map<Id,OpportunityLineItemSchedule__c>();
            List<OpportunityLineItemSchedule__c> lstOPSToUpsert = new List<OpportunityLineItemSchedule__c>();
            List<OpportunityLineItem> listOppyProductToDel = new List<OpportunityLineItem>();
            List<OpportunityLineItem> listOppyProductToUpdate = new List<OpportunityLineItem>();
            //traverse the wrapper to collect items in different lists
            for(OPSWrapper OPSObj : lstOPSWrapper) {
                // if user has opted to delete the product
                if(OPSObj.isDeleted) {
                    //select Oppy product to delete
                    listOppyProductToDel.add(OPSObj.oppyProduct);
                    for(String term : OPSObj.mapOPSAll.keySet()) {
                        for(OpportunityLineItemSchedule__c ops : OPSObj.mapOPSAll.get(term)) {
                            if(ops.Id!=null) {
                                //add to the map to delete all items that have id related to that product
                                mapOPSToDelete.put(ops.Id,ops);
                            }
                        }
                    }
                }
                else {//process records for upsert
                    Set<Id> setOPSToUpsert = new Set<Id>();
                    lstOPSToUpsert.addAll(OPSObj.lstOPS);
                    for(OpportunityLineItemSchedule__c ops: lstOPSToUpsert) {
                        if(ops.Id!=null) {
                            setOPSToUpsert.add(ops.Id);
                        }
                    }
                    //collect items not in mapOPSToUpsert for deletion
                    for(String term : OPSObj.mapOPSAll.keySet()) {
                        for(OpportunityLineItemSchedule__c ops : OPSObj.mapOPSAll.get(term)) {
                            if(ops.Id!=null && !setOPSToUpsert.contains(ops.Id)) {
                                //add to the map to delete all items that have id related to that product
                                mapOPSToDelete.put(ops.Id,ops);
                            }
                        }
                    }
                    listOppyProductToUpdate.add(OPSObj.oppyProduct);
                }
            }
            Savepoint sp = Database.setSavepoint();
            try {
                // Adding the changes for GlobalConstant to bypass the Opportunity lineItem before delete trigger. Setting to True
                GlobalConstants.hasAllowedOpportunityProductDeletion = true;     
                //prevent opportunity validations from firing
                GlobalConstants.hasTriggeredFromOpportunityProduct = true;
                GlobalConstants.disableOppyProductValidations = true;
                //query Opportunity and enable byPassValidation on it : Commented as byPassing has been moved to Global Variable use
                
                if(mapOPSToDelete!=null && !mapOPSToDelete.isEmpty()) {
                    delete mapOPSToDelete.values();
                }
                 if(listOppyProductToUpdate!=null && !listOppyProductToUpdate.isEmpty()) {                    
                    update listOppyProductToUpdate;                    
                }                
                //save OpportunityProductSchedules
                if(lstOPSToUpsert!=null && !lstOPSToUpsert.isEmpty()) {
                    System.debug('--mapOPSToUpsert--'+lstOPSToUpsert.size() );
                    upsert lstOPSToUpsert;
                }            
                
                //Query opportunity products and delete
                if(listOppyProductToDel!=null && !listOppyProductToDel.isEmpty()) {                
                    
                    delete listOppyProductToDel;              
                    
                    // Adding the changes for GlobalConstant to bypass the Opportunity lineItem before delete trigger. Setting to false back.
                    GlobalConstants.hasAllowedOpportunityProductDeletion = false; 
                    GlobalConstants.hasTriggeredFromOpportunityProduct = false;
                    GlobalConstants.disableOppyProductValidations = false;
                }                
                
                message = 'Records updated successfully';
            }
            catch(Exception e) {
                message = 'Error occurred while creating records :'+e.getMessage();
                Database.rollback(sp);
            }
            
        }
        return message;
    }
    //
    //@author : Paras Dhingra
    //@date: 21 Sep 2017
    //@description : SFDC1-4353 delete related oppy products and oppy product schedules
    //@company : IHS Markit
    //@param : String
    //@return : String
    //
    @auraEnabled public static  String deleteProductsOnOppy (String oppyId, String newLegalEntity) {
        if(newLegalEntity == '--None--') {
            newLegalEntity = null;
        }
        String message = productSearchController.deleteProductsOnOppy(oppyId,newLegalEntity);
        return message;
    }
    //
    //@author : Paras Dhingra
    //@date: 12 Dec 2017
    //@description : SFDC1-5854 fetch all legal entities not already in Opportunity
    //@company : IHS Markit
    //@param : String
    //@return : List<LegalEntity__c>
    //
    @auraEnabled public static List<LegalEntity__c> getValidLegalEntities(String currentLegalEntityId) {
        return [Select Id, Name from LegalEntity__c where Status__c='Active' and Id!=:currentLegalEntityId order by Name asc];
    }

    //
    //@author : Paras Dhingra
    //@date: 26th Sep 2017
    //@description : SFDC1-2043 fetch custom picklist values for licenseType
    //@company : IHS Markit
    //@param : null
    //@return : List<String>
    //@modified date: 16 Dec 2017
    //@modified reason : Adding new fields to edit screen
    //
    @AuraEnabled
    public static List<String> getLicenseTypes() {
        return UtilityClass.getselectOptions(new OpportunityLineItem(), 'LicenseType__c' );
    }
    //
    //@author : Paras Dhingra
    //@date: 01st Feb 2018
    //@description : SFDC1-4634 Product to be removed only by System admins for renewals
    //@company : IHS Markit
    //@param : String 
    //@return : Boolean
    //
    @TestVisible
    private static Boolean getHasRemoveProductAccess(String oppyRecordType) {
        Boolean hasAccess = true;
        if(oppyRecordType.containsIgnoreCase('Renewal')) {
            //check profile name
            Id profileId = UserInfo.getProfileId();
            String profileName = [Select Name from Profile where Id=:profileId].Name;
            if(!profileName.containsIgnoreCase('Admin')) {
                hasAccess = false;
            }
        }
        return hasAccess;
    }
     //
    //@author : Paras Dhingra
    //@date: 26th Sep 2017
    //@description : SFDC1-5958 check if logged in user has edit access to opportunity
    //@company : IHS Markit
    //@param : null
    //@return : List<String>
    //

    private static Boolean userHasEditAccess(Id usrId, Id recordId) {
        return UtilityClass.checkRecordAccessforUser(usrId, recordId);
    }
    public class OppyWrapper {
        @AuraEnabled public Opportunity oppy;
        @AuraEnabled public Boolean hasOpportunityEditAccess;
        @AuraEnabled public Boolean hasRemoveProductAccess;
        @AuraEnabled public Boolean canBeProRated;
        @AuraEnabled public Boolean isAdmin;
        @AuraEnabled public List<OPSWrapper> lstOPSWrapper;
    }
}