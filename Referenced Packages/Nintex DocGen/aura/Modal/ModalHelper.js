({
    //TODO: deprecate this function
    toggleModal : function(component) {
        var selectedOption = component.get("v.title");
        if (selectedOption) {
	        this.showModal(component);
        } else {
            this.hideModal(component);
        }
    },
    //TODO: deprecate this function
	showModal : function(component) {
        var modal = component.find("modal");
        var modalBackdrop = component.find("modalBackdrop");
        $A.util.addClass(modal, "slds-fade-in-open");
        $A.util.addClass(modalBackdrop, "slds-backdrop--open");
	},
    //TODO: deprecate this function
    hideModal : function(component) {
	    var modal = component.find("modal");
        var modalBackdrop = component.find("modalBackdrop");
        $A.util.removeClass(modal, "slds-fade-in-open");
        $A.util.removeClass(modalBackdrop, "slds-backdrop--open");
	}
})