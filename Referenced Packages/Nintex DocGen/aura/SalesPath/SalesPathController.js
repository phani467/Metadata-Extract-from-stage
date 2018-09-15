({
	changeStep : function(component, event, helper) {
        if (!component.get('v.disabled')) {
            // getElementsByClassName from parent becuase the event.target may be the link or the text
            var selectedStep = event.target.parentElement.getElementsByClassName('slds-tabs--path__title')[0].innerHTML;
            component.getEvent("salesPathSelected").setParams({path: selectedStep}).fire();
        }
	}
})