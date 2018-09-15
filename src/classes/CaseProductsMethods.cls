/**
* @author: Vishnu vardhan Chowdary Andra
* @date: 26 September 2017
* @description: SFDC1-593. After insert dispatcher event handler class that calls the functions in CaseProductsMethods.
* @companyname: VERTIBA
*/
public class CaseProductsMethods {

    /** 
    * @author: Vishnu vardhan Chowdary Andra
    * @date: 26 September 2017
    * @description: SFDC1-593. When a CaseProducts object is created/updated verify that same case and 
	* 		Product record is not there in database. If exists then dont allow the insert.
    * @param: TriggerParameters Contains the trigger parameters which includes the record(s) that got created.
    * @companyname: VERTIBA
    * @return: void
    * 
    * @author: Vishnu vardhan Chowdary Andra
    * @date: 3 November 2017
    * @description: SFDC1-593. Updating try catch block
    * 
    * @author: Vishnu vardhan Chowdary Andra
    * @date: 23 April 2018
    * @description: SFDC1-7599. Earlier, this object was plain junction object, and there were no other fields.
    * 				Now, we are adding few more fields to this object, so adding condition, such that when 
    * 				other fields are changed, this method doesnt need to execute. 
    * @author: Vishnu vardhan Chowdary Andra
    * @date: 27 June 2018
    * @description: SFDC1-8397. Products were checked to be unique for a case, now it has to be unique along with 
	* 			Product group and product family.
    */
    public static void validateIfCaseProductAlreadyExist(TriggerParameters tp) {
        try {
            if(tp.tEvent == TriggerParameters.TriggerEvent.beforeInsert ||
               tp.tEvent == TriggerParameters.TriggerEvent.beforeUpdate) {
                   //1. Collect all the caseId's(parent id) from the case Product and get records from database
                   Set<id> caseIds = new Set<id>();
                   List<CaseProducts__c> listCaseProducts = (List<CaseProducts__c>) tp.newList;
                   Map<Id,CaseProducts__c> mapOldCaseProducts = (Map<Id,CaseProducts__c>)tp.oldMap;
                   
                   for(CaseProducts__c caseProduct : listCaseProducts) {
                       CaseProducts__c oldCaseProducts = new CaseProducts__c();
                       if(tp.tEvent == TriggerParameters.TriggerEvent.beforeUpdate) {
                           oldCaseProducts = mapOldCaseProducts.get(caseProduct.Id);
                       }
                       if(caseProduct.Product__c != oldCaseProducts.Product__c ||
                          caseProduct.ProductFamily__c != oldCaseProducts.ProductFamily__c ||
                          caseProduct.productGroup__c != oldCaseProducts.productGroup__c ||
                          caseProduct.Case__c != oldCaseProducts.Case__c) {
                              caseIds.add(caseProduct.Case__c);
                          }
                   }
                   System.debug('Get Cases for verification:'+caseIds);
                   if(caseIds.isEmpty()) {
                       return;
                   }
                   Map<id,List<CaseProducts__c>> existingCaseProductMap = new Map<id, List<CaseProducts__c>>();
                   //Creating a map so that it is easy to search
                   for(CaseProducts__c caseProduct : 
                       [select Case__c, Product__C, ProductFamily__c, productGroup__c, id from CaseProducts__c where case__c in :caseIds]) {
                            if(!existingCaseProductMap.containsKey(caseProduct.Case__c)) {
                                existingCaseProductMap.put(caseProduct.Case__c, new List<CaseProducts__c>());
                            }
                            existingCaseProductMap.get(caseProduct.case__c).add(caseProduct);
                        }
                   System.debug('Case and Product map:'+existingCaseProductMap);
                   //2. verify from the records if the record is already present.
                   for(CaseProducts__c caseProduct : listCaseProducts) {
                       if(existingCaseProductMap.containsKey(caseProduct.Case__c)) {
                           //One or more than one Products are there for this case.
                           List<CaseProducts__c> caseProds = existingCaseProductMap.get(caseProduct.Case__c);
                           for(CaseProducts__c caseProd : caseProds) {
                               //Case Products, product, family, group should be same 
                               //but id should not be same for raising error
                               if(caseProd.Product__C == caseProduct.Product__C && 
                                  caseProd.ProductFamily__C == caseProduct.ProductFamily__C && 
                                  caseProd.ProductGroup__C == caseProduct.ProductGroup__C && 
                                  caseProduct.id != caseProd.id) {
                                      caseProduct.addError(System.Label.CaseProductDuplicateCheck);
                                  }
                           }
                       }
                   }
               }
        } catch (Exception e) {
            UtilityClass.createApexLogRecord(e,'CaseProductsMethods','validateIfCaseProductAlreadyExist');
        }
    } 
    
    //------------------------------------------------------
    // @author: Vishnu vardhan Chowdary Andra
    // @date: 23 April 2018
    // @param: TriggerParameters Contains the trigger parameters which includes the record(s) that got created.
    // @return: void
    // @description: SFDC1-7599. When product is selected in the case products, then populate, overwrite the 
    // 			product group and product family. If product family is selected then populate product group.
    //------------------------------------------------------
    public static void populateProductRelatedValues(TriggerParameters tp) {
        try {
            if(tp.tEvent == TriggerParameters.TriggerEvent.beforeInsert ||
                tp.tEvent == TriggerParameters.TriggerEvent.beforeUpdate) {
                    List<CaseProducts__c> listCaseProducts = (List<CaseProducts__c>) tp.newList;
                    Map<Id,CaseProducts__c> mapOldCaseProducts = (Map<Id,CaseProducts__c>)tp.oldMap;
                    Set<id> productFamilyIds = new Set<id>();
                    Set<id> productIds = new Set<id>();
                    
                    for(CaseProducts__c caseProduct : listCaseProducts ) {
                        CaseProducts__c oldCaseProducts = new CaseProducts__c();
                        if(tp.tEvent == TriggerParameters.TriggerEvent.beforeUpdate) {
                            oldCaseProducts = mapOldCaseProducts.get(caseProduct.Id);
                        }
                        if(caseProduct.Product__c != oldCaseProducts.Product__c ||
                           caseProduct.ProductFamily__c != oldCaseProducts.ProductFamily__c  ||
                           caseProduct.productGroup__c != oldCaseProducts.ProductGroup__c) {
                               //Though product group is not required, checking it because in case, user edits with
                               //Worn product value then it has to be removed and correct value to be populated.
                               if(caseProduct.Product__c != null) {
                                   productIds.add(caseProduct.Product__c);
                               }
                               if(caseProduct.ProductFamily__c != null) {
                                   productFamilyIds.add(caseProduct.ProductFamily__c);
                               }
                        }
                    }
                    if(productFamilyIds.isEmpty() && productIds.isEmpty()) {
                        return;
                    }
                    Map<id,Family__c> productFamiliesMap = new Map<Id, Family__c>(
                        [Select id, ProductGroup__c from Family__c where id in :productFamilyIds]);
                    Map<id,Product2> productsMap = new Map<Id, Product2>(
                        [Select id, Family__c, ProductGroup__c from Product2 where id in :productIds]);
                    for(CaseProducts__c newCaseProduct: listCaseProducts) {
                        //Product will take higher precedence in overwriting over product family
                        if(newCaseProduct.Product__c != null && productsMap.get(newCaseProduct.Product__c) != null) {
                            Product2 prd = productsMap.get(newCaseProduct.Product__c);
                            newCaseProduct.ProductFamily__c = prd.Family__c;
                            newCaseProduct.ProductGroup__c = prd.ProductGroup__c;
                        } else if(newCaseProduct.ProductFamily__c != null && productFamiliesMap.get(newCaseProduct.ProductFamily__c) != null) {
                            newCaseProduct.ProductGroup__c = productFamiliesMap.get(newCaseProduct.ProductFamily__c).ProductGroup__c;
                        }
                    }
            }
        } catch (Exception e) {
            UtilityClass.createApexLogRecord(e,'CaseProductsMethods','populateProductRelatedValues');
        }
    }
    
    //------------------------------------------------------
    // @author: Vishnu vardhan Chowdary Andra
    // @date: 23 April 2018
    // @param: TriggerParameters Contains the trigger parameters which includes the record(s) that got created.
    // @return: void
    // @description: SFDC1-7599. Either, product group, product family or product has to be populated.
    // 				Else throw validation error.
    //------------------------------------------------------
    public static void validateForMandatoryValues(TriggerParameters tp) {
        if(tp.tEvent == TriggerParameters.TriggerEvent.beforeInsert ||
           tp.tEvent == TriggerParameters.TriggerEvent.beforeUpdate) {
               List<CaseProducts__c> listCaseProducts = (List<CaseProducts__c>) tp.newList;
               for(CaseProducts__c caseProduct : listCaseProducts ) {
                   if(caseProduct.Product__c == null && 
                      caseProduct.ProductFamily__c == null && 
                      caseProduct.ProductGroup__c == null) {
                          caseProduct.addError(System.Label.CaseProductMandatoryCheck);
                      }
               }
           }
    }
}