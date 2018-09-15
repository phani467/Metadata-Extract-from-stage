({
    isCommunity : function(component) {
        var action = component.get("c.isCommunity");
        action.setCallback(this, function(response) {
            var isCommunity = response.getReturnValue(); 
            component.set("v.isCommunity",isCommunity);
        });
        $A.enqueueAction(action);
    },
    navigateLEX : function(oppyId) {
        var evt = $A.get("e.force:navigateToComponent");
        evt.setParams({
            componentDef : "c:productSelectorModal",
            componentAttributes: {
                oppyId :oppyId
            }
        });
        evt.fire();
    },
    navigateCommunity : function(oppyId) {
        console.log("navigateTOUrl");
        console.log("oppyId"+oppyId);
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": "/product-selector?recordId="+oppyId,
            "isredirect":true
        });
        urlEvent.fire();
    }
})