({
    onInit : function(component, event, helper) {
        var sessionId = component.get("v.sessionId");
        var domain = component.get("v.apiUrl");
        
        var loadTableData = component.get("c.loadTableData");
        loadTableData.setParams({
            sessionId: sessionId,
            domain: domain
        });
        loadTableData.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                var parsedResponse = JSON.parse(response.getReturnValue());
                if (parsedResponse.isSuccess) {
                    helper.updateTableData(component, parsedResponse);
                }
                else {
                    helper.fireErrorEvent(component, parsedResponse.errorMessage);
                }
            }
            else {
                helper.fireErrorEvent(component, 'There was a problem retrieving layout metadata.');
            }
            
            component.set("v.isTableLoading", false);
        });
        
        $A.enqueueAction(loadTableData);
    },
    toggleRow : function(component, event, helper) {
        var selectedRow = event.currentTarget;
        var allParentRows = component.get("v.layouts");
        for (var i = 0; i < allParentRows.length; i ++) {
            if (allParentRows[i].objectName === selectedRow.id) {
                allParentRows[i].isExpanded = !allParentRows[i].isExpanded;
                break;
            }
        }
        component.set("v.layouts", allParentRows);
    },
    parentCheckboxClicked : function(component, event, helper) {
        var selectedRowId = event.currentTarget.id;
        var allParentRows = component.get("v.layouts");
        var enabledCount = component.get("v.enabledCount");
        
        for (var i = 0; i < allParentRows.length; i ++) {
            if (allParentRows[i].objectName === selectedRowId) {
                allParentRows[i].isTristate = false;
                
                for (var j = 0; j < allParentRows[i].childLayouts.length; j ++) {
                    if (allParentRows[i].isChecked || allParentRows[i].isTristate) {
                        if (allParentRows[i].childLayouts[j].isChecked) {
                            enabledCount --;
                        }
                        allParentRows[i].childLayouts[j].isChecked = false;
                    }
                    else {
                        if (!allParentRows[i].childLayouts[j].isChecked) {
                            enabledCount ++;
                        }
                    	allParentRows[i].childLayouts[j].isChecked = true;
                    }
                }
                
                component.set("v.enabledCount", enabledCount);
                break;
            }
        }
    },
    childCheckboxClicked : function(component, event, helper) {
        var selectedRowId = event.currentTarget.id;
        var allParentRows = component.get("v.layouts");
        var parentId;
        
        //Since 'event.currentTarget.data-parent' is not a valid statement with LockerService activated, loop through its attributes to get the value of 'data-parent'
        for (var i = 0; i < event.currentTarget.attributes.length; i ++) {
            var attribute = event.currentTarget.attributes[i];
            if (attribute.name === 'data-parent') {
                parentId = attribute.value;
            }
        }
        
        var enabledCount = component.get("v.enabledCount");
        
        for (var i = 0; i < allParentRows.length; i ++) {
            if (allParentRows[i].objectName === parentId) {
                var childLayouts = allParentRows[i].childLayouts;
                
                //This is used to determine whether or not a parent row's checkbox is in a tristate. Is not related to 'enabledCount'.
        		var enabledChildLayouts = 0;
                
                for (var j = 0; j < childLayouts.length; j ++) {
                    if (childLayouts[j].id === selectedRowId) {
                        //ui:inputCheckbox will toggle the value of isChecked, so we don't have to change it here.
                        //If the current checkbox is currently false, then it is about to become true
                        if (!childLayouts[j].isChecked) {
                            enabledCount ++;
                            enabledChildLayouts ++;
                        }
                        else {
                            enabledCount --;
                        }
                    }
                    else if (childLayouts[j].isChecked) {
                        enabledChildLayouts ++;
                    }
                }
                
                allParentRows[i].isChecked = enabledChildLayouts > 0;
            	allParentRows[i].isTristate = allParentRows[i].isChecked && (enabledChildLayouts < childLayouts.length);
            }
        }
        
        component.set("v.enabledCount", enabledCount);
        component.set("v.layouts", allParentRows);
    },
    save : function(component, event, helper) {
        var allParentLayouts = component.get("v.layouts");
        var checkedLayoutIds = [];
        var checkedObjectTypes = [];
        
        for (var i = 0; i < allParentLayouts.length; i ++) {
            var childLayouts = allParentLayouts[i].childLayouts;
            var addObjectType = false;
            
            for (var j = 0; j < childLayouts.length; j ++) {
                if (childLayouts[j].isChecked) {
                	checkedLayoutIds.push(childLayouts[j].id);
                    addObjectType = true;
                }
            }
            
            if (addObjectType) {
                checkedObjectTypes.push(allParentLayouts[i].objectName);
            }
        }
        
        var action = component.get("c.saveLayouts");
        action.setParams({
            checkedLayoutIds: checkedLayoutIds,
            layoutMetadataJson: component.get("v.layoutMetadata"),
            domain: component.get('v.apiUrl')
        });
        action.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                var parsedResponse = JSON.parse(response.getReturnValue());
                if (parsedResponse.isSuccess) {
                    // Since we are not getting a response from the server on the status of the layout update, we update the metadata to match the currently checked checkboxes.
                    helper.updateLayoutMetadata(component, checkedLayoutIds);
                    var setSampleObjectsEvent = component.getEvent('setSampleObjects');

                    setSampleObjectsEvent.setParams({
                        sampleType: 'layoutButtons',
                        objectTypes: checkedObjectTypes
                    });
                    setSampleObjectsEvent.fire();
                    
        			var moveToNextStep = component.getEvent("moveToNextStep");
                    moveToNextStep.setParams({
                        success: true,
                        successMessage: $A.get('$Label.loop.RequestSubmitted_Message')
                    }).fire();
                }
                else {
                    helper.fireErrorEvent(component, parsedResponse.errorMessage);
                    var moveToNextStep = component.getEvent("moveToNextStep");
                    moveToNextStep.setParams().fire();
                }
            }
            else {
                helper.fireErrorEvent(component, 'There was a problem modifying layouts.');
                var moveToNextStep = component.getEvent("moveToNextStep");
                moveToNextStep.setParams().fire();
            }
        });
        
        $A.enqueueAction(action);
    },
    createButton : function(component, event, helper) {
        var objectType = component.find('customObjectSelect').get('v.value');
        if (objectType) {
        	helper.toggleLinkAndSpinner(component, false);
            
            var action = component.get("c.createWeblink");
            action.setParams({
                sessionId: component.get("v.sessionId"),
                objectType: objectType,
                domain: component.get('v.apiUrl')
            });
            action.setCallback(this, function(response) {
                if (response.getState() === "SUCCESS") {
                    var parsedResponse = JSON.parse(response.getReturnValue());
                    if (parsedResponse.isSuccess) {
                        helper.updateTableData(component, parsedResponse);
                    }
                    else {
                    	helper.fireErrorEvent(component, parsedResponse.errorMessage);
                    }
                }
                else {
                    helper.fireErrorEvent(component, 'There was a problem creating this button.');
                }
                
                helper.toggleLinkAndSpinner(component, true);
            });
            $A.enqueueAction(action);
        } else {
            helper.fireErrorEvent(component, 'This object type could not be found.');
        }
    },
    filterLayouts : function(component, event, helper) {
        helper.filterLayouts(component, event.getParam('arguments').searchText);
    }
})