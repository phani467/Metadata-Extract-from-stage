({
	doInit : function(component, event, helper) {
		var oppyProdId = component.get("v.recordId");
        var action = component.get("c.getOppyProdSchedules");
        action.setParams({
            "oppyProdId": oppyProdId
        });
        action.setCallback(this, function(response) {
            console.log("state >> "+ response.getState());
            if (response.getState() == 'SUCCESS') {
                var result = response.getReturnValue();
                console.log(result);
                component.set("v.lstOppySchedules",result);
                console.log(component.get("v.lstOppySchedules").length);
            }
        });
        $A.enqueueAction(action);
	}
})