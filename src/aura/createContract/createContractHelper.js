({
	isCommunity : function(component) {
        var action = component.get("c.isCommunity");
        action.setCallback(this, function(response) {
            var isCommunity = response.getReturnValue(); 
            component.set("v.isCommunity",isCommunity);
        });
        $A.enqueueAction(action);
    },
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
    },  
	
    refreshView : function() {
        return new Promise($A.getCallback(function(resolve, reject) {
            //To refresh the view
            $A.get('e.force:refreshView').fire();
            resolve(true); 
        }));
	},
    
    handleCallBackInPromiseFashion : function(component, event, helper) {
        helper.refreshView()
        .then(
            // resolve handler
            $A.getCallback(function(result) {
                $A.get("e.force:closeQuickAction").fire();
            }),    
            // reject handler
            $A.getCallback(function(error) {
                alert("Promise was rejected: " +  error);
            })
    	)
        .then(
            // resolve handler
            $A.getCallback(function(result) {
                var recordId = component.get('v.createdRecordId');
                var editRecordEvent = $A.get("e.force:editRecord");
                editRecordEvent.setParams( {
                    "recordId": recordId                                  
                });
               editRecordEvent.fire();
            }) 
        )
    }

})