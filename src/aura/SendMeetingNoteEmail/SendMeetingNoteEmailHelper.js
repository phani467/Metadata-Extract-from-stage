({
    loadRecipients : function(component, event, helper) {
        var action = component.get("c.getRecipientsOnLoad");
        action.setParams({"mnId": component.get("v.mnId"),
                          "launchedFrom": component.get("v.launchedFrom")
                         });
	    action.setCallback(this, function(response) {
            var state = response.getState();
	        //$A.get("e.force:closeQuickAction").fire();
            
            if(component.isValid() && state === "SUCCESS") {
                var response = response.getReturnValue();
				component.set("v.recipientList", response);
            } else if(state === "ERROR") {
                var errors = response.getError();
                helper.displayToast('Error',errors[0].message, 'Error');
            }
        });
	    $A.enqueueAction(action);
    },
    
    addRecipient : function(component, event, helper) {
        
        var conLookup = component.find("contactId");
        var contactId = null;
        
        if(!$A.util.isEmpty(conLookup.get("v.value"))) {
            contactId = conLookup.get("v.value");             
            var action = component.get("c.addEmailRecipient");
        	action.setParams({"contactId": contactId});
            action.setCallback(this, function(response) {
                var state = response.getState();
                if(component.isValid() && state === "SUCCESS") {
                    var response = response.getReturnValue();
                    //Add to the rendered list if response is not null
                    if(!$A.util.isEmpty(response)) {
                        var recipients = component.get("v.recipientList");
                        recipients.push(response);
                        component.set("v.recipientList", recipients);
                    }
                    else
                        helper.displayToast('Error', 'Selected Contact doesn\'t have an email', 'Error');
                } else if(state === "ERROR") {
                    var errors = response.getError();
                    helper.displayToast('Error',errors[0].message, 'Error');
            	}
			});
	    	$A.enqueueAction(action);
		}    
        else
       		helper.displayToast('Error','Please select any Recipient.', 'Error');    
    },
    
    deleteRecipient : function(component, event, helper) {
        var serialNumber = event.currentTarget.getAttribute('value');
        var arr = component.get("v.recipientList");
        var cAttendeeObj = arr.splice(serialNumber, 1);
        component.set("v.recipientList", arr);
    },
    
    doSendEmail : function(component, event, helper) {
		var recipients = component.get("v.recipientList");
        if(!$A.util.isEmpty(recipients)) {
            
            var action = component.get("c.sendEmail");
        	action.setParams({"mnId": component.get("v.mnId"), 
                              "jsonLstRecipients" : JSON.stringify(component.get("v.recipientList")) 
                             });
            action.setCallback(this, function(response) {
                var state = response.getState();
                if(component.isValid() && state === "SUCCESS") {
                    var response = response.getReturnValue();
					
                    if(response === 'Success')
                    	helper.navigateToObject({"recordId": component.get("v.mnId")});
                    else
                        helper.displayToast('Error', response, 'Error');
                } 
			});
	    	$A.enqueueAction(action);
            
        } else {
            helper.displayToast('Error','Please select Recipients to send email to them.', 'Error');   
        }
    },
    
    displayToast : function(title, message, typeOfToast) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "message": message,
            "type": typeOfToast
        });
        toastEvent.fire();
    },
    
    navigateToObject : function(params) {
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams(params);
        navEvt.fire();
    },
})