({
    getBaseURL : function(cmp) {
    	var action = cmp.get("c.salesforceBaseUrl");
        action.setCallback( this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                cmp.set("v.baseUrl", response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    }
})