({
    onInit : function(component, event, helper) {
        var recipients = component.get("v.recipients");
        var signingOrder = component.get("v.signingOrder");
        var title = recipients.length === 1 ? "Recipient " + signingOrder : "Recipient Group " + signingOrder;
        component.set("v.title", title);
    },
    closeAllSelectors : function(component, event, helper) {
        var recipientSelectors = component.find("recipientSelector");
        for (var i = 0; i < recipientSelectors.length; i++) {
            recipientSelectors[i].close();
        }
    },
    recipientGroupClicked : function(component, event) {
        var recipientSelectors = component.find("recipientSelector");
        if (recipientSelectors.length) {
            for (var i = 0; i < recipientSelectors.length; i++) {
                if (component.get("v.clickedGlobalId")) {
                    if (component.get("v.clickedGlobalId") !== recipientSelectors[i].getGlobalId()) {
                		recipientSelectors[i].close();
                    }
                }
                else {
                    recipientSelectors[i].close();
                }
            }
        }
        component.set("v.clickedGlobalId", "");
        
        component.getEvent("recipientGroupClicked").setParams({
            globalId: component.getGlobalId(),
            id: component.get("v.signingOrder")
        }).fire();
    },
    handleRecipientSelectorClicked : function(component, event, helper) {
        component.set("v.clickedGlobalId", event.getParam("globalId"));
    }
})