({
	onInit : function(component, event, helper) {
		var init = component.get('c.init');
        init.setParams({
            isConfigUsers: component.get('v.isConfigUsers')
        });
        init.setCallback(this, function(response) {
            if (response.getState() === 'SUCCESS') {
                var parsedResponse = JSON.parse(response.getReturnValue());
                if (parsedResponse.isSuccess) {
                    component.set('v.profiles', parsedResponse.profiles);
                    component.set('v.availUsers', parsedResponse.availUsers);
                    component.set('v.ddpAdmins', parsedResponse.ddpAdmins);
                    component.set('v.isSandbox', parsedResponse.isSandbox);
                    component.set('v.tooManyUsers', parsedResponse.availUsers.length > 1000);
                    component.set('v.queryIds', parsedResponse.queryIds);
                    
                    if (component.get('v.isConfigUsers')) {
                    	component.set('v.ddpUsers', parsedResponse.ddpUsers);
                        component.set('v.usedLicenses', parsedResponse.usedLicenses);
                        component.set('v.allowedLicenses', parsedResponse.allowedLicenses);
                        component.set('v.hasSiteWideLicense', parsedResponse.hasSiteWideLicense);
                        component.set('v.provisionedString', helper.updateProvisionedString(component));
                    }
                    else {
                    	component.set('v.ddpTesters', parsedResponse.ddpTesters);    
                    }
                }
                else {
                    helper.fireErrorEvent(component, parsedResponse.errorMessage);
                }
            }
            else {
                helper.fireErrorEvent(component, 'An unexpected error has occurred.');
            }
            
            var actionEvent = component.getEvent('actionEvent');
            actionEvent.setParams({
                action: 'doneLoading'
            });
            actionEvent.fire();
        });
        
        $A.enqueueAction(init);
	},
    handleActionEvent : function(component, event, helper) {
        var action = event.getParam('action');
        var params = event.getParam('params') ? JSON.parse(event.getParam('params')) : '';
        
        //Use switch-case if more than 2 options
        if (action === 'itemSelected') {
            var picklistComponentId = $A.getComponent(params.sourceId).getLocalId();
            
            switch (picklistComponentId) {
                case 'profiles':
                    helper.filterAvailableUsers(component, params.item);
                    break;
                default:
                    break;
            }
        }
    },
    addAdmin : function(component, event, helper) {
        var usedLicenses = component.get('v.usedLicenses');
        if (usedLicenses < component.get('v.allowedLicenses') || component.get('v.isSandbox') || component.get('v.hasSiteWideLicense')) {
            var availUsers = component.get('v.availUsers');
            var ddpAdmins = component.get('v.ddpAdmins');
            
            for (var i = 0; i < availUsers.length; i++) {
                if (availUsers[i].IsSelected) {
                    if (availUsers[i].CanBeAdmin) {
                        helper.stageUser(component, 'admin', availUsers[i]);
                        
                        availUsers[i].IsSelected = false;
                        availUsers[i].DesiredStatus = 'admin';
                        
                        ddpAdmins.push(availUsers[i]);
                        usedLicenses++;
                        
                        availUsers.splice(i, 1);
                        
                        break;
                    }
                    else {
                        helper.fireErrorEvent(component, 'This user cannot be an Admin.');
                    }
                }
            }
            
            component.set('v.availUsers', availUsers);
            component.set('v.ddpAdmins', helper.sortList(ddpAdmins));
            component.set('v.usedLicenses', usedLicenses);
            
            if (!component.get('v.isSandbox') && !component.get('v.hasSiteWideLicense')) {
                component.set('v.provisionedString', helper.updateProvisionedString(component));
            }
        }
        else {
            helper.fireErrorEvent(component, 'License seats exceeded.');
        }
    },
    removeAdmin : function(component, event, helper) {
        var usedLicenses = component.get('v.usedLicenses');
        var ddpAdmins = component.get('v.ddpAdmins');
        var availUsers = component.get('v.availUsers');
        
        for (var i = 0; i < ddpAdmins.length; i++) {
            if (ddpAdmins[i].IsSelected) {
                helper.stageUser(component, 'none', ddpAdmins[i]);
                
                ddpAdmins[i].IsSelected = false;
                ddpAdmins[i].DesiredStatus = 'none';
                
                if (component.get('v.selectedProfileId') === ddpAdmins[i].ProfileId || component.get('v.selectedProfileId') == 'allUsers') {
                	availUsers.push(ddpAdmins[i]);
                }
                usedLicenses--;
                
                ddpAdmins.splice(i, 1);
                
                break;
            }
        }
        
        component.set('v.ddpAdmins', ddpAdmins);
        component.set('v.availUsers', helper.sortList(availUsers));
        component.set('v.usedLicenses', usedLicenses);
            
        if (!component.get('v.isSandbox') && !component.get('v.hasSiteWideLicense')) {
            component.set('v.provisionedString', helper.updateProvisionedString(component));
        }
    },
    addUser : function(component, event, helper) {
        var usedLicenses = component.get('v.usedLicenses');
        if (usedLicenses < component.get('v.allowedLicenses') || component.get('v.isSandbox') || component.get('v.hasSiteWideLicense')) {
            var availUsers = component.get('v.availUsers');
            var ddpUsers = component.get('v.ddpUsers');
            
            for (var i = 0; i < availUsers.length; i++) {
                if (availUsers[i].IsSelected) {
                    helper.stageUser(component, 'user', availUsers[i]);
                    
                    availUsers[i].IsSelected = false;
                    availUsers[i].DesiredStatus = 'user';
                    
                    ddpUsers.push(availUsers[i]);
                    usedLicenses++;
                    
                    availUsers.splice(i, 1);
                    
                    break;
                }
            }
            
            component.set('v.availUsers', availUsers);
            component.set('v.ddpUsers', helper.sortList(ddpUsers));
            component.set('v.usedLicenses', usedLicenses);
            
            if (!component.get('v.isSandbox') && !component.get('v.hasSiteWideLicense')) {
                component.set('v.provisionedString', helper.updateProvisionedString(component));
            }
        }
        else {
            helper.fireErrorEvent(component, 'License seats exceeded.');
        }
    },
    removeUser : function(component, event, helper) {
        var usedLicenses = component.get('v.usedLicenses');
        var ddpUsers = component.get('v.ddpUsers');
        var availUsers = component.get('v.availUsers');
        
        for (var i = 0; i < ddpUsers.length; i++) {
            if (ddpUsers[i].IsSelected) {
                helper.stageUser(component, 'none', ddpUsers[i]);
                
                ddpUsers[i].IsSelected = false;
                ddpUsers[i].DesiredStatus = 'none';
                
                if (component.get('v.selectedProfileId') === ddpUsers[i].ProfileId || component.get('v.selectedProfileId') == 'allUsers') {
                	availUsers.push(ddpUsers[i]);
                }
                usedLicenses--;
                
                ddpUsers.splice(i, 1);
                
                break;
            }
        }
        
        component.set('v.ddpUsers', ddpUsers);
        component.set('v.availUsers', helper.sortList(availUsers));
        component.set('v.usedLicenses', usedLicenses);
        
        if (!component.get('v.isSandbox') && !component.get('v.hasSiteWideLicense')) {
            component.set('v.provisionedString', helper.updateProvisionedString(component));
        }
    },
    addTester : function(component, event, helper) {
        var availUsers = component.get('v.availUsers');
        var ddpTesters = component.get('v.ddpTesters');
        
        for (var i = 0; i < availUsers.length; i++) {
            if (availUsers[i].IsSelected) {
                helper.stageUser(component, 'test', availUsers[i]);
                
                availUsers[i].IsSelected = false;
                availUsers[i].DesiredStatus = 'test';
                
                ddpTesters.push(availUsers[i]);
                
                availUsers.splice(i, 1);
                
                break;
            }
        }
        
        component.set('v.availUsers', availUsers);
        component.set('v.ddpTesters', helper.sortList(ddpTesters));
    },
    removeTester : function(component, event, helper) {
        var ddpTesters = component.get('v.ddpTesters');
        var availUsers = component.get('v.availUsers');
        
        for (var i = 0; i < ddpTesters.length; i++) {
            if (ddpTesters[i].IsSelected) {
                helper.stageUser(component, 'none', ddpTesters[i]);
                
                ddpTesters[i].IsSelected = false;
                ddpTesters[i].DesiredStatus = 'none';
                
                if (component.get('v.selectedProfileId') === ddpTesters[i].ProfileId || component.get('v.selectedProfileId') == 'allUsers') {
                	availUsers.push(ddpTesters[i]);
                }
                
                ddpTesters.splice(i, 1);
                
                break;
            }
        }
        
        component.set('v.ddpTesters', ddpTesters);
        component.set('v.availUsers', helper.sortList(availUsers));
    },
    save : function(component, event, helper) {
        var saveSettings = component.get('c.saveSettings');
        saveSettings.setParams({
            isConfigUsers: component.get('v.isConfigUsers'),
            stagedUsersString: JSON.stringify(component.get('v.stagedUsers')),
            queryIds: component.get('v.queryIds')
        });
        saveSettings.setCallback(this, function(response) {
            if (response.getState() === 'SUCCESS') {
                var parsedResponse = JSON.parse(response.getReturnValue());
                if (parsedResponse.isSuccess) {
                    var availUsers = component.get('v.availUsers');
                    
                    for (var i = 0; i < availUsers.length; i++) {
                        availUsers[i].CurrentStatus = availUsers[i].DesiredStatus;
                    }
                    
                    component.set('v.availUsers', availUsers);
                    
                    if (component.get('v.isConfigUsers')) {
                        var ddpAdmins = component.get('v.ddpAdmins');
                        for (var i = 0; i < ddpAdmins.length; i++) {
                            ddpAdmins[i].CurrentStatus = ddpAdmins[i].DesiredStatus;
                        }
                        
                        component.set('v.ddpAdmins', ddpAdmins);
                        
                        var ddpUsers = component.get('v.ddpUsers');
                        for (var i = 0; i < ddpUsers.length; i++) {
                            ddpUsers[i].CurrentStatus = ddpUsers[i].DesiredStatus;
                        }
                        
                        component.set('v.ddpUsers', ddpUsers);
                    }
                    else {
                        var ddpTesters = component.get('v.ddpTesters');
                        for (var i = 0; i < ddpTesters.length; i++) {
                            ddpTesters[i].CurrentStatus = ddpTesters[i].DesiredStatus;
                        }
                        
                        component.set('v.ddpTesters', ddpTesters);
                    }
                    
                    component.set('v.stagedUsers', {});
                    
                    component.getEvent('moveToNextStep').setParams({success: true}).fire();
                }
                else {
            		helper.fireErrorEvent(component, parsedResponse.errorMessage);
                    component.getEvent('moveToNextStep').setParams({success: false}).fire();
                }
            }
            else {
            	helper.fireErrorEvent(component, 'Failed to update Users.');
                component.getEvent('moveToNextStep').setParams({success: false}).fire();
            }
        });
        
        $A.enqueueAction(saveSettings);
    },
    redirectPage : function(component, event) {
        var redirectEvent = component.getEvent("redirectPage");
        redirectEvent.setParams({
            'buttonName' : 'purchaseForm'
        });
        redirectEvent.fire();
    }
})