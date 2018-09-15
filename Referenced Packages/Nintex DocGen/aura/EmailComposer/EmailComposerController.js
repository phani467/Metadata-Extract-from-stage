({
	cancel : function(component, event, helper) {
        var slideOutEmailComposer = component.getEvent('slideOutEmailComposer');
        slideOutEmailComposer.fire();
	},
    reset: function(component) {
        component.set('v.loaded', false);
        component.set('v.sender', '');
        component.set('v.senderLabel', '');
        component.set('v.whoId', '');
        component.set('v.whoName', '');
        component.set('v.to', '');
        component.set('v.cc', '');
        component.set('v.bcc', '');
        component.set('v.subject', '');
        component.set('v.emailBody', '');
        component.set('v.templateRendererUrl', '');
        component.set('v.templateHtmlBody', '');
        component.set('v.emailAttachments', []);
        
        component.set('v.message', '');
        $A.util.removeClass(component.find('emailContents'), 'hidden');
        $A.util.addClass(component.find('toast'), 'hidden');
        
        component.set('v.errorMessage', '');
        $A.util.addClass(component.find('error'), 'hidden');
    },
    send : function(component, event, helper) {
        component.set('v.message', '');
        $A.util.removeClass(component.find('emailContents'), 'hidden');
        $A.util.addClass(component.find('toast'), 'hidden');
        
        if (!component.get('v.subject')) {
            component.set('v.errorMessage', 'Subject is required.');
            $A.util.removeClass(component.find('error'), 'hidden');
        } else if (!(component.get('v.whoId') || component.get('v.to') || component.get('v.cc') || component.get('v.bcc'))) {
            component.set('v.errorMessage', 'At least one recipient is required.');
            $A.util.removeClass(component.find('error'), 'hidden');
        } else if (!(component.get('v.emailBody') || component.get('v.templateHtmlBody') || component.get('v.docTemplate'))) {
            component.set('v.errorMessage', 'Email body is required.')
            $A.util.removeClass(component.find('error'), 'hidden');
        } else {
            component.set('v.errorMessage', '');
            $A.util.addClass(component.find('error'), 'hidden');

            var emailAttachments = component.get("v.emailAttachments");
            var fileIds = [];
            for (var i = 0; i < emailAttachments.length; i++) {
                var fileId = emailAttachments[i].Id;
                if (fileId) {
                    fileIds.push(fileId);
                }
            }
            
            var templateId = '';
            var templateHtmlValue = '';
            var plainTextBody = '';
            if (component.get('v.templateRendererUrl')) {
                templateId = component.get('v.templateId');
            }
            templateHtmlValue = component.get('v.templateHtmlBody') 
                ? component.get('v.templateHtmlBody') 
                : component.get('v.emailBody')
                    ? component.get('v.emailBody')
                    : component.get('v.docTemplate')
                        ? component.get('v.docTemplate')
                        : '';
            
            //TODO: ADD VALIDATION
            var action = component.get("c.sendEmail");
            action.setParams({
                whoId: component.get('v.whoId'),
                whatId: component.get('v.whatId'),
                additionalToAddresses: component.get('v.to'),
                ccAddresses: component.get('v.cc'),
                bccAddresses: component.get('v.bcc'),
                richText: true,
                includeSignature: false,
                defaultSenderInfo: component.get('v.sender'),
                subject: component.get('v.subject'),
                templateId: templateId,
                templateHtmlValue: templateHtmlValue,
                plainTextBody: plainTextBody,
                fileIdsJson: JSON.stringify(fileIds)
            });
            action.setCallback(this, function(response) {
                if (response.getState() === "SUCCESS") {
                    var responseInfo = JSON.parse(response.getReturnValue());
                    
                    if (responseInfo.isSuccess) {
                        component.set('v.header', component.get('v.ddpLabel') + ' Complete');
                        component.set('v.message', 'Success! Email sent including ' + fileIds.length + ' attachment' + (fileIds.length !== 1 ? 's' : '')  + '.');
                        $A.util.addClass(component.find('emailContents'), 'hidden');
                       	$A.util.removeClass(component.find('toast'), 'hidden');
                    } else {
                        component.set('v.errorMessage', responseInfo.errorMessage);
                        $A.util.addClass(component.find('emailContents'), 'hidden');
                        $A.util.removeClass(component.find('error'), 'hidden');
                    }
                    
                    component.getEvent('enableModifyButtons').fire();
                }
                else {
                    component.set('v.errorMessage', 'An unexpected error has occurred.');
                    $A.util.removeClass(component.find('error'), 'hidden');
                }
            });
            $A.enqueueAction(action);
        }
    },
    load : function(component, event, helper) {
        if (!component.get('v.loaded')) {
            // Reset form
            component.set('v.header', 'New Email');
            component.set('v.message', '');
            $A.util.removeClass(component.find('emailContents'), 'hidden');
            $A.util.addClass(component.find('toast'), 'hidden');
            
            var args = event.getParams().arguments;
            var emailUrl = args.emailUrl;
            var params = helper.parseQueryString(emailUrl);

            var whoId = 'p2_lkid' in params ? params.p2_lkid : null; // Can be contact, lead, or user.
            var whatId = 'p3_lkid' in params ? params.p3_lkid : null; // Can be most other objects.
            var sender = 'p26' in params ? params.p26 : '';
            var addTo = 'p24' in params ? params.p24 : '';
            var cc = 'p4' in params ? params.p4 : '';
            var bcc = 'p5' in params ? params.p5 : '';
            var subject = 'p6' in params ? params.p6 : '';
            var templateId = 'template_id' in params ? params.template_id : null;
            var docTemplateId = 'bodyId' in params ? params.bodyId : null;

            component.set('v.docTemplateId', docTemplateId);
            component.set('v.whoId', whoId);
            component.set('v.whatId', whatId);
            component.set('v.subject', subject);
            
            if (sender) {
	            component.set('v.sender', sender);
                var parts = sender.split(':');
                if (parts.length === 3) {
                    var senderLabel = parts[2] + ' <' + parts[1] + '>';
                    component.set('v.senderLabel', senderLabel);
                }
            }
            
            component.set('v.to', addTo);
            if (cc) {
	            component.set('v.cc', cc);
                component.set('v.displayCc', true);
            }
            if (bcc) {
	            component.set('v.bcc', bcc);
                component.set('v.displayBcc', true);
            }
            
            var documentIds = 'doc_id' in params ? params.doc_id : null; // semicolon delimited
            
            var action = component.get("c.getEmailInfo");
            action.setParams({
                whoId: whoId,
                whatId: whatId,
                templateId: templateId,
                documentIds: documentIds,
                docTemplateId: docTemplateId
            });
            action.setCallback(this, function(response) {
                component.set('v.loaded', true);
                if (response.getState() === "SUCCESS") {
                    var emailInfo = JSON.parse(response.getReturnValue());
                    
                    if ('who' in emailInfo && 'Name' in emailInfo.who && emailInfo.who.Name) {
                        component.set('v.whoName', emailInfo.who.Name);
                    }
                    
                    if ('documents' in emailInfo && emailInfo.documents) {
                        component.set('v.emailAttachments', emailInfo.documents);
                    }
                
                    if ('template' in emailInfo) {
                        component.set('v.templateId', emailInfo.template.Id);
                        if (emailInfo.template.Subject) {
                            component.set('v.subject', emailInfo.template.Subject);
                        }
                        if ('templateRendererUrl' in emailInfo) {
                            var hostname = window.location.hostname;
                            var subdomain = hostname.substring(0, hostname.indexOf('.'));
                            var namespacedSubdomain = subdomain + (subdomain.includes('--loop') ? '' : '--loop');
                            var templateRendererUrl = emailInfo.templateRendererUrl.replace(/(https:\/\/)c(.+)/, '$1' + namespacedSubdomain + '$2');

                            component.set('v.templateRendererUrl', templateRendererUrl);
                        }
                        if ('templateHtmlBody' in emailInfo) {
                            component.set('v.templateHtmlBody', emailInfo.templateHtmlBody);
                        }
                        if (emailInfo.template.Body) {
                            if ('templateBodyLines' in emailInfo) {
                                component.set('v.emailBody', emailInfo.templateBodyLines.join('<br/>'));
                            } else {
                                component.set('v.emailBody', emailInfo.template.Body);
                            }
                        }
                    }
                    if ('docTemplate' in emailInfo) {
                        component.set('v.docTemplate', emailInfo.docTemplate);
                    }
                } else {
                    component.set('v.errorMessage', 'An unexpected error occurred.');
                    $A.util.removeClass(component.find('error'), 'hidden');
                }
            });
            $A.enqueueAction(action);
        }
    },
    showCc : function(component) {
        component.set('v.displayCc', true);
        var paddingRight = parseInt(component.find('to').getElement().style.paddingRight, 10);
        component.find('to').getElement().style.paddingRight = (paddingRight - 20) + 'px';
    },
    showBcc : function(component) {
        component.set('v.displayBcc', true);
        var paddingRight = parseInt(component.find('to').getElement().style.paddingRight, 10);
        component.find('to').getElement().style.paddingRight = (paddingRight - 20) + 'px';
    },
    removeSender : function(component) {
        component.set('v.sender', '');
        component.set('v.senderLabel', '');
    },
    removeWho : function(component) {
        component.set('v.whoId', '');
        component.set('v.whoName', '');
    },
    updateTo : function(component, event) {
        component.set('v.to', event.target.value);
    },
    updateCc : function(component, event) {
        component.set('v.cc', event.target.value);
    },
    updateBcc : function(component, event) {
        component.set('v.bcc', event.target.value);
    },
    updateSubject : function(component, event) {
        component.set('v.subject', event.target.value);
    },
    removeAttachment : function(component, event, helper) {
        var emailAttachments = component.get("v.emailAttachments");
        var removeIndex = event.getParam("id");
        emailAttachments.splice(removeIndex, 1);
        component.set("v.emailAttachments", emailAttachments);
    },
    removeErrorMessage : function(component) {
        component.set('v.errorMessage', '');
        $A.util.addClass(component.find('error'), 'hidden');
    }
})