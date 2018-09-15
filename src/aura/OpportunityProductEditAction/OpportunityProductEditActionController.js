({
    doInit : function(component, event, helper) {
        var action = component.get("c.checkRecordAccessforUser");
        var userId = $A.get("$SObjectType.CurrentUser.Id");
		var oppyId = component.get("v.recordId");
        console.log("oppyid=>"+oppyId);
		console.log('userid'+userId);
        action.setParams({
            "usrId":userId,
            "recordId":oppyId,
            "actionType":"Edit Products"
        });
        console.log("entered into doinit");
        action.setCallback(this, function(response) {
            if (response.getState() == 'SUCCESS') {
                console.log('response'+response.getReturnValue());
                if(response.getReturnValue().isSuccess) {
                    var isCommunity = component.get("v.isCommunity");
                    console.log("isCommunity=>"+isCommunity);
                    helper.isCommunity(component);
                } else {
                    var dismissActionPanel = $A.get("e.force:closeQuickAction");
                    dismissActionPanel.fire();
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Insufficient Access",
                        "message":response.getReturnValue().validationMessage,
                        "mode":"dismissible",
                        "type":"error",
                        "duration":"3000"
                    });
                    toastEvent.fire();
                    return;
                }
        	}
        });
        $A.enqueueAction(action);                
    }
})