//------------------------------------------------
// @author: Vertiba
// @company: VERTIBA
// @date: 13 Dec 2017
// @param: ApexPages.StandardController
// @description:  SFDC1-5326 -Opportunity Behavior - when a Future Disconnect Product is on the Oppy.
// @return: 
// @Last Updated: Anjani Shukla: SFDC1-8147-Product - New Cross Plant status = 'Renewal Only' SAP Code = '09' for 
//                               only renewal type opportunities.
//------------------------------------------------
public class WarningMsgProductCrossPlantStatus {
    
    
    public static List<String> errorMsgRecord = new List<String>();
    
	//------------------------------------------------
	// @author: Vertiba
	// @company: VERTIBA
	// @date: 13 Dec 2017
	// @description:  This method will get opprotunity product details which needs to be inactivated.
	// @Last Updated: 
	//------------------------------------------------ 
	@auraenabled
    public static List<String> getOptyProdLineDetails(Id oppRecordId) {
        //variables
        boolean flagtoshowMsg= false;
    	List<Id> productAssocWdOptyLnLst = new List<Id>();
        List<OpportunityLineItem> optyProdLineDetailsLst = new List<OpportunityLineItem>();
        List<Product2> product2DetailsLst = new List<Product2>();
        //errorMsgRecord = new Map<String,String>();
        //errorMsgRecord = new List<String>();
        
        // query 
        optyProdLineDetailsLst = [select id,name,Product2Id,ProductCode,Product2.Name,Opportunity.OpportunityRecordType__c,Status__c 
                                   from OpportunityLineItem where Opportunityid =: oppRecordId];
        
		//capture product2 id details from opportunity line item (opportunity product)
        if(optyProdLineDetailsLst.size() > 0) {
            for(OpportunityLineItem objOptyLineItem: optyProdLineDetailsLst) {
             	productAssocWdOptyLnLst.add(objOptyLineItem.Product2Id);	   
            }    
        }
        
        //get Product and Cross plant status.
        if(productAssocWdOptyLnLst.size() > 0) {
        	product2DetailsLst = [SELECT id,name,ProductStatus__r.name,ProductStatus__r.SAPCode__c FROM Product2 
                                  where id in: productAssocWdOptyLnLst];
        }
        
        //------------------------------------------------
		// @author: Vertiba
		// @company: VERTIBA
		// @date: 13 Dec 2017
		// @description: check whether we have cross plant status is not "Available for Sale" and SapCode not equals 04
        // 				 check for product and opportunity product.	
        // @modification: Anjani Shukla:SFDC1-8147-Product - New Cross Plant status and availability functionaliy				 	
		//------------------------------------------------ 
		
        if(optyProdLineDetailsLst.size() > 0 && product2DetailsLst.size() > 0) {
            for(OpportunityLineItem objOptyLineItem: optyProdLineDetailsLst) {
                for( Product2 objProd: product2DetailsLst ) {
                    system.debug('objOptyLineItem.Product2Id-->'+objOptyLineItem.Product2Id);
                    system.debug('objProd.id-->'+objProd.id);
					if(objOptyLineItem.Product2Id == objProd.id) {
                        /*if(objProd.ProductStatus__r.name != 'Available for Sale' && objProd.ProductStatus__r.SAPCode__c != '04') {
                        //errorMsgRecord.put(objOptyLineItem.name,objProd.name);
                        	errorMsgRecord.add(objOptyLineItem.Product2.Name);
                        } */
                        //SFDC1-8147-Product - New Cross Plant status and availability functionaliy
                        if((objOptyLineItem.Opportunity.OpportunityRecordType__c == 'Renewal'    || 
                            objOptyLineItem.Opportunity.OpportunityRecordType__c == 'InnerYear') && 
                           ((objProd.ProductStatus__r.name != 'Renewal Only' && objProd.ProductStatus__r.SAPCode__c != '09') && 
                            ( objProd.ProductStatus__r.name != 'Available for Sale' && objProd.ProductStatus__r.SAPCode__c != '04')) &&
                             objOptyLineItem.Status__c != 'Lost') 
                            { 
                        	   errorMsgRecord.add(objOptyLineItem.Product2.Name);
                        }
                        
                        //SFDC1-8147-Product - New Cross Plant status and availability functionaliy
                        
                        if((objOptyLineItem.Opportunity.OpportunityRecordType__c == 'New Business' || 
                            objOptyLineItem.Opportunity.OpportunityRecordType__c == 'Gratis' || 
                            objOptyLineItem.Opportunity.OpportunityRecordType__c == 'Forecasting Placeholder') &&
                           (objProd.ProductStatus__r.name != 'Available for Sale') && 
                           (objProd.ProductStatus__r.SAPCode__c != '04')) {
                        	    errorMsgRecord.add(objOptyLineItem.Product2.Name);
                        }
                    }    
                }            
            }
        }
        
        if(!errorMsgRecord.isEmpty()) {
        	flagtoshowMsg = true;    
        } 
		else {
            flagtoshowMsg = false;
        }
        system.debug('flagtoshowMsg'+flagtoshowMsg);
        return errorMsgRecord;
    }    
}