({
    //Navigating to ViewEntitlement component
	doInit : function(component, event, helper) {
        var accId = component.get("v.recordId");
		var evt = $A.get("e.force:navigateToComponent");
        evt.setParams({
            componentDef : "c:ViewEntitlement",
            componentAttributes: {
            	accountId: accId
            }
        });
        evt.fire();
	}
})