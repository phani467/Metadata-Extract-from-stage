({
    load : function(component, event, helper) {
        component.set("v.loading", true);
        
        // clear data that would not have been cleared out from a previous DocGen Package selection
        component.set('v.hasErrorOccurred', false);
        component.set('v.errorMessage', '');
        
        var action =  component.get("c.getAvailableDdps");
        action.setParams({
            "recordId" : event.getParams().arguments.recordId,
            "ddpIds" : event.getParams().arguments.ddpIds,
            "filter" : event.getParams().arguments.filter,
            "filterType" : event.getParams().arguments.filterType,
            "ddpLabel" : event.getParams().arguments.ddpLabel
        });
        action.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                var parsedResponse = JSON.parse(response.getReturnValue());
                if (parsedResponse.isSuccess) {
                    component.set("v.records", parsedResponse.ddps);
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
        component.find('selectTiles').search(searchString);
    },
    handleError : function(component, event) {
        component.set("v.hasErrorOccurred", true);
        component.set("v.errorMessage", event.getParam("message"));
        event.stopPropagation();
    },
    clearTiles : function(component) {
        component.find("selectTiles").deselectTiles();
    }
})