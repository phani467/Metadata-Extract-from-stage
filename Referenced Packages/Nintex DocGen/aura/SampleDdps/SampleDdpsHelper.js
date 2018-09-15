({
    fireErrorEvent : function(component, message) {
        component.getEvent('showError').setParams({
            message: message
        }).fire();
    },
    filterDdps : function(component, event) {
        var params = event.getParam('params');
        var searchCriteria = JSON.parse(params);
        var searchText = searchCriteria[0].searchText || '';
        component.find('sampleDdpTable').filterDdps(searchText, searchCriteria[0].businessUser);
	}
})