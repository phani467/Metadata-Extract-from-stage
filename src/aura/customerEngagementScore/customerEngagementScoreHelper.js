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
            }
            else if(state === "ERROR") {
                alert('Problem with connection. Please try again.');
            }
        });
		$A.enqueueAction(action);
    }
})