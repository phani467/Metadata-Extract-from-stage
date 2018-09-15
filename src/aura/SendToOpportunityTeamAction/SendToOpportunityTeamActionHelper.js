({
	validateForEmailSending : function(component) {
		var action = component.get("c.validateEmailSending");
        action.setParams({"mnId": component.get("v.recordId"),
                          "launchedFrom": "OpportunityTeam"
                         });
	    action.setCallback(this, function(response) {
            var state = response.getState();
	        $A.get("e.force:closeQuickAction").fire();
            if(component.isValid() && state === "SUCCESS") { 
                var response = response.getReturnValue();
                if(response === 'SendEmail') {
                    this.navigateToMyComponent(component);
                } else {
                    this.displayToast('Error',response, 'Error');
                }
            } else if(state === "ERROR") {
                var errors = response.getError();
                helper.displayToast('Error',errors[0].message, 'Error');
            }
        });
	    $A.enqueueAction(action);
	},
    displayToast : function(title, message, typeOfToast) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "message": message,
            "type": typeOfToast
        });
        toastEvent.fire();
    },
    navigateToMyComponent : function(component) {
        var evt = $A.get("e.force:navigateToComponent");
        evt.setParams({
            componentDef : "c:SendMeetingNoteEmail",
            componentAttributes: {
                "mnId" : component.get("v.recordId"),
                "launchedFrom" : "OpportunityTeam"
            }
        });
        evt.fire();
    }
})