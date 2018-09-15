({
    isCommunity : function(component) {
		
        var action = component.get("c.isCommunity");
        var oppyId = component.get("v.recordId");
        action.setCallback(this, function(response) {
            var isCommunity = response.getReturnValue();          
            if(isCommunity) {                
                this.navigateCommunity(oppyId);
            } else {
                this.navigateLEX(component,oppyId);
            }
        });
        $A.enqueueAction(action);
    },
    navigateLEX : function(component,oppyId) {
		
        var evt = $A.get("e.force:navigateToComponent");
        evt.setParams({
            componentDef : "c:OpportunityProductEditPage",
            componentAttributes: {
                oppyId :oppyId
            }
        });
        evt.fire();
    },
    navigateCommunity : function(oppyId) {
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": "/edit-opportunity-products?recordId="+oppyId,
            "isredirect":true
        });
        urlEvent.fire();
    }
})