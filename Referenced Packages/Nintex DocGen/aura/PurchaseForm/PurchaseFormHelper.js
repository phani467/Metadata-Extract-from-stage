({
    toggleSubscriptionButtons : function(component) {
        if (component.get("v.isStandard")) {
            $A.util.addClass(component.find("standardButton"), "slds-button--brand");
            $A.util.removeClass(component.find("businessButton"), "slds-button--brand");
            $A.util.addClass(component.find("businessButtonSvg"), "hidden");
            $A.util.removeClass(component.find("standardButtonSvg"), "hidden");
        } else {
            $A.util.addClass(component.find("businessButton"), "slds-button--brand");
            $A.util.removeClass(component.find("standardButton"), "slds-button--brand");
            $A.util.addClass(component.find("standardButtonSvg"), "hidden");
            $A.util.removeClass(component.find("businessButtonSvg"), "hidden");
        }
    },
    checkFormComplete : function(component) {
        var isComplete = true;
        var formFields = ['firstName', 'lastName', 'email', 'phone', 'companyName', 'orgId', 'additionalUserLicenses', 'street', 'city', 'state', 'postalCode', 'country'];
        for (var i = 0; i < formFields.length; i++) {
            var field = component.find(formFields[i]);
            if (field) {
                if (!component.find(formFields[i]).getElement().value) {
                    isComplete = false;
                    break;
                }   
            }
        }
        return isComplete;
    },
    isValidEmail : function(email) {
		var re = /^[_a-zA-Z0-9-]+(\.[_a-zA-Z0-9-]+)*@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*\.(([0-9]{1,3})|([a-zA-Z]{2,3})|(aero|coop|info|museum|name))$/;
        return re.test(email);
    },
    isNotANumber : function(number) {
        return isNaN(number);
    },
    getFieldValidation : function(component) {
        var isComplete = true;
        var isNotANumber = this.isNotANumber(component.find('additionalUserLicenses').getElement().value);
        var isValidEmail = this.isValidEmail(component.find('email').getElement().value);
        if (!isValidEmail) {
            isComplete = false;
            this.addValidationStyles(component, false, 'email');
        } else {
        	this.addValidationStyles(component, true, 'email');
        }
        if (isNotANumber) {
            isComplete = false;
            this.addValidationStyles(component, false, 'additionalUserLicenses');
        } else {
            this.addValidationStyles(component, true, 'additionalUserLicenses');
        }
        return isComplete;
    },
    addValidationStyles : function(component, isComplete, field) {
        var parentDiv = component.find(field).getElement().parentNode;
        if (!isComplete) {
            $A.util.addClass(parentDiv, 'slds-has-error');
            $A.util.removeClass(component.find(field + 'Error'), 'hidden');
        } else {
            $A.util.removeClass(parentDiv, 'slds-has-error');
            $A.util.addClass(component.find(field + 'Error'), 'hidden');
        }
    },
    checkFormCompleteAndValidation : function(component) {
        var isComplete = true;
        var formComplete = this.checkFormComplete(component);
        var validated = this.getFieldValidation(component);
        if (!formComplete || !validated) {
            isComplete = false;
        }
        return isComplete;
    },
    fireEnableDisableSubmitButtonEvents : function(component, isComplete) {
        if (isComplete) {
            component.getEvent('enableSave').fire();
        } else {
            component.getEvent('disableSave').fire();
        }
    },
    fireErrorEvent : function(component, message) {
        var errorEvent = component.getEvent("showError");
        errorEvent.setParams({
            message: message
        });
        errorEvent.fire();
	}
})