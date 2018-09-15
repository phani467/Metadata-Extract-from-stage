({
    init : function(component) {
        var orgSettings = component.get('v.orgSettings');
        
        component.set('v.isFedRampAllowed', orgSettings.isFedRampAllowed);
        var subdomain = !orgSettings.subdomain && orgSettings.isFedRampAllowed && !component.get('v.isDdpAdmin') ? 'gov' : orgSettings.subdomain;
        component.set('v.subdomain', subdomain);
        component.find(orgSettings.storeAsSalesforceFile ? "salesforceFilesRadio" : "attachmentsRadio").set("v.value", true);
        component.set('v.useSalesforceFiles', orgSettings.storeAsSalesforceFile);

        var services = component.get('v.services');
        if (services.isSuccess) {
            component.set('v.isMass', services.massDdps);
        } else {
            component.getEvent('showError').setParams({
                message: services.errorMessage
            }).fire();
        }

        var actionEvent = component.getEvent('actionEvent');
        actionEvent.setParams({
            action: 'doneLoading'
        });
        actionEvent.fire();
    },
    subdomainChange : function(component, event) {
        var subdomain = event.getSource().get('v.value');
        component.set('v.subdomain', subdomain);
    },
    openRemoteSiteSettings : function(component) {
        var subdomainValue = component.get('v.subdomain');
        var subdomainLabel = component.find(subdomainValue).get('v.label');
        var endpointUrl = 'https://' + subdomainValue + '.drawloop.com';
        var finalUrl = '/0rp/e?' + 
            		'SiteName=Drawloop' + subdomainLabel + 
            		'&spl1=1&setupid=SecurityRemoteProxy' +
        			'&EndpointUrl=' + encodeURIComponent(endpointUrl) +
                	'&retURL=' + encodeURIComponent('/ui/setup/Setup?setupid=Security');
        window.open(finalUrl, '_blank');
    },
    updateAttachmentOption : function(component, event) {
        component.set('v.useSalesforceFiles', event.getSource().get("v.text") === 'Salesforce Files');
    },
    save : function(component, event, helper) {
        var pauseToEdit = component.find('pauseToEdit');
        pauseToEdit.save();
        
        var oAuth = component.find('oAuth');
        oAuth.save();
        
        //update the changes the user made on values in the custom settings
        var action = component.get('c.updateCustomSettings');
        action.setParams({
            subdomain: component.get('v.subdomain'),
            useSalesforceFiles: component.get('v.useSalesforceFiles')
        });
        $A.enqueueAction(action);
    }
})