({
	filterLayouts : function(component) {
		var event = component.getEvent("actionEvent");
        event.setParams({
            action: 'filterLayouts',
            params: component.find('searchText').getElement().value
        });
        event.fire();
	}
})