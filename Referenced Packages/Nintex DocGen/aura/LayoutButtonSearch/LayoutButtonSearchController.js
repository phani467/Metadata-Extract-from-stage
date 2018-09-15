({
	filterLayouts : function(component, event, helper) {
        helper.filterLayouts(component);
	},
    detectEnter : function(component, event, helper) {
        if (event.getParams() && event.getParams().keyCode && event.getParams().keyCode === 13) {
	        helper.filterLayouts(component);
        }
    }
})