({
    onInit : function(component, event, helper) {
        var type = component.get('v.type');
        if (component.get('v.record.Id') === component.get('v.selectedContact')) {
            helper.openTile(component);
        }
        if (type === 'attachment' && component.get('v.record').FileNames != null) {
            var fileNames = component.get('v.record').FileNames;
            if (fileNames.length > 1) {
                component.set('v.fileNamesLabel', 'File Names:');
            }
            component.set('v.fileNames', fileNames.join(', '));
        }
        if (type === 'delivery') {
            var record = component.get('v.record');
            
            if (record.AllowSubjectEmailChanges) {
            	//set email data
                component.set('v.emailSubject', record.EmailSubject);
                component.set('v.emailBody', record.EmailBody);
            }
            
            if (record.ExposeExpirations) {
                //set DocuSign data
                component.set('v.reminderDelay', record.ReminderDelay);
                component.set('v.reminderFrequency', record.ReminderFrequency);
                component.set('v.expireAfter', record.DaysTillSigningExpires);
                component.set('v.expireWarn', record.WarnOfExpiration);
            }
            
            if (record.IsESign) {
                component.set('v.isESign', true);
                var recipients = record.Recipients;
                var recipientGroups = [];
                var currentSigningOrder;
                var displaySigningOrder = 1;
                var group = [];
                for (var i = 0; i < recipients.length; i++) {
                    var recipient = recipients[i];
                    if (group.length === 0) {
                        currentSigningOrder = recipient.SigningOrder;
                        group.push(recipient);
                    }
                    else if (recipient.SigningOrder === currentSigningOrder) {
                        group.push(recipient);
                    }
                    else {
                        recipientGroups.push({
                            signingOrder: displaySigningOrder,
                            recipients: group
                        });
                        currentSigningOrder = recipient.SigningOrder;
                        displaySigningOrder++;
                        group = [];
                        group.push(recipient);
                    }
                }
                
                recipientGroups.push({
                    signingOrder: displaySigningOrder,
                    recipients: group
                });
                
                component.set('v.recipientGroups', recipientGroups);
            }
            if (record.IsUserSelectedContent) {
                component.set('v.selectedLibraryId', record.DefaultLibrary);
                component.set('v.isUserSelectedContent', true);
                component.set('v.libraries', record.Libraries);
            }
            if (record.RequireAttachToRecord) {
                component.set('v.attachToRecord', true);
            }
        }
    },
    clicked : function(component, event, helper) {
        var record = component.get('v.record');

        var tileClicked = component.getEvent('tileClicked');
        tileClicked.setParams({
            globalId: component.getGlobalId(),
            id: component.get('v.id'),
            name: record.Name,
        });

        if (record.DeliveryType) {
            tileClicked.setParams({
                deliveryType: component.get('v.record.DeliveryType')
            });

            if (record.AllowSubjectEmailChanges) {
                tileClicked.setParams({
                    emailSubject: component.get('v.emailSubject'),
                    emailBody: component.get('v.emailBody')
                });
            }

            if (record.IsESign) {
                tileClicked.setParams({
                    reminderDelay: component.get('v.reminderDelay'),
                    reminderFrequency: component.get('v.reminderFrequency'),
                    expireAfter: component.get('v.expireAfter'),
                    expireWarn: component.get('v.expireWarn')
                });
            }

            if (record.AllowAttachToRecord && component.find('attachCheckbox')) {
                tileClicked.setParams({
                    attachToRecord: component.find('attachCheckbox').get('v.checked')
                });
            }

            if (record.IsUserSelectedContent) {
                helper.toggleContentLibraryDropdown(component);
                tileClicked.setParams({
                    selectedContentLibrary: component.find('contentLibraryDropdown').get('v.value')
                });
            }
        }

        if (component.get('v.isMultiSelect')) {
            helper.toggleMultiSelectStyles(component);
        } else {
            helper.addClickedStyle(component);
        }

        tileClicked.fire();
    },
    open : function(component, event, helper) {
        helper.openTile(component);
    },
    close : function(component, event, helper) {
        helper.closeTile(component);
    },
    toggle : function(component, event, helper) {
        if (component.get('v.isOpen')) {
            helper.closeTile(component);
        }
        else {
            helper.openTile(component);
        }
    },
    handleRecipientGroupClicked : function(component, event) {
        var recipientGroupGlobalId = event.getParam('globalId');
        var recipientGroups = component.find('recipientGroup');
        if (recipientGroups.length) {
            for (var i = 0; i < recipientGroups.length; i++) {
                if (recipientGroups[i].getGlobalId() !== recipientGroupGlobalId) {
                    recipientGroups[i].closeRecipients();
                }
            }
        }
    },
    handleStoreRecipientInfo : function(component, event) {
        //recipientObjectId is the Id of the recipient on the delivery option.
        //selectedRecipientId is the Id of the selected User/Contact record.
        var eSignRecipients = component.get('v.eSignRecipients');
        var recipientObjectId = event.getParams().id;
        var selectedRecipientId = event.getParams().selectedRecipientId;
        var isHost = event.getParams().isHost;
        var recipientName = event.getParams().recipientName;
        var recipientEmail = event.getParams().recipientEmail;
        var accessCode = event.getParams().accessCode;
        var note = event.getParams().note;
        var satisfied = event.getParams().satisfied;
        
        var addNewRecipient = true;
        for (var i = 0; i < eSignRecipients.length; i++) {
            if (eSignRecipients[i].recipientObjectId === recipientObjectId) {
                if (isHost) {
                	eSignRecipients[i].host.selectedRecipientId = selectedRecipientId;
                    eSignRecipients[i].host.name = recipientName;
                    eSignRecipients[i].host.email = recipientEmail;
                    eSignRecipients[i].host.satisfied = satisfied;
                }
                else {
                	eSignRecipients[i].selectedRecipientId = selectedRecipientId;
                    eSignRecipients[i].name = recipientName;
                    eSignRecipients[i].email = recipientEmail;
                    eSignRecipients[i].accessCode = accessCode;
                    eSignRecipients[i].note = note;
                    eSignRecipients[i].satisfied = satisfied;
                }
                addNewRecipient = false;
                break;
            }
        }
        
        if (addNewRecipient) {
            var recipient;
            if (isHost) {
                recipient = {
                    'recipientObjectId': recipientObjectId,
                    'host': {
                        'selectedRecipientId': selectedRecipientId,
                        'name': recipientName,
                        'email': recipientEmail,
                        'satisfied': satisfied
                    }
                };
            }
            else {
                recipient = {
                    'recipientObjectId': recipientObjectId,
                    'selectedRecipientId': selectedRecipientId,
                    'name': recipientName,
                    'email': recipientEmail,
                    'accessCode': accessCode,
                    'note': note,
                    'satisfied': satisfied
                };
            }
        	
            eSignRecipients.push(recipient);
        }
        
        component.set('v.eSignRecipients', eSignRecipients);

        var updateESignRecipientsList = component.getEvent('updateESignRecipientsList');
        updateESignRecipientsList.setParams({
            updatedRecipientsList: eSignRecipients
        });
        updateESignRecipientsList.fire();
    },
    forcedDeselect : function(component, event, helper) {
       helper.removeClickedStyle(component);
    },
    forcedSelect : function(component, event, helper) {
        helper.addClickedStyle(component);
    },
    exposeMoreInformation : function(component, event, helper) {
        $A.util.addClass(component.find('moreInfoButton'), 'hidden');
        $A.util.removeClass(component.find('additionallAttachmentInfo'), 'hidden');
        event.stopPropagation();
    },
    libraryDropdownChanged : function(component, event, helper) {
        var id = event.getSource().get('v.value');
        component.set('v.selectedLibraryId', id ? id : 'Personal');
        
        var tileClicked = component.getEvent('tileClicked');
        tileClicked.setParams({
            id: component.get('v.id'),
            name: component.get('v.record.Name'),
            attachToRecord: component.find('attachCheckbox') ? component.find('attachCheckbox').get('v.checked') : false,
            selectedContentLibrary: component.get('v.selectedLibraryId')
        });
        tileClicked.fire();
        //This is to prevent the checkbox click event from propagating to the tile click function above.
        event.stopPropagation();
    },
    editEmailClicked : function(component, event, helper) {
        var clickEditEmail = component.getEvent('slideInEditEmail');
        clickEditEmail.setParams({
            globalId: component.getGlobalId(),
            htmlEmail: component.get('v.record.HtmlEmail'),
            emailSubject: component.get('v.emailSubject'),
            emailBody: component.get('v.emailBody')
        });
        clickEditEmail.fire();
        //This is to prevent the checkbox click event from propagating to the tile click function above.
        event.stopPropagation();
    },
    editDocuSignReminder :function(component, event, helper) {
        var clickEditReminder = component.getEvent('slideInDocuSignReminders');
        clickEditReminder.setParams({
            globalId: component.getGlobalId(),
            reminderDelay: component.get('v.reminderDelay'),
            daysTillSigningExpires: component.get('v.expireAfter'),
            reminderFrequency: component.get('v.reminderFrequency'),
            warnOfExpiration: component.get('v.expireWarn')
        });
        clickEditReminder.fire();
        //This is to prevent the checkbox click event from propagating to the tile click function above.
        event.stopPropagation();
    },
    updateEmailData : function(component, event, helper) {
        component.set('v.emailSubject', event.getParams().arguments.emailSubject);
        component.set('v.emailBody', event.getParams().arguments.emailBody);
    },
    updateDocuSignReminderData : function(component, event, helper) {
        component.set('v.reminderDelay', event.getParams().arguments.reminderDelay);
        component.set('v.expireAfter', event.getParams().arguments.daysTillSigningExpires);
        component.set('v.reminderFrequency', event.getParams().arguments.reminderFrequency);
        component.set('v.expireWarn', event.getParams().arguments.warnOfExpiration);
    }
})