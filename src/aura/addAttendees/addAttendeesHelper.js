({

	callToServer : function(component, method, callback, params) {
		var action = component.get(method);
        if(params) {
            action.setParams(params);
        }
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                callback.call(this,response.getReturnValue());
            }else if(state === "ERROR") {
                var errors = response.getError();
                helper.displayToast('Error',errors[0].message, 'Error');
            }
        });
		$A.enqueueAction(action);
    },
    navigateToObject : function(params){
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams(params);
        navEvt.fire();
	},
    displayToast : function(title, message, typeOfToast){
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "message": message,
            "type": typeOfToast
        });
        toastEvent.fire();
    }

})