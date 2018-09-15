({
	closeLookupMenu : function(component) {
		var lookupMenu = component.find("lookupMenu");
        $A.util.removeClass(component.find("lookupMenu"), "show");
	},
    resetSelectedRecordId : function(component, selectedRecord) {
        var event = component.getEvent("recipientSelected");
        event.setParams({
            id: selectedRecord && selectedRecord.Id ? selectedRecord.Id : ''
        });
        event.fire();
    }
})