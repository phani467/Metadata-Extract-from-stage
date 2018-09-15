({
    doInit : function(cmp, event, helper) {
        helper.getBaseURL(cmp);
    },
    showModal : function(cmp) {
        var endpointUrl = cmp.get("v.baseUrl");
        var finalUrl = '/0rp/e?'
            + 'DescriptionField=Used+for+validating+Salesforce+report+when+used+for+mass+DocGen+Packages.'
            + '&SiteName=Salesforce_for_Nintex_DocGen'
            + '&EndpointUrl=' + encodeURIComponent(endpointUrl)
            + '&retURL=' + encodeURIComponent('/0rp?');
        window.open(finalUrl, '_blank');
    }
})