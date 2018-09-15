({
	sendRecipientInfo : function(component) {
        var recipient = component.get("v.recipient");
        var id = recipient.Id;
        var recipientType = recipient.RecipientType;
        var selectedRecipientId;
        var recipientSelected = false;
        
        if (recipientType === '' || recipientType === 'NameEmail') {
            selectedRecipientId = "name_email";
        }
        else {
            selectedRecipientId = component.get("v.selectedRecipientId");
        }
        
        if (component.get("v.selectedRecipientId") || (component.get("v.name") && component.get("v.email")) || (recipient.Required || recipientType === 'SigningGroup')) {
            recipientSelected = true;
        }
        
        var storeRecipientInfo = component.getEvent('storeRecipientInfo');
        storeRecipientInfo.setParams({
            id: id,
            selectedRecipientId: selectedRecipientId,
            isHost: component.get("v.isHost"),
            recipientName: component.get("v.name"),
            recipientEmail: component.get("v.email"),
            accessCode: component.get("v.accessCodeValue"),
            note: component.get("v.noteValue"),
            satisfied: recipientSelected || !recipient.Required
        });
        storeRecipientInfo.fire();
	},
})