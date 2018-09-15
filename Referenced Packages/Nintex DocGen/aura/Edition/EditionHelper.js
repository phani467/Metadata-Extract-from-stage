({
    onSave: function(component, onComplete) {
        var isStandard = component.get('v.isStandard');
        var scheduledDdp = isStandard ? component.get('v.standardScheduledDdp') : component.get('v.businessScheduledDdp');
        var workflowDdp = component.get('v.workflowDdp');
        var componentLibrary = component.get('v.componentLibrary');
        var massDdp = component.get('v.massDdp');

        var action = component.get('c.saveServices');
        action.setParams({
            isStandard: isStandard,
            scheduledDdp: scheduledDdp,
            workflowDdp: workflowDdp,
            componentLibrary: componentLibrary,
            massDdp: massDdp,
            domain: component.get('v.loopUrl')
        });
        action.setCallback(this, function(response) {
            var moveToNextStep = component.getEvent('moveToNextStep');
            if (response.getState() === 'SUCCESS') {
                var parsedResponse = JSON.parse(response.getReturnValue());
                if (parsedResponse.isSuccess) {
                    moveToNextStep.setParams({success: true}).fire();
                    component.getEvent('updateIsStandard').setParams({
                        isStandard: isStandard
                    }).fire();
                } else {
                    moveToNextStep.setParams({success: false}).fire();
                    component.getEvent('showError').setParams({
                        message: parsedResponse.errorMessage
                    }).fire();
                }
            } else {
                moveToNextStep.setParams({success: false}).fire();
                var error = response.getError();
                var message = 'There was a problem saving changes.';
                if (error && error[0] && error[0].message) {
                    message = response.getError()[0].message;
                }
                component.getEvent('showError').setParams({
                    message: message
                }).fire();
            }
            if (onComplete) {
                onComplete(component);
            }
        });
        $A.enqueueAction(action);
    },
    setSettingsAndServices: function(component, orgSettings, services) {
        if (orgSettings && services) {
            component.set('v.isTrial', orgSettings.isTrial);
            component.set('v.isSandbox', orgSettings.isSandbox);
            component.set('v.hasContract', orgSettings.hasContract);
            component.set('v.connectedAppsEnabled', orgSettings.isConnectedAppsEnabled);

            this.clearServices(component);
            component.set('v.isStandard', services.isStandard);

            if (services.isStandard) {
                component.set('v.standardScheduledDdp', services.scheduledDdp);
            } else {
                component.set('v.businessScheduledDdp', services.scheduledDdp);
                component.set('v.workflowDdp', services.workflowApexDdp);
                component.set('v.componentLibrary', services.componentLibrary);
                component.set('v.massDdp', services.massDdp);
            }

            if (orgSettings.hasContract && !orgSettings.isSandbox) {
                this.disableAll(component);
            }

            var actionEvent = component.getEvent('actionEvent');
            actionEvent.setParams({
                action: 'doneLoading'
            });
            actionEvent.fire();
        }
    },
    clearServices: function(component) {
        component.set('v.standardScheduledDdp', false);
        component.set('v.businessScheduledDdp', false);
        component.set('v.workflowDdp', false);
        component.set('v.componentLibrary', false);
        component.set('v.massDdp', false);
    },
    parseQueryString: function(qstr) {
        var query = {};
        qstr = qstr[0] === '?' ? qstr.substr(1) : qstr
        var a = qstr.split('&');
        for (var i = 0; i < a.length; i++) {
            var b = a[i].split('=');
            query[decodeURIComponent(b[0])] = decodeURIComponent(b[1] || '');
        }
        return query;
    },
    disableAll: function(component) {
        component.set('v.disableAll', true);
        component.getEvent('disableSave').fire();
    },
    fireErrorEvent: function(component, message) {
        component.getEvent('showError').setParams({
            message: message
        }).fire();
    },
    transferSubscriptionServices: function(component, sessionId, location, loopUrl) {
        var action = component.get('c.fetchEditionServices');
        action.setParams({
            sessionId: sessionId,
            location: location,
            loopUrl: loopUrl
        });
        action.setCallback(this, function(response) {
            var returnValue = JSON.parse(response.getReturnValue());
            if (returnValue.isSuccess) {
                var services = returnValue.data.services;
                component.set('v.isStandard', services.isStandard);
                if (services.isStandard) {
                    component.set('v.standardScheduledDdp', services.scheduledDdps);
                } else {
                    component.set('v.businessScheduledDdp', services.scheduledDdps);
                }
                component.set('v.workflowDdp', services.workflowApexDdps);
                component.set('v.componentLibrary', services.componentLibrary);
                component.set('v.massDdp', services.massDdps);

                this.onSave(component, this.enableSubscriptionTransferButton);
            } else {
                component.getEvent('showError').setParams({
                    message: $A.get('$Label.loop.EditionRetrievalError_Message')
                }).fire();
            }
        });
        $A.enqueueAction(action);
    },
    enableSubscriptionTransferButton: function(component) {
        component.find('oAuthFlowButton').set('v.disabled', false);
        $A.util.addClass(component.find('oAuthLoadingSpinner'), 'slds-hide');
    },
    disableSubscriptionTransferButton: function(component) {
        component.find('oAuthFlowButton').set('v.disabled', true);
        $A.util.removeClass(component.find('oAuthLoadingSpinner'), 'slds-hide');
    }
})