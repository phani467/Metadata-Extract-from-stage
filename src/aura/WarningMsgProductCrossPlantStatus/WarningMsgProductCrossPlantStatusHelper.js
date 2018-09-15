({
	callToServer : function(component, method, callback, params) {
		var action = component.get(method);
        if(params) {
            action.setParams(params);
        }
        action.setCallback(this, function(response) {           
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.listOfProducts",response.getReturnValue());
                console.log("res==="+response.getReturnValue());
                callback.call(this,response.getReturnValue());
            } else if( state === "ERROR" ) {
                alert('Please try again.'+response.getError());
            }
        });
		$A.enqueueAction(action);
    }
})