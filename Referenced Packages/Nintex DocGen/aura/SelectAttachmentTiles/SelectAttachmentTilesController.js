({
	loadAttachments : function(component, event, helper) {
        var attachments = event.getParams().arguments.attachments;
        var globalIdTag = event.getParams().arguments.globalIdTag;
        
		component.set('v.attachments', attachments);
        component.set('v.globalIdTag', globalIdTag);    
    },
    cancel : function(component, event, helper){
        var allTiles = component.find("tile");
        var selectedAttachments = component.get("v.selectedAttachments");
        var selectedAttachmentsIds = [];
        
        for (var i = 0; i < selectedAttachments.length; i++) {
            var attachment = selectedAttachments[i];
            selectedAttachmentsIds.push(attachment.Id);
        }
        
        if (allTiles) {
            for (var j = 0; j < allTiles.length; j++) {
                var tile = allTiles[j];
                var id = tile.getElement().getAttribute("id").replace(component.get("v.globalIdTag"), "");
                if (selectedAttachmentsIds.indexOf(id) > -1) {
                    tile.forcedSelect();
                }
                else {
                    tile.forcedDeselect();
                }
            }    
        }
        
        component.set("v.updatedSelectedAttachments", selectedAttachments);
        component.set('v.disableApply', true);

        helper.fireSlideOut(component);
    },
    handleTileClicked : function(component, event) {
        var clickedId = event.getParam("id").replace(component.get("v.globalIdTag"), "");
        var currentUpdatedSelectedAttachments = component.get("v.updatedSelectedAttachments");
        var selectedTile;
        
        var newUpdatedSelectedAttachments = [];
        for (var i = 0; i < currentUpdatedSelectedAttachments.length; i++) {
            newUpdatedSelectedAttachments.push(currentUpdatedSelectedAttachments[i]);
        }

        var attachments = component.get("v.attachments");
        for (var j = 0; j < attachments.length; j++) {
            var a = attachments[j];
            if (a.Id === clickedId) {
                selectedTile = a;
                break;
            }
        }
        if (currentUpdatedSelectedAttachments.length === 0) {
            newUpdatedSelectedAttachments.push(selectedTile);
        }
        else {
            var attachmentNotFound = true;
            
            for (var k = 0; k < currentUpdatedSelectedAttachments.length; k++) {
                if (currentUpdatedSelectedAttachments[k].Id === clickedId) {
                    attachmentNotFound = false;
                    newUpdatedSelectedAttachments.splice(k, 1);
                    break;
                }
            }
            
            if (attachmentNotFound) {
                newUpdatedSelectedAttachments.push(selectedTile);
            }
        }
        component.set("v.updatedSelectedAttachments", newUpdatedSelectedAttachments);
        component.set("v.disableApply", false);
    },
    updateAttachments : function(component, event, helper) {
    	var updatedSelectedAttachments = component.get("v.updatedSelectedAttachments");
        component.set("v.selectedAttachments", updatedSelectedAttachments);
        component.set('v.disableApply', true);
        
        helper.fireAttachmentIds(component, updatedSelectedAttachments);
        helper.fireSlideOut(component);
    },
    updateDeselectedAttachments : function(component, event, helper) {
        component.set('v.updatedSelectedAttachments', event.getParam("arguments").remainingAttachments);
        component.set('v.selectedAttachments', event.getParam("arguments").remainingAttachments);
        var removedAttachmentId =  event.getParam("arguments").removedAttachmentId;
        
        var tiles = component.find("tile");
        for (var i = 0; i < tiles.length; i++) {
            var t = tiles[i];
            var tileElement = t.getElement();
            if (tileElement.getAttribute("id") === component.get('v.globalIdTag') + removedAttachmentId) {
                t.forcedDeselect();
            }
        }
    }
})