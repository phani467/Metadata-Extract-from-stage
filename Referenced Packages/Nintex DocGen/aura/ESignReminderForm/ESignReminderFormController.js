({
    setValues : function(component, event, helper) {
        var reminderFields = [
            {
                'id': 'reminderDelay',
                'label': 'Reminder Delay',
                'errorLabel': 'reminderDelayError',
                'value': event.getParams().arguments.reminderDelay,
                'savedValue': event.getParams().arguments.reminderDelay,
                'hasError': false
            },
            {
                'id': 'warnOfExpiration',
                'label': 'Warn of Expiration',
                'errorLabel': 'warnOfExpirationError',
                'value': event.getParams().arguments.warnOfExpiration,
                'savedValue': event.getParams().arguments.warnOfExpiration,
                'hasError': false
            },
            {
                'id': 'reminderFrequency',
                'label': 'Reminder Frequency',
                'errorLabel': 'reminderFrequencyError',
                'value': event.getParams().arguments.reminderFrequency,
                'savedValue': event.getParams().arguments.reminderFrequency,
                'hasError': false
            },
            {
                'id': 'daysTillSigningExpires',
                'label': 'Days Till Signing Expires',
                'errorLabel': 'daysTillSigningExpiresError',
                'value': event.getParams().arguments.daysTillSigningExpires,
                'savedValue': event.getParams().arguments.daysTillSigningExpires,
                'hasError': false
            }
        ];
        
        component.set('v.reminderFields', reminderFields);
        component.set('v.id', event.getParams().arguments.globalId);
    },
    updateDocuSignReminders : function(component, event, helper) {
        var reminderFields = component.get('v.reminderFields');
        var hasError = false;
        
        for (var i = 0; i < reminderFields.length; i++) {
            var field = reminderFields[i];
            if (field.hasError) {
                hasError = true;
                break;
            }
        }
        
        if (!hasError) {
            var updateDocuSignReminders = component.getEvent("updateDocuSignReminders");
            
            var reminderDelay = Number(component.find("reminderDelay").getElement().value);
            var daysTillSigningExpires = Number(component.find("daysTillSigningExpires").getElement().value);
            var reminderFrequency = Number(component.find("reminderFrequency").getElement().value);
            var warnOfExpiration = Number(component.find("warnOfExpiration").getElement().value);
            
            updateDocuSignReminders.setParams({
                globalId: component.get("v.id"),
                reminderDelay: reminderDelay,
                daysTillSigningExpires: daysTillSigningExpires,
                reminderFrequency: reminderFrequency,
                warnOfExpiration: warnOfExpiration
            });
            updateDocuSignReminders.fire();
            
            component.getEvent("slideOutDocuSignReminders").fire();
        }
    },
	cancel : function(component, event, helper) {
        component.getEvent("slideOutDocuSignReminders").fire();
    },
    validateField : function(component, event) {
        var reminderFields = component.get('v.reminderFields');
        
        for (var i = 0; i < reminderFields.length; i++) {
            if (reminderFields[i].id === event.target.id) {
                var fieldValue = component.find(reminderFields[i].id).getElement().value;
                
                reminderFields[i].value = fieldValue;
                reminderFields[i].hasError = isNaN(fieldValue);
                
                break;
            }
        }
        
        component.set('v.reminderFields', reminderFields);
	}
})