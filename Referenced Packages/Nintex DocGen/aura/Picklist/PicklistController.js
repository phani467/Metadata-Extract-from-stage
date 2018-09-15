({
	itemSelected : function(component, event, helper) {
		var selectedId = event.currentTarget.id;
        var list = component.get('v.list');
        var selectedItem;
        for (var i = 0; i < list.length; i++) {
            if (selectedId == list[i].Id) {
                selectedItem = list[i];
                list[i].IsSelected = true;
            }
            else {
                list[i].IsSelected = false;
            }
        }
        component.set('v.list', list);
        
        var actionEvent = component.getEvent('actionEvent');
        actionEvent.setParams({
            action: 'itemSelected',
            params: JSON.stringify({ item: selectedItem, sourceId: component.getGlobalId() })
        });
        actionEvent.fire();
	},
    startLoading : function(component, event) {
        component.set('v.isLoading', true);
    },
    doneLoading : function(component, event) {
        component.set('v.isLoading', false);
    }
})