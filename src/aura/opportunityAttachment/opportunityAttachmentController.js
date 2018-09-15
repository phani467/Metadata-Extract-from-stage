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
                var createOpportunityAttachmentEvent = $A.get("e.force:createRecord");
                createOpportunityAttachmentEvent.setParams({
                    "entityApiName": "OpportunityAttachment__c",
                    "recordTypeId" : recTypeId,
                    "defaultFieldValues": {
                        'Opportunity__c' : component.get('v.recordId')
                    }
                });
               $A.get('e.force:closeQuickAction').fire();
                createOpportunityAttachmentEvent.fire();
            }
        });
        $A.enqueueAction(action);
	}
})