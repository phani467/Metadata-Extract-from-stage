({
    init : function(component, event, showHierarchyboolean) {
        
		//Resetting license information section details
		component.set('v.showNextLicenseButton', false);
        component.set('v.showPreviousLicenseButton', false);
        component.set('v.showProductSummary', false);
		
		//Fetching allocated license information details
		var action=component.get('c.initialize');
        action.setParams({ 
            "recordId" : component.get('v.accountId'),
            "showHierarchy": showHierarchyboolean
        });
		var licenseInfoSize = component.get('v.licenseInfoSize');
		
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                
				component.set('v.entireListProductLicense', response.getReturnValue().listProductLicense);
                component.set('v.contactList', response.getReturnValue().conList);
				
				if(response.getReturnValue().listProductLicense.length>=10) {
                    var templist =response.getReturnValue().listProductLicense;
                    var permissionList =[]; 
                    var startIndex = 0;
                    var endIndex  = licenseInfoSize;
					//Adding elements to temporary list
                    if(startIndex <endIndex && templist.length > endIndex) {
                        for(var countVar = startIndex; countVar<endIndex ; countVar++) {
                            permissionList.push(templist[countVar]);
                        }
                    }
					component.set('v.listProductLicense',permissionList);
                    //Enabling/disabling pagination and export buttons 
                    if (response.getReturnValue().listProductLicense.length > licenseInfoSize) {
                    	component.set('v.showNextLicenseButton', true);
                    }
                    component.find("exportButton").set("v.disabled", false);
                }
                else if(response.getReturnValue().listProductLicense.length ==0) {
					//Enabling/disabling pagination and export buttons 
					component.find("exportButton").set("v.disabled", true);
                    component.set('v.showNextLicenseButton', false);
                }
                else if(response.getReturnValue().listProductLicense.length <licenseInfoSize) {
					////Enabling/disabling pagination and export buttons 
                    component.set('v.showNextLicenseButton', false);
                    component.set('v.listProductLicense',response.getReturnValue().listProductLicense);
                }
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                
                if (errors) {
                    if (errors[0] && errors[0].message) {
                    	console.log("Error message: " + errors[0].message);
                    }
                } 
                else {
                   console.log("Unknown error");
                }
            }
			//resetting Entitlement information
            var productUsageSummaryList =[];
            component.set('v.entireProductUsageSummaryList',productUsageSummaryList);
            component.set('v.productUsageSummary',productUsageSummaryList);
            component.set('v.showProductSummary', false);
        });
        $A.enqueueAction(action);
    },
    
    showEntitlementInformation:function(component,event,showHierarchy) {
		//resetting Entitlement pagination variables
        component.set('v.showProductSummary',true);
        component.set('v.showNextEntitlementInfo',false);
        component.set('v.showPrevEntitlementInfo',false);
		
        var entitlementSummarySize = component.get('v.entitlementSummarySize');
        var action=component.get('c.showUsageInformation');
		
        action.setParams({
            "productGroupId":event.currentTarget.getAttribute('data-attriVal'),
            "accountId":component.get('v.accountId'),
            "showHierarchy":showHierarchy
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {
                component.set('v.entireProductUsageSummaryList',response.getReturnValue());
                //Setting Entitlement pagination variables and data 
                if(response.getReturnValue().length>= entitlementSummarySize) {
                    var tempList=[];
                    var startIndex =0;
                    var endIndex  = entitlementSummarySize;
                    
                    for(var countVar = startIndex; countVar<endIndex ;countVar++) {
                        tempList.push(response.getReturnValue()[countVar]);
                    }
                    component.set('v.productUsageSummary',tempList);
                    if(response.getReturnValue().length > entitlementSummarySize) {
						component.set('v.showNextEntitlementInfo',true);
					}
                }
                else {
                    component.set('v.productUsageSummary',response.getReturnValue());  
                }
                
				console.log("permissionList message: " + component.get('v.productUsageSummary'));
                console.log("entitlementSummarySize: " + component.get('v.entireProductUsageSummaryList'));
                component.set('v.showPrevEntitlementInfo',false);
                component.set('v.showProductSummary',true);
            }
			else if (state === "ERROR") {
				var errors = response.getError();
				if (errors) {
					if (errors[0] && errors[0].message) {
						console.log("Error message: " + errors[0].message);
					}
				} 
                else {
					console.log("Unknown error");
				}
			}
        });
        
        $A.enqueueAction(action); 
    },
    //Navigating to Account and Contact sobjects
    navigateToSobjectRecord:function(component,event) {
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": event.currentTarget.getAttribute('data-attriVal')
        });
        navEvt.fire();
    },
    convertArrayOfObjectsToCSV : function(component,objectRecords) {
        // declare variables
        var csvStringResult, counter, keys, columnDivider, lineDivider,keyarr;
        
        // check if "objectRecords" parameter is null, then return from function
        if (objectRecords == null || !objectRecords.length) {
            return null;
        }
        // store ,[comma] in columnDivider variable for sparate CSV values and 
        // for start next line use '\n' [new line] in lineDivider variable  
        columnDivider = ',';
        lineDivider =  '\n';
        
        // in the keys valirable store fields API Names as a key 
        // this labels use in CSV file header  
        keys = ['Account Name','First Name','Last Name','Email','Product Groups'];
        keyarr=['AccountName','FirstName','LastName','Email','Licenses__c']
        
        csvStringResult = '';
        csvStringResult += keys.join(columnDivider);
        csvStringResult += lineDivider;
        
        for(var startIndex=0; startIndex < objectRecords.length; startIndex++) {   
            counter = 0;
            for(var sTempkey in keyarr) {
                var skey = keyarr[sTempkey] ;  
                objectRecords[startIndex].AccountName=objectRecords[startIndex].Account.Name;
                // add , [comma] after every String value,. [except first]
                if(counter > 0) { 
                    csvStringResult += columnDivider; 
                }   
                if(!$A.util.isUndefined(objectRecords[startIndex][skey])) {
                    csvStringResult += '"'+ objectRecords[startIndex][skey]+'"'; 
                }
                else {
                    csvStringResult += '"'+'' +'"'; 
                }
                counter++;
                
            } // inner for loop close 
            csvStringResult += lineDivider;
        }// outer main for loop close 
        
        // return the CSV formate String 
        return csvStringResult;        
    },
    
    nextOnLicense:function(component,event) {
        var licenseInfoSize = component.get('v.licenseInfoSize');
        var startIndex = component.get('v.licenseInfoStartIndex')+licenseInfoSize;
        startIndex = startIndex >=licenseInfoSize? component.get('v.licenseInfoEndIndex'):startIndex; 
        var endIndex  = component.get('v.licenseInfoEndIndex')+licenseInfoSize;
        var listSize = component.get('v.entireListProductLicense').length;
        component.set('v.licenseInfoStartIndex',startIndex);
        component.set('v.licenseInfoEndIndex',endIndex );
		
        var tempList=[];
        if(endIndex < listSize) {
			component.set('v.showPreviousLicenseButton', false);
		}
        else {
			component.set('v.showPreviousLicenseButton',true);
		}
        
        if(endIndex >= listSize) {
            endIndex  = listSize;
            component.set('v.showNextLicenseButton', false);
        }
        else {
			component.set('v.showNextLicenseButton', true);
		} 
        if(startIndex <= endIndex &&  listSize >= endIndex) {
            for(var countVar = startIndex; countVar<endIndex ;countVar++) {
                tempList.push(component.get('v.entireListProductLicense')[countVar]); 
            }
        }
        component.set('v.listProductLicense',tempList); 
		//Setting contact usage info as blank
        var productUsageSummaryList =[];
		component.set('v.entireProductUsageSummaryList',productUsageSummaryList);
		component.set('v.productUsageSummary',productUsageSummaryList);
        component.set('v.showProductSummary', false);        
    },
    
    backOnLicense:function(component,event) {
        component.set('v.showNextLicenseButton',true);
		var licenseInfoSize = component.get('v.licenseInfoSize');
        var startIndex =component.get('v.licenseInfoStartIndex')-licenseInfoSize;
        var endIndex  =component.get('v.licenseInfoEndIndex')-licenseInfoSize;
        
        var tempList=[];
        component.set('v.licenseInfoStartIndex',startIndex);
        component.set('v.licenseInfoEndIndex',endIndex );
        if(startIndex<=0) {
            component.set('v.showPreviousLicenseButton',false);
        }
        else if(endIndex <=licenseInfoSize ) {
			component.set('v.showPreviousLicenseButton', false);
		}
        else {
        	component.set('v.showPreviousLicenseButton',true);        
        } 
        if(endIndex >= component.get('v.entireListProductLicense').length) {
            component.set('v.showNextLicenseButton', false);
        }
        else {
            component.set('v.showNextLicenseButton', true);
        }
        if(startIndex <= endIndex &&  component.get('v.entireListProductLicense').length >= endIndex) {
            for(var countVar=startIndex;countVar<endIndex ;countVar++) {
                tempList.push(component.get('v.entireListProductLicense')[countVar]);
            }
        }
        component.set('v.listProductLicense',tempList);
		//Setting contact usage info as blank
        var productUsageSummaryList =[];
		component.set('v.entireProductUsageSummaryList',productUsageSummaryList);
		component.set('v.productUsageSummary',productUsageSummaryList);
        component.set('v.showProductSummary', false);
    },
    
    nextEntitlementInfo:function(component,event) {
        component.set('v.showPrevEntitlementInfo',true);
		var entitlementSummarySize = component.get('v.entitlementSummarySize');
        var startIndex =component.get('v.summaryStartIndex')+entitlementSummarySize;
        startIndex = startIndex >=entitlementSummarySize? component.get('v.summaryEndIndex'):
        			startIndex; 
        var endIndex  =component.get('v.summaryEndIndex')+entitlementSummarySize;
        
        component.set('v.summaryStartIndex',startIndex);
        component.set('v.summaryEndIndex',endIndex );
        
        var tempList=[];
        
        if(endIndex <component.get('v.entireProductUsageSummaryList').length) {
            component.set('v.showNextEntitlementInfo',true);
            component.set('v.showPrevEntitlementInfo', false);
        }
        else if(endIndex >=component.get('v.entireProductUsageSummaryList').length) {
            endIndex = component.get('v.entireProductUsageSummaryList').length;
            component.set('v.showNextEntitlementInfo',false);
            component.set('v.showPrevEntitlementInfo',true);
        }
        
        if(startIndex <= endIndex &&  component.get('v.entireProductUsageSummaryList').length >= endIndex) {
            for(var countVar = startIndex;countVar<endIndex ;countVar++) {
                tempList.push(component.get('v.entireProductUsageSummaryList')[countVar]); 
            }
        }
        
        component.set('v.productUsageSummary',tempList);
        component.set('v.showProductSummary', true);
    },
    
    prevEntitlementInfo:function(component,event) {
        component.set('v.showNextEntitlementInfo',true);
        var entitlementSummarySize = component.get('v.entitlementSummarySize');
        var startIndex =component.get('v.summaryStartIndex')-entitlementSummarySize;
        var endIndex  =component.get('v.summaryEndIndex')-entitlementSummarySize;
        component.set('v.summaryStartIndex',startIndex);
        component.set('v.summaryEndIndex',endIndex );
        var tempList=[];
        
        if(endIndex <component.get('v.entireProductUsageSummaryList').length) {
            component.set('v.showNextEntitlementInfo',true);
        }
        if(endIndex <=entitlementSummarySize) {
            component.set('v.showPrevEntitlementInfo',false);
        }
        else {
			component.set('v.showPrevEntitlementInfo',true);
		}
        if(startIndex <= endIndex &&  component.get('v.entireProductUsageSummaryList').length >= endIndex) {   
            for(var countVar=startIndex; countVar<endIndex; countVar++) {
                tempList.push(component.get('v.entireProductUsageSummaryList')[countVar]);
            }
        }
        component.set('v.productUsageSummary',tempList);
        component.set('v.showProductSummary', true);
    }
})