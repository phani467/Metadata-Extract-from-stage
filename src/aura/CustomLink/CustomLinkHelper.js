({
	callToServer : function(component, method,callback) {
		var action = component.get(method);
        action.setCallback(this, function(response) {
           
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log(response.getReturnValue());
                callback.call(this,response.getReturnValue());
            }else if(state === "ERROR") {
                alert('Please try again.'+response.getError());
            }
        });
		$A.enqueueAction(action);
    }
})