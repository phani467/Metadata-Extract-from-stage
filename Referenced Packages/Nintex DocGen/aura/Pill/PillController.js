({
	removePill : function(component, event, helper) {
		var removePillEvent = component.getEvent("removePill");
        removePillEvent.setParams({
            id: component.get("v.id")
        });
        removePillEvent.fire();
	}
})