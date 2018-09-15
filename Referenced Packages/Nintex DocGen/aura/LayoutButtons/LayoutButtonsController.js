({
    onInit : function(component, event, helper) {
        var actionEvent = component.getEvent('actionEvent');
        actionEvent.setParams({
            action: 'doneLoading'
        });
        actionEvent.fire();
    },
	handleActionEvent : function(component, event, helper) {
        var action = event.getParam('action');
        var params = event.getParam('params');
        
        switch (action) {
            case 'oAuthStatusUpdate':
            case 'oAuthInitDoneLoading':
                params = JSON.parse(params);
                component.set('v.isAuthorized', params.isAuthorized);

                var actionEvent = component.getEvent('actionEvent');
                actionEvent.setParams({
                    action: 'doneLoading'
                });
                actionEvent.fire();
                break;
            case 'filterLayouts':
                helper.filterLayouts(component, event);
                break;
            default:
                break;
        }
	},
    save : function(component) {
        component.find("layoutButtonTable").save();
    },
    startOAuthFlow : function(component, event) {
        var authorizeLoopServices = component.find('authorizeLoopServices');
        authorizeLoopServices.startOAuthFlow();
    }
})