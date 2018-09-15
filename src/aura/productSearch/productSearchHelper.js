({
    clearLists : function(component) {
        component.set("v.lstProductsSelected",[]);
        component.set("v.lstProductsSearched",[]);
        component.set("v.familyName",'');
        component.set("v.productName",'');
        component.set("v.materialNumber",'');
        component.set("v.businessLine",'');
        component.set("v.subBusinessLine",'');
        component.set("v.profitCenter",'');
        component.set("v.internalProductName",'');
        component.set("v.mediaType",'');
    },
    addScrollListener : function(component,event) {
        var scrollCheckIntervalId = component.get('v.scrollCheckIntervalId');
        if(scrollCheckIntervalId) {
            //interval id already exists. on scroll listener already added
            return;
        }
        var didScrolled;
        var div = component.find('scrollContainer');
        console.log('div'+ div);
        if(!$A.util.isEmpty(div)) {
            div = div.getElement();
            div.onscroll = function() {
                didScrolled = true;
            };
            //Interval function to check if the user scrolled or if there is a scrollbar
            scrollCheckIntervalId = setInterval($A.getCallback(function() {
                if(didScrolled ) {
                    didScrolled = false;                        
                    //if all products are already loaded no further trips to server are required
                    if(component.get("v.allProductsLoaded")) {
                        return;
                    }
                    var spinner= component.find("productSpinner");
                    if(div.scrollTop === (div.scrollHeight - div.offsetHeight)) {
                        var existingProducts = component.get("v.lstProductsSearched");
                        var offset = existingProducts.length;
                        console.log('offset'+offset);
                        if(offset >= 2000) {
                            console.log('offset'+offset);
                            //offset limit has been reached
                            component.set("v.offsetLimitReached",true);
							$A.util.addClass(spinner,"slds-hide");
                        	$A.util.removeClass(spinner,"slds-show");                            
                            return;
                        }
                        if(offset===0) {
                            //exit the scroll as list does not have products
                            return;
                        }
                        console.log('scroll reached at the end')
                        ////////////////////////////////////////////////////////
                        // Code for fetching more products. Couldn't make it modular as setinterval is not able to get 
                        // fetchProducts method
                        //
                        
                        $A.util.addClass(spinner,"slds-show");
                        $A.util.removeClass(spinner,"slds-hide");
                        var lstSearchedProducts = component.get("v.lstProductsSearched");
                        var familyName = (component.get("v.familyName")===null || component.get("v.familyName")===undefined)?'': component.get("v.familyName");
                        var productName = (component.get("v.productName")===null || component.get("v.productName")===undefined)?'': component.get("v.productName");
                        var materialNumber = (component.get("v.materialNumber")===null || component.get("v.materialNumber")===undefined)?'': component.get("v.materialNumber");
                        var businessLine = (component.get("v.businessLine")===null || component.get("v.businessLine")===undefined)?'': component.get("v.businessLine");
                        var subBusinessLine = (component.get("v.subBusinessLine")===null || component.get("v.subBusinessLine")===undefined)?'': component.get("v.subBusinessLine");
                        var profitCenter = (component.get("v.profitCenter")===null || component.get("v.profitCenter")===undefined)?'': component.get("v.profitCenter");
                        var internalProductName = (component.get("v.internalProductName")===null || component.get("v.internalProductName")===undefined)?'': component.get("v.internalProductName");
                        var mediaType = (component.get("v.mediaType")===null || component.get("v.mediaType")===undefined)?'': component.get("v.mediaType");
                        var legalEntity = (component.get("v.legalEntity")===null || component.get("v.legalEntity")===undefined)?'': component.get("v.legalEntity");
                        if(familyName.length>1 ||productName.length>0 ||materialNumber.length>0 
                           || businessLine.length>0 || subBusinessLine.length>0 || profitCenter.length>0
                           || internalProductName.length>0 || mediaType.length>0) {
                            var selectedProductIds = [];
                            var selectedProducts = component.get("v.lstProductsSelected");
                            if(selectedProducts!==undefined && selectedProducts!==null) {
                                for(var prod in selectedProducts) {
                                    selectedProductIds.push(selectedProducts[prod].productId);
                                }
                            }
                            var productsInOppy = component.get("v.productsAlreadyInOppy");
                            if(productsInOppy!==undefined && productsInOppy!==null) {
                                for(var prod in productsInOppy) {
                                    selectedProductIds.push(productsInOppy[prod]);
                                }
                            }
                            
                            var action = component.get("c.getProducts");
                            action.setParams({ familyName : familyName,                                              
                                              productName : productName,
                                              materialNumber: materialNumber,
                                              businessLine: businessLine,
                                              subBusinessLine : subBusinessLine,
                                              profitCenter : profitCenter,
                                              mediaType: mediaType,
                                              internalProductName : internalProductName,
                                              legalEntity : legalEntity,
                                              lastMaterialCode : existingProducts[offset-1].product.MaterialCode__c });
                            action.setCallback(this,function(response) {
                                var state = response.getState();
                                if(state ==="SUCCESS") {
                                    var result = response.getReturnValue();
                                    if(result!==undefined && result!==null) {
                                        if(result.length ===0) {
                                            component.set("v.allProductsLoaded",true);
                                        }
                                        lstSearchedProducts.push.apply(lstSearchedProducts,result);
                                        component.set("v.lstProductsSearched",lstSearchedProducts);
                                        console.log(result);
                                    }                    
                                } else if(state == "Error") {
                                    alert("An error has occured please contact Salesforce Helpdesk");
                                }
                                $A.util.addClass(spinner,"slds-hide");
                        		$A.util.removeClass(spinner,"slds-show");
                            });
                            $A.enqueueAction(action);
                        }
                        //                        
                        //                         
                    }
                }
            }), 1000);
            component.set('v.scrollCheckIntervalId', scrollCheckIntervalId);
        }
    },
    fetchProducts : function(component) {
        var lstSearchedProducts = component.get("v.lstProductsSearched");
        var familyName = (component.get("v.familyName")===null || component.get("v.familyName")===undefined)?'': component.get("v.familyName");
        var productName = (component.get("v.productName")===null || component.get("v.productName")===undefined)?'': component.get("v.productName");
        var materialNumber = (component.get("v.materialNumber")===null || component.get("v.materialNumber")===undefined)?'': component.get("v.materialNumber");
        var businessLine = (component.get("v.businessLine")===null || component.get("v.businessLine")===undefined)?'': component.get("v.businessLine");
        var subBusinessLine = (component.get("v.subBusinessLine")===null || component.get("v.subBusinessLine")===undefined)?'': component.get("v.subBusinessLine");
        var profitCenter = (component.get("v.profitCenter")===null || component.get("v.profitCenter")===undefined)?'': component.get("v.profitCenter");
        var internalProductName = (component.get("v.internalProductName")===null || component.get("v.internalProductName")===undefined)?'': component.get("v.internalProductName");
        var mediaType = (component.get("v.mediaType")===null || component.get("v.mediaType")===undefined)?'': component.get("v.mediaType");
        var legalEntity = (component.get("v.legalEntity")===null || component.get("v.legalEntity")===undefined)?'': component.get("v.legalEntity");
        if(familyName.length>1 ||productName.length>0 ||materialNumber.length>0 
           || businessLine.length>0 || subBusinessLine.length>0 || profitCenter.length>0
           || internalProductName.length>0 || mediaType.length>0) {
            var selectedProductIds = [];
            var selectedProducts = component.get("v.lstProductsSelected");
            if(selectedProducts!==undefined && selectedProducts!==null) {
                for(var prod in selectedProducts) {
                    selectedProductIds.push(selectedProducts[prod].productId);
                }
            }
            var productsInOppy = component.get("v.productsAlreadyInOppy");
            if(productsInOppy!==undefined && productsInOppy!==null) {
                for(var prod in productsInOppy) {
                    selectedProductIds.push(productsInOppy[prod]);
                }
            }
            
            var action = component.get("c.getProducts");
            action.setParams({ familyName : familyName,                              
                              productName : productName,
                              materialNumber: materialNumber,
                              businessLine: businessLine,
                              subBusinessLine : subBusinessLine,
                              profitCenter : profitCenter,
                              mediaType: mediaType,
                              internalProductName : internalProductName,
                              legalEntity : legalEntity
                             });
            action.setCallback(this,function(response) {
                var state = response.getState();
                if(state ==="SUCCESS") {
                    var result = response.getReturnValue();
                    if(result!==undefined && result!==null) {
                        lstSearchedProducts.push.apply(lstSearchedProducts,result);
                        component.set("v.lstProductsSearched",lstSearchedProducts);
                        console.log(result);
                    }                    
                } else if(state == "Error") {
                    alert("An error has occured please contact Salesforce Helpdesk");
                }
            });
            $A.enqueueAction(action);
        }
    }
    
})