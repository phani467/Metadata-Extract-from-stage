({
	load : function(component, event, helper) {
        component.set("v.loading", true);
        
        // clear data that would not have been cleared out from a previous DocGen Package selection
        component.set('v.hasErrorOccurred', false);
        component.set('v.errorMessage', '');
        
        var action = component.get("c.contactOptions");
        var contactId = component.get("v.contactId");
        var accountId = component.get("v.accountId");
        var recordId = event.getParam("arguments").recordId;
        var contactRequired = event.getParam("arguments").contactRequired;
        action.setParams({
            "contactNameSearch" : component.get("v.contactNameSearch"),
            "recordId" : recordId,
            "contactId" : contactId,
            "accountId" : accountId,
            "contactRequired" : contactRequired
        });
        action.setCallback(this, function(response){
            if (response.getState() === "SUCCESS") {
                var parsedResponse = JSON.parse(response.getReturnValue());
                if (parsedResponse.isSuccess) {
                    component.set("v.records", parsedResponse.contacts);
                }
                else {
                    //So far, there is only one scenario where isSuccess is false.
                    //If we find other ways this can error, then we'll have to change this error handling.
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
        component.find('contactTiles').search(searchString);
    },
    handleError : function(component, event) {
        component.set("v.hasErrorOccurred", true);
        component.set("v.errorMessage", event.getParam("message"));
        event.stopPropagation();
    }
})