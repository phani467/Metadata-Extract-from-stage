({
    fireErrorEvent : function(component, message) {
        component.getEvent('showError').setParams({
            message: message
        }).fire();
    },
    filterLayouts : function(component, event) {
    	var searchText = event.getParam('params') || '';
        component.find('layoutButtonTable').filterLayouts(searchText);
	}
})