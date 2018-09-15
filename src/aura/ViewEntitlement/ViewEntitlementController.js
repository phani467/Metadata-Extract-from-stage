({
    doInit : function(component, event, helper) {
        var showHierarchy = component.get('v.showHierarchy')== true ? true:false;
		helper.init(component, event, showHierarchy);
    },
    showEntitlementInfo:function(component,event,helper) {
        var showHierarchy = component.get('v.showHierarchy')==true ? true:false;
        helper.showEntitlementInformation(component, event, showHierarchy);
    }, 
    navigateToRecord:function(component,event,helper) {
        helper.navigateToSobjectRecord(component,event);
    },
    showAccountHierarchy:function(component,event,helper) {
        var licenseInfoSize = component.get('v.licenseInfoSize');
        component.set('v.showProductSummary',false);
        component.set('v.showHierarchy', true);
        component.set('v.summaryStartIndex',0);
        component.set('v.summaryEndIndex',licenseInfoSize);
        helper.init(component,event,true)
    },
    showAccountOnly:function(component,event,helper) {
        var licenseInfoSize = component.get('v.licenseInfoSize');
        component.set('v.summaryStartIndex',0);
        component.set('v.summaryEndIndex', licenseInfoSize);
        component.set('v.showHierarchy', false);
        component.set('v.showProductSummary',false);
        helper.init(component,event,false);
    },
    downloadCsv : function(component,event,helper) {
        
        // get the Recordslist from 'contactList' attribute 
        var contactList = component.get("v.contactList");
        
        // call the helper function which "return" the CSV data as a String   
        var csv = helper.convertArrayOfObjectsToCSV(component, contactList);   
        if (csv == null) {
            return;
        } 
        
        // creating a temp. <a> html tag [link tag] for download the CSV file
        var hiddenElement = document.createElement('a');
        hiddenElement.href = 'data:text/csv;charset=utf-8,' + encodeURI(csv);
        hiddenElement.target = '_self'; // 
        hiddenElement.download = 'ContactUsageData.csv';  // CSV file Name
        document.body.appendChild(hiddenElement); // Required for FireFox browser
        hiddenElement.click(); // using click() js function to download csv file
    },
    nextEntitlementPage:function(component,event,helper) {
        helper.nextEntitlementInfo(component,event);
    },
    previousEntitlementPage:function(component,event,helper) {
        helper.prevEntitlementInfo(component,event);
    },
    previousLicensePage:function(component,event,helper) {
        helper.backOnLicense(component,event);
    },
    nextLicensePage:function(component,event,helper) {
        helper.nextOnLicense(component,event);
    }
})