({
	save : function(component, event, helper) {
        helper.toggleSpinner(component);
        component.get("v.edit").get("e.recordSave").fire();
        window.setTimeout(function() {
            helper.toggleSpinner(component);
        }, 500);
    },
    doInit : function(component, event, helper) {
        var action = component.get("c.getCase");
        action.setParams({
            "caseId": component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.case", response.getReturnValue());
                $A.createComponent('force:recordEdit',
                                   {
                                       'aura:id': 'edit',
                                       'recordId': component.get('v.case.AdditionalFields__c')
                                   },
                                   function(edit) {
                                       component.set('v.edit', edit);
                                   }
                                  ); 
            }
         });
         $A.enqueueAction(action); 
    }
})