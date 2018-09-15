//
//@Author : Paras Dhingra
//@Date : 15th Sep 2017
//@Description : SFDC1-4275 Trigger helper method class for OpportunityLineItem object 
//@company : IHS Markit
// @Last Modified By: Sruti Srivastava
// @Last Modified Date: 10th April 2018
// @Last Modified Description: SFDC1-7027- Added method populateContractStartDateAndEndDate which 
// populate Contract Start Date and End Date on Opportunity Line Items form Opportunity
// @Modification : SFDC1-8161: Modified exception handling by showing customized error message
// @Modified by : Sruti Srivastava
// @Last Modified Date: 8th May 2018
//@modified : Paras Dhingra
//@modified date : 20-Jun-2018
//@modified description: SFDC1-8222 Product schedule update on change of contract start date and end date
//
public class OpportunityLineItemMethods {
	//
	//@author : Paras Dhingra
	//@date : 15th Sep 2017
	//@description : SFDC1-4275 Method to rollup values from Oppy products to Opportunity
	//@param : TriggerParameters
	//@return : void
	//@companyname : IHS Markit
	// @Modification : SFDC1-8161: Modified exception handling, showing customized error message
	// @Modified by : Sruti Srivastava
	// @Last Modified Date: 8th May 2018
	//
	public static void rollupValuesToOpportunity(TriggerParameters tp) {
		try {
			Set<Id> setOppyID = new Set<Id>();
			List<OpportunityLineItem> lstOLIUpdated = new List<OpportunityLineItem>();
			
			System.debug('--Rolling up Opportunity--');
			if(tp.tEvent == TriggerParameters.TriggerEvent.afterInsert ||
			tp.tEvent == TriggerParameters.TriggerEvent.afterUpdate) {
				lstOLIUpdated = tp.newList;
			}
			if(tp.tEvent == TriggerParameters.TriggerEvent.afterDelete) { 
				lstOLIUpdated = tp.oldList;
			}
			for(OpportunityLineItem oli : lstOLIUpdated) {
				setOppyID.add(oli.OpportunityId);
			}
			//Query Opportunity Ids for which Query was updated.
			List<Opportunity> lstOppyToUpdate = [Select id, AverageDiscountPercentage__c,FirstYearValue__c, DiscountOverThreshold__c, MultiYear__c,
												(select Id, FirstYear__c, DiscountPercentage__c, DiscountOverThreshold__c,IsProRated__c 
												from OpportunityLineItems where Status__c!='Lost' ),
												(select id from OpportunityProductSchedules__r where Status__c!='Lost' )
												from Opportunity where ID IN:setOppyID];
												
			System.debug('--lstOppyToUpdate--'+lstOppyToUpdate);
			
			if(lstOppyToUpdate!=null && !lstOppyToUpdate.isEmpty()) {
				List<Opportunity> lstOpportunityToBeUpdated = new List<Opportunity>();
				
				for(Opportunity oppy : lstOppyToUpdate) {
					Opportunity oppyToUpdate = new Opportunity(Id=oppy.Id);
					oppyToUpdate.AverageDiscountPercentage__c = 0.0;
					oppyToUpdate.FirstYearValue__c = 0.0;
					oppyToUpdate.DiscountOverThreshold__c = false;
					oppyToUpdate.MultiYear__c = false;
					oppyToUpdate.IsProRated__c='No';
					if(oppy.OpportunityProductSchedules__r.size()> oppy.OpportunityLineItems.size()) {
						oppyToUpdate.MultiYear__c = true;
					}
					for(OpportunityLineItem oli: oppy.OpportunityLineItems) {
						if(oli.FirstYear__c!=null) {
							oppyToUpdate.FirstYearValue__c += oli.FirstYear__c;
						}                          

						if(oli.DiscountPercentage__c!=null) {
							oppyToUpdate.AverageDiscountPercentage__c += oli.DiscountPercentage__c;
						}

						if(oli.DiscountOverThreshold__c) {
							oppyToUpdate.DiscountOverThreshold__c = true;
						}
						if(oli.IsProRated__c=='Yes') {
						    oppyToUpdate.IsProRated__c = 'Yes';
						}
					}
					if(oppyToUpdate.AverageDiscountPercentage__c>0) {
						oppyToUpdate.AverageDiscountPercentage__c = oppyToUpdate.AverageDiscountPercentage__c/(oppy.OpportunityLineItems.size());
					}
					lstOpportunityToBeUpdated.add(oppyToUpdate);
				}
				if(lstOpportunityToBeUpdated!=null && !lstOpportunityToBeUpdated.isEmpty()) {
				    //prevent validations from rollup
				    GlobalConstants.hasTriggeredFromOpportunityProduct = true;
					update lstOpportunityToBeUpdated;
				}
			}
		}
		catch(Exception ex) {
			System.debug('Exception caught' + ex);
			UtilityClass.createApexLogRecord(ex, 'OpportunityLineItemMethods', 'rollupValuesToOpportunity');
			String errMessage = ex.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION')? 
									ex.getMessage().substringAfterLast('FIELD_CUSTOM_VALIDATION_EXCEPTION,'):ex.getMessage();
			tp.newList[0].addError('Error: '+errMessage);
			//throw new GenericCustomException('Error occurred. Please contact salesforce helpdesk for assistance', ex);
		}
	}
      //
      //@author : Paras Dhingra
      //@date : 14th Dec 2017
      //@description : SFDC1-5432 Clear all related Opportunity Line Item schedule after delete 
      //@param : TriggerParameters
      //@return : void
      //@companyname : IHS Markit
      //
      public static void deleteChildOpportunityLineItemSchedules(TriggerParameters tp) {
         try {
             Set<Id> setOLIIds = new Set<Id>();
             List<OpportunityLineItem> lstOLIDeleted = new List<OpportunityLineItem>();
             if(tp.tEvent == TriggerParameters.TriggerEvent.afterDelete) { 
                    lstOLIDeleted = tp.oldList;
                   for(OpportunityLineItem oli : lstOLIDeleted) {
                        setOLIIds.add(oli.Id);
                    }
                    if(setOLIIds!=null && !setOLIIds.isEmpty()) {
                        //query Opportunity line item schedules
                        List<OpportunityLineItemSchedule__c> listOLIs = [Select id from OpportunityLineItemSchedule__c 
                                                                        where OpportunityProductID__c IN:setOLIIds];
                        if(listOLIs!=null && !listOLIs.isEmpty()) {
                            delete listOLIs;
                        }
                    }
                }
             
          }
          catch(Exception ex) {
            System.debug('Exception caught' + ex);
            UtilityClass.createApexLogRecord(ex, 'OpportunityLineItemMethods', 'deleteChildOpportunityLineItemSchedules');
            throw new GenericCustomException('Error occurred. Please contact salesforce helpdesk for assistance');
          }
      }
    //-----------------------------
    // @author: Sruti Srivastava
    // @date: 9th April 2018
    // @param: TriggerParameters
    // @description: SFDC1-7027 - populate Contract Start Date and End Date on Opportunity Line Items form Opportunity
    // This method will be called in before insert trigger Events.
    // @return: None
    //------------------------------
    public static void populateContractStartDateAndEndDate(TriggerParameters tp) {
        
        Map<Id, Opportunity> mapOpportunity = new Map<Id, Opportunity>();
        List<OpportunityLineItem> listNewOpportunityLineItem = (List<OpportunityLineItem>)tp.newList;
        Set<Id> setOpportunityIds = new Set<Id>();
        //Method should run on before insert
		if(tp.tEvent == TriggerParameters.TriggerEvent.beforeInsert) {
        	try {
            	// Add all related opportunity to a set
                for(OpportunityLineItem newOLI : listNewOpportunityLineItem) {
					setOpportunityIds.add(newOLI.OpportunityId);
				}
                
                //If Contract Start Date or End Date on Opportunity have been populated, populate values on Opportunity Products too
                if(!setOpportunityIds.isEmpty()) {
                    // Querying related Opportunities
                    for(Opportunity opp : [Select Id, ContractStartDate__c, ContractEndDate__c
                                                   from Opportunity
                                                   where Id IN: setOpportunityIds ]) {
                        if(opp.ContractEndDate__c !=  null ||
                           opp.ContractStartDate__c !=  null) {                                         
                                mapOpportunity.put(opp.Id, opp );
                           }
                    }
                }
                if(!listNewOpportunityLineItem.isEmpty()) {
                    for(OpportunityLineItem newOLI : listNewOpportunityLineItem) {
                        if(mapOpportunity != null && mapOpportunity.containsKey(newOLI.OpportunityId)) {
                            Opportunity opp = mapOpportunity.get(newOLI.OpportunityId);
                            newOLI.ContractStartDate__c = opp.ContractStartDate__c;
                            newOLI.ContractEndDate__c = opp.ContractEndDate__c;
                        }
                        else {
                            newOLI.ContractStartDate__c = null;
                            newOLI.ContractEndDate__c = null;
                        }
                    }
                }
            }
            catch(Exception e) {
                UtilityClass.createApexLogRecord(e, 'OpportunityLineItemMethods', 'populateContractStartDateAndEndDate');
            }
        }
    }
	//
	//@author : Paras Dhingra
	//@date : 10th Apr 2018
	//@description : SFDC1-7525 Rollup profit center, product family, and former Ip to Opportunity level 
	//@param : TriggerParameters
	//@return : void
	//@companyname : IHS Markit
	// @Modification : SFDC1-8161: Modified exception handling, showing customized error message
	// @Modified by : Sruti Srivastava
	// @Last Modified Date: 8th May 2018
	// @Modification : SFDC1-9301: Modified to update Product Family Field on Contract
	// @Modified by : Ankita Singh
	// @Last Modified Date: 23rd July 2018
	// @Modification : SFDC1-5228: Account Overview Report
	// @Modified by : Jagadesh Kumar
	// @Last Modified Date: 01st Aug 2018
	//
	public static void rollupProductInfoToOpportunity(TriggerParameters tp) {
		System.Savepoint sp = Database.setSavepoint();
		try {
			//create a set of opportunityid from opportunity products being updated
			Set<Id> setOpportunityIds = new Set<Id>();
			List<Opportunity> lstOpportunityUpdate = new List<Opportunity>();
            List<Contract> contractToBeUpdatedList = new List<Contract>();

			if(tp.tEvent == TriggerParameters.TriggerEvent.afterInsert || tp.tEvent == TriggerParameters.TriggerEvent.afterUpdate || tp.tEvent == TriggerParameters.TriggerEvent.afterUndelete) {
				for(OpportunityLineItem oli: (List<OpportunityLineItem>) tp.newList) {
					setOpportunityIds.add(oli.OpportunityId);
				}
			}
			if(tp.tEvent == TriggerParameters.TriggerEvent.afterDelete) {
				for(OpportunityLineItem oli: (List<OpportunityLineItem>) tp.oldList) {
					setOpportunityIds.add(oli.OpportunityId);
				}           
			}
			//query related opportunities with fields that needs to be rolled up
			List<Opportunity> lstOppy = [Select Id, ProfitCenter__c, ProductFamily__c, ProductGroup__c, FormerIP__c,
			(Select Id, PricebookEntry.Product2.FormerIPOwner__c, PricebookEntry.Product2.Family__r.name,
			PricebookEntry.Product2.ProductGroup__r.name,PricebookEntry.Product2.ProfitCenters__r.name from OpportunityLineItems where Status__c!='Lost'),
            (Select id ,ProductFamily__c, ProductGroup__c from Contracts__r where RecordType.DeveloperName='OrderForm' OR RecordType.DeveloperName='Consulting')
			from opportunity where Id IN:setOpportunityIds ];//SFDC1-5228 JK- Change
			
			for(Opportunity oppy: lstOppy) {
			
				//initialize the opportunity 
				Set<String> productFamily = new Set<String>();
				Set<String> productGroup = new Set<String>();	//SFDC1-5228 JK- New										 
				Set<String> profitCenter = new Set<String>();
				Set<String> formerIP = new Set<String>();

				//initialize sets and add values from related child opportunities
				for(OpportunityLineItem childOlI : oppy.OpportunityLineItems) {
					productFamily.add(childOlI.PricebookEntry.Product2.Family__r.name);
					productGroup.add(childOlI.PricebookEntry.Product2.ProductGroup__r.name);	//SFDC1-5228 JK- New																	
					profitCenter.add(childOlI.PricebookEntry.Product2.ProfitCenters__r.name);
					formerIP.add(childOlI.PricebookEntry.Product2.FormerIPOwner__c);

				}
				//initialize values from oppy
				oppy.ProfitCenter__c = '';
				oppy.ProductFamily__c = '';
				oppy.ProductGroup__c = '';	//SFDC1-5228 JK- New					  
				oppy.FormerIP__c = '';
				//process product family and create comma separated values
				if(productFamily.size()>0) {
					oppy.ProductFamily__c = String.join(new List<String>(productFamily),',');		
				}
				//process product group and create comma separated values
				if(productGroup.size()>0) {	//SFDC1-5228 JK- New
					oppy.ProductGroup__c = String.join(new List<String>(productGroup),',');		
				} 																									 
				//process profit center values
				if(profitCenter.size()>0) {
					oppy.ProfitCenter__c = String.join(new List<String>(profitCenter),',');
				}
				//process formerIP values
				if(formerIP.size()>0) {
					oppy.FormerIP__c = String.join(new List<String>(formerIP),',');
				}
                // Updating Product Family Field on Contract
               for(Contract childContract : oppy.Contracts__r) {
                   childContract.ProductFamily__c = '';
                   childContract.ProductGroup__c = ''; //SFDC1-5228 JK- New
			   		if(productFamily.size()>0) {
						childContract.ProductFamily__c = String.join(new List<String>(productFamily),',');	
                        contractToBeUpdatedList.add(childContract);
					}
                    if(productGroup.size()>0) { //SFDC1-5228 JK- New
						childContract.ProductGroup__c = String.join(new List<String>(productGroup),',');
                        if(!contractToBeUpdatedList.contains(childContract)) {
                        	contractToBeUpdatedList.add(childContract);
                    	}
					}
				}
				lstOpportunityUpdate.add(oppy);
			}
			if(!lstOpportunityUpdate.isEmpty()) {
				update lstOpportunityUpdate;
			}
            
            if(!contractToBeUpdatedList.isEmpty()) {
				update contractToBeUpdatedList;
			}

		}
		catch(Exception ex) {
			Database.rollback(sp);

			String errMessage = ex.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION')? 
			ex.getMessage().substringAfterLast('FIELD_CUSTOM_VALIDATION_EXCEPTION,'):ex.getMessage();
			tp.newList[0].addError('Error: '+errMessage);
			//throw new GenericCustomException ('An Exception Has been caught+ex.getMessage()', ex);
		}
	}
    //@author : Mohit Modi
    //@date : 23 Apr 2018
    //@description : SFDC1-5722 : This method will be used to prevent the deletion of Opportunity line Items from UI, it wcan be bypassed using the global constant in any of the APEX.
    //@param : TriggerParameters
    //@return : void
    //@companyname : Vertiba
    public static void preventOpportunityLineItemDeletion(TriggerParameters tp) {
        // This is a globla constant which will be used to bypass this trigger Error if required.
        if(!GlobalConstants.hasAllowedOpportunityProductDeletion) {
        
            String profileName=[Select Id,Name from Profile where Id=:userinfo.getProfileId()].Name;
            system.debug('ProfileName'+profileName);
            List<OpportunityLineItem> listOppLineItem = (List<OpportunityLineItem>) tp.oldList;
            for(OpportunityLineItem OppLineItemObj : listOppLineItem) {
                if(!profileName.contains('System Admin')){
                    OppLineItemObj.addError('You are not authorized to delete Opportunity Products.');
                }
            }        
        }
    }
    //@author : Paras Dhingra
    //@date : 04 Jun 2018
    //@description : SFDC1-7082 : Rolling down children Oppy schedules on change of contract start date and end date
    //@param : TriggerParameters
    //@return : void
    //@companyname : IHS Markit
    //@modified : Paras Dhingra
    //@modified date : 20-Jun-2018
    //@modified description: SFDC1-8222 Product schedule update on change of contract start date and end date
    public static void updateChildSchedulesOnContractDateChange(TriggerParameters tp) {
        System.Savepoint sp = Database.setSavepoint();
        try {
            List<OpportunityLineItemSchedule__c> lstOppySchedulesToUpdate = new List<OpportunityLineItemSchedule__c>();
            List<OpportunityLineItemSchedule__c> lstOLISToBeChanged = new List<OpportunityLineItemSchedule__c>();
            Map<Id,OpportunityLineItem> mapOLIContractDateChanged = new Map<Id,OpportunityLineItem>();
            Map<Id,OpportunityLineItem> mapOLIContractFiscalChanged = new Map<Id,OpportunityLineItem>();
            Map<Id,OpportunityLineItem> mapOLIAllChanged = new Map<Id,OpportunityLineItem>();
            Set<Id> setProductIDs = new Set<Id>();
            Set<String> setPricingYear = new Set<String>();
            Map<Id,String> mapOLIFiscalYear = new Map<Id,String>();
            Map<String,ProductSchedule__c> mapMultiKeyProductSchedule = new Map<String,ProductSchedule__c>();
            Set<Id>setOpportunityIdForBlankCSDOLIs = new Set<Id>();
            Set<Id>setOLIIdsBlankCSD = new Set<Id>();
            if(!GlobalConstants.preventOpportunityProductScheduleUpdate) {
                GlobalConstants.preventOpportunityProductScheduleUpdate=true;
                Integer fiscalStartMonth = UtilityClass.FiscalStartMonth;
                //collect all opportunity products for which contract start date or end date has been modified
                for(OpportunityLineItem oli : (List<OpportunityLineItem>) tp.newList) {
                    OpportunityLineItem oldOli =(OpportunityLineItem)tp.oldMap.get(oli.Id);
                    if(oldOli!=null  && (oli.ContractStartDate__c!=oldOli.ContractStartDate__c || oli.ContractEndDate__c!=oldOli.ContractEndDate__c)) {
                        //fiscal change
                        if(oli.ContractStartDate__c!=null) {
                            //Integer oldOLIFiscalYear = UtilityClass.calculateFYFromDate(oldOli.ContractStartDate__c,fiscalStartMonth);
                            Integer oliFiscalYear =  UtilityClass.calculateFYFromDate(oli.ContractStartDate__c,fiscalStartMonth);
                            //if(oldOLIFiscalYear!=oliFiscalYear) {
                            mapOLIContractFiscalChanged.put(oli.id,oli);
                            mapOLIAllChanged.put(oli.Id,oli);
                            setProductIDs.add(oli.Product2Id);
                            setPricingYear.add(String.valueOf(oliFiscalYear));
                            mapOLIFiscalYear.put(oli.Id,String.valueOf(oliFiscalYear));
                            //}
                        } 
                        else if(oli.ContractStartDate__c==null) {
                            //fetch contract start date or close date from opportunity
                            setOpportunityIdForBlankCSDOLIs.add(oli.OpportunityId);
                            setOLIIdsBlankCSD.add(oli.Id);
                        }
                       
                        //check if opportunity is already pro-rated and is eligible for pro-ration
                        //to be uncommented for phase 1.3
                        /*
                        if(oli.status__c!='Lost' && oli.isProRated__c=='Yes'&& oli.ProductType__c =='Subscription' ) {
                            mapOLIContractDateChanged.put(oli.id,oli);
                            mapOLIAllChanged.put(oli.Id,oli);
                        }*/
                    }
                    
                }
                System.debug('--setOpportunityIdForBlankCSDOLIs--'+ setOpportunityIdForBlankCSDOLIs);
                
                if(setOpportunityIdForBlankCSDOLIs!=null && !setOpportunityIdForBlankCSDOLIs.isEmpty()) {
                    //query opportunities for closeDate and opportunity start date
                    Map<Id,Opportunity> mapOppyForCSD = new Map<Id,Opportunity>([Select Id, CloseDate, ContractStartDate__c 
                                                                                from Opportunity 
                                                                                where Id IN: setOpportunityIdForBlankCSDOLIs ]);
                    System.debug('--mapOppyForCSD--'+mapOppyForCSD);
                    if(mapOppyForCSD!=null && !mapOppyForCSD.isEmpty()) {
                        for(Id OLIId : setOLIIdsBlankCSD) {
                            OpportunityLineItem oli = (opportunityLineItem)tp.newMap.get(OLIId);
                            OpportunityLineItem oldOLi = (OpportunityLineItem)tp.oldMap.get(OLIId);
                            Opportunity oppy = mapOppyForCSD.get(oli.OpportunityId);
                            Integer oppyFiscalYear;
                            //by defauly fiscal date is close date but if Contract Start date is present, it takes precedence
                            Date fiscalDate = oppy.CloseDate;
                            if(oppy.ContractStartDate__c!=null) {
                                fiscalDate = oppy.ContractStartDate__c;
                            }
                            oppyFiscalYear = UtilityClass.calculateFYFromDate(fiscalDate,fiscalStartMonth);
                            //update maps with opportunity fiscal year as oppy fiscal year is not present
                            if(oppyFiscalYear!=null) {
                                System.debug('@PD--inside oppyFiscalYear logic');
                                mapOLIContractFiscalChanged.put(oli.id,oli);
                                mapOLIAllChanged.put(oli.Id,oli);
                                setProductIDs.add(oli.Product2Id);
                                setPricingYear.add(String.valueOf(oppyFiscalYear));
                                mapOLIFiscalYear.put(oli.Id,String.valueOf(oppyFiscalYear));
                            }
                           
                        }
                    }
                }
                System.debug('@PD --mapOLIAllChanged--'+mapOLIAllChanged.size());
                System.debug('@PD --mapOLIContractDateChanged--'+mapOLIContractDateChanged.size());
                System.debug('@PD --mapOLIContractFiscalChanged--'+mapOLIContractFiscalChanged.size());
                System.debug('@PD --mapOLIFiscalYear--'+mapOLIFiscalYear);
                
                if(mapOLIAllChanged!=null && !mapOLIAllChanged.isEmpty()) {
                    lstOLISToBeChanged = [Select id, DiscountPercent__c,DiscountAmount__c,DiscountType__c,ExternalListPrice__c,
                                             InstallmentYears__c, OpportunityProductID__c,PriceBookListPrice__c, Product__c,ProductSchedule__c,
                                             ProductSchedule__r.ProductTerm__c, ProductSchedule__r.Year__c,
                                             SalesPrice__c, TotalPrice__c, Quantity__c,AnnualizedDiscountAmount__c, AnnualizedUnitPrice__c, 
                                             AnnualizedTotalAmount__c, ProRatedDiscountAmount__c, ProRatedUnitPrice__c
                                             from OpportunityLineItemSchedule__c
                                             where OpportunityProductID__c IN: mapOLIAllChanged.keySet()
                                             order by InstallmentYears__c ASC];
                    if(mapOLIContractFiscalChanged!=null && !mapOLIContractFiscalChanged.isEmpty()) {
                        //query the product schedules to be reassigned to olis
                         
                        List<ProductSchedule__c> lstProdSchedules = [Select id,Product__c,InstallmentYear__c,PricingYear__c,Year__c,ProductTerm__c,ListPrice__c 
                                                                        from ProductSchedule__c  
                                                                        where isactive__c = true AND PricingYear__c IN:setPricingYear AND Product__c IN:setProductIDs 
                                                                        order by InstallmentYear__c,ProductTerm__c ASC];
                        if(lstProdSchedules!=null && !lstProdSchedules.isEmpty()) {
                            for(ProductSchedule__c ps : lstProdSchedules) {
                                String PSKey = String.valueOf(ps.Product__c) + ps.PricingYear__c + ps.Year__c + ps.ProductTerm__c ;
                                mapMultiKeyProductSchedule.put(PSKey,ps);
                            }
                        
                        }
                        
                    }
                    System.debug('@PD--lstOLIS--'+lstOLISToBeChanged);
                    if(lstOLISToBeChanged!=null && !lstOLISToBeChanged.isEmpty()) {
                    //change pro-ration of opportunity schedule products and change of contract where financial year is changed
                        for(opportunityLineItemSchedule__c olis : lstOLISToBeChanged) {
                            OpportunityLineItem oli = new OpportunityLineItem();
                            oli=mapOLIAllChanged.get(olis.OpportunityProductID__c);
                            //make changes to olis oppy schedules if contract date is changed of parent oppy products
                            //to be uncommendted for phase 1.3
                            /*
                            if(mapOLIContractDateChanged.containsKey(olis.OpportunityProductID__c)) {
                                Double proRatedDays = UtilityClass.getDays360(oli.ContractStartDate__c, oli.ContractEndDate__c);
                                //copy existing unit price to annualized unit price and discount
                                olis.ProRatedUnitPrice__c = (olis.AnnualizedUnitPrice__c / 360) * proRatedDays;
                                olis.ProRatedDiscountAmount__c = (olis.AnnualizedDiscountAmount__c / 360) * proRatedDays;
                                //set precision to 2
                                olis.ProRatedUnitPrice__c = olis.ProRatedUnitPrice__c.setScale(2);
                                olis.ProRatedDiscountAmount__c = olis.ProRatedDiscountAmount__c.setScale(2);
                                //move values from proRated to unit price
                                olis.ExternalListPrice__c = olis.ProRatedUnitPrice__c;
                                olis.DiscountAmount__c = olis.ProRatedDiscountAmount__c;
                                olis.SalesPrice__c = (olis.ExternalListPrice__c - olis.DiscountAmount__c).setScale(2);
                                olis.TotalPrice__c = (olis.SalesPrice__c * oli.Quantity).setScale(2);
                            }*/
                            //make changes to oppy schedules if fiscal is changed of parent oppy products
                            if(mapOLIContractFiscalChanged!=null && mapOLIContractFiscalChanged.containsKey(olis.OpportunityProductID__c) && mapOLIFiscalYear!=null && mapOLIFiscalYear.containsKey(olis.OpportunityProductID__c)) {
                                String OlisPSKey = String.valueOf(olis.Product__c) + mapOLIFiscalYear.get(olis.OpportunityProductID__c) + olis.ProductSchedule__r.Year__c + olis.ProductSchedule__r.ProductTerm__c;
                                if(mapMultiKeyProductSchedule!=null && mapMultiKeyProductSchedule.containsKey(OlisPSKey)) {
                                    
                                    ProductSchedule__c ps = mapMultiKeyProductSchedule.get(OlisPSKey);
                                    olis.ProductSchedule__c = ps.Id;
                                    olis.InstallmentYears__c = ps.InstallmentYear__c;
                                    olis.PriceBookListPrice__c = ps.ListPrice__c; 
                                }
                            
                            }
                            lstOppySchedulesToUpdate.add(olis);    
                        }
                            
                            
                    }
                        
                }
                System.debug('@PD --lstOppySchedulesToUpdate--'+lstOppySchedulesToUpdate);
                if(lstOppySchedulesToUpdate!=null && !lstOppySchedulesToUpdate.isEmpty()) {
                    update lstOppySchedulesToUpdate;
                }
            }
        }
        catch(Exception ex) {
            Database.rollback(sp);
            throw new GenericCustomException ('An Exception Has been caught'+ex.getMessage()); 
        }

    }
    //-----------------------------
    // @author: Paras Dhingra
    // @date: 21st July 2018
    // @param: TriggerParameters
    // @description: SFDC1-7060 - Adding validations for auto renew and opening certain fields from editing
    // This method will be called in before update trigger Events.
    // @return: None
    //------------------------------
    public static void oppyProductValidations(TriggerParameters tp) {
        //the trigger will not be called when records updated from add/edit products page
        if(GlobalConstants.disableOppyProductValidations) {
            return;
        }
        //get logged in user profile name
        String profileName = UtilityClass.LoggedInUserProfileName;
        //get all the valid fields on this object
        Map <String, Schema.SobjectField > oppyProductFields = OpportunityLineItem.sObjectType.getDescribe().fields.getMap();
        Set<Id> setOppportunityID = new Set<Id>();
        Map<Id,Opportunity> mapRelatedOpportunity = new Map<Id,Opportunity>();
        //check if user is admin then do not process further
        if(profileName=='IHSMarkit System Admin' || profileName =='System Administrator') {
            //no validation checks are required for system admins
            return;
        }
        //control reached here not admin
        //iterate through opportunity product and fetch opportunity ids
        for(OpportunityLineItem oli : (List<OpportunityLineItem>) tp.newList) {
            setOppportunityID.add(oli.OpportunityId);
        }
        //query Opportunity records
        mapRelatedOpportunity = new Map<Id,Opportunity>([Select Id, AutoRenewal__c, DoesThisAutoRenewalHaveChanges__c
                                                        from Opportunity where Id IN:setOppportunityID]);
        //fetch custom opportunity validation custom settings
        List<OpportunityValidationFields__c> oppyValidationFields = OpportunityValidationFields__c.getAll().values();
        //Set<String> setHasChangesAPIs = new Set<String>();
        Set<String> setDoesNotHaveChangesAPIs = new Set<String>();
        for(OpportunityValidationFields__c ovf : oppyValidationFields) {
            String apiname = ovf.APIName__c.toLowerCase();
            //commenting out code based on input from Christine. no validations on edit products page when does this auto renewal has changes is 'yes'
            /*
            if(ovf.RuleName__c=='AutoRenewHasChangesOppyProduct') {
                setHasChangesAPIs.add(apiname);
            }
			*/
            if(ovf.RuleName__c=='AutoRenewNoChangesOppyProduct') {
                setDoesNotHaveChangesAPIs.add(apiname);
            }
        }
        //iterate opportunity products and process which have auto-renewal opportunity attached
        for(OpportunityLineItem oli : (List<OpportunityLineItem>) tp.newList) {
            Boolean hasError = false;
            Boolean isAllowed = false;
            //not adding null check as opportunityId will always be populated
            Opportunity oppy = mapRelatedOpportunity.get(oli.OpportunityId);
            OpportunityLineItem oldOppyProduct = (OpportunityLineItem)tp.oldMap.get(oli.Id);
            //check if the oppy is valid for validations
            if(oppy.AutoRenewal__c==true) {
                //check profile level checks
                if(profileName.containsIgnoreCase('General') || profileName.containsIgnoreCase('Sales Ops') || profileName.containsIgnoreCase('Sales Coordinator') ) {
                   isAllowed=true;
                }
                if(!isAllowed) {
                    //not allowed to edit the opportunity product
                   oli.addError(System.Label.AutoRenewOppyProductError);// TODO add label
                   //no further processing required on this oppy product record skip the iteration
                   continue;
                }
                for(string fieldName : oppyProductFields.keySet()) {
                    Schema.DescribeFieldResult dfr = oppyProductFields.get(fieldName).getDescribe();
                    if(oldOppyProduct.get(fieldName)!=oli.get(fieldName) && !dfr.IsCalculated()) {
                    //locked field edited
                    //commenting out code based on input from Christine. no validations on edit products page when does this auto renewal has changes is 'yes'
                    /*
                        if(oppy.DoesThisAutoRenewalHaveChanges__c && !setHasChangesAPIs.contains(fieldName)) {
                            //rule specific custom message can be added later 
                            System.debug('@PD--Error Field--'+fieldName);
                            hasError = true;
                            break;
                        }
					*/
                    if(!oppy.DoesThisAutoRenewalHaveChanges__c && !setDoesNotHaveChangesAPIs.contains(fieldName)) {
                            //rule specific custom message can be added later on
                            System.debug('@PD--Error Field2--'+fieldName);
                            hasError = true;
                            break;
                        }
                    }
                }
                
            }
            if(hasError) {
                oli.addError(System.Label.AutoRenewHasChangesOppyError); // todo add label    
            }
         
        }
    }
}