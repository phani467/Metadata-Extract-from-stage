//-----------------------------
// @author: Uttam Arya
// @date: 13 April 2018
// @param: NA
// @description: Class to hold Additional Product Login Fields trigger methods 
// @return: NA
//-----------------------------
public class AdditionalProductLoginFieldsMethods { 
    
    //-----------------------------
    // @author: Uttam Arya
    // @date: 13 April 2018
    // @param: TriggerParameters tp
    // @description: SFDC1-6347 Whenever an Product Login is created, whether through an integration/data migration or manually created by a user an "Additional Product Login Fields" 
    //                          record belonging to the Product Login is automatically created and a link to the record is populated in the "Additional Product Login Fields" field. 
    //                          This function populate the Additional Fields lookup in Product Login.
    // @return: None
    //------------------------------
    public static void populateAdditionalFiledsLookupInProductLogin(TriggerParameters tp) {
        try {
            //List of Product Logins that needs to be updated    
            List <ProductLogin__c> ProductLoginsToUpdate = new List <ProductLogin__c>(); 
            
            for(AdditionalProductLoginFields__c auaf: (List <AdditionalProductLoginFields__c>) tp.newList) {
                if(auaf.ProductLogin__c != null) {
                    ProductLoginsToUpdate.add(new ProductLogin__c(Id = auaf.ProductLogin__c, AdditionalProductLoginFields__c = auaf.Id));
                }
            }
            //update if list has any records
            if(ProductLoginsToUpdate != null && ProductLoginsToUpdate.size() > 0) {
                update ProductLoginsToUpdate;
            }
        } catch(Exception ex) {
            //this will happen if any exception apart from DML exception has occurred
            UtilityClass.createApexLogRecord(ex, 'AdditionalProductLoginFieldsMethods', 'populateAdditionalFiledsLookupInProductLogin');
        }
    }
}