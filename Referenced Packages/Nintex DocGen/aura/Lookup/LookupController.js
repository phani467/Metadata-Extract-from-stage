({
    openLookupMenu : function(component) {
        component.set("v.recordsFound", []);
        $A.util.addClass(component.find("lookupMenu"), "show");
        
        var lookupMenuElement = component.find("lookupMenu").getElement();
        
        //Within the RunDdp context:
        //Can't pop out the dropdown menu due to `overflow-y: auto;` on AccordionSection.cmp. Instead, use `position:fixed;` and insta-snap the menu to where it's suppose to be.
        var buttonBoundingRect = component.find('lookupButton').getElement().getBoundingClientRect();
        var width = buttonBoundingRect.width;
        var left = buttonBoundingRect.left;
        var top = buttonBoundingRect.top + buttonBoundingRect.height;
        
        //This won't work on the SF1 app. Mobile browsers read 'position:fixed' as 'position:absolute'.
        //We need to either figure out a solution without using 'position:fixed' or rework things inside AccordionSection.cmp.
        lookupMenuElement.hidden = false;
        lookupMenuElement.style.position = 'fixed';
        lookupMenuElement.style.width = width + 'px';
        lookupMenuElement.style.left = left + 'px';
        lookupMenuElement.style.top = top + 'px';
    },
    closeLookupMenu : function(component, event, helper) {
        helper.closeLookupMenu(component);
    },
    blurLookupMenu : function(component, event, helper) {
        var lookupMenu = component.find('lookupMenu') && component.find('lookupMenu').getElement && component.find('lookupMenu').getElement();
        if (lookupMenu && event.relatedTarget !== lookupMenu && !lookupMenu.contains(event.relatedTarget)) {
            helper.closeLookupMenu(component);
        }
    },
    updateSearchString : function(component, event, helper) {
        component.set("v.searchString", event.target.value);
        helper.resetSelectedRecordId(component, null);
    },
	search : function(component, event, helper) {
        var searchString = component.get('v.searchString');
        var executeSearch = false;
        if ((event.type === "keydown" && event.keyCode === 13) || event.type === "click") {
            executeSearch = true;
        }
        if (executeSearch && searchString) {
        	$A.util.removeClass(component.find("searchResultsLoading"), 'hidden');
            
            var objectType = component.get("v.objectType");
            var action = component.get("c.searchForRecords");
            action.setParams({
                objectType: objectType,
                searchString: searchString
            });
            action.setCallback(this, function(response) {
                if (response.getState() === "SUCCESS") {
                    var parsedResponse = JSON.parse(response.getReturnValue());
                    if (parsedResponse.isSuccess) {
                        component.set("v.recordsFound", parsedResponse.records);
                    }
                    else {
                        component.set("v.recordsFound", []);
                    }
                }
                else {
                    component.set("v.recordsFound", []);
                }
                
                $A.util.addClass(component.find("searchResultsLoading"), 'hidden');
            });
            
            $A.enqueueAction(action);
        }
	},
    recordSelected : function(component, event, helper) {
        var selectedId = event.currentTarget.id;
        var recordsList = component.get("v.recordsFound");
        var selectedRecord;
        if (recordsList.length) {
            for (var i = 0; i < recordsList.length; i++) {
                if (recordsList[i].Id === selectedId) {
                    selectedRecord = recordsList[i];
                    break;
                }
            }
        }
        else {
            selectedRecord = recordsList;
        }
        
        component.set("v.searchString", selectedRecord.Name);
        component.set("v.recordsFound", []);
        helper.closeLookupMenu(component);
        
        helper.resetSelectedRecordId(component, selectedRecord);
    }
})