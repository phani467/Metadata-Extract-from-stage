({
    onInit : function(component, event, helper) {
        helper.updateContent(component);
        var complete = component.get('v.complete');
        
        var init = component.get('c.init');
        init.setParams({
            passedSessionId: component.get('v.sessionId'),
            domain: component.get('v.loopUrl')
        });
        init.setCallback(this, function(response) {
            if (response.getState() === 'SUCCESS') {
                var parsedResponse = JSON.parse(response.getReturnValue());
                //Don't check for isSuccess, because even if certain parts of the callout failed, we still want to load/initialize the parts that did succeed
                
                var services = parsedResponse.services;
                component.set('v.isCustomizeApplication', parsedResponse.isCustomizeApplication);
                component.set('v.oAuthSettings', parsedResponse.oAuthSettings);
                component.set('v.services', services);
                component.set('v.orgSettings', parsedResponse.orgSettings);
                
                if (!parsedResponse.isCustomizeApplication) {
                    component.set('v.alertText', 'You need the Customize Application permission to complete the setup and start generating documents. Contact your system administrator, or continue and complete steps that require this permission later.');
                    component.set('v.isCustomizeApplication', false);
                }
                
                if (!services.isSuccess) {
                    var errorEvent = component.getEvent('showError');
                    errorEvent.setParams({
                        message: services.errorMessage
                    });
                    errorEvent.fire();
                }
            }
            else {
                component.getEvent('showError').setParams({
                    message: $A.get('$Label.loop.Generic_Error_Message')
                }).fire();
            }
            
            component.set('v.isLoading', false);
        });
        
        $A.enqueueAction(init);
    },
    save : function(component, event, helper) {
        // We don't want to put the wizard into a loading state when saving on the last screen (Basic Buttons)
        if (component.get('v.step') !== 'Basic Buttons') {
            component.set('v.isLoading', true);
            component.set('v.ready', false);
        }

        switch (component.get('v.step')) {
            case 'Splash':
                helper.moveToNextStep(component, event, helper);
                break;
            case 'Edition':
                component.set('v.busy', true);
                component.find('edition').save();
                break;
            case 'Users':
                component.set('v.busy', true);
                component.find('setupUsers').save();
                break;
            case 'Authorize':
                helper.moveToNextStep(component, event, helper);
                break;
            case 'Integrations':
                helper.moveToNextStep(component, event, helper);
                break;
            case 'Settings':
                component.set('v.busy', true);
                component.find('settings').save();
                break;
            case 'Sample DocGen Packages':
                component.set('v.busy', true);
                component.find('sampleDdps').save();
                break;
            case 'Basic Buttons':
                var hasSavedLayouts = component.get('v.saveButtonLabel') === 'Continue';
                //First click of save button should save the layouts, and change the 'Save' button to 'Continue'.
                if (!hasSavedLayouts) {
                    component.set('v.disableLayoutButtonsCheckboxes', true);
                    component.set('v.busy', true);
                    component.find('pageLayouts').save();
                } else { // Subsequent clicks of the button will continue to the next step.
                    helper.moveToNextStep(component, event, helper);
                }
                break;
            default:
                break;
        }
    },
    moveToNextStep : function(component, event, helper) {
        var isBasicButtonsStep = component.get('v.step') === 'Basic Buttons';

        // We want to display a success banner on save in the basic buttons step, so we don't put the wizard into loading state then.
        if (!isBasicButtonsStep) {
            component.set('v.isLoading', true);
            component.set('v.ready', false);
        }

        if (event.getParam('success')) {
            // On successful save of button layouts, we change the save button to continue and display a success alert.
            if (isBasicButtonsStep) {
                component.set('v.saveButtonLabel', 'Continue');
                component.set('v.alertType', 'success');
                component.set('v.alertText', event.getParam('successMessage'));
                component.set('v.busy', false);
            } else {
                helper.moveToNextStep(component, event, helper);
            }
        } else {
            component.set('v.busy', false);
        }
    },
    skipStep : function(component, event, helper) {
        component.set('v.isLoading', true);
        component.set('v.ready', false);
        
        var text = event.target.textContent;
        if (text === 'Skip Wizard') {
            var action = component.get('c.completeSetupWizard');
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state !== 'SUCCESS' || response.getReturnValue() !== 'true') {
                    component.getEvent('showError').setParams({
                        message: 'An unexpected error has occurred.'
                    }).fire();
                } else {
                    window.location.reload();
                }
            });
            $A.enqueueAction(action);
        } else if (component.get('v.step') === 'Basic Buttons') {
            helper.moveToNextStep(component, event, helper);
        } else {
            var stepsToSkip = 1;
            var steps = component.get('v.steps');
            if (component.get('v.step') === 'Authorize') {
                stepsToSkip = 2;
            }
            var nextStep = steps[steps.indexOf(component.get('v.step')) + stepsToSkip];
            component.set('v.step', nextStep);
            helper.updateContent(component);
        }
    },
    changeStep : function(component, event, helper) {
        component.set('v.isLoading', true);
        component.set('v.ready', false);
        
        var step = event.getParam('path');
        component.set('v.step', step);
        helper.updateContent(component);
        component.set('v.complete', false);
    },
    setSampleObjects : function(component, event, helper) {
        if (event.getParam('sampleType') === 'sampleDdps') {
            component.set('v.sampleDdpObjects', event.getParam('objectTypes'));
        } else if (event.getParam('sampleType') === 'layoutButtons') {
            component.set('v.layoutButtonObjects', event.getParam('objectTypes'));
        }
    },
    showError : function(component, event, helper) {
        component.set('v.isLoading', false);
        
        var errorPrompt = component.find('errorPrompt');
        var title = event.getParam('title');
        var message = event.getParam('message');
        errorPrompt.showError(title, message);
    },
    updateIsStandard : function(component, event) {
        component.set('v.services.isStandard', event.getParam('isStandard'));
    },
    handleActionEvent : function(component, event, helper) {
        var action = event.getParam('action');
        var params = event.getParam('params') ? JSON.parse(event.getParam('params')) : null;

        switch (action) {
            case 'isLoading':
                component.set('v.isLoading', true);
                component.set('v.ready', false);
                break;
            case 'doneLoading':
                component.set('v.isLoading', false);
                if (params && 'isAuthorized' in params && params.isAuthorized != null) {
                    component.set('v.ready', params.isAuthorized);
                } else {
                    component.set('v.ready', true);
                }
                break;
            case 'authorized':
            case 'oAuthStatusUpdate':
                component.set('v.ready', true);
                component.set('v.oAuthSettings.isAuthorized', true);
                if (params && 'authorizingUser' in params) {
                    component.set('v.orgSettings.integrationUsername', params.authorizingUser);
                }
                break;
            case 'connectedAppsChanged':
                if (params && 'connectedAppsEnabled' in params) {
                    component.set('v.orgSettings.isConnectedAppsEnabled', params.connectedAppsEnabled);
                }
                break;
            case 'disconnectIntegrationUser':
                helper.disconnectIntegrationUser(component);
                break;
            default:
                break;
        }
    }
})