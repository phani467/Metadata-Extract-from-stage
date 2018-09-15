({
    validate : function(component) {
        //validate for negative values
        var save = component.find("save");
        save.set("v.disabled",false);
        var showError = false;       
        component.set("v.showErrorMessage",showError);
        var savedProducts = component.get("v.lstProducts");
        for (var key in savedProducts) {
            for(var ps in savedProducts[key].lstProductsSelected) {
                if(savedProducts[key].lstProductsSelected[ps].totalPrice<0){
                    save.set("v.disabled",true);
                    showError=true;
                    component.set("v.showErrorMessage",showError);
                    break;
                }                
            }            
        }
    },
    applyGlobalDiscount : function(component) {
        var lstProducts = component.get("v.lstProducts");
        var discountType = component.get("v.globalDiscountType");
        var globalDiscount = component.get("v.globalDiscountValue");
        var globalDiscountStep = component.get("v.globalDiscountStep");
        for(var key in lstProducts) {
            lstProducts[key].discountType = discountType;
            var stepCounter = 1;
            for(var prod in lstProducts[key].lstProductsSelected) {
                
                var calculatedDiscount ;
                calculatedDiscount = globalDiscount*stepCounter;
                if(globalDiscountStep === "Step down") {
                    calculatedDiscount = globalDiscount/stepCounter;
                }
                if(discountType=="Amount") {
                    lstProducts[key].lstProductsSelected[prod].discountAmount = calculatedDiscount;
                    lstProducts[key].lstProductsSelected[prod].discountPercent =(calculatedDiscount/lstProducts[key].lstProductsSelected[prod].externalListPrice)*100;
                    
                }else if(discountType=="Percentage"){
                    lstProducts[key].lstProductsSelected[prod].discountPercent = calculatedDiscount;
                    lstProducts[key].lstProductsSelected[prod].discountAmount = (calculatedDiscount/100)*lstProducts[key].lstProductsSelected[prod].externalListPrice;
                }else {
                    lstProducts[key].lstProductsSelected[prod].discountPercent = 0.0;
                    lstProducts[key].lstProductsSelected[prod].discountAmount = 0.0;
                    
                }
                lstProducts[key].lstProductsSelected[prod].salesPrice = lstProducts[key].lstProductsSelected[prod].externalListPrice - lstProducts[key].lstProductsSelected[prod].discountAmount;
                lstProducts[key].lstProductsSelected[prod].totalPrice=lstProducts[key].lstProductsSelected[prod].salesPrice*lstProducts[key].productQty;
                if(globalDiscountStep.indexOf("Step")>=0) {
                    stepCounter++;
                }
                
                lstProducts[key].lstProductsSelected[prod].discountPercent = parseFloat(lstProducts[key].lstProductsSelected[prod].discountPercent).toFixed(2);
                lstProducts[key].lstProductsSelected[prod].discountAmount = parseFloat(lstProducts[key].lstProductsSelected[prod].discountAmount).toFixed(2);
                lstProducts[key].lstProductsSelected[prod].salesPrice = parseFloat(lstProducts[key].lstProductsSelected[prod].salesPrice).toFixed(2);
                lstProducts[key].lstProductsSelected[prod].totalPrice = parseFloat(lstProducts[key].lstProductsSelected[prod].totalPrice).toFixed(2);
                
            }
        }
        component.set("v.lstProducts",lstProducts);
        if(discountType=="No Discount") {
            component.set("v.globalDiscountValue",0);
        }
    },
    resetErrorCode : function(component) {
        component.set("v.resetErrors",false);
        component.set("v.resetErrors",true);
    },
    validateLicense : function(component) {
        //check if any field has invalid input
        //check for license type
        var lstProducts = component.get("v.lstProducts");
        var listSize = lstProducts.length;
        var isValid = true;
        var licenseTypeField=[];
        licenseTypeField = component.find("licenseTypes");
        if (!licenseTypeField) {
            return true;
        }
        licenseTypeField = [].concat(licenseTypeField);
        licenseTypeField.forEach( cmp => {
            var validity = cmp.get("v.validity");
            if(!cmp.get("v.validity").valid) {            		                             
            //cmp.set("v.validity", {valid:false, valueMissing :true});
            isValid=false;
            cmp.showHelpMessageIfInvalid();            
        }
                                 })
        return isValid;
    },
    applyGlobalUplift: function(component) {
        var lstProducts = component.get("v.lstProducts");
        var upliftpercent = component.get("v.globalUplift");
        console.log('--upliftpercent--'+upliftpercent);
        for (var key in lstProducts) {
            var year = 1;
            var previousListPrice = 0;
            for (var prod in lstProducts[key].lstProductsSelected) { 
                var percentIncrease = 0.0;
                if(year>1) {
                    console.log("previousListPrice=>" + previousListPrice);
                    console.log("percentIncrease=>" + percentIncrease);
                    percentIncrease = parseFloat(upliftpercent * previousListPrice / 100).toFixed(2);                
                    console.log("percentIncrease=>" + percentIncrease);
                    lstProducts[key].lstProductsSelected[prod].externalListPrice = (parseFloat(previousListPrice).toFixed(2) * 1) + (parseFloat(percentIncrease).toFixed(2) * 1);                    
                    //lstProducts[key].lstProductsSelected[prod].externalListPrice = parseFloat(lstProducts[key].lstProductsSelected[prod].externalListPrice).toFixed(2);                    
                }
                previousListPrice = lstProducts[key].lstProductsSelected[prod].externalListPrice;
                year++;
            }            
        }
         component.set("v.lstProducts", lstProducts);
    }
})