({
    onChange : function(component, event, helper) {
        var toggle = event.getSource();
        component.set('v.connectedAppsEnabled', toggle.get('v.checked'));
    },
    save : function(component, event, helper) {
        var enabled = component.get('v.connectedAppsEnabled');

        var action = component.get('c.enableDisableOrgOAuth');
        action.setParams({ 'selection' : enabled });
        action.setCallback(this, function(response) {
            var moveToNextStep = component.getEvent('moveToNextStep');
            moveToNextStep.setParams({success: true}).fire();

            var connectedAppsToggled = component.getEvent('actionEvent');
            connectedAppsToggled.setParams({
                action: 'connectedAppsChanged',
                params: JSON.stringify({'connectedAppsEnabled': enabled})
            });
            connectedAppsToggled.fire();
        });
        $A.enqueueAction(action);
    }
})