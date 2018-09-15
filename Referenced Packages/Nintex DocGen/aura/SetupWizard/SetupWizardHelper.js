({
    updateContent : function(component) {
        var step = component.get('v.step');
        var stepTitle = '';
        var stepDescription = '';
        component.set('v.alertText', '');

        switch (step) {
            case 'Edition':
                stepTitle = step;
                stepDescription = '';
                component.set('v.skipButtonLabel', 'Skip');
                component.set('v.saveButtonLabel', 'Save & Next');
                component.set('v.helpLink', 'http://help.nintex.com/en-us/docgen/docservices/Default.htm#cshid=9013');
                break;
            case 'Users':
                stepTitle = 'User Permissions and Licensing';
                stepDescription = 'Identify users in your organization who can use the app and set their permission level. Administrators have access to the DocGen Admin tab and can create and run DocGen Packages. Users only have permission to run DocGen Packages.';
                component.set('v.skipButtonLabel', 'Skip');
                component.set('v.saveButtonLabel', 'Save & Next');
                component.set('v.helpLink', 'http://help.nintex.com/en-us/docgen/docservices/Default.htm#cshid=9010');
                break;
            case 'Authorize':
                stepTitle = 'Authorize Nintex DocGen';
                stepDescription = '';
                component.set('v.skipButtonLabel', 'Skip');
                component.set('v.saveButtonLabel', "");
                component.set('v.helpLink', 'http://help.nintex.com/en-us/docgen/docservices/Default.htm#cshid=9008');
                break;
            case 'Sample DocGen Packages':
                stepTitle = 'Sample DocGen Packages';
                stepDescription = '';
                component.set('v.skipButtonLabel', 'Skip');
                component.set('v.saveButtonLabel', 'Save & Next');
                component.set('v.helpLink', 'http://help.nintex.com/en-us/docgen/docservices/Default.htm#cshid=9011');
                break;
            case 'Basic Buttons':
                stepTitle = 'Basic Buttons';
                stepDescription = '';
                component.set('v.skipButtonLabel', 'Skip');
                component.set('v.saveButtonLabel', component.get('v.disableLayoutButtonsCheckboxes') ? 'Continue' : 'Save');
                if (!component.get('v.isCustomizeApplication')) {
                    component.set('v.ready', false);
                }
                component.set('v.helpLink', 'http://help.nintex.com/en-us/docgen/docservices/Default.htm#cshid=9009');
                break;
            default:
                break;
        }

        component.set('v.stepTitle', stepTitle);
        component.set('v.stepDescription', stepDescription);
    },
    moveToNextStep : function(component, event, helper) {
        var steps = component.get('v.steps');
        var nextStep = steps[steps.indexOf(component.get('v.step')) + 1];
        if (nextStep) {
            component.set('v.busy', false);
            component.set('v.step', nextStep);
            helper.updateContent(component);
        } else {
            var action = component.get('c.completeSetupWizard');
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state !== 'SUCCESS' || response.getReturnValue() !== 'true') {
                    component.getEvent('showError').setParams({
                        message: 'An unexpected error has occurred.'
                    }).fire();
                } else {
                    // Go to End Page
                    component.set('v.busy', false);
                    component.set('v.step', '');
                    helper.updateContent(component);
                    component.set('v.complete', true);
                    component.set('v.alertType', 'success');
                    component.set('v.alertText', 'You deployed Nintex DocGen!');
                }
            });
            $A.enqueueAction(action);
        }
    },
    disconnectIntegrationUser : function(component) {
        var action = component.get('c.disconnectIntegrationUser');
        action.setCallback(this, function(response) {
            if (response.getState() === 'SUCCESS') {
                var parsedResponse = JSON.parse(response.getReturnValue());
                if (parsedResponse.isSuccess) {
                    component.set('v.orgSettings', parsedResponse.orgSettings);
                    component.set('v.alertText', 'Your Integration User has been successfully disconnected.');
                } else {
                    this.showError(component, 'There was an issue disconnecting your Integration User. If this issue persists, please contact Nintex Support.');
                }
            } else {
                this.showError(component, 'There was an issue disconnecting your Integration User. If this issue persists, please contact Nintex Support.');
            }
        });
        $A.enqueueAction(action);
    }
})