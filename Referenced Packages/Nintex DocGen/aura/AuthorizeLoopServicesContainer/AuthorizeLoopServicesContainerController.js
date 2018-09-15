({
    handleActionEvent : function(component, event, helper) {
        var action = event.getParam('action');
        var params = event.getParam('params');

        switch (action) {
            case 'oAuthInitStartLoading':
                component.set('v.isAuthLoading', true);
                break;
            case 'oAuthInitDoneLoading':
                component.set('v.isAuthLoading', false);

                var actionEvent = component.getEvent('actionEvent');
                actionEvent.setParams({
                    action: 'doneLoading'
                });
                actionEvent.fire();
                break;
            case 'oAuthStartLoading':
                component.set('v.isAuthLoading', true);
                break;
            case 'oAuthDoneLoading':
                component.set('v.isAuthLoading', false);
                break;
            case 'oAuthError':
                var errorEvent = component.getEvent('showError');
                errorEvent.setParams({
                    message: params
                });
                errorEvent.fire();
                break;
            default:
                break;
        }
    },
    startOAuthFlow : function(component, event) {
        var authorizeLoopServices = component.find('authorizeLoopServices');
        authorizeLoopServices.startOAuthFlow();
    }
})