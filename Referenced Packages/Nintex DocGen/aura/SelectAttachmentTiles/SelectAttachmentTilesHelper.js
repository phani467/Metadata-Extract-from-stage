({
    fireAttachmentIds : function(component, selectedAttachments) {
        var event = component.getEvent("attachmentsSelected");
        event.setParams({
            selectedAttachments: selectedAttachments
        });
        event.fire();
    },
    fireSlideOut : function(component) {
        var slideOutAttachments = component.getEvent("slideOutAttachments").fire();
    }
})