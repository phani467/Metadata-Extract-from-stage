({
    load : function(component, event, helper) {
        component.set('v.loading', true);
        var ddpLabel = event.getParams().arguments.ddpLabel;
        var objectName = event.getParams().arguments.objectName;
        var objectPluralLabel = event.getParams().arguments.objectPluralLabel;
        component.set('v.ddpLabel', ddpLabel);
        component.set('v.objectName', objectName);
        component.set('v.objectPluralLabel', objectPluralLabel);
        
        // clear data that would not have been cleared out from a previous DocGen Package selection
        component.set('v.hasErrorOccurred', false);
        component.set('v.errorMessage', '');
        
        var action =  component.get('c.getRecentRecords');
        action.setParams({
            'ddpLabel' : ddpLabel,
            'objectName' : objectName,
            'objectPluralLabel' : objectPluralLabel
        });
        action.setCallback(this, function(response) {
            if (response.getState() === 'SUCCESS') {
                var parsedResponse = JSON.parse(response.getReturnValue());
                if (parsedResponse.isSuccess) {
                    component.set('v.records', parsedResponse.records);
                }
                else {
                    helper.fireErrorEvent(component, parsedResponse.errorMessage);
                }
            }
            else {
                helper.fireErrorEvent(component, $A.get('$Label.loop.Generic_Error_Message'));
            }
            
            component.set('v.loading', false);
        });
        $A.enqueueAction(action);
    },
    searchAll : function(component, event, helper) {
        component.set('v.loading', true);
        component.set('v.hasErrorOccurred', false);
        component.set('v.errorMessage', '');

        var action = component.get("c.getAvailableRecords");
        action.setParams({
           'searchString' : event.getParams().arguments.searchString,
           'ddpLabel' : component.get('v.ddpLabel'),
           'objectName' : component.get('v.objectName'),
           'objectPluralLabel' : component.get('v.objectPluralLabel')
        });
        action.setCallback(this, function(response) {
            if (response.getState() === 'SUCCESS') {
                var parsedResponse = JSON.parse(response.getReturnValue());
                if (parsedResponse.isSuccess) {
                   component.set('v.records', parsedResponse.records);
                }
                else {
                   helper.fireErrorEvent(component, parsedResponse.errorMessage);
                }
            }
            else {
                helper.fireErrorEvent(component, $A.get('$Label.loop.Generic_Error_Message'));
            }

            component.set('v.loading', false);
        });
        $A.enqueueAction(action);
    },
    handleError : function(component, event) {
        component.set('v.hasErrorOccurred', true);
        component.set('v.errorMessage', event.getParam('message'));
        event.stopPropagation();
    },
    clearTiles : function(component) {
        component.find('selectTiles').deselectTiles();
    }
})