({
    fireErrorEvent : function(component, message) {
        var errorEvent = component.getEvent('showError');
        errorEvent.setParams({
            message: message
        });
        errorEvent.fire();
    },
    getAvailableIntegrations : function(component) {
        var action = component.get('c.getIntegrationInfos');
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === 'SUCCESS') {
                var iisJson = response.getReturnValue();
                var iis = JSON.parse(iisJson);

                var existingTypes = [];
                for (var i in iis) {
                    existingTypes.push(iis[i].Loop__Type__c);
                }
                var singleIntegrations = ['Box', 'DocGen API', 'DocuSign', 'e-SignLive', 'Lob'];
                var availableIntegrations = [];
                for (var j in singleIntegrations) {
                    var type = singleIntegrations[j];
                    if (existingTypes.indexOf(type) < 0) {
                        availableIntegrations.push(type);
                    }
                }
                availableIntegrations.push('Office 365');
                availableIntegrations.push('SMTP');
                availableIntegrations.push('FTP');
                availableIntegrations.push('SFTP');

                component.set('v.availableIntegrations', availableIntegrations);
            }
        });
        $A.enqueueAction(action);
        var allIntegrations = ['Box', 'DocGen API', 'DocuSign', 'e-SignLive', 'Lob', 'Office 365', 'SMTP', 'FTP', 'SFTP', 'Nintex Workflow Cloud'];
        this.createDisplayUtility(component, allIntegrations);
    },
    showModal : function(component) {
        component.find('integrationsModal').show();
    },
    hideModal : function(component) {
        component.set('v.selectedIntegration', '');
        component.find('selectedOption').set('v.value', '');
        component.set('v.errors', null);
        var name = component.find('name');
        var apiKey = component.find('apiKey');
        var protocolDomain = component.find('protocolDomain');
        var baseUrl = component.find('baseUrl');
        var tagSourceUrl = component.find('tagSourceUrl');
        var singleInputFields = [name, apiKey, protocolDomain, baseUrl, tagSourceUrl];
        var paths = component.find('path');
        if (paths) {
            var sitePathFields = this.getSitePathFields(paths);
        }

        var allFields = singleInputFields.concat(sitePathFields);
        for (var i in allFields) {
            var field = allFields[i];
            if (field) {
                this.removeErrorFromField(field);
            }
        }
        component.find('integrationsModal').hide();
    },
    createDisplayUtility : function(component, allIntegrations) {
        var displayUtilityMap = {};
        for (var i in allIntegrations) {
            var integrationDisplayMap = this.getIntegrationDisplaySettings(component, allIntegrations[i]);
            displayUtilityMap[allIntegrations[i]] = integrationDisplayMap;
        }
        component.set('v.displayUtility', displayUtilityMap);
    },
    getIntegrationDisplaySettings : function(component, selectedIntegration) {
        var integrationDisplayMap = {'displayName' : false, 'displayApiKey' : false , 'displayDomain' : false, 'displayBaseUrl' : false , 'displayTagSourceUrl' : false , 'displaySitePaths' : false , 'displayBoxText' : false , 'displayUsernamePassword' : false , 'displaySecure' : false, 'apiKeyLabel' : 'API Key', 'saveButtonLabel' : 'Save', 'editButtonLabel' : '', 'baseUrlLabel' : 'Base URL', 'baseUrlPlaceholder' : ''};
        switch (selectedIntegration) {
            case 'Box':
                integrationDisplayMap.displayBoxText = true;
                integrationDisplayMap.saveButtonLabel = 'Authorize';
                integrationDisplayMap.editButtonLabel = 'Reauthorize';
                break;
            case 'DocuSign':
                integrationDisplayMap.displayApiKey = true;
                integrationDisplayMap.displayBaseUrl = true;
                integrationDisplayMap.apiKeyLabel = 'Account Id';
                break;
            case 'e-SignLive':
                integrationDisplayMap.displayApiKey = true;
                integrationDisplayMap.displayBaseUrl = true;
                break;
            case 'Lob':
                integrationDisplayMap.displayBaseUrl = true;
                integrationDisplayMap.displayApiKey = true;
                break;
            case 'DocGen API':
                integrationDisplayMap.displayBaseUrl = true;
                integrationDisplayMap.displayTagSourceUrl = true;
                break;
            case 'Office 365':
                integrationDisplayMap.displayName = true;
                integrationDisplayMap.displayBaseUrl = true;
                integrationDisplayMap.displaySitePaths = true;
                integrationDisplayMap.baseUrlLabel = 'Site URL';
                integrationDisplayMap.saveButtonLabel = 'Authorize';
                integrationDisplayMap.editButtonLabel = 'Reauthorize';
                integrationDisplayMap.baseUrlPlaceholder = 'https://[sitename].sharepoint.com';
                break;
            case 'FTP':
                integrationDisplayMap.displayName = true;
                integrationDisplayMap.displayProtocolDomain = true;
                integrationDisplayMap.displayUsernamePassword = true;
                integrationDisplayMap.displaySecure = true;
                integrationDisplayMap.baseUrlLabel = 'Domain';
                integrationDisplayMap.saveButtonLabel = 'Authorize';
                break;
            case 'SFTP':
                integrationDisplayMap.displayName = true;
                integrationDisplayMap.displayProtocolDomain = true;
                integrationDisplayMap.displayUsernamePassword = true;
                integrationDisplayMap.baseUrlLabel = 'Domain';
                integrationDisplayMap.saveButtonLabel = 'Authorize';
                break;
            case 'SMTP':
                integrationDisplayMap.displayName = true;
                integrationDisplayMap.displayBaseUrl = true;
                integrationDisplayMap.displayUsernamePassword = true;
                integrationDisplayMap.baseUrlLabel = 'Domain';
                integrationDisplayMap.saveButtonLabel = 'Authorize';
                break;
            case 'Nintex Workflow Cloud':
                integrationDisplayMap.displayNwcText = true;
                integrationDisplayMap.saveButtonLabel = 'Rotate';
                break;
            default:
                integrationDisplayMap = {};
        }
        return integrationDisplayMap;
    },
    editIntegration : function(component, integration) {
        integration = JSON.parse(integration);
        component.set('v.selectedIntegrationDisplayUtility', component.get('v.displayUtility')[integration.serviceName]);
        component.set('v.displayEditLabel', component.get('v.selectedIntegrationDisplayUtility').editButtonLabel);
        component.set('v.isSecure', integration.isSecure);
        if (integration.serviceName === 'Office 365') {
            component.set('v.selectedIntegration', integration.serviceName);
            var sitePaths = [];
            for (var i in integration.childIntegrations) {
                sitePaths.push({id:'sitePath' + i, name:integration.childIntegrations[i].name, value:integration.childIntegrations[i].url, nameHasError:false, nameErrorMessage:'', valueHasError:false, valueErrorMessage:'', sfId:integration.childIntegrations[i].id})
            }

            component.set('v.sitePaths', sitePaths);
            component.set('v.showFields', true);
            component.find('id').set('v.value', integration.id);
            component.find('name').set('v.value', integration.name);
            component.find('baseUrl').set('v.value', integration.url);

            this.showModal(component);

            var integrationsList = component.find('integrationsList');
            integrationsList.replaceSpinnersWithLinks();
        } else {
            var action = component.get('c.getIntegrationInfo');
            action.setParams({recordId: integration.id});
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === 'SUCCESS') {
                    var integrationsJson = response.getReturnValue();
                    var integrations = JSON.parse(integrationsJson);
                    if (integrations !== null && integrations.length > 0) {
                        var type = integration.serviceName;
                        this.updateFields(component, type);
                        this.updateValues(component, integrations);
                        component.set('v.selectedIntegrationDisplayUtility', component.get('v.displayUtility')[type]);
                        component.set('v.selectedIntegration', type);
                    }
                } else {
                    this.fireErrorEvent(component, $A.get('$Label.loop.Generic_Error_Message'));
                }

                var integrationsList = component.find('integrationsList');
                integrationsList.replaceSpinnersWithLinks();
            });
            $A.enqueueAction(action);
        }
    },
    resetFields : function(component) {
        var singleInputFields = ['id', 'name', 'apiKey', 'protocolDomain', 'baseUrl', 'tagSourceUrl', 'username', 'password'];
        for (var i in singleInputFields) {
            var field = component.find(singleInputFields[i]);
            if (field) {
                field.set('v.value', '');
            }
        }

        var paths = component.find('path');
        if (paths) {
            try {
                paths = [];
            } catch(ex) {
                paths.set('v.value', '');
            }
        }

        component.set('v.boxError', '');
        component.set('v.isSecure', false);
        component.set('v.sitePaths', [{id:'sitePath0', name:'', value:'', nameHasError:false, nameErrorMessage:'', valueHasError:false, valueErrorMessage:''}]);
    },
    updateFields : function(component, selectedOptionValue) {
        if (selectedOptionValue) {
            component.set('v.selectedIntegration', selectedOptionValue);
            component.set('v.showFields', true);
            if (selectedOptionValue === 'Office 365') {
                component.set('v.sitePaths', [{id:'sitePath0', name:'', value:'', nameHasError:false, nameErrorMessage:'', valueHasError:false, valueErrorMessage:''}]);
            }
            this.showModal(component);
        } else {
            component.set('v.showFields', false);
        }
    },
    updateValues : function(component, values) {
        var integrationData = values[0];
        var id = component.find('id');
        var name = component.find('name');
        var apiKey = component.find('apiKey');
        var protocolDomain = component.find('protocolDomain');
        var baseUrl = component.find('baseUrl');
        var tagSourceUrl = component.find('tagSourceUrl');
        var username = component.find('username');
        var type = integrationData.Loop__Type__c;

        if (id && integrationData.Id) id.set('v.value', integrationData.Id);
        if (name && integrationData.Name) name.set('v.value', integrationData.Name);
        if (apiKey && integrationData.Loop__API_Key__c) apiKey.set('v.value', integrationData.Loop__API_Key__c);
        if (protocolDomain && integrationData.Loop__Base_URL__c) protocolDomain.set('v.value', integrationData.Loop__Base_URL__c);
        if (baseUrl && integrationData.Loop__Base_URL__c) baseUrl.set('v.value', integrationData.Loop__Base_URL__c);
        if (tagSourceUrl && integrationData.Loop__Tag_Source_URL__c) tagSourceUrl.set('v.value', integrationData.Loop__Tag_Source_URL__c);
        if (username && integrationData.Loop__Username__c) username.set('v.value', integrationData.Loop__Username__c);
    },
    getUrlInfo : function(url) {
        var el = document.createElement('a');
        el.href = url;
        return el;
    },
    getSitePaths : function(paths) {
        var sitePaths = [];
        try {
            for (var i in paths) {
                sitePaths.push(paths[i].get('v.value'));
            }
        } catch(ex) {
            sitePaths.push(paths.get('v.value'));
        }
        return sitePaths;
    },
    getSitePathFields : function(paths) {
        var sitePaths = [];
        try {
            var isSingle = paths.getLocalId() === 'path';
            sitePaths.push(paths);
        } catch(ex) {
            for (var i in paths) {
                sitePaths.push(paths[i]);
            }
        }
        return sitePaths;
    },
    validateFields : function(type, fields) {
        var invalidFields = [];
        for (var i in fields) {
            var field = fields[i];

            if (field === undefined) {
                continue;
            }

            var value = field.get('v.value') ? field.get('v.value').trim() : '';

            if (field && field.getLocalId() !== 'password') {
                field.set('v.value', value);
            }

            if (!field || !value) {
                this.addErrorToField(field, 'Required field');
                invalidFields.push(field);
            } else if (type !== 'Office 365' && field.getLocalId() === 'name' && this.hasWhitespaceAndSpecialCharacters(value) && encodeURIComponent(value).length > 38) {
                //If the user adds a special character AND whitespace, the value of the name field is encoded by Salesforce. Therefore, increasing the length of the string.
                //Throw an error if the number of encoded characters exceeds 38.
                this.addErrorToField(field, 'This exceeds the maximum numbers of characters available.');
                invalidFields.push(field);
            } else if (type === 'Office 365' && field.getLocalId() === 'baseUrl' && !this.isValidUrl(value)) {
                this.addErrorToField(field, 'Not a valid URL');
                invalidFields.push(field);
            } else if (type === 'Office 365' && field.getLocalId() === 'path' && !this.isValidPath(value)) {
                this.addErrorToField(field, 'Not a valid Site Path');
                invalidFields.push(field);
            } else {
                this.removeErrorFromField(field);
            }
        }
        return invalidFields;
    },
    hasWhitespaceAndSpecialCharacters : function(value) {
        //Regex to check if the string includes a whitespace AND a special character.
        return new RegExp(/([^a-z0-9\s_.-].*\s)|(\s.*[^a-z0-9\s_.-])/, 'ig').test(value);
    },
    addErrorToField : function(field, message) {
        field.set('v.errors', [{message: message}]);
    },
    removeErrorFromField : function(field) {
        field.set('v.errors', null);
    },
    isValidUrl : function(url) {
        // http://stackoverflow.com/questions/1303872/trying-to-validate-url-using-javascript
        var re = /^(?:(?:(?:https?|ftp):)?\/\/)(?:\S+(?::\S*)?@)?(?:(?!(?:10|127)(?:\.\d{1,3}){3})(?!(?:169\.254|192\.168)(?:\.\d{1,3}){2})(?!172\.(?:1[6-9]|2\d|3[0-1])(?:\.\d{1,3}){2})(?:[1-9]\d?|1\d\d|2[01]\d|22[0-3])(?:\.(?:1?\d{1,2}|2[0-4]\d|25[0-5])){2}(?:\.(?:[1-9]\d?|1\d\d|2[0-4]\d|25[0-4]))|(?:(?:[a-z\u00a1-\uffff0-9]-*)*[a-z\u00a1-\uffff0-9]+)(?:\.(?:[a-z\u00a1-\uffff0-9]-*)*[a-z\u00a1-\uffff0-9]+)*(?:\.(?:[a-z\u00a1-\uffff]{2,})).?)(?::\d{2,5})?(?:[/?#]\S*)?$/i;
        return re.test(url);
    },
    isValidPath : function(path) {
        var re = /^\/(sites\/.+)?$/i;
        return re.test(path);
    },
    upsertIntegrationInfos : function(component, values) {
        var action = component.get('c.upsertIntegrationInfos');
        action.setParams({
            valuesJson: JSON.stringify(values)
        });
        action.setCallback(this, function(response) {
            if (response.getState() === 'SUCCESS') {
                var parsedResponse = JSON.parse(response.getReturnValue());
                if (parsedResponse.isSuccess) {
                    this.hideModal(component);
                    this.getAvailableIntegrations(component);
                    component.find('selectedOption').set('v.value', '');
                    this.resetFields(component);
                    var integrationsList = component.find('integrationsList');
                    integrationsList.refreshList();
                }
                else {
                    this.fireErrorEvent(component, parsedResponse.errorMessage);
                }
            }
            else {
                this.fireErrorEvent(component, $A.get('$Label.loop.Generic_Error_Message'));
            }
            component.set('v.modalBusy', false);
        });
        $A.enqueueAction(action);
    },
    getValues : function(component) {
        var type = component.get('v.selectedIntegration');
        var id = component.find('id');
        var name = component.find('name');
        var apiKey = component.find('apiKey');
        var baseUrl = component.find('baseUrl');
        var tagSourceUrl = component.find('tagSourceUrl');
        var username = component.find('username');
        var password = component.find('password');
        var protocolDomain = component.find('protocolDomain');

        var values = {
            type: type == 'FTP' && component.get('v.isSecure') ? 'FTPS' : type,
            id: id ? id.get('v.value') : '',
            name: name ? name.get('v.value') : '',
            apiKey: apiKey ? apiKey.get('v.value') : '',
            baseUrl: protocolDomain ? protocolDomain.get('v.value') : baseUrl ? baseUrl.get('v.value') : '',
            tagSourceUrl: tagSourceUrl ? tagSourceUrl.get('v.value') : '',
            username: username ? username.get('v.value') : '',
            password: password ? password.get('v.value') : '',
        };

        var paths = component.find('path');
        var pathIds = component.find('pathId');
        var sitePaths = this.getSitePaths(paths);
        var sitePathIds = this.getSitePaths(pathIds);
        if (sitePaths.length) {
            values.sitePaths = JSON.stringify(sitePaths);
            values.pathIds = JSON.stringify(sitePathIds);
        }

        return values;
    },
    validateAndUpsertIntegrations : function(component, event) {
        var values = this.getValues(component);
        var type = component.get('v.selectedIntegration');
        var paths = component.find('path');

        // Field validation
        var errors = [];
        var singleInputFields = [component.find('name'), component.find('apiKey'), component.find('protocolDomain'), component.find('baseUrl'), component.find('tagSourceUrl'), component.find('username'), component.find('password')];

        var invalidSingleInputFields = this.validateFields(type, singleInputFields);
        var sitePathFields = this.getSitePathFields(paths);
        var invalidSitePathFields = this.validateFields(type, sitePathFields);

        if (invalidSingleInputFields.length || invalidSitePathFields.length) {
            var labels = [];
            for (var i in invalidSingleInputFields) {
              var field = invalidSingleInputFields[i];
              labels.push(field.get('v.label'));
            }
            if (invalidSitePathFields.length > 0) {
              labels.push('Site Paths');
            }
            errors.splice(0, 0, 'These following fields have errors: ' + labels.join(', '));
        }

        if (errors.length) {
            component.set('v.errors', errors);
            component.set('v.modalBusy', false);
        } else {
            // Validation Success
            if (type === 'Office 365') {
                this.startOAuthOffice365(component);
            } else if (type === 'SMTP' || type === 'SFTP' || type === 'FTP') {
                if (!component.get('v.isAuthorized')) {
                    this.startSalesforceOAuth(component, event);
                } else {
                    this.upsertIntegrationInfos(component, values);
                }
            } else {
                this.upsertIntegrationInfos(component, values);
            }
        }
    },
    validateO365Fields : function(component) {
        var name = component.find('name');
        var url = component.find('baseUrl');
        var invalidFieldNames = [];

        var invalidFieldComponents = this.validateFields('Office 365', [name, url]);
        for (var i in invalidFieldComponents) {
            invalidFieldNames.push(invalidFieldComponents[i].get('v.label'));
        }

        invalidFieldNames.push.apply(invalidFieldNames, this.validateSitePaths(component));

        if (invalidFieldNames.length) {
            var error = ['These following fields have errors: ' + invalidFieldNames.join(', ')];
            component.set('v.errors', error);
            return false;
        }
        else {
            component.set('v.errors', []);
            return true;
        }
    },
    //Make the appropriate validations for Site Path fields,
    validateSitePaths : function(component) {
        var sitePaths = component.get('v.sitePaths');
        var validNameRegExp = /[0-9a-zA-Z\s]+/;
        var uniqueSiteNames = [];
        var uniqueSiteValues = [];

        var invalidFields = [];
        for (var i = 0; i < sitePaths.length; i++) {
            var matches = validNameRegExp.exec(sitePaths[i].name);

            if (!sitePaths[i].name) {
                sitePaths[i].nameHasError = true;
                sitePaths[i].nameErrorMessage = 'Required field';
            } else if (!matches || matches[0] !== matches.input) {
                sitePaths[i].nameHasError = true;
                sitePaths[i].nameErrorMessage = 'Only alphanumeric characters';
            } else if (uniqueSiteNames.includes(sitePaths[i].name)) {
                sitePaths[i].nameHasError = true;
                sitePaths[i].nameErrorMessage = 'Site Path Name already used';
            } else {
                uniqueSiteNames.push(sitePaths[i].name);
                sitePaths[i].nameHasError = false;
                sitePaths[i].nameErrorMessage = '';
            }

            if (sitePaths[i].nameHasError && !sitePaths.includes('Site Path Name')) {
                invalidFields.push('Site Path Name');
            }

            if (!sitePaths[i].value) {
                sitePaths[i].valueHasError = true;
                sitePaths[i].valueErrorMessage = 'Required field';
            } else if (!this.isValidPath(sitePaths[i].value)) {
                sitePaths[i].valueHasError = true;
                sitePaths[i].valueErrorMessage = 'Not a valid Site Path';
            } else if (uniqueSiteValues.includes(sitePaths[i].value)) {
                sitePaths[i].valueHasError = true;
                sitePaths[i].valueErrorMessage = 'Site Path already used';
            } else {
                uniqueSiteValues.push(sitePaths[i].value);
                sitePaths[i].valueHasError = false;
                sitePaths[i].valueErrorMessage = '';
            }

            if (sitePaths[i].valueHasError && !sitePaths.includes('Site Path')) {
                invalidFields.push('Site Path');
            }
        }

        component.set('v.sitePaths', sitePaths);

        return invalidFields;
    },
    getPartialOAuthUrlOffice365 : function(component) {
        var getPartialO365AuthUrl = component.get('c.getPartialO365AuthUrl');
        getPartialO365AuthUrl.setParams({
            nonLightningSessionId: component.get('v.sessionId'),
            domain: component.get('v.loopUrl')
        });
        getPartialO365AuthUrl.setCallback(this, function(response) {
            if (response.getState() === 'SUCCESS') {
                var parsedResponse = JSON.parse(response.getReturnValue());
                if (parsedResponse.isSuccess) {
                    component.set('v.o365AuthUrl', parsedResponse.oAuthUrl);
                }
                else {
                    this.fireErrorEvent(component, parsedResponse.errorMessage);
                }
            }
            else {
                this.fireErrorEvent(component, $A.get('$Label.loop.Generic_Error_Message'));
            }
        });
        $A.enqueueAction(getPartialO365AuthUrl);
    },
    startOAuthOffice365 : function(component) {
        // Store helper methods to var so they are accessible to the listener function
        // This is necessary here because referring to a helper function from the helper would require a reference to 'this.helper',
        // but 'this' is changed in the scope of the below function.
        var helper = this;

        window.Drawloop.eventListener.addEventListener('o365', function(event) {
            var payload = JSON.parse(event.data.payload);
            if (payload.isSuccess) {
                helper.upsertO365Integration(component);
            }
            else {
                helper.fireErrorEvent(component, payload.errorDescription);
            }
        });

        var siteUrl = encodeURIComponent(component.find('baseUrl').get('v.value'));
        window.open(component.get('v.o365AuthUrl').replace('[ENDPOINT]', siteUrl), 'Authorize Office 365', 'height=500,width=500,location=0,status=0,titlebar=0');
        component.set('v.modalBusy', false);
    },
    upsertO365Integration : function(component) {
         var upsertO365Integration = component.get('c.upsertO365Integration');
         upsertO365Integration.setParams({
             integrationId: component.find('id').get('v.value'),
             integrationName: component.find('name').get('v.value'),
             baseUrl: component.find('baseUrl').get('v.value'),
             sitePaths: JSON.stringify(component.get('v.sitePaths'))
         });
         upsertO365Integration.setCallback(this, function(response) {
             if (response.getState() === 'SUCCESS') {
                 var parsedResponse = JSON.parse(response.getReturnValue());
                 if (parsedResponse.isSuccess) {
                     this.hideModal(component);
                     this.getAvailableIntegrations(component);
                     this.resetFields(component);

                     component.set('v.sitePaths', parsedResponse.sitePaths);
                     component.find('selectedOption').set('v.value', '');

                     var integrationsList = component.find('integrationsList');
                     integrationsList.refreshList();
                 } else if (parsedResponse.validationErrors) {
                     var validationErrors = parsedResponse.validationErrors;
                     Object.keys(validationErrors).forEach(function(validationError) {
                         switch (validationError) {
                             case 'duplicateName':
                                this.addErrorToField(component.find('name'), validationErrors[validationError]);
                                break;
                             case 'duplicateUrl':
                                this.addErrorToField(component.find('baseUrl'), validationErrors[validationError]);
                                break;
                             case 'validatedSitePaths':
                                component.set('v.sitePaths', JSON.parse(validationErrors[validationError]));
                                break;
                             default:
                                break;
                         }
                      }, this);
                 } else {
                     this.fireErrorEvent(component, parsedResponse.errorMessage);
                 }
             } else {
                 this.fireErrorEvent(component, $A.get('$Label.loop.Generic_Error_Message'));
             }
         });

         $A.enqueueAction(upsertO365Integration);
    },
    startSalesforceOAuth : function(component, event) {
        window.Drawloop.eventListener.addEventListener('integrationInfo', function(event) {
            var authorizedEvent = component.getEvent('actionEvent');
            authorizedEvent.setParams({
                action: 'authorized'
            });
            authorizedEvent.fire();
        });
        window.open(component.get('v.oAuthUrl'), 'Salesforce Auth', 'width=490, height=680');
    },
    saveIntegration : function(component, event) {
        component.set('v.errors', []);
        var type = component.get('v.selectedIntegration');
        if (type === 'Box') {
            var helper = this;//Store helper methods to var so they are accessible to the callback function.
            window.Drawloop.eventListener.addEventListener('box', function(event) {
                var payload = JSON.parse(event.data.payload);
                if (payload.isSuccess) {
                    helper.hideModal(component);
                    helper.getAvailableIntegrations(component);
                    component.find('selectedOption').set('v.value', '');
                    helper.resetFields(component);
                    component.find('integrationsList').refreshList();
                } else {
                    var errorDescription = 'Error: ' + payload.errorDescription.replace(/\+/g, ' ');
                    component.set('v.boxError', errorDescription);
                }
            });

            window.open(component.get('v.boxOAuthUrl'), 'Authorize Box', 'height=750,width=500,location=0,status=0,titlebar=0');
        } else if (type === 'Office 365') {
            component.set('v.modalBusy', true);
            var o365FieldsValid = this.validateO365Fields(component);
            if (o365FieldsValid) {
                this.startOAuthOffice365(component);
            }
            else {
                component.set('v.modalBusy', false);
            }
        } else if (type === 'Nintex Workflow Cloud') {
            component.set('v.modalBusy', true);
            var action = component.get('c.rotateNwcEncryptionKey');
            action.setCallback(this, function(response) {
                if (response.getState() === 'SUCCESS') {
                    var returnValue = response.getReturnValue();
                    if (returnValue.success) {
                        this.hideModal(component);
                    } else {
                        this.fireErrorEvent(component, returnValue.errorMessage ? returnValue.errorMessage : $A.get('$Label.loop.Generic_Error_Message'));
                    }
                    component.set('v.modalBusy', false);
                }
            });
            $A.enqueueAction(action);
        } else {
            component.set('v.modalBusy', true);
            this.validateAndUpsertIntegrations(component, event);
        }
    }
})