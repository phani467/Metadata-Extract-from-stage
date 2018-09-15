({
    init : function(component, event, helper) {
        //loads default data from the user
        var action = component.get("c.getDefaultOrganizationInfo");
        action.setParams({
            sessionId: component.get("v.sessionId"),
            domain: component.get("v.loopUrl")
        });
        action.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                var parsedResponse = JSON.parse(response.getReturnValue());
                component.set("v.firstName", parsedResponse.firstName);
                component.set("v.lastName", parsedResponse.lastName);
                component.set("v.email", parsedResponse.email);
                component.set("v.companyName", parsedResponse.companyName);
                component.set("v.orgId", parsedResponse.orgId);
                component.set("v.street", parsedResponse.street);
                component.set("v.city", parsedResponse.city);
                component.set("v.state", parsedResponse.state);
                component.set("v.postalCode", parsedResponse.postalCode);
                component.set("v.country", parsedResponse.country);
                component.set("v.phone", parsedResponse.phone);
                
                component.set("v.firstNameLabel", parsedResponse.firstNameLabel);
                component.set("v.lastNameLabel", parsedResponse.lastNameLabel);
                component.set("v.emailLabel", parsedResponse.emailLabel);
                component.set("v.phoneLabel", parsedResponse.phoneLabel);
                component.set("v.companyNameLabel", parsedResponse.companyNameLabel);
                component.set("v.orgIdLabel", parsedResponse.orgIdLabel);
                component.set("v.streetLabel", parsedResponse.streetLabel);
                component.set("v.cityLabel", parsedResponse.cityLabel);
                component.set("v.stateLabel", parsedResponse.stateLabel);
                component.set("v.postalCodeLabel", parsedResponse.postalCodeLabel);
                component.set("v.countryLabel", parsedResponse.countryLabel);
                
                if (component.get("v.hasContract")) {
                    component.set("v.userLicenseLabel", "Additional User Licenses");
                    var allowedLicenses = component.get("v.allowedLicenses");
                    if (allowedLicenses < 0) {
                        allowedLicenses = 'Unlimited';
                    }
                    component.set("v.allowedLicenses", allowedLicenses);
                }
                helper.toggleSubscriptionButtons(component);
                //Enable and disable the submit button based on whether or not the form is completely filled out.
                var isComplete = helper.checkFormComplete(component);
                helper.fireEnableDisableSubmitButtonEvents(component, isComplete);
            }
            
            var actionEvent = component.getEvent('actionEvent');
            actionEvent.setParams({
                action: 'doneLoading'
            });
            actionEvent.fire();
        });
        $A.enqueueAction(action);
    },
    updateSubscriptionLevel : function(component, event, helper) {
        var isStandard = event.currentTarget.id === 'standardButton';
        component.set("v.isStandard", isStandard);
        helper.toggleSubscriptionButtons(component, isStandard);
    },
    getCheckFormComplete : function(component, event, helper) {
        var isComplete = helper.checkFormComplete(component);
        helper.fireEnableDisableSubmitButtonEvents(component, isComplete);
    },
    getCheckFormCompleteAndValidation : function(component, event, helper) {
        var isComplete = helper.checkFormCompleteAndValidation(component);
        helper.fireEnableDisableSubmitButtonEvents(component, isComplete);
    },
    submit : function(component, event, helper) {
        var hasContract = component.get("v.hasContract");
        var action = component.get('c.sendPurchaseRequest');
        action.setParams({
            firstName : component.find('firstName').getElement().value,
            lastName : component.find('lastName').getElement().value,
            email : component.find('email').getElement().value,
            phone : component.find('phone').getElement().value,
            street : !hasContract ? component.find('street').getElement().value : '',
            city : !hasContract ? component.find('city').getElement().value : '',
            state : !hasContract ? component.find('state').getElement().value : '',
            postalCode : !hasContract ? component.find('postalCode').getElement().value : '',
            country : !hasContract ? component.find('country').getElement().value : '',
            companyName: component.find('companyName').getElement().value,
            seats: component.find('additionalUserLicenses').getElement().value,
            edition: component.get('v.isStandard') ? 'Standard' : 'Enterprise',
            domain: component.get('v.loopUrl'),
            isTest: component.get('v.isTest')
        });
        action.setCallback(this, function(response) {
            var errorMessage = $A.get('$Label.loop.Generic_Error_Message');
            var moveToNextStep = component.getEvent('moveToNextStep');
            if (response.getState() === 'SUCCESS') {
                var parsedResponse = JSON.parse(response.getReturnValue());
                if (parsedResponse.status === 'success') {
                    var successMessage = !hasContract ? "Thank you! Your order form is on its way. You must sign the order to complete the transaction." : "Thank you! Your upgrade request is on its way. You must sign the request to complete the transaction.";
                    moveToNextStep.setParams({
                        success: true,
                        successMessage: successMessage
                    }).fire();
                } else {
                    if (parsedResponse.ErrorId) {
                        var responseMessage = parsedResponse.Message ? parsedResponse.Message : '';
                        errorMessage = responseMessage + ' ' + $A.get('$Label.loop.Include_This_Error_Id_Error_Message') + ' ' + parsedResponse.ErrorId;
                    }
                    helper.fireErrorEvent(component, errorMessage);
                    moveToNextStep.setParams({success: false}).fire();
                }
            } else {
                helper.fireErrorEvent(component, errorMessage);
                moveToNextStep.setParams({success: false}).fire();
            }
        });
        $A.enqueueAction(action);
    }
})