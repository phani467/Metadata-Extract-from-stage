({
    navigateToOppy: function(component) {
        var oppyId = component.get("v.oppyId");
        var navEvent = $A.get("e.force:navigateToSObject");
        navEvent.setParams({
            "recordId": oppyId,
            "slideDevName": "detail",
            "isredirect": true
        });
        navEvent.fire();
    },
    navigateToAddProducts: function(component) {
        var environmentType = component.get("v.environmentType");
        console.log("--environmentType--" + environmentType);
        var oppyId = component.get("v.oppyId");
        if (environmentType === "Lightning") {
            var evt = $A.get("e.force:navigateToComponent");
            evt.setParams({
                componentDef: "c:productSelectorModal",
                componentAttributes: {
                    oppyId: oppyId
                }
            });
            $A.get('e.force:refreshView').fire();
            evt.fire();
        }
        else if (environmentType === "Community") {

            var urlEvent = $A.get("e.force:navigateToURL");
            urlEvent.setParams({
                "url": "/productselector?recordId=" + oppyId,
                "isredirect": true
            });
            urlEvent.fire();
        }

    },
    validate: function(component) {
        //validate for negative values
        var save = component.find("save");
        save.set("v.disabled", false);
        var showError = false;
        component.set("v.showErrorMessage", showError);
        var savedProducts = component.get("v.lstProductsAdded");
        for (var key in savedProducts) {
            for (var ops in savedProducts[key].lstOPS) {
                if (savedProducts[key].lstOPS[ops].TotalPrice__c < 0) {
                    save.set("v.disabled", true);
                    showError = true;
                    component.set("v.showErrorMessage", showError);
                    return;
                }
            }
        }
    },
    applyGlobalDiscount : function(component) {
        var lstProducts = component.get("v.lstProductsAdded");
        var discountType = component.get("v.globalDiscountType");
        var globalDiscount = component.get("v.globalDiscountValue");
        var globalDiscountStep = component.get("v.globalDiscountStep");
        console.log("discountType==>"+discountType);
        console.log("globalDiscount==>"+globalDiscount);
        console.log("globalDiscountStep==>"+globalDiscountStep);
        console.log("lstProducts"+lstProducts);
        for(var key in lstProducts) {
            lstProducts[key].discountType = discountType;
            var stepCounter = 1;
            var stepDownCounter = lstProducts[key].lstOPS.length;
            var stepDownDiscount = globalDiscount/stepDownCounter;
            for(var prod in lstProducts[key].lstOPS) {
                
                var calculatedDiscount;
                calculatedDiscount = parseFloat(globalDiscount*stepCounter).toFixed(2);
                if(globalDiscountStep === "Step down" ) {
                    calculatedDiscount = parseFloat(stepDownDiscount*stepDownCounter--).toFixed(2);
                }
                if(discountType=="Amount") {
                    lstProducts[key].lstOPS[prod].DiscountAmount__c = calculatedDiscount;
                    lstProducts[key].lstOPS[prod].DiscountPercent__c = parseFloat((calculatedDiscount/lstProducts[key].lstOPS[prod].ExternalListPrice__c)*100).toFixed(2);
                    
                } else if(discountType=="Percentage") {
                    lstProducts[key].lstOPS[prod].DiscountPercent__c = calculatedDiscount;
                    lstProducts[key].lstOPS[prod].DiscountAmount__c = parseFloat((calculatedDiscount/100)*lstProducts[key].lstOPS[prod].ExternalListPrice__c).toFixed(2);
                } else {
                    lstProducts[key].lstOPS[prod].DiscountPercent__c = 0;
                    lstProducts[key].lstOPS[prod].DiscountAmount__c = 0;
                    
                }
                lstProducts[key].lstOPS[prod].SalesPrice__c = lstProducts[key].lstOPS[prod].ExternalListPrice__c - lstProducts[key].lstOPS[prod].DiscountAmount__c;
                lstProducts[key].lstOPS[prod].TotalPrice__c=lstProducts[key].lstOPS[prod].SalesPrice__c*lstProducts[key].productQty;
                if(globalDiscountStep.indexOf("Step")>=0) {
                    stepCounter++;
                }
                lstProducts[key].lstOPS[prod].DiscountPercent__c = parseFloat(lstProducts[key].lstOPS[prod].DiscountPercent__c).toFixed(2);
                lstProducts[key].lstOPS[prod].DiscountAmount__c = parseFloat(lstProducts[key].lstOPS[prod].DiscountAmount__c).toFixed(2);
                lstProducts[key].lstOPS[prod].SalesPrice__c = parseFloat(lstProducts[key].lstOPS[prod].SalesPrice__c).toFixed(2);
                lstProducts[key].lstOPS[prod].TotalPrice__c = parseFloat(lstProducts[key].lstOPS[prod].TotalPrice__c).toFixed(2);                
            }
        }
        component.set("v.lstProductsAdded",lstProducts);
        if(discountType=="No Discount") {
            component.set("v.globalDiscountValue",0);
        }
    },
    applyGlobalUplift: function(component) {
        console.log("helper uplift entered");
        var lstProducts = component.get("v.lstProductsAdded");
        var upliftpercent = component.get("v.globalUplift");
        //apply uplift to all
        for (var key in lstProducts) {
            var year = 1;
            var previousListPrice = 0;
            for (var prod in lstProducts[key].lstOPS) {
                var percentIncrease = 0.0;
                if (year > 1) {
                    percentIncrease = parseFloat(upliftpercent * previousListPrice / 100).toFixed(2);
                    console.log("previousListPrice=>" + previousListPrice);
                    console.log("percentIncrease=>" + percentIncrease);
                    lstProducts[key].lstOPS[prod].ExternalListPrice__c = parseFloat(previousListPrice).toFixed(2) * 1 + parseFloat(percentIncrease).toFixed(2) * 1;
                    lstProducts[key].lstOPS[prod].ExternalListPrice__c = parseFloat(lstProducts[key].lstOPS[prod].ExternalListPrice__c).toFixed(2);
                    console.log("--lstProducts[key].lstOPS[prod].ExternalListPrice__c--" + lstProducts[key].lstOPS[prod].ExternalListPrice__c);

                }
                previousListPrice = lstProducts[key].lstOPS[prod].ExternalListPrice__c;
                year++;
            }
        }
        component.set("v.lstProductsAdded", lstProducts);
    },
    resetErrorCode: function(component) {
        component.set("v.resetErrors", false);
        component.set("v.resetErrors", true);
    },
    save: function(component, event, isClosed) {
        var isValid = this.validateLicense(component);
        if(!isValid) {
            return;
        }
        var spinner = component.find("loadSpinner");
        $A.util.toggleClass(spinner, "slds-hide");
        var save = component.find("save");
        save.set("v.disabled", true);
        var close = component.find("close");
        close.set("v.disabled", true);
        var savedProducts = component.get("v.lstProductsAdded");
        var oppyId = component.get("v.oppyId");
        var action = component.get("c.saveProducts");
        for (var key in savedProducts) {
            for (var ops in savedProducts[key].lstOPS) {
                savedProducts[key].lstOPS[ops].Status__c = savedProducts[key].status;
                savedProducts[key].lstOPS[ops].DiscountType__c = savedProducts[key].discountType;
            }
        }

        action.setParams({
            "oppyId": oppyId,
            "wrapperJson": JSON.stringify(savedProducts)
        });
        action.setCallback(this, function(response) {
            var toastEvent = $A.get("e.force:showToast");
            if (response.getState() == 'SUCCESS') {
                var result = response.getReturnValue();
                var message = result;
                console.log("message=>" + message);
                if (message.indexOf("Error occurred") !== -1) {
                    toastEvent.setParams({
                        "title": "Oops!",
                        "message": result,
                        "mode": "dismissible",
                        "type": "error",
                        "duration" : "3000"

                    });
                    toastEvent.fire();
                    return;
                }
                toastEvent.setParams({
                    "title": "Products Updated!",
                    "message": result,
                    "mode": "dismissible",
                    "type": "success",

                });
                toastEvent.fire();
                if (isClosed) {
                    this.navigateToOppy(component);
                }
                this.initializeData(component, event);
            }
            else {
                var result = response.getReturnValue();
                console.log("message=>" + result);
                toastEvent.setParams({
                    "title": "Error occurred!",
                    "message": result,
                    "mode": "dismissible",
                    "type": "error",
                    "duration":"3000"
                });
                toastEvent.fire();
            }
            $A.util.toggleClass(spinner, "slds-hide");
            save.set("v.disabled", false);
            close.set("v.disabled", false);
        });
        $A.enqueueAction(action);
    },
    validDecimal: function(component, numValue) {
        var testResult = /^(\d)+\.?(\d{1,2})?$/.test(numValue);
        //check to prevent errors on blank values
        if (!numValue || numValue.length == 0) {
            return true;
        }
        return testResult;
    },
    initializeData: function(component, event) {
        var action2 = component.get("c.getLicenseTypes");
        action2.setCallback(this, function(response) {
            console.log("license types state >> " + response.getState());
            if (response.getState() == 'SUCCESS') {
                var result2 = response.getReturnValue();
                component.set("v.licenseTypes", result2);
            }
        });
        $A.enqueueAction(action2);
        var action = component.get("c.getOpportunityOPS");
        var oppyId = component.get("v.oppyId");

        //process if oppyId exists
        if (oppyId) {
            action.setParams({
                "OppyId": oppyId
            });
            action.setCallback(this, function(response) {
                console.log("state >> " + response.getState());
                if (response.getState() == 'SUCCESS') {
                    var result = response.getReturnValue();
                    component.set("v.lstProductsAdded", result.lstOPSWrapper);
                    component.set("v.oppy", result.oppy);
                    component.set("v.canBeProRated", result.canBeProRated);
                    component.set("v.globalProRate","No");
                    if(result.oppy && result.oppy.AutoRenewal__c &&  !result.isAdmin) {
                        if(!result.oppy.DoesThisAutoRenewalHaveChanges__c) {
                            component.set("v.autoRenewNoChanges",true);
                        }
                        /*
                        else {
                            component.set("v.autoRenewHasChanges",true);
                        }
                        */
                    }
                    if(result.oppy && result.oppy.IsProRated__c) {
                        component.set("v.globalProRate",result.oppy.IsProRated__c);
                    }
                    component.set("v.hasOppyEditAccess", result.hasOpportunityEditAccess);
                    component.set("v.hasOppyProductRemoveAccess", result.hasRemoveProductAccess);
                    if (!result.lstOPSWrapper || result.lstOPSWrapper.length == 0) {
                        component.set("v.noProductsMessage", "No Products found");
                    }
                }
                else {
                    console.log(response.getReturnValue());
                }
            });
            $A.enqueueAction(action);
        }
    },
    proRateYes: function(component) {
        //prorate button has been set to yes
        var lstProducts = component.get("v.lstProductsAdded");
        var oppy = component.get("v.oppy");
        //process products and set annualized unit price and pro-rated unit price
        for (var opsWrap in lstProducts) {
            //proRate only for subscription products
            if (lstProducts[opsWrap].oppyProduct.ProductType__c === 'Subscription') {
                lstProducts[opsWrap].oppyProduct.isProrated__c = 'Yes';
                var conStartDate = new Date(lstProducts[opsWrap].oppyProduct.ContractStartDate__c);
                var conEndDate = new Date(lstProducts[opsWrap].oppyProduct.ContractEndDate__c);
                var proRatedDays = this.date360(conStartDate,conEndDate);
                for (var olis in lstProducts[opsWrap].lstOPS) {
                    //copy existing unit price to annualized unit price and discount
                    lstProducts[opsWrap].lstOPS[olis].AnnualizedUnitPrice__c = lstProducts[opsWrap].lstOPS[olis].ExternalListPrice__c;
                    lstProducts[opsWrap].lstOPS[olis].AnnualizedDiscountAmount__c = lstProducts[opsWrap].lstOPS[olis].DiscountAmount__c;
                    lstProducts[opsWrap].lstOPS[olis].ProRatedUnitPrice__c = (lstProducts[opsWrap].lstOPS[olis].AnnualizedUnitPrice__c / 360) * proRatedDays;
                    lstProducts[opsWrap].lstOPS[olis].ProRatedDiscountAmount__c = (lstProducts[opsWrap].lstOPS[olis].AnnualizedDiscountAmount__c / 360) * proRatedDays;
                    //set precision to 2
                    lstProducts[opsWrap].lstOPS[olis].ProRatedUnitPrice__c = parseFloat(lstProducts[opsWrap].lstOPS[olis].ProRatedUnitPrice__c).toFixed(2);
                    lstProducts[opsWrap].lstOPS[olis].ProRatedDiscountAmount__c = parseFloat(lstProducts[opsWrap].lstOPS[olis].ProRatedDiscountAmount__c).toFixed(2);
                    //move values from proRated to unit price
                    lstProducts[opsWrap].lstOPS[olis].ExternalListPrice__c = lstProducts[opsWrap].lstOPS[olis].ProRatedUnitPrice__c;
                    lstProducts[opsWrap].lstOPS[olis].DiscountAmount__c = lstProducts[opsWrap].lstOPS[olis].ProRatedDiscountAmount__c;
                    lstProducts[opsWrap].lstOPS[olis].SalesPrice__c = parseFloat(lstProducts[opsWrap].lstOPS[olis].ExternalListPrice__c - lstProducts[opsWrap].lstOPS[olis].DiscountAmount__c).toFixed(2);
                    lstProducts[opsWrap].lstOPS[olis].TotalPrice__c = parseFloat(lstProducts[opsWrap].lstOPS[olis].SalesPrice__c * lstProducts[opsWrap].productQty).toFixed(2);
                }
            }
        }
        component.set("v.lstProductsAdded", lstProducts);

    },
    proRateNo: function(component) {
        //proRate no has been selected that means one or more opportunity products are pro-rated
        var lstProducts = component.get("v.lstProductsAdded");
        for (var opsWrap in lstProducts) {
            //copy annualized values back to original ones
            if (lstProducts[opsWrap].oppyProduct.ProductType__c === 'Subscription') {
                lstProducts[opsWrap].oppyProduct.isProrated__c = 'No';
                for (var olis in lstProducts[opsWrap].lstOPS) {
                    lstProducts[opsWrap].lstOPS[olis].ExternalListPrice__c = lstProducts[opsWrap].lstOPS[olis].AnnualizedUnitPrice__c;
                    lstProducts[opsWrap].lstOPS[olis].DiscountAmount__c = lstProducts[opsWrap].lstOPS[olis].AnnualizedDiscountAmount__c;
                    lstProducts[opsWrap].lstOPS[olis].SalesPrice__c = lstProducts[opsWrap].lstOPS[olis].ExternalListPrice__c - lstProducts[opsWrap].lstOPS[olis].DiscountAmount__c;
                    lstProducts[opsWrap].lstOPS[olis].TotalPrice__c = lstProducts[opsWrap].lstOPS[olis].SalesPrice__c * lstProducts[opsWrap].productQty;
                    //remove prorated values
                    lstProducts[opsWrap].lstOPS[olis].ProRatedUnitPrice__c = 0
                    lstProducts[opsWrap].lstOPS[olis].ProRatedDiscountAmount__c = 0;
                    lstProducts[opsWrap].lstOPS[olis].AnnualizedUnitPrice__c = 0;
                    lstProducts[opsWrap].lstOPS[olis].AnnualizedDiscountAmount__c= 0;
                    
                }
            }
        }
        component.set("v.lstProductsAdded", lstProducts);
    },
    validateLicense: function(component) {
        //check if any field has invalid input
        //check for license type
        var isValid = true;
        var licenseTypeField = [];
        licenseTypeField = component.find("licenseTypes");
        if (!licenseTypeField) {
            return true;
        }
        licenseTypeField = [].concat(licenseTypeField);
        licenseTypeField.forEach(cmp => {
            var validity = cmp.get("v.validity");
            if (!cmp.get("v.validity").valid) {
                //cmp.set("v.validity", {valid:false, valueMissing :true});
                isValid = false;
                cmp.showHelpMessageIfInvalid();
            }
        })
        return isValid;
    },
    date360: function(startDate, endDate,european) {
       
            var date1 = new Date(startDate);
            var date2 = new Date(endDate);
            var date1_1 = date1;
            var date2_1 = date2;
            var euro = european || false;
            var date1_y = date1.getFullYear();
            var date2_y = date2.getFullYear();
            var dy = 0;
            var date1_m = date1.getMonth();
            var date2_m = date2.getMonth();
            var dm = 0;
            var date1_d = date1.getDate();
            var date2_d = date2.getDate();
            var dd = 0;
            if (euro) {
                // european way of handling dates
                if (date1_d == 31) {
                  date1_d = 30;  
                } 
                if (date2_d == 31) {
                  date2_d = 30;  
                } 
            }
            else {
                // american North American way fo days360 method
                if (date1_d == 31) {
                  date1_d = 30;  
                } 
                if (date2_d == 31) {
                    if (date1_d < 30) {
                        if (date2_m == 11) {
                            date2_y = date2_y + 1;
                            date2_m = 0;
                            date2_d = 1;
                        }
                        else {
                            date2_m = date2_m + 1;
                            date2_d = 1;
                        }
                    }
                    else {
                        date2_d = 30;
                    }
                }
            }
            dy = date2_y - date1_y;
            dm = date2_m - date1_m;
            dd = date2_d - date1_d;
            return parseFloat(dy * 360 + dm * 30 + dd);
        
    },
    proRateSave: function(component) {
        
    }
})