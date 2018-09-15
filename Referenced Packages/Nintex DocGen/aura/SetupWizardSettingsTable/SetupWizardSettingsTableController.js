({
    doInit : function(component, event, helper) {
    	helper.usersProfiles(component, event);
    },
    editSettings : function(component, event, helper) {
        var id = event.target.getAttribute("data-data");
        
        $A.util.addClass(helper.getEditLink(component, id), "hidden");
        $A.util.removeClass(helper.getEditSpinner(component, id), "hidden");
        
        helper.isProfile(component, id);
        helper.loadDefaults(component, id);
        helper.onloadPTE(component, id, event);
        
        component.find("pteModal").show();
    },
    newSettings : function(component, event, helper) {
        helper.loadAll(component, "Profile");
        helper.isProfile(component, "Profile");
        helper.onloadPTE(component, "New", event);
        component.set("v.recordId", "");
        
        component.find("pteModal").show();
    },
    resetSelectedOption : function(component, event, helper) {
        component.set("v.selectedOption", "");
        
        helper.closePtEModal(component);
    },
    optionChange : function(component, event, helper) {
        component.set("v.profileUserSelection", event.getSource().get("v.value"));
    },
    pteChange: function(component, event) {
        component.set("v.pauseToEditSelection", event.getSource().get("v.text"));
    },
    typeChange: function(component, event, helper) {
        var change = event.getSource().get("v.value");
        if (change === component.get("v.defaultType") && component.get("v.selectedOption") !== 'New') {
            component.set("v.userProfileOptions", component.get("v.defaultOptions"));
        } else {
            helper.loadAll(component, change);
        }
    },
    saveSettings : function(component, event, helper) {
        component.set('v.busy', true);
        var selection = component.get("v.profileUserSelection");
        var pauseToEdit = component.get("v.pauseToEditSelection");
        var recordId = component.get("v.recordId");
        if (!recordId) {
            recordId = "New";
        }
        var save = component.get("c.saveRecord");
        save.setParams({ 
            recordId : recordId,
            profileUserId : selection, 
            pte : pauseToEdit 
        });
        save.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                helper.usersProfiles(component);
            } else {
                component.set("v.selectedOption", "");
                component.set('v.busy', false);
            }
            
            helper.closePtEModal(component);
        });
        $A.enqueueAction(save);
    },
    deleteSettings : function(component, event, helper) {
        var recordId = event.target.getAttribute("data-data");
        
        var deleteLink = helper.getDeleteLink(component, recordId);
        var deleteSpinner = helper.getDeleteSpinner(component, recordId);
        
        $A.util.addClass(deleteLink, "hidden");
        $A.util.removeClass(deleteSpinner, "hidden");
        
        var d = component.get("c.deleteRecord");
        d.setParams({ "recordId" : recordId });
        d.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                helper.usersProfiles(component);
            }
        });
        $A.enqueueAction(d);
    }
})