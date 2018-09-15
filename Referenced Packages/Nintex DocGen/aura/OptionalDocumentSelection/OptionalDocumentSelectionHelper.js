({
	fireErrorEvent : function(component, message) {
        var errorEvent = component.getEvent("error");
        errorEvent.setParams({
            message: message
        });
        errorEvent.fire();
	}
})