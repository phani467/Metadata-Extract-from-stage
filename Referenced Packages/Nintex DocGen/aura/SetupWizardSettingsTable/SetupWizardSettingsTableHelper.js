({
	usersProfiles : function(component) {
		var action = component.get("c.currentUsersProfiles");
        action.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                var retVal = JSON.parse(response.getReturnValue());
                component.set("v.profileUsers", retVal);
                var hideSpinner = component.getEvent("hideSpinner");
				hideSpinner.fire();
                component.set("v.selectedOption", "");
            } else {
                component.getEvent('showError').setParams({
                    message: $A.get('$Label.loop.Generic_Error_Message')
                }).fire();
            }
            component.set('v.busy', false);
        });
		$A.enqueueAction(action);
	},
    loadDefaults : function(component, recordId) {
        var isProfile = component.get("c.isProfile");
        isProfile.setParams({ "selection" : recordId });
        isProfile.setCallback(this, function(response) {
            if (response.getState() === 'SUCCESS') {
                var defaultVal = response.getReturnValue();
                component.set("v.defaultType", defaultVal);
                if (defaultVal === "Profile") {
                    component.find("profile").set("v.value", true);
                    component.find("user").set("v.value", false);
                } else {
                    component.find("profile").set("v.value", false);
                    component.find("user").set("v.value", true);
                }
            }
        });
        $A.enqueueAction(isProfile);
        
        var action = component.get("c.modalDefaultDropdownOptions");
        action.setParams({ "defaultSelection" : recordId });
        action.setCallback(this, function(response) {
            var retVal = JSON.parse(response.getReturnValue());
            component.set("v.userProfileOptions", retVal);
            component.set("v.defaultOptions", retVal);
        });
        $A.enqueueAction(action);
        component.set("v.profileUserSelection", recordId);
        component.set("v.recordId", recordId);
    },
    loadAll : function(component, selection) {
        var load = component.get("c.modalAlternateDropdownOptions");
        load.setParams({ "selection" : selection });
        load.setCallback(this, function(response) {
           var retVal = JSON.parse(response.getReturnValue());
           component.set("v.userProfileOptions", retVal);
           component.set("v.profileUserSelection", retVal[0].i);
        });
        $A.enqueueAction(load);
    },
    isProfile : function(component, recordId) {
        var isProfile = component.get("c.isProfile");
        isProfile.setParams({ "selection" : recordId });
        isProfile.setCallback(this, function(response) {
            var defaultVal = response.getReturnValue();
           	component.set("v.defaultType", defaultVal);
            if (defaultVal === "Profile") {
                component.find("profile").set("v.value", true);
            	component.find("user").set("v.value", false);
	        } else {
            	component.find("profile").set("v.value", false);
            	component.find("user").set("v.value", true);
    	    }
        });
        $A.enqueueAction(isProfile);
    },
    onloadPTE : function(component, recordId, event) {
        var currentPTEList = component.get("c.loadPauseToEdit");
        currentPTEList.setParams({ 
            "selected": recordId 
        });
        currentPTEList.setCallback(this, function(response) {
            if (response.getState() === 'SUCCESS') {
                var result = response.getReturnValue();
                var tmpSelection = document.getElementsByClassName('radio');
                for (var i = 0; i < tmpSelection.length; i++) {
                    if (tmpSelection[i].value === result) {
                        tmpSelection[i].checked = true;
                    } else if (!result) {
                        if (tmpSelection[i].value === 'Use Organization-Wide') {
                            tmpSelection[i].checked = true;
                        }
                    } else {
                        tmpSelection[i].checked = false;
                    }
                }
                component.set("v.pauseToEditSelection", result);
                recordId === "New" ? component.set("v.selectedOption", "New") : component.set("v.selectedOption", "Edit");
                
                //The modal loads with a spinner as its content, so once we're ready to display the actual modal, remove the spinner and show our content
                $A.util.removeClass(component.find("modalContent"), "hidden");
                $A.util.addClass(component.find("modalLoadingSpinner"), "hidden");
            }
		});
        $A.enqueueAction(currentPTEList);
    },
    closePtEModal : function(component) {
        var editLinks = component.find("editLink");
        var editSpinners = component.find("editSpinner");
        if (editLinks && editSpinners) {
            if (editLinks.length && editSpinners.length && editLinks.length == editSpinners.length) {
                for (var i = 0; i < editLinks.length; i ++) {
                    $A.util.removeClass(editLinks[i], "hidden");
                    $A.util.addClass(editSpinners[i], "hidden");
                }
            }
            else {
                $A.util.removeClass(editLinks, "hidden");
                $A.util.addClass(editSpinners, "hidden");
            }
        }
        
        $A.util.removeClass(component.find("modalLoadingSpinner"), "hidden");
        $A.util.addClass(component.find("modalContent"), "hidden");
        component.find("pteModal").hide();
    },
    getEditLink : function(component, id) {
        var editLink = component.find("editLink");
        
        if (editLink.length) {
            for (var i = 0; i < editLink.length; i ++) {
                if (editLink[i].getElement().id === 'editLink' + id) {
                    editLink = editLink[i];
                    break;
                }
            }
        }
        
        return editLink;
    },
    getEditSpinner : function(component, id) {
        var editSpinner = component.find("editSpinner");
        
        if (editSpinner.length) {
            for (var i = 0; i < editSpinner.length; i ++) {
                if (editSpinner[i].getElement().id === 'editSpinner' + id) {
                    editSpinner = editSpinner[i];
                    break;
                }
            }
        }
        
        return editSpinner;
    },
    getDeleteLink : function(component, id) {
        var deleteLink = component.find("deleteLink");
        
        if (deleteLink.length) {
            for (var i = 0; i < deleteLink.length; i ++) {
                if (deleteLink[i].getElement().id === 'deleteLink' + id) {
                    deleteLink = deleteLink[i];
                    break;
                }
            }
        }
        
        return deleteLink;
    },
    getDeleteSpinner : function(component, id) {
        var deleteSpinner = component.find("deleteSpinner");
        
        if (deleteSpinner.length) {
            for (var i = 0; i < deleteSpinner.length; i ++) {
                if (deleteSpinner[i].getElement().id === 'deleteSpinner' + id) {
                    deleteSpinner = deleteSpinner[i];
                    break;
                }
            }
        }
        
        return deleteSpinner;
    }
})