({
    doInit : function(component, event, helper) {
        
        var action2 = component.get("c.getLicenseTypes");
        
        action2.setCallback(this,function(response) {
            console.log("license types state >> "+ response.getState());
            if (response.getState() == 'SUCCESS') {
                var result2 = response.getReturnValue();
                console.log(result2);
                component.set("v.licenseTypes",result2);
            }
        });
        $A.enqueueAction(action2);
        var productIds = component.get("v.productIds");
        var oppyId = component.get("v.oppyId");
        console.log("productIds"+productIds);
        console.log("productIds"+productIds.length);
        var action = component.get("c.getProductDetails");
        
        action.setParams({
            "productIds": productIds,
            "oppyId" : oppyId            
        });
        action.setCallback(this, function(response) {
            console.log("state >> "+ response.getState());
            if (response.getState() == 'SUCCESS') {
                var result = response.getReturnValue();
                console.log(result);
                var licenseTypes = component.get("v.licenseTypes");
                if(result) {
                    for( var key in result) {
                        result[key].licenseType= '';
                    }
                    component.set("v.lstProducts",result);
                    if(result[0]) {
                        component.set("v.currencyCode",result[0].currencyCode);
                        component.set("v.oppyRecordTypeName",result[0].recordTypeName);
                        console.log('--RecordType.DeveloperName--'+result[0].recordTypeName);                       
                    }                    
                }
                
            }
        });
        $A.enqueueAction(action);
    },
    productTermChange : function(component, event, helper) {
        var yearVal = event.getSource().get("v.value");
        var index = event.getSource().get("v.name");
        var lstProducts = component.get("v.lstProducts");
        var lstProductSchedulesCurrent = lstProducts[index].lstProductsSelected;
        var lstProductSchedules = [];
        var mapProductSchedulesAll = lstProducts[index].mapProductsAll;
        var discountType = lstProducts[index].discountType;
        console.log('discountType'+discountType);
        lstProductSchedules = mapProductSchedulesAll[yearVal];
        for(var key in lstProductSchedules) {
            if(lstProductSchedulesCurrent && lstProductSchedulesCurrent[key]) {
                if(discountType==='Amount') {
                    lstProductSchedules[key].discountAmount = parseFloat(lstProductSchedulesCurrent[key].discountAmount).toFixed(2);
                    lstProductSchedules[key].discountPercent = parseFloat(lstProductSchedulesCurrent[key].discountAmount/lstProductSchedules[key].externalListPrice*100).toFixed(2);
                }
                else {
                    lstProductSchedules[key].discountPercent = parseFloat(lstProductSchedulesCurrent[key].discountPercent).toFixed(2);
                    lstProductSchedules[key].discountAmount = parseFloat((lstProductSchedules[key].discountPercent/100)*lstProductSchedules[key].externalListPrice).toFixed(2);
                }
                
                
            }
            
            lstProductSchedules[key].salesPrice = parseFloat(lstProductSchedules[key].externalListPrice - lstProductSchedules[key].discountAmount).toFixed(2); 
            lstProductSchedules[key].totalPrice=parseFloat(lstProductSchedules[key].salesPrice*lstProducts[index].productQty).toFixed(2) ;
        }
        
        component.set("v.lstProducts["+index+ "].lstProductsSelected",lstProductSchedules);
        component.set("v.lstProducts["+index+ "].productTermSelected",yearVal);
        var discountType = component.get("v.globalDiscountType");
        if(discountType!="No Discount") {
            helper.applyGlobalDiscount(component);
            helper.validate(component);
        }
    },
    cancel : function(component, event, helper) {
        var oppyId = component.get("v.oppyId");
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": oppyId,
            "slideDevName": "detail",
            "isredirect":true
        });
        navEvt.fire();
    },
    onSave: function(component, event, helper) {
        var isValid = helper.validateLicense(component);
        if(!isValid) {
            return;
        }
        var spinner = component.find("loadSpinner");
        $A.util.toggleClass(spinner, "slds-hide");
        var save = component.find("save");
        save.set("v.disabled",true);
        var savedProducts = component.get("v.lstProducts");
        var oppyId = component.get("v.oppyId");
        var legalEntity = component.get("v.legalEntity");
        var action = component.get("c.saveProductsOnOpportunity");
        action.setParams({
            "stringProductWrapper": JSON.stringify(savedProducts),
            "opportunityId" :  oppyId,
            "legalEntity" : legalEntity
        });
        action.setCallback(this, function(response) {
            var toastEvent = $A.get("e.force:showToast");
            if (response.getState() == 'SUCCESS') {
                var result = response.getReturnValue();
                var message = result;
                console.log("message=>"+message);
                if(message.indexOf("Error occurred")!==-1) {
                    toastEvent.setParams({
                        "title": "Oops!",
                        "message":result,
                        "mode":"dismissible",
                        "type":"error",
                        "duration":"3000"
                        
                    });
                    toastEvent.fire();
                    return;
                }
                toastEvent.setParams({
                    "title": "Record created!",
                    "message":result,
                    "mode":"dismissible",
                    "type":"success",
                    "duration":"3000"
                    
                });
                toastEvent.fire();
                var oppyId = component.get("v.oppyId");
                var navEvt = $A.get("e.force:navigateToSObject");
                navEvt.setParams({
                    "recordId": oppyId,
                    "slideDevName": "detail",
                    "isredirect":true
                });
                $A.get('e.force:refreshView').fire();
                navEvt.fire();
                
            } else {
                var result = response.getReturnValue();
                console.log("message=>"+result);
                toastEvent.setParams({
                    "title": "Error occurred!",
                    "message":result,
                    "mode":"dismissible",
                    "type":"error",
                    "duration":"3000"
                });
                toastEvent.fire();
            }
            $A.util.toggleClass(spinner, "slds-hide");
            save.set("v.disabled",false);
        });
        $A.enqueueAction(action);
    },
    onDiscAmtPercentChange : function(component, event, helper) {
        var listedProducts = component.get("v.lstProducts");
        var discountName = event.getSource().get("v.name");
        var discount = event.getSource().get("v.value");
        var index = discountName.charAt(0);
        var prodIndex = discountName[discountName.length -1];
        var lstProductSelected = listedProducts[prodIndex].lstProductsSelected;
        if(discountName.indexOf("Percent")!==-1) {
            lstProductSelected[index].salesPrice =  parseFloat(lstProductSelected[index].externalListPrice *(1-(discount)/100)).toFixed(2);
            lstProductSelected[index].discountAmount = parseFloat(lstProductSelected[index].externalListPrice - lstProductSelected[index].salesPrice).toFixed(2) ;
        } else{
            lstProductSelected[index].salesPrice =  parseFloat(lstProductSelected[index].externalListPrice -discount).toFixed(2);
            lstProductSelected[index].discountPercent = parseFloat((discount/(lstProductSelected[index].externalListPrice)*100)).toFixed(2);
        }
        
        lstProductSelected[index].totalPrice =  parseFloat(listedProducts[prodIndex].productQty * lstProductSelected[index].salesPrice).toFixed(2);
        component.set("v.lstProducts["+prodIndex+ "].lstProductsSelected",lstProductSelected);
        helper.validate(component);
    },
    onDiscountTypeChange : function(component, event, helper) {
        var discountName = event.getSource().get("v.name");
        var prodIndex = discountName[discountName.length -1];
        var listedProducts = component.get("v.lstProducts");
        var discountType = listedProducts[prodIndex].discountType;
        // this might return an array in case multiple line items
        var discountPercents = component.find("discountPercent");
        discountPercents = [].concat(discountPercents);//convert it into an array or add blank
        // this might return an array in case multiple line items
        var discountAmounts = component.find("discountAmount");
        discountAmounts = [].concat(discountAmounts);//convert it into an array or add blank
        console.log("discountAmounts size=>"+discountAmounts.length);
        if(discountType==="No Discount") {
            discountPercents.forEach( cmp => {
                if(cmp.get("v.name")[cmp.get("v.name").length-1]===prodIndex) {
                cmp.set("v.disabled",true);
                
            }
                                     })
            discountAmounts.forEach( cmp => {
                if(cmp.get("v.name")[cmp.get("v.name").length-1]===prodIndex) {
                cmp.set("v.disabled",true);
                
            }
                                    })
            var selectedProducts = listedProducts[prodIndex].lstProductsSelected;
            console.log("selectedProducts size =>"+selectedProducts.length);
            for(var i=0; i<selectedProducts.length; i++) {
                selectedProducts[i].discountPercent=0;
                selectedProducts[i].discountAmount=0;
                selectedProducts[i].salesPrice=parseFloat(selectedProducts[i].externalListPrice).toFixed(2);
                selectedProducts[i].totalPrice=parseFloat(selectedProducts[i].externalListPrice*listedProducts[prodIndex].productQty).toFixed(2) ;
            }
            component.set("v.lstProducts["+prodIndex+"].lstProductsSelected",selectedProducts);
            var discountType = component.get("v.lstProducts["+prodIndex+"].discountType");
            console.log("--discountType--"+discountType);
        }
        if(discountType==="Amount" ) {
            discountPercents.forEach( cmp => {
                if(cmp.get("v.name")[cmp.get("v.name").length-1]===prodIndex) {
                cmp.set("v.disabled",true);
                
            }
                                     })
            discountAmounts.forEach( cmp => {
                if(cmp.get("v.name")[cmp.get("v.name").length-1]===prodIndex) {
                cmp.set("v.disabled",false);
                
            }
                                    })
        }
        if(discountType==="Percentage" ) {
            discountPercents.forEach( cmp => {
                if(cmp.get("v.name")[cmp.get("v.name").length-1]===prodIndex) {
                cmp.set("v.disabled",false);
                
            }
                                     })
            discountAmounts.forEach( cmp => {
                if(cmp.get("v.name")[cmp.get("v.name").length-1]===prodIndex) {
                cmp.set("v.disabled",true);
                
            }
                                    })
        }
    },
    onQtyChange : function(component, event, helper) {
        var qtyComp = event.getSource();
        var qty = qtyComp.get("v.value");
        var prodIndex = qtyComp.get("v.name").charAt(0);
        var lstProducts = component.get("v.lstProducts");
        //quantity cannot be less than 1
        if(!qty || qty<1) {
            qty=1;
            component.set("v.lstProducts["+prodIndex+"].productQty",qty);
        }
        var lstSelectedProducts = lstProducts[prodIndex].lstProductsSelected;
        for(var i=0; i<lstSelectedProducts.length; i++) {
            lstSelectedProducts[i].totalPrice=parseFloat(lstSelectedProducts[i].salesPrice*qty).toFixed(2) ;
        }
        component.set("v.lstProducts["+prodIndex+"].lstProductsSelected",lstSelectedProducts);
    },
    onListPriceChange : function(component, event, helper) {
        var listComp = event.getSource();
        var name = listComp.get("v.name");
        var index=name.charAt(0);
        var prodIndex = name[name.length-1];
        var lstProducts = component.get("v.lstProducts");
        var lstSelectedProducts = lstProducts[prodIndex].lstProductsSelected;
        var extListPrice = listComp.get("v.value");
        var discountType = lstProducts[prodIndex].discountType;
        var discountAmt = 0;
        if(discountType==="Amount") {
            discountAmt = lstSelectedProducts[index].discountAmount;
            lstSelectedProducts[index].discountPercent = parseFloat((discountAmt/extListPrice)*100).toFixed(2);
        }
        if(discountType==="Percentage") {
            discountAmt = (lstSelectedProducts[index].discountPercent/100)*extListPrice;
            lstSelectedProducts[index].discountAmount = parseFloat(discountAmt).toFixed(2);
        }
        console.log("extListPrice" + extListPrice);
        console.log("discountAmt"+ discountAmt);
        lstSelectedProducts[index].salesPrice=parseFloat(extListPrice-discountAmt).toFixed(2);
        lstSelectedProducts[index].totalPrice=parseFloat(lstSelectedProducts[index].salesPrice*lstProducts[prodIndex].productQty).toFixed(2);
        component.set("v.lstProducts["+prodIndex+"].lstProductsSelected",lstSelectedProducts);
        helper.validate(component);
    },
    onBack : function(component,event,helper) {
        var backEvent = component.getEvent("onBackEvent");
        backEvent.setParams({"isBackPressed" : true});
        backEvent.fire();
    },
    onGlobalDiscountChange: function(component,event,helper) {
        helper.applyGlobalDiscount(component);
        helper.validate(component);
        helper.resetErrorCode(component);
        
    },
    onGlobalTermChange : function(component,event,helper) {
        var globalTerm = component.get("v.globalTermYears");
        var lstProducts = component.get("v.lstProducts");
        for(var key in lstProducts) {            
            var mapProductSchedulesAll = lstProducts[key].mapProductsAll;
            if(mapProductSchedulesAll[globalTerm]) {
                lstProducts[key].lstProductsSelected = mapProductSchedulesAll[globalTerm];
                lstProducts[key].productTermSelected = globalTerm;
            } else {
                for(var i=5; i>0; i--) {
                    //var term = i.toString();
                    if(mapProductSchedulesAll[i]) {
                        lstProducts[key].lstProductsSelected = mapProductSchedulesAll[i];
                        lstProducts[key].productTermSelected = i;
                        break;
                    }
                }
            }
        }
        component.set("v.lstProducts",lstProducts);
        helper.applyGlobalDiscount(component);
    },
    onGlobalDiscountTypeChange: function(component, event, helper) {
        component.set("v.globalDiscountValue",0);
        helper.applyGlobalDiscount(component);
        helper.validate(component);
        helper.resetErrorCode(component);
    },
    onGlobalLicenseTypeChange: function(component, event, helper) {
        var globallicenseType = component.get("v.globalLicenseType");
        var lstProducts = component.get("v.lstProducts");
        for(var prod in lstProducts ) {
            lstProducts[prod].licenseType = globallicenseType;
        }
         component.set("v.lstProducts",lstProducts);
    },
    collapse: function(component, event, helper) {
        var collapseId = event.getSource().get('v.name');
        var collapseLabel = event.getSource().get('v.label');
        if(collapseLabel==='Collapse') {
            event.getSource().set('v.label','Expand');
        } else {
            event.getSource().set('v.label','Collapse');
        }
        
        var collapseDiv = collapseId.replace('collapse','');
        var divComp = document.getElementById(collapseDiv);
        $A.util.toggleClass(divComp, 'slds-hide');
        
    },
    onUpliftChange: function(component, event, helper) {
        helper.applyGlobalUplift(component);
        helper.applyGlobalDiscount(component);
        helper.validate(component);
        helper.resetErrorCode(component);
    }
}
 })