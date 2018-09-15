({
    showError : function(component, message) {
        var errorEvent = component.getEvent('showError');
        errorEvent.setParams({
            title: 'ERROR',
            message: message
        });
        errorEvent.fire();
    },
    searchHelper : function(component) {
        var searchString = document.getElementById("search").value;
        document.getElementById("noResults").setAttribute("data-hidden", "true");
        if (!searchString) {
            var branches = ["buttonToggle", "configuration", "users"];
            for (var i = 0; i < branches.length; i++) {
                var br = component.find(branches[i] + "-Node");
                var icon = component.find(branches[i] + "-icon");
                document.getElementById(branches[i]).setAttribute("data-hidden", "false");
                $A.util.addClass(br, "slds-collapsed");
                $A.util.removeClass(icon, "icon-on");
            }
            var branchItems = component.get('v.branches');
            for (var j = 0; j < branchItems.length; j++) {
                document.getElementById(branchItems[j]).setAttribute("data-hidden", "false");
            }
        } else {
            this.searchHeaders(component, searchString.toLowerCase());
        }
    },
    searchHeaders : function(component, searchString) {
        var escapedSearchString = this.escapeRegExp(searchString);
        var re = new RegExp(escapedSearchString, 'i');
        var buttonCount = 0;
        var buttonHeader = 0;
        var configCount = 0;
        var configHeader = 0;
        var usersCount = 0;
        var usersHeader = 0;
        
        var buttonHeaders = ['classic experience buttons', 'basic buttons', 'button wizard'];
        
        for (var i = 0; i < buttonHeaders.length; i++) {
            if (buttonHeaders[i].match(re)) {
                buttonCount++;
                if (buttonHeaders[i] === "classic experience buttons") {
                    buttonHeader++;
                }
            }
        }
        
        var configHeaders = ['configuration', 'edition', 'third-party integrations', 'job queue status', 'settings', 'sample docgen packages'];
        
        for (var j = 0; j < configHeaders.length; j++) {
            if (configHeaders[j].match(re)) {
                configCount++;
                if (configHeaders[j] === "configuration") {
                    configHeader++;
                }
            }
        }
        
        var usersHeaders = ['users', 'test user configuration', 'user permissions'];
        
        for (var k = 0; k < usersHeaders.length; k++) {
            if (usersHeaders[k].match(re)) {
                usersCount++;
                if (usersHeaders[k] === "users") {
                    usersHeader++;
                }
            }
        }
        
        this.searchHeadersResults(component, buttonCount, configCount, usersCount);
        this.searchItemsResults(component, escapedSearchString, buttonCount, configCount, usersCount, buttonHeader, configHeader, usersHeader);
        if ((buttonCount + configCount + usersCount) === 0) {
            document.getElementById("noResults").setAttribute("data-hidden", "false");
        } else {
            document.getElementById("noResults").setAttribute("data-hidden", "true");
        }
    },
    searchHeadersResults : function(component, buttonCount, configCount, usersCount) {
        var showBranches = [];
        var hideBranches = [];
        if (buttonCount > 0) {
            showBranches.push("buttonToggle");
        } else {
            hideBranches.push("buttonToggle");
        }
        if (configCount > 0) {
            showBranches.push("configuration");
        } else {
            hideBranches.push("configuration");
        }
        if (usersCount > 0) {
            showBranches.push("users");
        } else {
            hideBranches.push("users");
        }
        for (var i = 0; i < showBranches.length; i++) {
            var branchToShow = document.getElementById(showBranches[i]);
            var brToExpand = component.find(showBranches[i] + "-Node");
            var iconToExpand = component.find(showBranches[i]+ "-icon");
            
            if (branchToShow.getAttribute("data-hidden") !== "false") {
            	branchToShow.setAttribute("data-hidden", "false");
            }
            if ($A.util.hasClass(brToExpand, "slds-collapsed")) {
                $A.util.removeClass(brToExpand, "slds-collapsed");
            }
            if (!$A.util.hasClass(iconToExpand, "icon-on")) {
                $A.util.addClass(iconToExpand, "icon-on");
            }
        }
        for (var j = 0; j < hideBranches.length; j++) {
            var branchToHide = document.getElementById(hideBranches[j]);
            var brToCollapse = component.find(hideBranches[j] + "-Node");
            var iconToCollapse = component.find(hideBranches[j]+ "-icon");
            
            if (branchToHide.getAttribute("data-hidden") !== "true") {
            	branchToHide.setAttribute("data-hidden", "true");
                $A.util.removeClass(component.find(hideBranches[j] + "-icon"), "icon-on");
            }
            if (!$A.util.hasClass(brToCollapse, "slds-collapsed")) {
                $A.util.addClass(brToCollapse, "slds-collapsed");
            }
            if ($A.util.hasClass(iconToCollapse, "icon-on")) {
                $A.util.removeClass(iconToCollapse, "icon-on");
            }
        }
    },
    searchItemsResults : function(component, escapedSearchString, buttonCount, configCount, usersCount, buttonHeader, configHeader, usersHeader) {
        var re = new RegExp(escapedSearchString, 'i');
        
        if (buttonCount > 0 && buttonHeader === 0) {
            var buttonItems = [{option:"basic buttons", element:"basicButtons"}, 
                               {option:"button wizard", element:"buttonWizard"}];
            for (var i = 0; i < buttonItems.length; i++) {
                var buttonElement = document.getElementById(buttonItems[i].element);
                if (buttonItems[i].option.match(re)) {
                    if (buttonElement.getAttribute("data-hidden") !== "false") {
            			buttonElement.setAttribute("data-hidden", "false");
                    }
                } else {
                    if (buttonElement.getAttribute("data-hidden") !== "true") {
            			buttonElement.setAttribute("data-hidden", "true");
                    }
                }
            }
        }
        if (configCount > 0 && configHeader === 0) {
            var configItems = [{option:"edition", element:"editionSection"},
                               {option:"third-party integrations", element:"thirdpartyIntegrations"},
                               {option:"job queue status", element:"jobQueueStatus"},
                               {option:"settings", element:"settings"},
                               {option:"sample docgen packages", element:"sampleDdps"}];
            for (var j = 0; j < configItems.length; j++) {
                var configElement = document.getElementById(configItems[j].element);
                if (configItems[j].option.match(re)) {
                    if (configElement.getAttribute("data-hidden") !== "false") {
            			configElement.setAttribute("data-hidden", "false");
                    }
                } else {
                    if (configElement.getAttribute("data-hidden") !== "true") {
            			configElement.setAttribute("data-hidden", "true");
                    }
                }
            }
        }
        if (usersCount > 0 && usersHeader === 0) {
            var usersItems = [{option:"test user configuration", element:"testUserConfiguration"},
                              {option:"user permissions", element:"userPermissions"}];
            for (var k = 0; k < usersItems.length; k++) {
                var userElement = document.getElementById(usersItems[k].element);
                if (usersItems[k].option.match(re)) {
                    if (userElement.getAttribute("data-hidden") !== "false") {
            			userElement.setAttribute("data-hidden", "false");
                    }
                } else {
                    if (userElement.getAttribute("data-hidden") !== "true") {
            			userElement.setAttribute("data-hidden", "true");
                    }
                }
            }
        }
    },
    toggleBranch : function(component, step) {
        if (step === 'purchaseForm') {
        	$A.util.removeClass(component.find("edition-Node"), "slds-collapsed");
        	$A.util.addClass(component.find("edition-icon"), "icon-on");
            $A.util.removeClass(component.find("configuration-Node"), "slds-collapsed");
        	$A.util.addClass(component.find("configuration-icon"), "icon-on");    
        } else {
            $A.util.removeClass(component.find("buttonToggle-Node"), "slds-collapsed");
        	$A.util.addClass(component.find("buttonToggle-icon"), "icon-on");
        }
    },
    isSelected : function(component, id) {
        var branches = component.get('v.branches');
        for (var i = 0; i < branches.length; i++) {
            $A.util.removeClass(component.find(branches[i]), "slds-is-selected");
        }
        $A.util.addClass(component.find(id), "slds-is-selected");
    },
    escapeRegExp : function(str) {
    	return str.replace(/[\-\[\]\/\{\}\(\)\*\+\?\.\\\^\$\|]/g, "\\$&");
	},
    loadDdpAdminSplash : function(component, orgSettings) {
        component.find("ddpAdminSplash").load(orgSettings.hasContract, orgSettings.usedLicenses, orgSettings.daysRemainingInTrial, orgSettings.allowedLicenses);
    },
    updateSaveButtonText : function(component, id) {
        if (id === 'purchaseForm') {
            component.set("v.saveButtonLabel", 'Submit');
        } else {
            component.set("v.saveButtonLabel", 'Save');
        }
    },
    updateBreadcrumb : function(component, id, label) {
        var parentSectionName;
        switch(id) {
            case "basicButtons":
            case "buttonWizard":
                parentSectionName = 'Classic Experience Buttons';
                break;
            case "editionSection":
            case "purchaseForm":
            case "thirdpartyIntegrations":
            case "jobQueueStatus":
            case "settings":
            case "sampleDdps":
                parentSectionName = 'Configuration';
                break;
            case "testUserConfiguration":
            case "userPermissions":
                parentSectionName = 'Users';
                break;
        }
        component.set("v.sectionLabel", label);
        component.set("v.parentSectionLabel", parentSectionName);
    },
    changeStep : function(component, newStep) {
        if (component.get("v.step") !== newStep && newStep !== "buttonWizard" && newStep !== "jobQueueStatus") {
            //Don't display spinner for 'buttonWizard', 'jobQueueStatus' because it's an iframed vf page
        	component.set("v.isNavItemLoading", true);
        }
        
        component.set("v.step", newStep);
    },
    disconnectIntegrationUser : function(component) {
        var action = component.get('c.disconnectIntegrationUser');
        action.setCallback(this, function(response) {
            if (response.getState() === 'SUCCESS') {
                var parsedResponse = JSON.parse(response.getReturnValue());
                if (parsedResponse.isSuccess) {
                    component.set('v.orgSettings', parsedResponse.orgSettings);
                    component.set('v.alertText', 'Your Integration User has been successfully disconnected.');
                } else {
                    this.showError(component, 'There was an issue disconnecting your Integration User. If this issue persists, please contact Nintex Support.');
                }
            } else {
                this.showError(component, 'There was an issue disconnecting your Integration User. If this issue persists, please contact Nintex Support.');
            }
        });
        $A.enqueueAction(action);
    }
})