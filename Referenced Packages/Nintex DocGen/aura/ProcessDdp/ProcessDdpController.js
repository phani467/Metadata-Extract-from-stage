({
    onInit : function(component, event, helper) {
        var action = component.get("c.fetchInit");
        action.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                var parsedResponse = JSON.parse(response.getReturnValue());
                if (parsedResponse.isSuccess) {
                    component.set("v.containerId", parsedResponse.containerId);
                    component.set("v.isSandbox", parsedResponse.isSandbox);
                }
                else {
            		$A.util.addClass(component.find("panel-progress"), "hidden");
            		$A.util.addClass(component.find("panel-preview"), "hidden");
                    component.set("v.hasErrored", true);
                    component.find("panel-error").getElement().innerHTML = parsedResponse.errorMessage;
                }
            }
            else {
                $A.util.addClass(component.find("panel-progress"), "hidden");
                $A.util.addClass(component.find("panel-preview"), "hidden");
                component.set("v.hasErrored", true);
                component.find("panel-error").getElement().innerHTML = $A.get('$Label.loop.Generic_Error_Message');
            }
        });
        
        $A.enqueueAction(action);

        if (window && window.location) {
            var params = window.location.search.substring(1).split('&');
            for (var i = 0; i < params.length; i++) {
                var parts = params[i].split('=');
                if (encodeURIComponent(parts[0]) === 'secret' && encodeURIComponent(parts[1]) === 'rainbow') {
                    $A.util.removeClass(component.find('progressBar'), 'custom-texture');
                    $A.util.addClass(component.find('progressBar'), 'rainbow');
                }
            }
        }
    },
    start : function(component, event, helper) {
        var eventParameters = event.getParam("arguments");
        if (eventParameters && !component.get("v.hasErrored")) {
            var parameters = eventParameters.parameters;
            var eSignRecipients = eventParameters.eSignRecipients;
            var globalId = eventParameters.globalId;
            
            var reminderDelay = parameters.reminderDelay;
            var reminderFrequency = parameters.reminderFrequency;
            var expireAfter = parameters.expireAfter;
            var expireWarn = parameters.expireWarn;
            
            var formattedRecipients = [];
            for (var i = 0; i < eSignRecipients.length; i++) {
                var recipient = eSignRecipients[i];
                var id = recipient.recipientObjectId;
                var idSuffix = recipient.isHost ? '_host' : '_recipient';
                
                formattedRecipients.push({
                    "key": id + "_recipient",
                    "value": recipient.selectedRecipientId
                });
                
                if (recipient.selectedRecipientId === "name_email") {
                    formattedRecipients.push({
                        "key": id + "_recipient_name",
                        "value": recipient.name
                    });
                    formattedRecipients.push({
                        "key": id + "_recipient_email",
                        "value": recipient.email
                    });
                }
                
                if (recipient.accessCode) {
                    formattedRecipients.push({
                        "key": id + "_accesscode",
                        "value": recipient.accessCode
                    });
                }
                
                if (recipient.note) {
                    formattedRecipients.push({
                        "key": id + "_note",
                        "value": recipient.note
                    });
                }
                
                if (recipient.host) {
                    formattedRecipients.push({
                        "key": id + "_host",
                        "value": recipient.host.selectedRecipientId
                    });
                    
                    if (recipient.host.selectedRecipientId === "name_email") {
                        formattedRecipients.push({
                            "key": id + "_host_name",
                            "value": recipient.host.name
                        });
                        formattedRecipients.push({
                            "key": id + "_host_email",
                            "value": recipient.host.email
                        });
                    }
                }
                
                formattedRecipients.push({
                    "key": id + "_remindDelay",
                    "value": reminderDelay
                });
                formattedRecipients.push({
                    "key": id + "_remindFreq",
                    "value": reminderFrequency
                });
                formattedRecipients.push({
                    "key": id + "_expireAfter",
                    "value": expireAfter
                });
                formattedRecipients.push({
                    "key": id + "_expireWarn",
                    "value": expireWarn
                });
            }
            
            component.set("v.formattedRecipients", JSON.stringify(formattedRecipients));
            var emailSubjectKey = parameters.deliveryOptionId + '_emailSubject';
            var emailBodyKey = parameters.deliveryOptionId + '_emailText';
            var serializedEmailData = JSON.stringify([{"key": emailSubjectKey, "value": parameters.emailSubject}, {"key": emailBodyKey, "value": parameters.emailText}]);
                        
            var action = component.get("c.fetchEndpoint");
            action.setParams({
                parameters: JSON.stringify(parameters)
            });
            action.setCallback(this, function(response) {
                if (response.getState() === "SUCCESS") {
                    var parsedResponse = JSON.parse(response.getReturnValue());
                    if (parsedResponse.isSuccess) {
                        //locker service doesn't like that Drawloop is being defined in a static resource,
                        //but this works with lockerservice enabled and is necessary to process the ddp.
                        var processDdpComponent = new Drawloop.ProcessDdpComponent({
                            containerId:        	component.get("v.containerId"),
                            pollPause:          	1000,
                            endpoint:           	parsedResponse.endpoint,
                            sessionId:          	parsedResponse.sessionId,
                            partnerServerUrl:   	parsedResponse.partnerServerUrl,
                            onErrorCallback:    	parameters.onErrorCallback ? parameters.onErrorCallback : '',
                            onProgressCallback: 	parameters.onProgressCallback ? parameters.onProgressCallback : '',
                            onCompleteCallback: 	parameters.onCompleteCallback ? parameters.onCompleteCallback : '',
                            previewButtonText:  	parameters.previewButtonText,
                            deliveryOptionType: 	parameters.deliveryOptionType,
                            isAutoRun:          	parameters.isAutoRun,
                            isLightning:			true,
                            componentId: 			globalId,
                            userId:             	parsedResponse.userId,
                            sandbox:                component.get('v.isSandbox'),
                            ddpLabel:				component.get('v.ddpLabel')
                        });
                        
                        var styleUrl = $A.get('$Resource.Loop__Styles') + '/css/process-ddp.css';
                        
                        Drawloop.ddpRunner.queueDdp(processDdpComponent, {
                            id: 							parameters.ddpId,
                            deliveryOptionId: 				parameters.deliveryOptionId ? parameters.deliveryOptionId : '',
                            recipients:						component.get('v.formattedRecipients'),
                            standardDelivery: 				parameters.standardDeliveryAsString ? parameters.standardDeliveryAsString : '',
                            recordId: 						parameters.recordId,
                            objectType: 					parameters.objectName,
                            additionalRecordInfo: 			parameters.additionalRecordInfoAsString,
                            attachments: 					parameters.attachmentsAsString,
                            excludedOptionalDdpFileIds: 	JSON.parse(parameters.excludedOptionalDdpFileIdsAsString),
                            workspaceId: 					parameters.workspaceId ? parameters.workspaceId : '',
                            attachToRecord: 				parameters.attachToRecord,
                            emailParams:					serializedEmailData,
                            usePreview:                     parameters.usePreview,
                            showAllData: 					parameters.showAllData ? parameters.showAllData : '',
                            progress: 						parameters.processingText ? parameters.processionText : '',
                            isTestDelivery:                 parameters.isTestDelivery,
                            runContext:                     'RDLC'
                        }, styleUrl);
                    }
                    else {
                        $A.util.addClass(component.find("panel-progress"), "hidden");
                        $A.util.addClass(component.find("panel-preview"), "hidden");
                        component.set("v.hasErrored", true);
                        component.find("panel-error").getElement().innerHTML = parsedResponse.errorMessage;
                    }
                }
                else {
                    $A.util.addClass(component.find("panel-progress"), "hidden");
                    $A.util.addClass(component.find("panel-preview"), "hidden");
                    component.set("v.hasErrored", true);
                    component.find("panel-error").getElement().innerHTML = $A.get('$Label.loop.Generic_Error_Message');
                }
            });
            
            $A.enqueueAction(action);
        }
	},
    resetBar : function(component, event, helper) {
        var progressBar = component.find("progressBar");
        $('.progress-bar').prop('aria-valuenow', 0);
        $('.progress-bar').css('width', 0);
        component.find("progressBarInnerText").getElement().innerHTML = "";
        component.find("progressBarText").getElement().innerHTML = "";
    }
})