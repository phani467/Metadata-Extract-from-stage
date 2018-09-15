({
	filterDdps : function(component) {
		var event = component.getEvent("actionEvent");
        var searchCriteria = [{'searchText' : component.find("searchText").get("v.value")},{'businessUser' : component.find("businessUser").get("v.value")}];
        var params = JSON.stringify(searchCriteria);
               
        event.setParams({
            action: 'filterDdps',
            params : params
        });
        event.fire();
	}
})