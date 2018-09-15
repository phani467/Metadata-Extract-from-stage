({
    init : function(component, event, helper) {
        var action = component.get("c.getSupportInfo");
        action.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                var r = JSON.parse(response.getReturnValue());
                component.set("v.orgId", r.orgId);
                component.set("v.versionNumber", r.versionNumber);
            }
        });
        $A.enqueueAction(action);
    },
	loginAccess : function(component, event, helper) {
        $A.get('e.force:navigateToURL').setParams({'url': '/partnerbt/grantLoginAccess.apexp'}).fire();
	},
    openCase : function(component, event, helper) {
        window.open('https://support.nintex.com/Submit_a_Support_Case', '_blank');
    }
})