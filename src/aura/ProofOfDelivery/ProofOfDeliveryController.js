({
    doInit : function(component, event, helper) {
        window.setTimeout(
            $A.getCallback(function() {
                $A.get("e.force:closeQuickAction").fire();
            }), 1
        );
        var createPODEvent = $A.get("e.force:createRecord");
        createPODEvent.setParams({
            "entityApiName": "ProofOfDelivery__c",
            "defaultFieldValues": {
                'Contract__c' : component.get('v.recordId')
            }
        });
        $A.get('e.force:closeQuickAction').fire();
        createPODEvent.fire();
    }
})