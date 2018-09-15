({
	doInit : function(component, event, helper) {
        var action = component.get('c.getRecordTypeId');
        action.setParams({
            "parentId" : component.get('v.recordId')
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === 'SUCCESS' && component.isValid()){
                var recTypeId = response.getReturnValue();
                var createContractAttachmentEvent = $A.get("e.force:createRecord");
                createContractAttachmentEvent.setParams({
                    "entityApiName": "ContractAttachment__c",
                    "recordTypeId" : recTypeId,
                    "defaultFieldValues": {
                        'Contract__c' : component.get('v.recordId')
                    }
                });
               $A.get('e.force:closeQuickAction').fire();
                createContractAttachmentEvent.fire();
            }
        });
        $A.enqueueAction(action);
	}
})