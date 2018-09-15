({
    onInit : function(component, event, helper) {
        var getDdps = component.get("c.getDdps");
        getDdps.setParams({
            sessionId: component.get('v.sessionId'),
            domain: component.get('v.loopUrl')
        });
        getDdps.setCallback(this, function(response) {
            if (response.getState() === 'SUCCESS') {
                var parsedResponse = JSON.parse(response.getReturnValue());
                if (parsedResponse.isSuccess) {
                    component.set('v.sampleDdpParentRows', parsedResponse.parentRows);
                }
                else {
                    helper.fireErrorEvent(component, $A.get('$Label.loop.Sample_Retrieval_Error_Message'));
                }
            }
            else {
                helper.fireErrorEvent(component, $A.get('$Label.loop.Sample_Retrieval_Error_Message'));
            }
            
            component.set('v.isTableContentLoading', false);
        });
        
        $A.enqueueAction(getDdps);
	},
    toggleChildRowsDisplay : function(component, event) {
        var selectedParentId = event.currentTarget.id;
        var sampleDdpParentRows = component.get('v.sampleDdpParentRows');
        
        for (var i = 0; i < sampleDdpParentRows.length; i++) {
            if (sampleDdpParentRows[i].industryName === selectedParentId) {
                for (var j = 0; j < sampleDdpParentRows[i].childRows.length; j++) {
                    //If child rows are currently hidden, then show them
                    if (sampleDdpParentRows[i].isChildRowsHidden) {
                        sampleDdpParentRows[i].childRows[j].isHidden = false;
                    }
                    else {
                        sampleDdpParentRows[i].childRows[j].isHidden = true;
                    }
                }
                sampleDdpParentRows[i].isChildRowsHidden = !sampleDdpParentRows[i].isChildRowsHidden;
            }
            break;
        }
        
        component.set('v.sampleDdpParentRows', sampleDdpParentRows);
    },
    toggleParentCheckbox : function(component, event) {
        var sampleDdpParentRows = component.get('v.sampleDdpParentRows');
        var selectedIndustryName = event.currentTarget.id;
        
        for (var i = 0; i < sampleDdpParentRows.length; i++) {
            if (sampleDdpParentRows[i].industryName === selectedIndustryName) {
                for (var j = 0; j < sampleDdpParentRows[i].childRows.length; j++) {
                    //If sampleDdpParentRows[i] is currently enabled, then it is about to be disabled
                    if (sampleDdpParentRows[i].isEnabled) {
                        sampleDdpParentRows[i].childRows[j].isEnabled = false;
                    }
                    else {
                        sampleDdpParentRows[i].childRows[j].isEnabled = true;
                    }
                }
                
                sampleDdpParentRows[i].isTristate = false;
                break;
            }
        }
        
        component.set('v.sampleDdpParentRows', sampleDdpParentRows);
    },
    toggleChildCheckbox : function(component, event) {
        var selectedId = event.currentTarget.id;
        var selectedElementAttributes = event.currentTarget.attributes;
        var parentIndustryName;
        
        for (var i = 0; i < selectedElementAttributes.length; i++) {
            if (selectedElementAttributes[i].name === 'data-parent') {
                parentIndustryName = selectedElementAttributes[i].value;
                break;
            }
        }
        
        var sampleDdpParentRows = component.get('v.sampleDdpParentRows');
        
        for (var i = 0; i < sampleDdpParentRows.length; i++) {
            if (sampleDdpParentRows[i].industryName === parentIndustryName) {
            	var childCount = sampleDdpParentRows[i].childRows.length;
                var enabledChildCount = 0;
                for (var j = 0; j < sampleDdpParentRows[i].childRows.length; j++) {
                    if (sampleDdpParentRows[i].childRows[j].id === selectedId) {
                        //If row's checkbox is currently unchecked, then it is about to be checked;
                        if (!sampleDdpParentRows[i].childRows[j].isEnabled) {
                            enabledChildCount++;
                        }
                    }
                    else if (sampleDdpParentRows[i].childRows[j].isEnabled) {
                        enabledChildCount++;
                    }
                }
                
                sampleDdpParentRows[i].isEnabled = enabledChildCount > 0;
                sampleDdpParentRows[i].isTristate = sampleDdpParentRows[i].isEnabled && enabledChildCount < childCount;
            }
            break;
        }
        
        component.set('v.sampleDdpParentRows', sampleDdpParentRows);
    },
    save : function(component, event, helper) {
        var selectedIds = [];
        var selectedObjectTypes = [];
        
        var sampleDdpParentRows = component.get('v.sampleDdpParentRows');
        for (var i = 0; i < sampleDdpParentRows.length; i++) {
            for (var j = 0; j < sampleDdpParentRows[i].childRows.length; j++) {
                if (sampleDdpParentRows[i].childRows[j].isEnabled) {
                    selectedIds.push(sampleDdpParentRows[i].childRows[j].id);
                    selectedObjectTypes.push(sampleDdpParentRows[i].childRows[j].recordType);
                }
            }
        }
        
        var migrateDdps = component.get('c.migrateDdps');
        migrateDdps.setParams({
            sessionId: component.get("v.sessionId"),
            folderId: '',
            selectedDdpIds: selectedIds,
            domain: component.get('v.loopUrl'),
            selectedObjectTypes: selectedObjectTypes
        });
        migrateDdps.setCallback(this, function(response) {
            var moveToNextStep = component.getEvent('moveToNextStep');
            if (response.getState() == 'SUCCESS') {
                var parsedResponse = JSON.parse(response.getReturnValue());
                
                if (parsedResponse.isSuccess) {
                    var setSampleObjectsEvent = component.getEvent('setSampleObjects');
                    setSampleObjectsEvent.setParams({
                        sampleType: 'sampleDdps',
                        objectTypes: parsedResponse.selectedObjectTypes
                    });
                    setSampleObjectsEvent.fire();
                    
                    moveToNextStep.setParams({
                        success: true
                    });
                }
                else {
                    helper.fireErrorEvent(component, $A.get('$Label.loop.Migration_Error_Message'));
                    moveToNextStep.setParams({
                        success: false
                    });
                }
            }
            else {
                helper.fireErrorEvent(component, $A.get('$Label.loop.Migration_Error_Message'));
                moveToNextStep.setParams({
                    success: false
                });
            }
            
            moveToNextStep.fire();
        });
        
        $A.enqueueAction(migrateDdps);
    },
    filterDdps : function(component, event, helper) {
        helper.performFilter(component, event.getParam('arguments').searchText, event.getParam('arguments').industry);
    }
})