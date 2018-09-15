({
    doInit : function(component, event, helper) {
        var action = component.get("c.getRelatedOppySplits");
        var oppyId = component.get("v.recordId");
        action.setParams({
            "oppyId":oppyId
        });
        action.setCallback(this, function(response) {
            console.log("state >> "+ response.getState());
            if (response.getState() == 'SUCCESS') {
                var result = response.getReturnValue();
                component.set("v.oppySplitWrap",result);
            }
        });
        $A.enqueueAction(action);
    },
    moveToOppySplit: function(component, event, helper) {
        var environmentType = component.get("v.environmentType");
        if(environmentType==="Community") {
            var oppyId = component.get("v.recordId");
            var urlEvent = $A.get("e.force:navigateToURL");
            urlEvent.setParams({
                "url": "/opportunity-split-edit?recordId="+oppyId
            });
            urlEvent.fire();
        } else if(environmentType==="Lightning") {
            var evt = $A.get("e.force:navigateToComponent");
            var oppySplitWrap = component.get("v.oppySplitWrap");
            evt.setParams({
                componentDef : "c:OpportunitySplitEdit",
                componentAttributes:{
                    oppySplitWrap :oppySplitWrap
                }
            });
            evt.fire();
        }
        
    }
})