({
    fireErrorEvent : function(component, message) {
        var errorEvent = component.getEvent("error");
        errorEvent.setParams({
            message: message
        });
        errorEvent.fire();
    },
    recordSelected : function(component) {
        var records = component.get("v.records");
		var recordType = component.get("v.recordType").toLowerCase();
        var selectedRecords = component.get("v.selectedTiles");
        
        switch (recordType) {
            case "record":
                var selectedRecord = selectedRecords[0];
                var records = component.get("v.records");
                for (var i = 0; i < records.length; i++) {
                    if (records[i].Id === selectedRecord.id) {
                        var record = records[i];
                        var recordSelected = component.getEvent("recordSelected");
                        recordSelected.setParams({
                            id: selectedRecord.id,
                            name: selectedRecord.name
                        });
                        recordSelected.fire();
                        break;
                    }
                }
                break;
            case "ddp":
                var selectedDdp = selectedRecords[0];
                for (var i = 0; i < records.length; i++) {
                    if (records[i].Id === selectedDdp.id) {
                        var ddpRecord = records[i];
                        var ddpSelected = component.getEvent("ddpSelected");
                        ddpSelected.setParams({
                            id: selectedDdp.id,
                            name: selectedDdp.name,
                            contactRequired: ddpRecord.ContactRequired,
                            attachmentAllowed: ddpRecord.AttachmentAllowed,
                            attachmentRequired: ddpRecord.AttachmentRequired,
                            hasOptionalDocuments: ddpRecord.HasOptionalDocuments,
                            hasAdhocApexClass: ddpRecord.HasAdhocApexClass
                        });
                        ddpSelected.fire();
                        break;
                    }
                }
                break;
            case "contact":
                var selectedContact = selectedRecords[0];
                var contactSelected = component.getEvent("contactSelected");
                contactSelected.setParams({
                    id: selectedContact.id,
                    name: selectedContact.name
                });
                contactSelected.fire();
                break;
            case "document":
                var selectedDocuments = selectedRecords;
                var selectedDocumentIds = [];
                for (var j = 0; j < selectedDocuments.length; j++) {
                    selectedDocumentIds.push(selectedDocuments[j].id);
                }
                
                var event = component.getEvent("documentSelected");
                event.setParams({
                    ids: selectedDocumentIds
                });
                event.fire();
                break;
            case "delivery":
                var clickedTile = component.get("v.clickedTile");
                var deliveryOptionSelected = component.getEvent("deliveryOptionSelected");
                deliveryOptionSelected.setParams({
                    id: clickedTile.id,
                    name: clickedTile.name,
                    deliveryType: clickedTile.deliveryType,
                    attachToRecord: clickedTile.attachToRecord,
                    selectedContentLibrary: clickedTile.selectedContentLibrary,
                    emailSubject: clickedTile.emailSubject,
                    emailBody: clickedTile.emailBody,
                    reminderDelay: clickedTile.reminderDelay,
                    reminderFrequency: clickedTile.reminderFrequency,
                    expireAfter: clickedTile.expireAfter,
                    expireWarn: clickedTile.expireWarn,
                    isTestDelivery: clickedTile.isTestDelivery
                });
                deliveryOptionSelected.fire();
                break;
            default:
                break;
        }
	}
})