({
	updateStep : function(component) {
        var steps = component.get("v.steps");
        var stepComponents = component.find("step");
        var currentStep = component.get("v.step");
        var complete = component.get("v.complete");

        var currentStepReached = false;
        for (var i in steps) {
            var step = steps[i];
            var stepComponent = stepComponents[i];

            var a = stepComponent.getElement().children[0];
            if (component.get('v.disabled')) {
                if (!$A.util.hasClass(a, 'no-decoration')) {
                    $A.util.addClass(a, 'no-decoration');
                }
                if (!$A.util.hasClass(stepComponent, 'slds-is-incomplete') && !$A.util.hasClass(stepComponent, 'slds-is-current') && !$A.util.hasClass(stepComponent, 'slds-is-complete')) {
                    $A.util.addClass(stepComponent, 'slds-is-incomplete');
                }
            } else {
                if ($A.util.hasClass(a, 'no-decoration')) {
                    $A.util.removeClass(a, 'no-decoration');
                }
                if (currentStep === step && !complete) {
                    currentStepReached = true;
                    $A.util.removeClass(stepComponent, "slds-is-incomplete");
                    $A.util.removeClass(stepComponent, "slds-is-complete");
                    $A.util.addClass(stepComponent, "slds-is-current");
                } else if (currentStepReached && !complete) {
                    $A.util.removeClass(stepComponent, "slds-is-current");
                    $A.util.removeClass(stepComponent, "slds-is-complete");
                    $A.util.addClass(stepComponent, "slds-is-incomplete");
                } else {
                    $A.util.removeClass(stepComponent, "slds-is-incomplete");
                    $A.util.removeClass(stepComponent, "slds-is-current");
                    $A.util.addClass(stepComponent, "slds-is-complete");
                }                
            }
        }
    }
})