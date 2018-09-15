({
    load : function(component, event, helper) {
        component.set("v.loading", true);
        
        // clear data that would not have been cleared out from a previous DocGen Package selection
        component.set('v.hasErrorOccurred', false);
        component.set('v.errorMessage', '');
        
        var ddpId = event.getParam("arguments").ddpId;
        var recordId = event.getParam("arguments").recordId;
        var selectedContactId = event.getParam("arguments").selectedContactId;
        
        var selectedDeliveryOptionId = component.get("v.selectedDeliveryOptionId");
        
        component.set('v.ddpId', ddpId);
        
        var action = component.get("c.getDeliveryOptions");
        action.setParams({
            recordId : recordId,
            ddpId: ddpId,
            contactId: selectedContactId
        });
        action.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                var parsedResponse = JSON.parse(response.getReturnValue());
                if (parsedResponse.isSuccess) {
                    component.set("v.records", parsedResponse.deliveryOptions);
                }
                else {
                    helper.fireErrorEvent(component, parsedResponse.errorMessage);
                }
            }
            else {
                helper.fireErrorEvent(component, $A.get('$Label.loop.Generic_Error_Message'));
            }

            component.set("v.loading", false);
        });
        $A.enqueueAction(action);
    },
    search : function(component, event, helper) {
        var searchString = event.getParams().arguments.searchString;
        component.find('deliveryTiles').search(searchString);
    },
    handleErrorEvent : function(component, event) {
        component.set("v.hasErrorOccurred", true);
        component.set("v.errorMessage", event.getParam("message"));
        event.stopPropagation();
    }
})