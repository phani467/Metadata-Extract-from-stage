({
	toggleSpinner : function(component) {
		var spinner = component.find("mySpinner");
        $A.util.toggleClass(spinner, "slds-hide");
        $A.util.toggleClass(spinner, "slds-show");
	}
})