({
    doInit : function(component, event, helper) {
        
       helper.initializeData(component,event);
        
    },
    onDiscAmtPercentChange : function(component, event, helper) {
        
        var listedProducts = component.get("v.lstProductsAdded");
        var discountName = event.getSource().get("v.name");
        var discount = event.getSource().get("v.value");
        var validNumber = helper.validDecimal(component,discount);
        //if discount is not a valid decimal number show overlay message
        if(!validNumber) {
            component.find('overlayMessages').showCustomModal({
                                            header: "Invalid Decimal",
                                            body: "Please enter a valid decimal of upto 2 decimal places", 
                                            footer: "",
                                            showCloseButton: true,
                                            cssClass: "my-modal,my-custom-class,my-other-class",
                                            closeCallback: function() {
                                                discount=parseFloat(discount).toFixed(2);
                                                event.getSource().set("v.value",discount);
                                            }
                                        });
        }
        console.log("discount"+discount);
        if(!discount || isNaN(discount)) {
             event.getSource().set("v.value",'');
        }
        console.log("discount"+discount);
        var index = discountName.charAt(0);
        var prodIndex = discountName[discountName.length -1];
        var lstProductSelected = listedProducts[prodIndex].lstOPS;
        if(discountName.indexOf("Percent")!==-1) {
            lstProductSelected[index].SalesPrice__c =  parseFloat(lstProductSelected[index].ExternalListPrice__c *(1-(discount)/100)).toFixed(2);
            lstProductSelected[index].DiscountType__c = 'Percentage';
            lstProductSelected[index].DiscountAmount__c = parseFloat(lstProductSelected[index].ExternalListPrice__c - lstProductSelected[index].SalesPrice__c).toFixed(2) ;
        } else if(discountName.indexOf("Amount")!==-1) {
            lstProductSelected[index].SalesPrice__c =  parseFloat(lstProductSelected[index].ExternalListPrice__c -discount).toFixed(2);
            lstProductSelected[index].DiscountType__c = 'Amount';
            lstProductSelected[index].DiscountPercent__c = parseFloat(discount/(lstProductSelected[index].ExternalListPrice__c)*100).toFixed(2);
        } else {
            lstProductSelected[index].DiscountType__c = 'No Discount';
        }
        lstProductSelected[index].TotalPrice__c = parseFloat(lstProductSelected[index].SalesPrice__c * lstProductSelected[index].Quantity__c).toFixed(2);
        component.set("v.lstProductsAdded["+prodIndex+ "].lstOPS",lstProductSelected);
        helper.validate(component);
    },
    onQtyChange : function(component, event, helper) {
        var qtyComp = event.getSource();
        var qty = qtyComp.get("v.value");
        var prodIndex = qtyComp.get("v.name").charAt(0);
        var lstProducts = component.get("v.lstProductsAdded");
        //quantity cannot be less than 1
        if(!qty || qty<1) {
            qty=1;
            component.set("v.lstProductsAdded["+prodIndex+"].productQty",qty);
        }
        
        var lstProducts = component.get("v.lstProductsAdded");
        var lstOPS = lstProducts[prodIndex].lstOPS;
        for(var i=0; i<lstOPS.length; i++) {
            lstOPS[i].TotalPrice__c=lstOPS[i].SalesPrice__c*qty ;
            lstOPS[i].Quantity__c = qty;
        }
        component.set("v.lstProductsAdded["+prodIndex+"].lstOPS",lstOPS);
    },
    onListPriceChange : function(component, event, helper) {
        var listComp = event.getSource();
        var name = listComp.get("v.name");
        var index=name.charAt(0);
        var prodIndex = name[name.length-1];
        var lstProducts = component.get("v.lstProductsAdded");
        var lstSelectedProducts = lstProducts[prodIndex].lstOPS;
        console.log("ProdIndex=>" + prodIndex);
        console.log("Index" + index);
        console.log("lstOPS=>"+lstSelectedProducts);
        var extListPrice = listComp.get("v.value");
        var discountType = lstProducts[prodIndex].discountType;
        var discountAmt = 0;
        if(discountType==="Amount") {
            discountAmt = lstSelectedProducts[index].DiscountAmount__c;
            lstSelectedProducts[index].DiscountPercent__c = parseFloat((discountAmt/extListPrice)*100).toFixed(2);
        }
        if(discountType==="Percentage") {
            discountAmt = (lstSelectedProducts[index].DiscountPercent__c/100)*extListPrice;
            lstSelectedProducts[index].DiscountAmount__c = parseFloat(discountAmt).toFixed(2);
        }
        lstSelectedProducts[index].SalesPrice__c=parseFloat(extListPrice-discountAmt).toFixed(2);
        lstSelectedProducts[index].TotalPrice__c=parseFloat(lstSelectedProducts[index].SalesPrice__c*lstProducts[prodIndex].productQty).toFixed(2);
        component.set("v.lstProductsAdded["+prodIndex+"].lstOPS",lstSelectedProducts);
    },
    onDiscountTypeChange : function(component, event, helper) {
        var discountName = event.getSource().get("v.name");
        var prodIndex = discountName[discountName.length -1];
        var listedProducts = component.get("v.lstProductsAdded");
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
            
            var selectedProducts = listedProducts[prodIndex].lstOPS;
            console.log("selectedProducts size =>"+selectedProducts.length);
            for(var i=0; i<selectedProducts.length; i++) {
                selectedProducts[i].DiscountPercent__c=0;
                selectedProducts[i].DiscountAmount__c=0;
                selectedProducts[i].SalesPrice__c=selectedProducts[i].ExternalListPrice__c;
                selectedProducts[i].TotalPrice__c=parseFloat(selectedProducts[i].ExternalListPrice__c*listedProducts[prodIndex].productQty).toFixed(2) ;
            }
            component.set("v.lstProductsAdded["+prodIndex+"].lstOPS",selectedProducts);
            var discountType = component.get("v.lstProductsAdded["+prodIndex+"].discountType");
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
    productTermChange : function(component, event, helper) {
        var yearVal = event.getSource().get("v.value");
        var index = event.getSource().get("v.name");
        var lstProducts = component.get("v.lstProductsAdded");
        var lstOPSCurrent = lstProducts[index].lstOPS;
        var lstOPS = [];
        var mapOPSAll = lstProducts[index].mapOPSAll;
        var discountType = lstProducts[index].discountType;
        console.log('discountType'+discountType);
        lstOPS = mapOPSAll[yearVal];
        //carry forward existing discounts values
        for(var key in lstOPS) {
            //carry forward discount percentages user already selected
            if(lstOPSCurrent && lstOPSCurrent[key]) {
                console.log('lstOPSCurrent'+lstOPSCurrent[key]);
                if(discountType==='Amount') {
                    lstOPS[key].DiscountAmount__c = parseFloat(lstOPSCurrent[key].DiscountAmount__c).toFixed(2);     
                    lstOPS[key].DiscountPercent__c = parseFloat(lstOPSCurrent[key].DiscountAmount__c/lstOPSCurrent[key].ExternalListPrice__c*100).toFixed(2);     
                }
                else {
                	lstOPS[key].DiscountPercent__c = parseFloat(lstOPSCurrent[key].DiscountPercent__c).toFixed(2);      
                    lstOPS[key].DiscountAmount__c = parseFloat((lstOPS[key].DiscountPercent__c/100)*lstOPS[key].ExternalListPrice__c).toFixed(2);
                }
                
            }
            
            lstOPS[key].SalesPrice__c = parseFloat(lstOPS[key].ExternalListPrice__c - lstOPS[key].DiscountAmount__c).toFixed(2); 
            lstOPS[key].TotalPrice__c=parseFloat(lstOPS[key].SalesPrice__c*lstProducts[index].productQty).toFixed(2) ;
        }
        component.set("v.lstProductsAdded["+index+ "].lstOPS",lstOPS);
        component.set("v.lstProductsAdded["+index+ "].productTermSelected",yearVal);
    },
    cancel : function(component, event, helper) {
        var oppyId = component.get("v.oppyId");
        helper.navigateToOppy(component);
    },
    save : function(component, event, helper) {
        helper.save(component,event);
    },
    close : function(component,event,helper) {
        helper.save(component,event,true);
    },
    remove : function(component, event, helper) {
        var prodIndex = event.getSource().get("v.name").charAt(0);
        var lstProducts = component.get("v.lstProductsAdded");
        lstProducts[prodIndex].isDeleted = true;
        component.set("v.lstProductsAdded",lstProducts);
    },
    reset : function(component, event,helper) {
       helper.initializeData(component,event);
    },
    openModal : function(component, event, helper) {
        component.set("v.openModal", true);
        var lstLegalEntity = component.get("v.lstLegalEntity");
        if(!lstLegalEntity || lstLegalEntity.length<1) {
            //query the controller to get active legal entity list
            var action = component.get("c.getValidLegalEntities");
            var legalEntityId = component.get("v.oppy.LegalEntity__c");
            action.setParams({
                "currentLegalEntityId" : legalEntityId
            });
            action.setCallback(this,function(response) {
                var state = response.getState();
                if(state ==="SUCCESS") { 
                    var result = response.getReturnValue();
                    if(result!==undefined && result!==null) {
                        component.set("v.lstLegalEntity",result);						
                    }
                } else if(state == "Error") {
                    alert("An error has occured while deleting the records");
                }
            });
            $A.enqueueAction(action);
        }
    },
    closeModal : function(component, event, helper) {
        component.set("v.openModal", false);        
    },
    changeLegalEntity : function(component, event, helper) {
        var action = component.get("c.deleteProductsOnOppy");
        var oppyId = component.get("v.oppyId");
        var changedLegalEntity = component.get("v.newlegalEntity");
        action.setParams({
            "oppyId" : oppyId,
            "newLegalEntity" : changedLegalEntity
        });
        action.setCallback(this,function(response) {
            var state = response.getState();
            var toastEvent = $A.get("e.force:showToast");
            if(state ==="SUCCESS") { 
                var result = response.getReturnValue();
                if(result!==undefined && result!==null) {
                    if(result.indexOf("Error Occurred")!==-1) {
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
                        "title": "Records deleted!",
                        "message":result,
                        "mode":"dismissible",
                        "type":"success",
                        "duration":"3000"
                        
                    });
                    toastEvent.fire();
                    //helper.navigateToAddProducts(component);
                    component.set("v.openModal", false);
                    $A.get('e.force:refreshView').fire();
                    
                }
            } else if(state == "Error") {
                alert("An error has occured while deleting the records");
            }
        });
        $A.enqueueAction(action);
    },onGlobalDiscountChange: function(component,event,helper) {
        helper.applyGlobalDiscount(component);
        helper.validate(component);
        helper.resetErrorCode(component);
    },
    onGlobalTermChange : function(component,event,helper) {
        var globalTerm = component.get("v.globalTermYears");
        var index = event.getSource().get("v.name");
        var lstProducts = component.get("v.lstProductsAdded");
        console.log("--globalTerm--"+globalTerm);
        for(var key in lstProducts) {
            
            var mapProductSchedulesAll = lstProducts[key].mapOPSAll;
            console.log("--mapProductSchedulesAll--"+mapProductSchedulesAll);
            if(mapProductSchedulesAll[globalTerm]) {
                lstProducts[key].lstOPS = mapProductSchedulesAll[globalTerm];
                lstProducts[key].productTermSelected = globalTerm;
            } else {
                for(var i=5; i>0; i--) {
                    if(mapProductSchedulesAll[i]) {
                        lstProducts[key].lstOPS = mapProductSchedulesAll[i];
                        lstProducts[key].productTermSelected = i;
                        break;
                    }
                }
            }
        }
        component.set("v.lstProductsAdded",lstProducts);
        helper.applyGlobalDiscount(component);
    },
    onGlobalDiscountTypeChange: function(component, event, helper) {
        helper.applyGlobalDiscount(component);
        helper.validate(component);
        helper.resetErrorCode(component);
    },
    onUpliftChange: function(component, event,helper) {
        helper.applyGlobalUplift(component);
        helper.applyGlobalDiscount(component);
        helper.validate(component);
        helper.resetErrorCode(component);
    },
    roundOffDiscounts: function(component, event, helper) {
        var discount = event.getSource().get("v.value");
        if(!discount || isNaN(discount)) {
            discount=0;
        }
        discount = parseFloat(discount).toFixed(2);
        event.getSource().set("v.value",discount);
    },
    onGlobalLicenseTypeChange: function(component, event, helper) {
        var globallicenseType = component.get("v.globalLicenseType");
        var lstProductsAdded = component.get("v.lstProductsAdded");
        for(var prod in lstProductsAdded ) {
            lstProductsAdded[prod].oppyProduct.LicenseType__c = globallicenseType;
        }
         component.set("v.lstProductsAdded",lstProductsAdded);
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
    onProRate: function(component, event, helper) {
        var proRateType = event.getSource().get("v.value");
        if(proRateType === 'Yes') {
            helper.proRateYes(component);
        } 
        else if(proRateType === 'No') {
            helper.proRateNo(component);
        }
    }
})