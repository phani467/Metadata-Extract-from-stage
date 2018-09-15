({
    initializeIntegrations : function(component, event, helper) {
        // Get Integration Infos and Rows
        helper.getAvailableIntegrations(component);

        var action = component.get("c.fetchBoxIntegrationData");
        action.setParams({
            domain: component.get("v.loopUrl")
        });
        action.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                var parsedResponse = JSON.parse(response.getReturnValue());
                if (parsedResponse.Success) {
                    component.set('v.boxOAuthUrl', parsedResponse.BoxOAuthUrl);
                }
            }
            
            var actionEvent = component.getEvent('actionEvent');
            actionEvent.setParams({
                action: 'doneLoading'
            });
            actionEvent.fire();
        });
        $A.enqueueAction(action);

        helper.getPartialOAuthUrlOffice365(component);
    },
    saveIntegration : function(component, event, helper) {
        helper.saveIntegration(component, event);
    },
    handleKeyup : function (component, event, helper) {
        var field = event.getSource();
        var value = field.get('v.value');
        if (event.getParam('keyCode') === 13) {
            helper.saveIntegration(component, event)
        } else if (field.get('v.label') === 'Name') {
            //The documented Name field length for Custom Settings is 40, but the actual input limit is 38 because two characters are reserved for Salesforce.
            //Regex checks whether the value needs to be encoded before the length is evaluated.
            var charactersRemaining = 38 - (helper.hasWhitespaceAndSpecialCharacters(value) ? encodeURIComponent(value).length : value.length);
            helper.addErrorToField(field, charactersRemaining + ' characters remaining.');
        }
    },
    changeSelectedOption : function(component, event, helper) {
        component.set('v.displayEditLabel', false);
        var selectedOptionValue = event.getSource().get("v.value");
        component.set('v.selectedIntegrationDisplayUtility', component.get('v.displayUtility')[selectedOptionValue]);
        helper.updateFields(component, selectedOptionValue);
        if (selectedOptionValue === 'DocuSign') {
            var action = component.get("c.getDocuSignAccountConfiguration");
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var dsObjJson = response.getReturnValue();
                    if (dsObjJson) {
                        var dsObj = JSON.parse(dsObjJson);
                        if (dsObj && dsObj[0].dsfs__UseSendOnBehalfOf__c) {
                            var ds = dsObj[0];
                            var values = {};
                            values.Name = 'DocuSign';
                            values.Loop__Type__c = 'DocuSign';
                            values.Loop__API_Key__c = ds.dsfs__AccountId__c;
                            values.Loop__Base_URL__c = ds.dsfs__DocuSignBaseURL__c;
                            helper.updateValues(component, [values]);
                        }
                    }
                }
            });
            $A.enqueueAction(action);
        }
        helper.resetFields(component);
    },
    hideModal : function(component, event, helper) {
        helper.hideModal(component);
        helper.resetFields(component);
    },
    addSitePath : function(component, event, helper) {
        var sitePaths = component.get('v.sitePaths');
        sitePaths.push({name: '', value: '', nameHasError: false, nameErrorMessage: '', valueHasError: false, valueErrorMessage: ''});

        for (var i = 0; i < sitePaths.length; i++) {
            sitePaths[i].id = 'sitePath' + i;
        }

        component.set('v.sitePaths', sitePaths);
    },
    removeSitePath : function(component, event, helper) {
        var rowId = event.target.closest('div.slds-grid').id;
        var sitePaths = component.get('v.sitePaths');

        for (var i = 0; i < sitePaths.length; i++) {
            if (sitePaths[i].id == rowId) {
                sitePaths.splice(i, 1);
                break;
            }
        }

        component.set('v.sitePaths', sitePaths);
    },
     updateSitePathName : function(component, event, helper) {
         var sitePaths = component.get('v.sitePaths');
         var rowId = event.target.closest('div.slds-grid').id;
         var name = event.currentTarget.value;

         for (var i = 0; i < sitePaths.length; i++) {
             if (sitePaths[i].id == rowId) {
                 sitePaths[i].name = name;
                 break;
             }
         }

         component.set('v.sitePaths', sitePaths);
     },
     updateSitePathValue : function(component, event, helper) {
         var sitePaths = component.get('v.sitePaths');
         var rowId = event.target.closest('div.slds-grid').id;
         var value = event.currentTarget.value;

         for (var i = 0; i < sitePaths.length; i++) {
             if (sitePaths[i].id == rowId) {
                 sitePaths[i].value = value;
                 break;
             }
         }

         component.set('v.sitePaths', sitePaths);
     },
    handleActionEvent : function(component, event, helper) {
        var action = event.getParam('action');
        
        switch (action) {
            case 'editIntegration':
                var integration = event.getParam('params');
                helper.editIntegration(component, integration);
                break;
            case 'deleteIntegration':
                component.find('selectedOption').set('v.value', '');
                helper.getAvailableIntegrations(component);
                break;
            case 'authorized':
                component.set('v.isAuthorized', true);
                helper.validateAndUpsertIntegrations(component, event);
                event.stopPropagation();
                break;
            default:
                break;
        }
    }
})