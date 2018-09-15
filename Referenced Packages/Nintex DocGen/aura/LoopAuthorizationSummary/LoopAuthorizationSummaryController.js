({
    handleActionEvent : function(component, event) {
        var action = event.getParam('action');
        var params = event.getParam('params');
        
        switch (action) {
            case 'oAuthStatusUpdate':
                params = JSON.parse(params);
                
                var isAuthorized = component.get('v.isAuthorized') || params.isAuthorized;
                component.set('v.isAuthorized', isAuthorized);
                
                if (isAuthorized) {
                    component.set('v.integrationUsername', params.authorizingUser ? params.authorizingUser : component.get('v.integrationUsername'));
                }
                else {
                    var errorEvent = component.getEvent('showError');
                    errorEvent.setParams({
                        message: 'Authorization was denied.'
                    });
                    errorEvent.fire();
                }
                
                if (isAuthorized) {
                    var moveToNextStep = component.getEvent("moveToNextStep");
                    moveToNextStep.setParams({
                        success: true
                    });
                    moveToNextStep.fire();
                }
                break;
            case 'oAuthStartLoading':
                component.set('v.isStatusLoading', true);
                break;
            case 'oAuthDoneLoading':
                component.set('v.isStatusLoading', false);
                
                var doneLoading = component.getEvent('actionEvent');
                doneLoading.setParams({
                    action: 'doneLoading'
                });
                doneLoading.fire();
                break;
            case 'oAuthError':
                var errorEvent = component.getEvent('showError');
                errorEvent.setParams({
                    message: params
                });
                errorEvent.fire();
            default:
                break;
        }
    },
    startOAuthFlow : function(component, event) {
        var authorizeLoopServices = component.find('authorizeLoopServices');
        authorizeLoopServices.startOAuthFlow();
    },
    handleDisconnectIntegrationUser : function(component) {
        var disconnectIntegrationUser = component.getEvent('actionEvent');
        disconnectIntegrationUser.setParams({
            action: 'disconnectIntegrationUser'
        });
        disconnectIntegrationUser.fire();
    }
})