({
    doInit : function(component,event,helper) {
        helper.callToServer(
            component,
            "c.getActiveCurrencies",
            function(response) {
                var jsonObject=JSON.parse(response);
                component.set('v.recordTypeList',jsonObject);  
            }, 
            { }
        ); 
            
    },
    
    hideExampleModal : function(component, event, helper) {
    	helper.hideExampleModal(component);
        $A.get("e.force:closeQuickAction").fire();
    },
	
	showExampleModal : function(component, event, helper) {
    	helper.showExampleModal(component);
    },
     
    onChange : function(component, event, helper) {
		var value = event.getSource().get("v.text");
        component.set('v.selectedRecordType', value);
	},
	
    defaultCloseAction : function(component, event, helper) {
        $A.util.addClass(component, "slds-hide");
    },
    
    onContinue : function(component, event, helper) {
		helper.callToServer(
            component,
            "c.getOpptyAccess",
            function(response) {
                if(response == 'userHasNoAccess') {
                    alert('You are not authorized to change Opportunity currency.');
                    return;
                }
                else if(response == 'autoRenewWithoutChange') {
                    alert('If you would like to change the currency for this Auto Renew - you must click the "Change Auto Renew?');
                    return;
                }
                else if(response == 'renewalCanBeUpdatedAtStage3') {
                    alert('For a Renewal Opportunity, currency can be updated only at stage 3-Renewal Pending.');
                    return;
                }
                else if(response == 'newBusinessCanBeUpdatedAtStage1Or2') {
                    alert('For a New Business Opportunity, currency can be updated only at 1-Sales Qualified or 2-Need Confirmed.');
                    return;
                }
                else {
					var value = component.get('v.selectedRecordType');
					if (value == null) {
						alert('Please select a currency and then click continue');
						return;
					}
					var btn = event.getSource();
					btn.set("v.disabled",true);
					helper.callToServer(
						component,
						"c.changeOpportunityCurrency",
						function(response) {
							helper.hideExampleModal(component);
							$A.get("e.force:closeQuickAction").fire();
                            var jsonObject = response != null ? response : '';
							if (jsonObject == 'currency updated') {
								alert('Currency is updated. Press OK to be navigated to updated record.');                   
								$A.get('e.force:refreshView').fire();
							} 
							else {
                                alert('Changing currency failed. Please contact your system administrator for more information.\n Error: '+jsonObject);
								var navEvt = $A.get("e.force:navigateToSObject");
								navEvt.setParams({
								  "recordId": component.get('v.recordId')
								});
								navEvt.fire();
							}
						}, 
						{expectedCurrencyIsoCode: component.get('v.selectedRecordType'),
						 oppId: component.get('v.recordId') }
					); 
				}
            }, 
            {oppId: component.get('v.recordId') }
        ); 
	
	}
})