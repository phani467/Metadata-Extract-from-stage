({
    onInit : function(component, event, helper) {
        //Store 'globalId' and use it when defining an 'id' within this component.
        //This will ensure that when trying to grab a certain tile by id,
        //we won't grab a tile outside of this component.
        component.set("v.globalIdTag", component.getGlobalId() + "_");
        
        var attachments = component.get('v.attachments');
        var attachmentsRequired = component.get('v.required');
        if (!attachments.length && attachmentsRequired) {
        	$A.util.removeClass(component.find('errorContainer'), 'hidden');
            $A.util.addClass(component.find('attachmentContainer'), 'hidden');
        }
    },
    slideInAttachments : function(component, event) {
        var slideInAttachments = component.getEvent('slideInAttachments');
        slideInAttachments.setParams({
            globalIdTag : component.get('v.globalIdTag'),
            attachments : component.get('v.attachments')
        });
        slideInAttachments.fire();
    },
    updateAttachments : function(component, event, helper) {
        var updatedSelectedAttachments = event.getParam("arguments").selectedAttachments;
        component.set("v.selectedAttachments", updatedSelectedAttachments);
        
        component.set("v.hasAttachmentsSelected", updatedSelectedAttachments.length > 0);
    },
    handleRemovePill : function(component, event, helper) {
        //The 'id' that comes in has the 'globalIdTag' prepended
        var clickedId = event.getParam("id");
        var rawId = clickedId.replace(component.get("v.globalIdTag"), "");
        
        var selectedAttachments = component.get("v.selectedAttachments");
        for (var i = 0; i < selectedAttachments.length; i++) {
            if (selectedAttachments[i].Id === rawId) {
                selectedAttachments.splice(i, 1);
                break;
            }
        }
        component.set("v.selectedAttachments", selectedAttachments);
        
        component.set("v.hasAttachmentsSelected", selectedAttachments.length > 0);
        
        helper.fireRemoveAttachment(component, rawId, selectedAttachments);
    }
})