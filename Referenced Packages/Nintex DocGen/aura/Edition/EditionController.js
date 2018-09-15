({
    onInit : function(component, event, helper) {
        var orgSettings = component.get('v.orgSettings');
        var services = component.get('v.services');
        helper.setSettingsAndServices(component, orgSettings, services);
    },
    load : function (component, event, helper) {
        var orgSettings = event.getParams().arguments.orgSettings;
        var services = event.getParams().arguments.services;
        helper.setSettingsAndServices(component, orgSettings, services);
    },
    save : function(component, event, helper) {
        helper.onSave(component);
    },
    toggleServiceLevel : function(component, event, helper) {
        var isStandard = component.get("v.isStandard");
        helper.clearServices(component);
        component.set("v.isStandard", !isStandard);
    },
    redirectPage : function(component, event) {
        var redirectEvent = component.getEvent("redirectPage");
        redirectEvent.setParams({
            'buttonName' : 'purchaseForm'
        });
        redirectEvent.fire();
    },
    handleActionEvent : function(component, event, helper) {
        var action = event.getParam('action');
        var params = event.getParam('params') ? JSON.parse(event.getParam('params')) : null;

        switch (action) {
            case 'oAuthInitComplete':
                // Checks to see if this is the first oAuthInitComplete - checking to see if the user is authorized and able to interact with Edition
                if (component.get('v.connectedAppsEnabled') && !component.get('v.isAuthorized')) {
                    component.set('v.isAuthorized', params.isAuthorized);
                    component.set('v.isAuthLoading', false);
                } else if (component.get('v.isSandbox')) { // The incoming oAuthInitComplete carries the OAuth url for a prod -> sandbox license transfer
                    component.set('v.isAuthorized', params.isAuthorized);
                    helper.enableSubscriptionTransferButton(component);
                    var actionEvent = component.getEvent('actionEvent');
                    //Receiving components are only expecting the isAuthorized parameter when connectedApps is enabled.
                    actionEvent.setParams({
                        action: 'doneLoading',
                        params: component.get('v.connectedAppsEnabled') ? JSON.stringify({isAuthorized: params.isAuthorized}) : null
                    });
                    actionEvent.fire();
                    component.set('v.isAuthLoading', false);
                }
                break;
            case 'oAuthInitFailed':
                component.set('v.isAuthLoading', false);
                $A.util.addClass(component.find('authText'), 'slds-hide');
                $A.util.addClass(component.find('appAuth'), 'slds-hide');
                $A.util.addClass(component.find('oAuthLoadingSpinner'), 'slds-hide');
                component.getEvent('showError').setParams({
                    message: params.message
                }).fire();
                break;
            case 'oAuthSuccess':
                if (component.get('v.isAuthorized') === true || !component.get('v.connectedAppsEnabled')) { // Case: User is already authorized (or connect apps is not enabled), so they are trying to migrate subscription services
                    helper.disableSubscriptionTransferButton(component);
                    helper.transferSubscriptionServices(component, params.sessionId, params.location, component.get("v.loopUrl"));
                } else { // Case: User is newly authorized
                    component.set('v.isAuthorized', true);
                }
                break;
            case 'oAuthFailure':
                helper.fireErrorEvent(component,  $A.get('$Label.loop.AuthorizationUnsuccessful_Label'));
                break;
            default:
                break;
        }
    },
    startOAuthFlow : function(component, event) {
        component.find('appAuth').startOAuthFlow();
    }
})