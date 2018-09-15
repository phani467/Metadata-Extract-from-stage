({
	validateForExistingValues : function(component) {
		var action = component.get("c.validateEventForMeetingCreation");
        action.setParams({"recordId": component.get("v.recordId")});
	    action.setCallback(this, function(response) {
            var state = response.getState();
	        $A.get("e.force:closeQuickAction").fire();
            if(component.isValid() && state === "SUCCESS") {
                var response = response.getReturnValue();
                if(response === 'Create Meeting Note'){
                    //this.createMeetingNote();
                    this.navigateToMyComponent(component);
                } else {
                    this.displayToast('Error',response, 'Error');
                }
            } else {
                console.log('There was a problem and the state is: '+state);
            }
            $A.get('e.force:refreshView').fire();
        });
	    $A.enqueueAction(action);
        //To close the panel for button
	},
    displayToast : function(title, message, typeOfToast){
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "message": message,
            "type": typeOfToast
        });
        toastEvent.fire();
    },
    /*createMeetingNote : function () {
        var createAcountContactEvent = $A.get("e.force:createRecord");
        createAcountContactEvent.setParams({
            "entityApiName": "MeetingNote__c",
            "defaultFieldValues": {
                'Name' : '10/10/2017: Meeting for Opportunity: V testing'
            }
        });
        createAcountContactEvent.fire();
    }, */
    navigateToMyComponent : function(component) {
        var evt = $A.get("e.force:navigateToComponent");
        evt.setParams({
            componentDef : "c:CreateMeetingNoteComponent",
            componentAttributes: {
                "eventId" : component.get("v.recordId")
            }
        });
        evt.fire();
    }
})