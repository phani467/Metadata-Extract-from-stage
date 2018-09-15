({
	fireRemoveAttachment : function(component, clickedId, selectedAttachments) {
        var event = component.getEvent("removeAttachment");
        event.setParams({
            globalIdTag: component.get('v.globalIdTag'),
            removeAttachmentId: clickedId,
            remainingAttachments: selectedAttachments
        });
        event.fire();
	}
})