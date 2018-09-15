({
    load : function(component, event, helper) {
        component.set("v.loading", true);
        
        // clear data that would not have been cleared out from a previous DocGen Package selection
        component.set('v.hasErrorOccurred', false);
        component.set('v.errorMessage', '');
        
        var ddpId = event.getParam("arguments").ddpId;
        var recordId = event.getParam("arguments").recordId;
        var contactId = event.getParam("arguments").contactId;
        var hasAdhocApexClass = event.getParam("arguments").hasAdhocApexClass;
        var attachmentAllowed = event.getParam("arguments").attachmentAllowed;
        var attachmentRequired = event.getParam("arguments").attachmentRequired;
        var searchString = component.get("v.searchString");
        
        component.set("v.attachmentAllowed", attachmentAllowed);
        component.set("v.attachmentRequired", attachmentRequired);
        component.set("v.hasAdhocApexClass", hasAdhocApexClass);
        component.set("v.nextButtonDisabled", attachmentRequired);
        
        var action = component.get("c.getOptionalDocuments");
        action.setParams({
            ddpId : ddpId,
            recordId : recordId,
            contactId : contactId,
            searchString : searchString,
            attachmentAllowed : attachmentAllowed,
            attachmentRequired : attachmentRequired,
            hasAdhocApexClass : hasAdhocApexClass
        });
        action.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                var parsedResponse = JSON.parse(response.getReturnValue());
                if (parsedResponse.isSuccess) {
                    component.set("v.records", parsedResponse.optionalDocuments);
                    component.set("v.attachments", parsedResponse.attachments);
                    
                    var exposeSecondaryAccordionSections = component.getEvent('exposeSecondaryAccordionSections');
                    exposeSecondaryAccordionSections.fire();
                }
                else {
                    helper.fireErrorEvent(component, parsedResponse.errorMessage);
                }
            }
            else {
                helper.fireErrorEvent(component, $A.get('$Label.loop.Generic_Error_Message'));
            }
            
            component.set("v.loading", false);
        });
        $A.enqueueAction(action);
    },
    passSelectedAttachmentsToSelectTiles : function(component, event, helper) {
        var selectedAttachments = event.getParam('arguments').selectedAttachments;
        component.find('documentTiles').updateSelectedAttachments(selectedAttachments);
    },
    search : function(component, event, helper) {
        var searchString = event.getParams().arguments.searchString;
        component.find('documentTiles').search(searchString);
    },
    handleError : function(component, event) {
        component.set("v.hasErrorOccurred", true);
        component.set("v.errorMessage", event.getParam("message"));
        event.stopPropagation();
    },
    updateDocumentNextButton : function(component, event, helper) {
        component.set('v.nextButtonDisabled', event.getParam('arguments').nextButtonDisabled);
    },
    completedOptionalDocumentSelection : function(component, event, helper) {
        component.getEvent('documentSelectionCompleted').fire();
    }
})