//
//@Author Paras Dhingra
//@Date 15th Sep 2017
//@Description SFDC1-4275 Trigger helper method class for OpportunityLineItemSchedule object 
//@company IHS Markit
//
public class OpportunityLineItemScheduleMethods {
    
    //
    //@author Paras Dhingra
    //@date 15th Sep 2017
    //@description SFDC1-4275 Method to rollup values from 
    //            Oppy product schedules to Oppy products
    //@param TriggerParameters
    //@return void
    //@companyname IHS Markit
    //
    public static void rollUpValuesToOppyProduct(TriggerParameters tp) {
        try {
            System.debug('Control Reached rollUpValuesToOppyProduct');
            Map<Id,OpportunityLineItemSchedule__c> mapOPSModified = new  Map<Id,OpportunityLineItemSchedule__c>();
        
            if(tp.tEvent == TriggerParameters.TriggerEvent.afterInsert ||
                tp.tEvent == TriggerParameters.TriggerEvent.afterUpdate) {
                    mapOPSModified = (Map<Id,OpportunityLineItemSchedule__c>)tp.newMap;
            }
            if(tp.tEvent == TriggerParameters.TriggerEvent.afterDelete) {
                
                mapOPSModified = (Map<Id,OpportunityLineItemSchedule__c>)tp.oldMap;
            }
            if(mapOPSModified!=null && !mapOPSModified.isEmpty()) {
                //traverse the map and extract opportunity product id
                Set<Id> setOppyProductId = new Set<Id>();
                for(OpportunityLineItemSchedule__c ops: mapOPSModified.values()) {
                    setOppyProductId.add(ops.OpportunityProductId__c);
                }
                if(setOppyProductId!=null && !setOppyProductId.isEmpty()) {
                    //query Opportunity prodcut which was to be updated
                    Map<Id, OpportunityLineItem> mapOppyProductId = new Map<Id, OpportunityLineItem>([Select id, DiscountPercentage__c, Discount_Amount__c, DiscountType__c,OpportunityId,FirstYear__c,
                                                                ListPrice__c,Quantity,UnitListPrice__c,UnitPrice, PricebookEntry.Product2.DiscountThreshold__c,LicenseType__c,
                                                                DiscountOverThreshold__c,Status__c, ActiveInactiveNetUnitPrice__c,AnnualizedUnitPrice__c, AnnualizedDiscountAmount__c,
                                                                    ProRatedUnitPrice__c, ProRatedDiscountAmount__c From OpportunityLineItem 
                                                                where Id IN: setOppyProductId]);
                    //query all OpportunityLinetITemSchedule related to Opportunity Products
                    //Cannot use inner query as there is no direct relation exists between the two Oppy product and Oppy product schedules
                    List<OpportunityLineItemSchedule__c> lstOPS = [Select id, DiscountPercent__c, DiscountAmount__c, DiscountType__c, ExternalListPrice__c,
                                                                    InstallmentYears__c, OpportunityProductId__c, PriceBookListPrice__c, Quantity__c, SalesPrice__c,
                                                                    TotalPrice__c,Status__c, AnnualizedUnitPrice__c, AnnualizedDiscountAmount__c,
                                                                    ProRatedUnitPrice__c, ProRatedDiscountAmount__c from OpportunityLineItemSchedule__c where OpportunityProductID__c IN:setOppyProductId
                                                                    order by InstallmentYears__c ASC];
                     System.debug('--lstOPS--' + lstOPS);
                     System.debug('--mapOppyProductId--' + mapOppyProductId);
                     if(lstOPS!=null && !lstOps.isEmpty() && mapOppyProductId!=null && !mapOppyProductId.isEmpty()) {
                         System.debug('--inside if--');
                         //create a map of Opportunity ID it's OppyProducts
                         Map<Id, List<OpportunityLineItemSchedule__c>> mapOppyProdAndScheds = new Map<Id, List<OpportunityLineItemSchedule__c>>();
                         List<OpportunityLineItem> lstOLIToUpdate = new List<OpportunityLineItem>();
                         for(OpportunityLineItemSchedule__c ops : lstOPS) {
                             if(mapOppyProdAndScheds.containskey(ops.OpportunityProductId__c)) {
                                 mapOppyProdAndScheds.get(ops.OpportunityProductId__c).add(ops);
                             }
                             else {
                                 List<OpportunityLineItemSchedule__c> tempLstOps = new List<OpportunityLineItemSchedule__c>();
                                 tempLstOps.add(ops);
                                 mapOppyProdAndScheds.put(ops.OpportunityProductId__c, tempLstOps);
                             }
                         }
                         System.debug('--mapOppyProdAndScheds--' + mapOppyProdAndScheds);
                         //process the map and update OpportunityProducts
                         
                         for( OpportunityLineItem oli : mapOppyProductId.values()) {
                             
                             List<OpportunityLineItemSchedule__c> lstCurrentOliScheds = new List<OpportunityLineItemSchedule__c>();
                             lstCurrentOliScheds = mapOppyProdAndScheds.get(oli.Id);
                             //reset all values
                             oli.DiscountPercentage__c = 0.0;
                             oli.Discount_Amount__c = 0.0;
                             oli.DiscountType__c = 'No Discount';
                             oli.FirstYear__c = 0.0; // First Year Total Price
                             if(lstCurrentOliScheds!=null && lstCurrentOliScheds.size()>0) {
                                 oli.FirstYear__c = lstCurrentOliScheds[0].TotalPrice__c;
                                 oli.Status__c = lstCurrentOliScheds[0].Status__c;
                                 oli.Quantity = lstCurrentOliScheds[0].Quantity__c;// Always fetch Quantity from Opportunity Line Item Schedule
                                 oli.DiscountType__c = lstCurrentOliScheds[0].DiscountType__c;
                                 oli.ListPrice__c = lstCurrentOliScheds[0].PriceBookListPrice__c; //Price book List Price first year
                                 //oli.LicenseType__c = lstCurrentOliScheds[0].LicenseType__c;// LicenseType__c copied from Opportunity Line item schedule
                                 
                             }
                             oli.UnitListPrice__c = 0.0; //Total external list price
                             oli.UnitPrice = 0.0;//Total Sales Price
                             //traverse the opportunity line item children
                             oli.AnnualizedUnitPrice__c = 0.0;
                             oli.AnnualizedDiscountAmount__c = 0.0;
                             oli.ProRatedUnitPrice__c = 0.0;
                             oli.ProRatedDiscountAmount__c = 0.0;
                             for( OpportunityLineItemSchedule__c ops : lstCurrentOliScheds) {
                                  oli.Discount_Amount__c += ops.DiscountAmount__c==null?0:ops.DiscountAmount__c;
                                 oli.DiscountPercentage__c+=ops.DiscountPercent__c==null?0:ops.DiscountPercent__c;
                                 oli.UnitListPrice__c+=ops.ExternalListPrice__c==null?0:ops.ExternalListPrice__c;
                                 oli.UnitPrice +=ops.SalesPrice__c==null?0:ops.SalesPrice__c;
                                 oli.ActiveInactiveNetUnitPrice__c = oli.UnitPrice==null?0:oli.UnitPrice;
                                 oli.AnnualizedUnitPrice__c += ops.AnnualizedUnitPrice__c==null?0:ops.AnnualizedUnitPrice__c;
                                 oli.AnnualizedDiscountAmount__c += ops.AnnualizedDiscountAmount__c==null?0:ops.AnnualizedDiscountAmount__c;
                                 oli.ProRatedUnitPrice__c += ops.ProRatedUnitPrice__c==null?0:ops.ProRatedUnitPrice__c;
                                 oli.ProRatedDiscountAmount__c += ops.ProRatedDiscountAmount__c==null?0:ops.ProRatedDiscountAmount__c;
                             }
                             if(oli.Status__c=='Lost') {
                                 oli.UnitPrice=0;
                             }
                             oli.DiscountPercentage__c = oli.DiscountPercentage__c/(lstCurrentOliScheds.size());
                             oli.DiscountOverThreshold__c = oli.DiscountPercentage__c>oli.PricebookEntry.Product2.DiscountThreshold__c?true:false;
                             lstOLIToUpdate.add(oli);
                         }
                         //update Opportunity Line Items
                         if(lstOLIToUpdate!=null && !lstOLIToUpdate.isEmpty()) {
                             update lstOLIToUpdate;
                         }
                     }
                    
                }
            }
            
        } catch(Exception ex) {
            System.debug('Exception caught' + ex);
            UtilityClass.createApexLogRecord(ex, 'OpportunityLineItemScheduleMethods', 'rollUpValuesToOppyProduct');
            throw new GenericCustomException('Error occurred. Please contact salesforce helpdesk for assistance');

        }

        
    }
    //
    //@author Paras Dhingra
    //@date 11th Jul 2018
    //@description SFDC1-9058 Method to populate annualized values
    //@param TriggerParameters tp
    //@return void
    //@companyname IHS Markit
    //
    public static void populateAnnualizedValues(TriggerParameters tp) {
        try {
            //traverse oppy schedules and copy values to annualized fields
            for(OpportunityLineItemSchedule__c olis : (List<OpportunityLineItemSchedule__c>)tp.newList) {
                olis.AnnualizedUnitPrice__c = olis.ExternalListPrice__c;
                olis.AnnualizedDiscountAmount__c = olis.DiscountAmount__c;
            }
        }
        catch(Exception ex) {
            UtilityClass.createApexLogRecord(ex, 'OpportunityLineItemScheduleMethods', 'populateAnnualizedValues');
        }
    }

}