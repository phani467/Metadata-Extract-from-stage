({
    doInit : function(component, event, helper) {
        //check whether the context is LEX or community
        var environmentType = component.get("v.environmentType");
        if(environmentType==="Community") {
            //fetch oppyId
            var oppyId = component.get("v.oppyId");
            //if oppyId is not loaded at load
            if(!oppyId) {
                oppyId = helper.getParameterByName(component , event, 'recordId');
                component.set("v.oppyId", oppyId);
            }
            if(oppyId) {
                var action = component.get("c.getRelatedOppySplits");
                action.setParams({
                    "oppyId":oppyId
                });
                action.setCallback(this, function(response) {
                    console.log("state >> "+ response.getState());
                    if (response.getState() == 'SUCCESS') {
                        var result = response.getReturnValue();
                        component.set("v.oppySplitWrap",result);
                        helper.renderOppySplitWrap(component);
                    }
                });
                $A.enqueueAction(action);
            }
            
        } else if(environmentType==="Lightning") {
            //wrapper class would be passed from the navigateToComponent
                helper.renderOppySplitWrap(component);            
        }
    },
    back : function(component,event,helper) {
        var oppyId = component.get("v.oppySplitWrap.oppy.Id");
        helper.goBack(oppyId);
    },
    deleteItem: function(component,event,helper) {
        var buttonClicked = event.getSource().get("v.name");
        console.log('buttonClicked=='+buttonClicked);
        var index = buttonClicked.charAt(0);
        if(buttonClicked.includes("revenue")) {
            var lstOppySplitRevenue = component.get("v.lstOppySplitRevenue");            
            lstOppySplitRevenue.splice(index,1);
            component.set("v.lstOppySplitRevenue",lstOppySplitRevenue);
            var lstOppySplitRevenue = component.get("v.lstOppySplitRevenue");
            var revenueTotal = helper.calculateTotal(lstOppySplitRevenue);
            component.set("v.revenueTotal",revenueTotal);
            
        }
        if(buttonClicked.includes("overlay")) {
            var lstOppySplitOverlay = component.get("v.lstOppySplitOverlay");
            var lstOppySplitOverlayDel = component.get("v.lstOppySplitOverlayDel");
            if(lstOppySplitOverlay[index].Id) {
                lstOppySplitOverlayDel.push(lstOppySplitOverlay[index]);
                component.set("v.lstOppySplitOverlayDel",lstOppySplitOverlayDel);
            }
            lstOppySplitOverlay.splice(index,1);
            component.set("v.lstOppySplitOverlay",lstOppySplitOverlay);
            var lstOppySplitOverlay = component.get("v.lstOppySplitOverlay");
            var overlayTotal =  helper.calculateTotal(lstOppySplitOverlay);
            component.set("v.overlayTotal",overlayTotal);
        }
        
    },
    addnewItem : function(component,event,helper) {
        var oppyId = component.get("v.oppySplitWrap.oppy.Id");        
        var splitTypeMap = component.get("v.oppySplitWrap.mapSplitTypes");
        var tabType = event.getSource().get("v.name");
        var oppySplit = {'sobjectType':'OpportunitySplit','OpportunityId':oppyId,'SplitTypeId':splitTypeMap[tabType]
                         ,'SplitOwnerId':'','SplitPercentage':0,'SplitAmount':0,'SplitNote':''};
        if(tabType==='Revenue') {
            var lstOppySplitRevenue = component.get("v.lstOppySplitRevenue");
            lstOppySplitRevenue.push(oppySplit);
            component.set("v.lstOppySplitRevenue",lstOppySplitRevenue);
        }
        if(tabType==='Overlay') {
            var lstOppySplitOverlay = component.get("v.lstOppySplitOverlay");
            lstOppySplitOverlay.push(oppySplit);
            component.set("v.lstOppySplitOverlay",lstOppySplitOverlay);
        }
        
    },
    onRevenueSplitChange : function(component,event,helper) {
        var lstOppySplitRevenue = component.get("v.lstOppySplitRevenue");
        lstOppySplitRevenue = helper.onPercentChange(lstOppySplitRevenue,event,component);
        component.set("v.lstOppySplitRevenue",lstOppySplitRevenue);
    },
    onOverlaySplitChange : function(component,event,helper) {
        var lstOppySplitOverlay = component.get("v.lstOppySplitOverlay");
        lstOppySplitOverlay = helper.onPercentChange(lstOppySplitOverlay,event,component);
        component.set("v.lstOppySplitOverlay",lstOppySplitOverlay);
    },
    calculateRevenueTotal : function(component,event,helper) {
        var lstOppySplitRevenue = component.get("v.lstOppySplitRevenue");
        var revenueTotal = helper.calculateTotal(lstOppySplitRevenue);
        component.set("v.revenueTotal",revenueTotal);
    },
    calculateOverlayTotal: function(component, event,helper) {
        var lstOppySplitOverlay = component.get("v.lstOppySplitOverlay");
        var overlayTotal =  helper.calculateTotal(lstOppySplitOverlay);
        component.set("v.overlayTotal",overlayTotal);
    },
    saveOverlayOppySplits:function(component,event,helper) {
        var buttonName = event.getSource().get("v.name");        
        var lstOppySplitOverlay = component.get("v.lstOppySplitOverlay");
        var lstOppySplitOverlayDel = component.get("v.lstOppySplitOverlayDel");
        var oppyId = component.get("v.oppySplitWrap.oppy.Id");
        var action = component.get("c.saveOverlaySplits");
        action.setParams({
            "oppyId":oppyId,
            "lstOppySplit":lstOppySplitOverlay,
            "lstOppySplitDel":lstOppySplitOverlayDel
        });
        action.setCallback(this, function(response) {
            //console.log("state >> "+ response.getState());
            var toastEvent = $A.get("e.force:showToast");
            var result = response.getReturnValue();
            console.log("function called");
            console.log(result);
            var message = result.message;
            if (response.getState() == 'SUCCESS') {
                if(message.indexOf("Error occurred")!==-1) {
                    toastEvent.setParams({
                        "title": "Oops!",
                        "message":message,
                        "mode":"sticky",
                        "type":"error"
                        
                    });
                    toastEvent.fire();
                    return;
                }
                toastEvent.setParams({
                    "title": "Records updated!",
                    "message":message,
                    "mode":"dismissible",
                    "type":"success"
                    
                });
                toastEvent.fire();
                var lstOppySplitOverlayDel = [];
                component.set("v.lstOppySplitOverlayDel",lstOppySplitOverlayDel);
                var lstOppySplitOverlay = result.lstResultOppySplits;
                component.set("v.lstOppySplitOverlay",lstOppySplitOverlay);
                if(buttonName==="close") {
                    var oppyId = component.get("v.oppySplitWrap.oppy.Id");
                    helper.goBack(oppyId);
                }
            } else {
                toastEvent.setParams({
                    "title": "Oops!",
                    "message":'Something went wrong '+message,
                    "mode":"sticky",
                    "type":"error"                    
                });
                toastEvent.fire();
                return;
            }
        });
        $A.enqueueAction(action);
        
    },
    saveRevenueOppySplits : function (component, event, helper) {
        var buttonName = event.getSource().get("v.name");        
        var lstOppySplitRevenue = component.get("v.lstOppySplitRevenue");
        var oppyId = component.get("v.oppySplitWrap.oppy.Id");
        var action = component.get("c.saveRevenueSplits");
        console.log("--Saving revenue--");
        action.setParams({
            "oppyId":oppyId,
            "lstOppySplit":lstOppySplitRevenue
        });
        console.log("--lstOppySplitRevenue--"+lstOppySplitRevenue);
        console.log("--action--" + action);
        action.setCallback(this, function(response) {
            console.log("--revenue function called--");
            var toastEvent = $A.get("e.force:showToast");
            var result = response.getReturnValue();
            var message = result.message;
            console.log("revenue function called");
            if (response.getState() == 'SUCCESS') {
                if(message.indexOf("Error occurred")!==-1) {
                    toastEvent.setParams({
                        "title": "Oops!",
                        "message":message,
                        "mode":"sticky",
                        "type":"error"                        
                    });
                    toastEvent.fire();
                    return;
                }
                toastEvent.setParams({
                    "title": "Records updated!",
                    "message":message,
                    "mode":"dismissible",
                    "type":"success"                    
                });
                toastEvent.fire();
                var lstOppySplitRevenue = result.lstResultOppySplits;
                component.set("v.lstOppySplitRevenue",lstOppySplitRevenue);
                if(buttonName==="close") {
                    var oppyId = component.get("v.oppySplitWrap.oppy.Id");
                    helper.goBack(oppyId);
                }
            } else {
                toastEvent.setParams({
                    "title": "Oops!",
                    "message":'Something went wrong '+message,
                    "mode":"sticky",
                    "type":"error"                    
                });
                toastEvent.fire();
                return;
            }
        });
        $A.enqueueAction(action);
        
    },
    validOverlay : function(component,event,helper) {
        console.log('--validation called overlay--');
        helper.validateOverlay(component);
    },
    validRevenue : function(component,event,helper) {
        console.log('--validation called revenue--');
        helper.validateRevenue(component);
    }
})