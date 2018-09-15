({
    sortList : function(list) {
        list.sort(function(a, b) {
            var nameA = a.Name.toUpperCase();
            var nameB = b.Name.toUpperCase();
            if (nameA < nameB) {
                return -1;
            }
            if (nameA > nameB) {
                return 1;
            }
            
            return 0;
        });
        
        return list;
    },
	filterAvailableUsers : function(component, profile) {
        if (profile) {
            component.find('availUsers').startLoading();
            var filterAvailableUsers = component.get('c.requeryAvailableUsers');
            var queryIds = component.get('v.queryIds');
            
            component.set('v.selectedProfileId', profile.Id);

            var ddpPermissionSetIds = [queryIds.ddpAdminPermissionSetId, queryIds.ddpUserPermissionSetId];

            if (queryIds.deprecatedDdpAdminPermissionSetId) {
                ddpPermissionSetIds = ddpPermissionSetIds.concat(JSON.parse(queryIds.deprecatedDdpAdminPermissionSetId));
            }

            if (queryIds.deprecatedDdpUserPermissionSetId) {
                ddpPermissionSetIds = ddpPermissionSetIds.concat(JSON.parse(queryIds.deprecatedDdpUserPermissionSetId));
            }

            filterAvailableUsers.setParams({
                isConfigUsers: component.get('v.isConfigUsers'),
                profileId: profile.Id,
                ddpPermissionSetIds: ddpPermissionSetIds,
                sfUserLicenseId: queryIds.sfUserLicenseId,
                stagedUsers: JSON.stringify(component.get('v.stagedUsers'))
            });
            filterAvailableUsers.setCallback(this, function(response) {
                if (response.getState() === 'SUCCESS') {
                    var parsedResponse = JSON.parse(response.getReturnValue());
                    if (parsedResponse.isSuccess) {
                        var sortedAvailUsers = this.sortList(parsedResponse.availUsers);
                        component.set('v.availUsers', sortedAvailUsers);
                        component.set('v.tooManyUsers', sortedAvailUsers.length > 1000);
                    }
                    else {
                        this.fireErrorEvent(component, parsedResponse.errorMessage);
                    }
                }
                else {
                    this.fireErrorEvent(component, 'An unexpected error has occurred.');
                }
                
                component.find('availUsers').doneLoading();
            });
            
            $A.enqueueAction(filterAvailableUsers);
        }
	},
    stageUser : function(component, desiredStatus, user) {
        var stagedUsers = component.get('v.stagedUsers');
        
        if (user.CurrentStatus !== desiredStatus) {
            if (stagedUsers[user.Id]) {
                stagedUsers[user.Id].DesiredStatus = desiredStatus;
            }
            else {
                user.DesiredStatus = desiredStatus;
                stagedUsers[user.Id] = user;
            }
        }
        else {
            user.DesiredStatus = desiredStatus;
            var updatedStagedUsers = {};
            
            for (var key in stagedUsers) {
                if (key !== user.Id) {
                    updatedStagedUsers[key] = stagedUsers[key];
                }
            }
            
            stagedUsers = updatedStagedUsers;
        }
        
        component.set('v.stagedUsers', stagedUsers);
    },
    updateProvisionedString : function(component) {
        var isSandbox = component.get('v.isSandbox');
        var usedLicenses = component.get('v.usedLicenses');
        var allowedLicenses = component.get('v.allowedLicenses');
        var hasSiteWideLicense = component.get('v.hasSiteWideLicense');
        
        if (isSandbox) {
            return "Sandbox environments can have an unlimited number of users.";
        }
        else if (hasSiteWideLicense) {
            return "An organization with a site-wide license can have an unlimited number of users.";
        }
        else {
            return usedLicenses + " of " + allowedLicenses + " users provisioned.";
        }
    },
    fireErrorEvent : function(component, message) {
        var errorEvent = component.getEvent('showError');
        errorEvent.setParams({
            title: 'Error',
            message: message
        });
        errorEvent.fire();
    }
})