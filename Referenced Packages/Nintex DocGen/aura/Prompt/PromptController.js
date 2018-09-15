({
	show : function(component, event, helper) {
        component.find("modal").getElement().removeAttribute("hidden");
	},
    hide : function(component) {
        component.find("modal").getElement().setAttribute("hidden", "true");
    },
    showError : function(component, event, helper) {
        var title = event.getParam('arguments').title;
        var message = event.getParam('arguments').message;

        if (title) {
	        component.set('v.title', title);
        }
        component.set('v.message', message);
        
        component.find("modal").getElement().removeAttribute("hidden");
    }
})