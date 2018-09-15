//
//@Author : Paras Dhingra
//@date: 17th Aug 2017
//@description : SFDC1-2043 product selector controller for multi-year oppys
//@modified date: 09th Mar 2017
//@modified reason: SFDC1-7092 fixing inconsistent search behavior by adding recursion and soql limit check
//@modified by: Paras Dhingra
//
public without sharing class productSearchController {
    
    //
    //@Author : Paras Dhingra
    //@date: 17th Aug 2017
    //@description : SFDC1-2043 fetch search products based on user filters
    //@company : IHS Markit
    //@param : String , List<String>, String,String, String, String,String, String, String, String
    //@return : List<ProductEditController.ProductLineItemWrapper>
    //
    @auraEnabled
    public static List<productSelectorWrapperClass> getProducts (String familyName, String productName,
                                                                 String materialNumber, String businessLine, String subBusinessLine, 
                                                                 String profitCenter, String mediaType, String internalProductName, String legalEntity, String lastMaterialCode, List<productSelectorWrapperClass> lstSearchedSoFar) {
                                                                     List<productSelectorWrapperClass> lstProductsToReturn = new List<productSelectorWrapperClass>();
                                                                     System.debug('--familyName--'+ familyName);
                                                                     List<Product2> lstProductsLegal = new List<Product2>();
                                                                     Map<Id,Product2> mapProductsLegalEntity = new Map<Id,Product2>();
                                                                     Set<Id> setLegaLEntityProductIds = new Set<Id>();
                                                                     
                                                                     String availableForSale = '04';
                                                                     String queryBase = 'Select id, name, family__c, family__r.Name, MaterialCode__c, BusinessLine2__r.name, SubBusinessLine__r.name, ProfitCenters__r.Name, InternalProductName__c, MediaType__c, LegalEntity__c from Product2 where';
                                                                     //String queryLegalFilter = ' (LegalEntity__c=:legalEntity OR ID IN: setLegaLEntityProductIds) ';
                                                                     String queryCommonFilter = ' isActive=true AND ProductStatus__r.SAPCode__c=:availableForSale';
                                                                     if(familyName!=null && !String.IsBlank(familyName)) {
                                                                         queryCommonFilter += ' AND family__r.Name like \'%'+familyName+'%\'';
                                                                     }
                                                                     if(productName!=null && !String.IsBlank(productName)) {                                                                         
                                                                         queryCommonFilter+= ' AND Name like \'%'+productName+'%\'';
                                                                     }
                                                                     if(materialNumber!=null && !String.IsBlank(materialNumber)) {
                                                                         queryCommonFilter+= ' AND  MaterialCode__c like \'%'+materialNumber+'%\'';
                                                                     }
                                                                     if(businessLine!=null && !String.IsBlank(businessLine)) {
                                                                         queryCommonFilter += ' AND BusinessLine2__r.name like \'%'+businessLine+'%\'';
                                                                     }
                                                                     if(subBusinessLine!=null && !String.IsBlank(subBusinessLine)) {
                                                                         queryCommonFilter += ' AND SubBusinessLine__r.name like \'%'+subBusinessLine+'%\'';
                                                                     }
                                                                     if(profitCenter!=null && !String.IsBlank(profitCenter)) {
                                                                         queryCommonFilter += ' AND ProfitCenters__r.name like \'%'+profitCenter+'%\'';
                                                                     }
                                                                     if(mediaType!=null && !String.IsBlank(mediaType)) {
                                                                         queryCommonFilter += ' AND MediaType__c like \'%'+mediaType+'%\'';
                                                                     }
                                                                     if(internalProductName!=null && !String.IsBlank(internalProductName)) {
                                                                         queryCommonFilter += ' AND internalProductName__c like \'%'+internalProductName+'%\'';
                                                                     }
                                                                     if(lastMaterialCode!=null && !String.IsBlank(lastMaterialCode)) {
                                                                         queryCommonFilter += ' AND MaterialCode__c > \''+lastMaterialCode+'\'';
                                                                     }
                                                                    
                                                                     String queryFinalLegal = queryBase + queryCommonFilter + ' ORDER BY MaterialCode__c ASC LIMIT 100' ;
                                                                     System.debug('--queryFinalLegal--'+ queryFinalLegal);
                                                                     //lstProductsLegal = Database.query(queryFinalLegal);
                                                                     mapProductsLegalEntity = new Map<Id,Product2>((List<Product2>)Database.query(queryFinalLegal)); 
                                                                     
                                                                     //for recursive call carry forward the already searched products
                                                                     if(lstSearchedSoFar!=null) {
                                                                         lstProductsToReturn = lstSearchedSoFar;
                                                                     }
                                                                     //check if products are extended in product extensions
                                                                     //query the product extenstions and fetch related extensions only
                                                                     if(mapProductsLegalEntity!=null && !mapProductsLegalEntity.isEmpty()) {
                                                                         for(ProductExtensions__c pe : [Select Product__c from ProductExtensions__c where LegalEntity__c =:legalEntity AND Product__r.isActive=true
                                                                                                    AND Status__c='Active' AND Product__c IN: mapProductsLegalEntity.keySet() ] ) {
                                                                         setLegaLEntityProductIds.add(pe.Product__c);
                                                                        }
                                                                         for(Product2 prod : mapProductsLegalEntity.values()) {
                                                                             productSelectorWrapperClass pswc = new productSelectorWrapperClass();
                                                                             if(prod.LegalEntity__c ==legalEntity|| setLegaLEntityProductIds.contains(prod.Id)) {                                                                              
                                                                                 pswc.isSelected = false;
                                                                                 pswc.ProductName = prod.Name;
                                                                                 pswc.productId = prod.Id;
                                                                                 pswc.product = prod;
                                                                                 lstProductsToReturn.add(pswc);
                                                                                 
                                                                                    
                                                                             }
                                                                             // the last material code added in the loop will be the marker for offset    
                                                                             if( prod.MaterialCode__c!=null) {
                                                                                 lastMaterialCode = prod.MaterialCode__c;
                                                                             }
                                                                         }
                                                                     }
                                                                     System.debug('--getQueries--'+Limits.getQueries());
                                                                     //check if queried results have been filtered out and reduced the size of return payload
                                                                     System.debug('--lstProductsToReturn.size before recursion--'+lstProductsToReturn.size());
                                                                     if(lstProductsToReturn.size()<50 && mapProductsLegalEntity!=null && mapProductsLegalEntity.size()==100 ) {
                                                                         //make a recursive call to the method only if soql limit allowance is within range
                                                                         if(Limits.getQueries()<=94) {
                                                                            lstProductsToReturn = getProducts(familyName, productName,materialNumber, businessLine, subBusinessLine,profitCenter, mediaType, internalProductName, legalEntity, lastMaterialCode,lstProductsToReturn); 
                                                                         }
                                                                         
                                                                        
                                                                     }
                                                                     System.debug('--lstProductsToReturn.size--'+lstProductsToReturn.size());
                                                                     return lstProductsToReturn;
                                                                 }
    //
    //@Author : Paras Dhingra
    //@date: 17th Aug 2017
    //@description : SFDC1-2043 fetch productIds already on opportunity
    //@company : IHS Markit
    //@param : String 
    //@return : List<String>
    //
    @auraEnabled
    public static List<String> getProductsAlreadyInOppy(String oppyId) {
        List<String> lstProductId = new List<String>();
        List<OpportunityLineItem> lstOppyProduct = [Select Product2Id from OpportunityLineItem where OpportunityId=:oppyId];
        if(lstOppyProduct!=null && !lstOppyProduct.isEmpty()) {
            for(OpportunityLineItem oli : lstOppyProduct) {
                lstProductId.add(oli.Product2Id);
            }
        }
        return lstProductId;
    }
    //
    //@Author : Paras Dhingra
    //@date: 20 Sep 2017
    //@description : SFDC1-4353 fetch list of all legal entities in the system
    //@company : IHS Markit
    //@param : String 
    //@return : List<LegalEntity__c>
    //
    @auraEnabled 
    public static OpportunityLegalEntityWrapper getAllLegalEntities(String oppyId) {
        System.debug('--OppyId--'+ oppyId);
        OpportunityLegalEntityWrapper  oleWrapObj= new OpportunityLegalEntityWrapper();
        List<LegalEntity__c> lstLegalEntity = [Select Id, Name from LegalEntity__c where Status__c='Active' order by Name asc];
        Map<String,Id> mapLegalEntityNameId = new Map<String,Id>();
        if(lstLegalEntity!=null && !lstLegalEntity.isEmpty()) {
            for(LegalEntity__c legEnt : lstLegalEntity) {
                mapLegalEntityNameId.put(legEnt.Name,legEnt.Id);
            }
        }
        List<Opportunity> lstOppy = new List<Opportunity> ();
        oleWrapObj.oppyLegalEntity = '--None--';
        if(oppyId!=null && oppyId!='') {
            lstOppy = [Select id, LegalEntity__c,Owner.LegalEntity__c, (Select id from opportunityLineItems) from Opportunity where id=:oppyId];
            if(lstOppy!=null && !lstOppy.isEmpty() ) {
                if(lstOppy[0].LegalEntity__c!=null) {
                    
                    oleWrapObj.oppyLegalEntity = lstOppy[0].LegalEntity__c;    
                }
                else if(lstOppy[0].Owner.LegalEntity__c!=null && lstOppy[0].Owner.LegalEntity__c!='' && mapLegalEntityNameId.containsKey(lstOppy[0].Owner.LegalEntity__c)) {
                    
                    oleWrapObj.oppyLegalEntity = mapLegalEntityNameId.get(lstOppy[0].Owner.LegalEntity__c);
                    System.debug('--oleWrapObj.oppyLegalEntity--'+oleWrapObj.oppyLegalEntity);
                }
                
            }
        }
       
        
        oleWrapObj.lstLegalEntity = lstLegalEntity;
        return oleWrapObj;
    }
    //
    //@Author : Paras Dhingra
    //@date: 21 Sep 2017
    //@description : SFDC1-4353 delete related oppy products and oppy product schedules
    //@company : IHS Markit
    //@param : String
    //@return : String
    //
    @auraEnabled public static  String deleteProductsOnOppy (String oppyId, String newLegalEntity) {
        
        String message = '';
        Savepoint sp = Database.setSavepoint();
        try {
            GlobalConstants.hasAllowedOpportunityProductDeletion = true;
            List<Opportunity> lstOppy = [Select Id, LegalEntity__c, (Select Id, Product2.LegalEntity__c, Product2Id from OpportunityLineItems where Status__c='New') 
                                            from Opportunity where Id=:oppyId];
            
            if(lstOppy!=null && !lstOppy.isEmpty()) {
                Opportunity oppy = new Opportunity(id=lstOppy[0].Id);
                oppy.LegalEntity__c = newLegalEntity!=null?newLegalEntity:null;
                update oppy;
                
                if(lstOppy[0].OpportunityLineItems!=null && !lstOppy[0].OpportunityLineItems.isEmpty()) {
                    //collate product ids
                    Set<Id> setOppyProductIdsToDel = new Set<Id>();
                    Set<Id> setValidProducts = new Set<Id>();
                    for(OpportunityLineItem oli : lstOppy[0].OpportunityLineItems) {
                        setOppyProductIdsToDel.add(oli.Product2Id);
                        if(oli.Product2.LegalEntity__c == newLegalEntity) {
                            setValidProducts.add(oli.Product2Id);
                        }
                        
                    }
                    //query product extensions which are related to new legal entity
                    List<ProductExtensions__c> lstProductExtension = [Select Product__c from ProductExtensions__c where LegalEntity__c=:newLegalEntity
                                                                        and Product__c IN:setOppyProductIdsToDel ];
                    if(lstProductExtension!=null && !lstProductExtension.isEmpty()) {
                        for(ProductExtensions__c prodEx : lstProductExtension) {
                            setValidProducts.add(prodEx.Product__c);
                        }
                    }
                    if(setValidProducts!=null && !setValidProducts.isEmpty()) {
                        //remove valid products from the list
                        setOppyProductIdsToDel.removeAll(setValidProducts);
                    }
                    //check if deletion list still has products 
                    if(setOppyProductIdsToDel!=null && !setOppyProductIdsToDel.isEmpty()) {
                        //create a list of opportunity line items to delete
                        List<OpportunityLineItem> lstOppyLineItemToDelete = new List<OpportunityLineItem>();
                        for(OpportunityLineItem oli : lstOppy[0].OpportunityLineItems) {
                            if(setOppyProductIdsToDel.contains(oli.Product2Id)) {
                                lstOppyLineItemToDelete.add(oli);
                            }
                        }
                        if(lstOppyLineItemToDelete!=null && !lstOppyLineItemToDelete.isEmpty()) {
                            delete lstOppyLineItemToDelete;
                        }
                    }
                }
            }
            message = 'Related products updated!!';
            GlobalConstants.hasAllowedOpportunityProductDeletion = false;
        }
        catch(Exception ex) {
            System.debug('Exception caught in deleteProductsOnOppy');
            message = 'Error Occurred ' +ex; 
            Database.rollback(sp);
        }
        return message;
    }
    
    //
    //@Author : Paras Dhingra
    //@date: 21 Sep 2017
    //@description : SFDC1-4353 Wrapper class for Opportunity legal entity
    //@company : IHS Markit
    //
    public class OpportunityLegalEntityWrapper {
        @auraEnabled public string oppyLegalEntity;
        @auraEnabled public List<LegalEntity__c> lstLegalEntity;
    }
}