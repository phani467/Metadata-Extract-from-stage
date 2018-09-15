//
// @Author : Paras Dhingra
// @date: 17th Aug 2017
// @description : SFDC1-2043 product selector controller for multi-year oppys
// @company : IHS Markit
// @Modified : Paras Dhingra
// @Modified Reason: SFDC1-7082 commenting out pro-ration code will be uncommented for phase 1.3 IHS release
// @Modified date: 18th Jul 2018
//
public without sharing  class ProductEditController {
    
    /**
    * @Author : Paras Dhingra
    * @date: 17th Aug 2017
    * @description : SFDC1-2043 fetch product schedules and convert into wrapper
    * @company : IHS Markit
    * @param : List<ID>
    * @return : List<ProductEditController.ProductLineItemWrapper>
    */
    public static Map<String, Decimal> mapCurrencyType = UtilityClass.mapCurrencyIsoCodeConversionRate;
    @AuraEnabled
    public static List<ProductEditController.ProductLineItemWrapper> getProductDetails(List<Id> productIds, String oppyId) {
    try {
		    List<Opportunity> oppy = [Select id, CurrencyIsoCode, CloseDate,ContractStartDate__c,RecordType.Name from Opportunity where Id=:oppyId];
		    //close date is a required field on oppy and cannot be null
		    Date pricingDate = oppy[0].CloseDate;
		    if(oppy[0].ContractStartDate__c!=null) {
		        pricingDate = oppy[0].ContractStartDate__c;
		    }
            String currentFiscalYear = [SELECT FiscalYearSettings.Name FROM Period WHERE Type = 'Year' AND StartDate <=:pricingDate AND EndDate >=:pricingDate].FiscalYearSettings.Name;
            List<Product2> lstProductsWithSchedules = [Select Id, Name ,MaterialCode__c,ProfitCenters__c,ProfitCenters__r.SaleType__c,
                                                        (SELECT Id, Name, ListPrice__c, PricingYear__c, Product__c, ProductTerm__c, 
                                                                         InstallmentYear__c, Year__c,CurrencyIsoCode FROM ProductSchedules__r where isactive__c = true
                                                                         AND PricingYear__c=:currentFiscalYear order by InstallmentYear__c,ProductTerm__c asc ) 
                                                       from Product2 where id in :productIds];
            System.debug('oppy'+oppy);
            Map<Id, Product2> mapProductsWithSchedules = new Map<Id,Product2>(lstProductsWithSchedules);
            List<ProductLineItemWrapper> lstProductLineItemWrapper = new List<ProductLineItemWrapper>();
            for(Id prodId : productIds) {
                ProductLineItemWrapper prodWrapper = new ProductLineItemWrapper();
                Product2 prod = mapProductsWithSchedules.get(prodId);
                prodWrapper.productName = prod.Name;
                prodWrapper.productId = prod.Id;
                prodWrapper.materialCode = prod.MaterialCode__c;
                prodWrapper.productType = prod.ProfitCenters__r!=null?prod.ProfitCenters__r.SaleType__c:'';
                prodWrapper.currencyCode = oppy[0].CurrencyIsoCode;
                prodWrapper.recordTypeName = oppy[0].RecordType.Name;
                prodWrapper.licenseType = '';
                prodWrapper.lstProductsSelected = new List<OpportunityLineItemScheduleWrapper>();
                prodWrapper.mapProductsAll = new Map<String, List<OpportunityLineItemScheduleWrapper>>();
                //traverse the prodschedules and prepare opportunity line items schedules
                for(ProductSchedule__c ps :prod.ProductSchedules__r) {
                    Decimal psListPrice = ps.ListPrice__c>0?ps.ListPrice__c:0.0;
                    if(ps.ListPrice__c!=null && ps.ListPrice__c>0 && ps.CurrencyIsoCode!=oppy[0].CurrencyIsoCode) {
                        psListPrice = getConvertedCurrencyRate(ps.CurrencyIsoCode,oppy[0].CurrencyIsoCode,ps.ListPrice__c);
                    }
                    
                    OpportunityLineItemScheduleWrapper wrapperObj = new OpportunityLineItemScheduleWrapper();
                    wrapperObj.installmentYear = ps.InstallmentYear__c;
                    wrapperObj.priceBookListPrice = psListPrice;
                    wrapperObj.externalListPrice = prodWrapper.recordTypeName=='Gratis'?0:psListPrice;
                    wrapperObj.discountPercent = 0.0;
                    wrapperObj.discountAmount = 0.00;
                    wrapperObj.salesPrice = prodWrapper.recordTypeName=='Gratis'?0:psListPrice;
                    wrapperObj.totalPrice= prodWrapper.recordTypeName=='Gratis'?0:psListPrice;
                    wrapperObj.productScheduleId = ps.Id;
                    //populate product term map
                    String productTerm = '';
                    productTerm= ps.ProductTerm__c!='Evergreen'?ps.ProductTerm__c.subString(0,1):ps.ProductTerm__c;
                    if(prodWrapper.mapProductsAll.containsKey(productTerm)) {
                        prodWrapper.mapProductsAll.get(productTerm).add(wrapperObj);
                    } else {
                        List<OpportunityLineItemScheduleWrapper> tempListWrapObj = new List<OpportunityLineItemScheduleWrapper>();
                        tempListWrapObj.add(wrapperObj);
                        prodWrapper.mapProductsAll.put(productTerm,tempListWrapObj);
                    }
                    
                }
                if(prodWrapper.mapProductsAll!=null && !prodWrapper.mapProductsAll.isEmpty()) {
                    prodWrapper.lstMapProductIndex = new List<String>();
                    prodWrapper.lstMapProductIndex.addAll(prodWrapper.mapProductsAll.keySet());
                    prodWrapper.lstMapProductIndex.sort();
                    prodWrapper.productTermSelected = prodWrapper.lstMapProductIndex[0];
                    prodWrapper.lstProductsSelected = prodWrapper.mapProductsAll.get(prodWrapper.productTermSelected);
                }
                
                prodWrapper.productQty = 1;
                lstProductLineItemWrapper.add(prodWrapper);
        }
            return lstProductLineItemWrapper;
            
        } catch(exception e) {
		
            List<ProductLineItemWrapper> lstProductLineItemWrapper = new List<ProductLineItemWrapper>();
            return lstProductLineItemWrapper;
        }
        
    }
    
    /**
    * @Author : Paras Dhingra
    * @date: 17th Aug 2017
    * @description : SFDC1-2043 fetch updated productSchedules and save them
    * @company : IHS Markit
    * @param : String, String, String
    * @return : String
    */
    @AuraEnabled
    public static String saveProductsOnOpportunity(String stringProductWrapper, String opportunityId, String legalEntity) {
        System.debug('--stringProductWrapper--'+ stringProductWrapper);
        List<ProductEditController.ProductLineItemWrapper> lstProductWrapper = (List<ProductEditController.ProductLineItemWrapper>)JSON.deserialize(stringProductWrapper, List<ProductEditController.ProductLineItemWrapper>.class);
        String message = '';
        System.debug('--lstProductWrapper--'+lstProductWrapper);
        System.debug('Oppy Id' + opportunityId);
        //query the Opportunity
        Opportunity oppy = [Select id, CurrencyIsoCode, LegalEntity__c, Name,IsProRated__c,ContractStartDate__c,ContractEndDate__c from Opportunity where Id=:opportunityId limit 1 ];
        System.debug('--Opportunity--'+ oppy);
        //Initialise the records to be inserted
        List<OpportunityLineItemSchedule__c> lstOpportunityProductSchedules = new List<OpportunityLineItemSchedule__c>();
        Map<Id,OpportunityLineItem> mapOpportunityProducts = new Map<Id,OpportunityLineItem>();
        Map<Integer,OpportunityLineItem> mapOppyLineItem = new Map<Integer,OpportunityLineItem>();
        Map<Integer,List<OpportunityLineItemSchedule__c>> mapOppyLineItemSchedules = new Map<Integer,List<OpportunityLineItemSchedule__c>>();
        //traverse and fetch products to query pricebookentry.
        List<Id>lstProductIds = new List<Id>();
        System.debug('--Control reached here--');
        for( Integer i=0; i<lstProductWrapper.size();i++) {
            lstProductIds.add(lstProductWrapper[i].productId);
        }
        System.debug('--lstProductIds--'+lstProductIds);
        //query pricebookentries and create a map
        List<PriceBookEntry> lstPriceBookEntries = [Select id, Product2Id from PriceBookEntry where product2Id IN:lstProductIds and isActive=true 
                                                    and Pricebook2.Name = 'Standard Price Book' and CurrencyIsoCode =:oppy.CurrencyIsoCode ];
        
        System.debug('--lstPriceBookEntries--'+ lstPriceBookEntries);
        if(lstPriceBookEntries!=null && lstPriceBookEntries.size()>0) {
            
            Map<Id,Id> mapProductPBEId = new Map<Id,Id>();
            for(PriceBookEntry pbe : lstPriceBookEntries) {
                mapProductPBEId.put(pbe.Product2Id, pbe.Id);
            }
            Integer index = 1;
            //traverse the wrapper and create OpportunityLineItem Schedule for each product schedule displayed
            for(ProductLineItemWrapper prodWrap : lstProductWrapper ) {
                
                OpportunityLineItem oli = new OpportunityLineItem();
                oli.OpportunityId = opportunityId;
                oli.PricebookEntryId = mapProductPBEId.get(prodWrap.productId);
                oli.Quantity = prodWrap.productQty;
                oli.UnitPrice = 0;
                oli.FirstYear__c = 0.0;
                oli.Status__c = 'New';//by default all products added will be set to 'New'
                oli.LicenseType__c = prodWrap.licenseType;
                
                //add a flag to determine if pro-ration needs to be done or not
                //to be uncommented for phase 1.3
                /*
                Boolean shouldProRate = false;
                if(prodWrap.productType!=null && prodWrap.productType=='Subscription' && oppy.IsProRated__c=='Yes' && oppy.ContractStartDate__c!=null && oppy.ContractEndDate__c!=null) {
                    shouldProRate = true;
                    oli.isProRated__c='Yes';
                }*/
                //process through the line item
                lstOpportunityProductSchedules = new List<OpportunityLineItemSchedule__c>();
                for(Integer i=0; i<prodWrap.lstProductsSelected.size(); i++) {
                    
                    //oli.UnitPrice = prodWrap.lstProductScheduleDisplayed[i].ListPrice__c;//sales price
                    //oli.UnitListPrice__c = prodWrap.lstProductScheduleAll[i].ListPrice__c;// list price
                    OpportunityLineItemSchedule__c olis = new OpportunityLineItemSchedule__c();
                    olis.Opportunity__c = opportunityId;
                    olis.CurrencyIsoCode = oppy.CurrencyIsoCode;
                    olis.ProductSchedule__c = prodWrap.lstProductsSelected[i].productScheduleId;
                    olis.ExternalListPrice__c = prodWrap.lstProductsSelected[i].externalListPrice;
                    olis.SalesPrice__c = prodWrap.lstProductsSelected[i].salesPrice;
                    olis.TotalPrice__c = prodWrap.lstProductsSelected[i].totalPrice;
					olis.DiscountType__c = prodWrap.discountType;
					olis.DiscountPercent__c = prodWrap.lstProductsSelected[i].discountPercent;
					olis.DiscountAmount__c = prodWrap.lstProductsSelected[i].discountAmount;
					olis.PriceBookListPrice__c = prodWrap.lstProductsSelected[i].priceBookListPrice;                    
                    olis.Product__c = prodWrap.productId;
                    olis.InstallmentYears__c =prodWrap.lstProductsSelected[i].installmentYear;
                    //olis.OpportunityProductScheduleKey__c = oppy.Name + ' - ' +  prodWrap.productName+' - ' +prodWrap.lstProductsSelected[i].InstallmentYear ;
                    olis.Quantity__c = prodWrap.productQty;
                    //olis.LicenseType__c = prodWrap.licenseType;
                    olis.Status__c = 'New';
                    //roll up values
                    //pro-rate the olis if the related product is scheduled
                    //to be uncommented for phase 1.3
                    /*
                    if(shouldProRate) {
                        olis = proRateBeforeInsert(olis, oppy, oli.Quantity);    
                    }
                    */
                    
                    lstOpportunityProductSchedules.add(olis);
                }
                mapOppyLineItem.put(index,oli);
                mapOppyLineItemSchedules.put(index,lstOpportunityProductSchedules);
                mapOpportunityProducts.put(prodWrap.productId,oli);
                index++;
            }
            Savepoint sp = Database.setSavepoint();
            try {
                if(mapOppyLineItem!=null && mapOppyLineItem.size()>0) {
                    List<OpportunityLineItemSchedule__c> listOppySchedulesToInsert = new List<OpportunityLineItemSchedule__c>();
                    insert mapOppyLineItem.values();
                    //now traverse olis and add opportunity product ids
                    for(Integer i : mapOppyLineItemSchedules.keySet()) {
                        for(OpportunityLineItemSchedule__c olis : mapOppyLineItemSchedules.get(i)) {
                            olis.OpportunityProductID__c = mapOppyLineItem.get(i).Id;
                            listOppySchedulesToInsert.add(olis);
                        }
                    }
                    insert listOppySchedulesToInsert;
                    //update legal entity on opportunity
                    if(oppy.LegalEntity__c!=legalEntity) {
                        oppy.LegalEntity__c = legalEntity;
                        update oppy;
                    }
                    
                    message = 'Records added successfully';
                }
            }catch(Exception e) {
                message = 'Error occurred while creating records :'+e.getMessage();
                Database.rollback(sp);
            }
            
        } else {
             message = 'Error occurred no pricebookentries found';
        }
       
        return message;
    }
    /**
    * @Author : Paras Dhingra
    * @date: 25th Sep 2017
    * @description : SFDC1-2043 fetch custom picklist values for licenseType
    * @company : IHS Markit
    * @param : null
    * @return : List<String>
    */
    @AuraEnabled
    public static List<String> getLicenseTypes() {
        return UtilityClass.getselectOptions(new OpportunityLineItem(), 'LicenseType__c' );
    }
    
    /**
    * @Author : Paras Dhingra
    * @date: 27th Sep 2017
    * @description : SFDC1-4353 Get converted currency for a value
    * @company : IHS Markit
    * @param : null
    * @return : Decimal
    */
     public static Decimal getConvertedCurrencyRate(String currentCurrency, String convertedCurrency, Decimal value)
        {
            
            Decimal convertedValue = value;
            if(currentCurrency != convertedCurrency && mapCurrencyType != null && !mapCurrencyType.isEmpty()) {
                if(mapCurrencyType.containsKey(currentCurrency) && mapCurrencyType.containsKey(convertedCurrency)) {				
                    convertedValue *= ((1 / mapCurrencyType.get(currentCurrency)) * (mapCurrencyType.get(convertedCurrency)));
                }
            }
        Decimal convertedValueRounded = convertedValue.setScale(2);
        System.debug('--roundedValue--'+convertedValueRounded);
        return convertedValueRounded;
    }
    //
    //@author Paras Dhingra
    //@date 30th May 2018
    //@description SFDC1-7082 Method to pro-rate schedule if the parent
    //                  opportunity is pro-rated
    //@param TriggerParameters
    //@return void
    //@companyname IHS Markit
    //
    //to be uncommented for phase 1.3
    /*
    public static OpportunityLineItemSchedule__c proRateBeforeInsert(OpportunityLineItemSchedule__c ops, Opportunity Oppy,Decimal qty) {
        //pro-rate the opportunity product scheduled is opportunity is prorate and contract start and end date are not null
        Double proRatedDays = UtilityClass.getDays360(Oppy.ContractStartDate__c, Oppy.ContractEndDate__c);
        //copy existing unit price to annualized unit price and discount
        ops.AnnualizedUnitPrice__c = ops.ExternalListPrice__c;
        ops.AnnualizedDiscountAmount__c = ops.DiscountAmount__c;
        ops.ProRatedUnitPrice__c = (ops.AnnualizedUnitPrice__c / 360) * proRatedDays;
        ops.ProRatedDiscountAmount__c = (ops.AnnualizedDiscountAmount__c / 360) * proRatedDays;
        //set precision to 2
        ops.ProRatedUnitPrice__c = ops.ProRatedUnitPrice__c.setScale(2);
        ops.ProRatedDiscountAmount__c = ops.ProRatedDiscountAmount__c.setScale(2);
        //move values from proRated to unit price
        ops.ExternalListPrice__c = ops.ProRatedUnitPrice__c;
        ops.DiscountAmount__c = ops.ProRatedDiscountAmount__c;
        ops.SalesPrice__c = (ops.ExternalListPrice__c - ops.DiscountAmount__c).setScale(2);
        ops.TotalPrice__c = (ops.SalesPrice__c * qty).setScale(2);
        return ops;
        
    }*/
    public class ProductLineItemWrapper {
        @AuraEnabled public String productName;
        @AuraEnabled public String materialCode;
        @AuraEnabled public String productId;
        @AuraEnabled public String currencyCode;
        @AuraEnabled public String recordTypeName;
        @AuraEnabled public String productTermSelected;
        @AuraEnabled public List<OpportunityLineItemScheduleWrapper> lstProductsSelected;
        @AuraEnabled public Map<String, List<OpportunityLineItemScheduleWrapper>> mapProductsAll;
        @AuraEnabled public List<String> lstMapProductIndex;
        @AuraEnabled public Integer productQty;
        @AuraEnabled public String discountType;
        @AuraEnabled public String licenseType;
        @AuraEnabled public String productType;
    }
    public class OpportunityLineItemScheduleWrapper {
        
        @AuraEnabled public Decimal priceBookListPrice;
        @AuraEnabled public Decimal externalListPrice;
        @AuraEnabled public Decimal discountPercent;
        @AuraEnabled public Decimal discountAmount;
        @AuraEnabled public Decimal salesPrice;
        @AuraEnabled public Decimal totalPrice;
        @AuraEnabled public String installmentYear;
        @AuraEnabled public String productScheduleId;
    }
    
}