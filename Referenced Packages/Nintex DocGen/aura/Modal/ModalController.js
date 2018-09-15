({
    onInit : function(component, event, helper) {
        helper.toggleModal(component);
    },
    //TODO: deprecate this function
    toggleModal : function(component, event, helper) {
        var eventName = event.getDef().$descriptor$.name;
        var type = '';
        if (eventName === 'selectOptionChanged') {
   			type = event.getParam("selectedOption");
            component.set("v.title", type);
        } else if (eventName === 'editRecord') {
            type = event.getParam("type");
            component.set("v.title", type);
        }
        helper.toggleModal(component);
    },
    //TODO: deprecate this function
    hideModal : function(component, event, helper) {
        helper.hideModal(component);
        component.getEvent("hideModal").fire();
    },
    show : function(component, event, helper) {
        helper.showModal(component);
    },
    hide : function(component, event, helper) {
        helper.hideModal(component);
    }
})