({
    setValues : function(component, event) {
        var params = event.getParams().arguments;
        component.set('v.id', params.globalId);
        component.set('v.isHtmlEmail', params.isHtmlEmail);
        component.set('v.emailSubject', params.emailSubject);
        component.set('v.emailBody', params.emailBody);
    },
    updateSlideEmail : function(component) {
        var updateSlideEmail = component.getEvent('updateSlideEmail');
        updateSlideEmail.setParams({
            globalId: component.get('v.id'),
            emailSubject: component.get('v.emailSubject'),
            emailBody: component.get('v.emailBody')
        });
        updateSlideEmail.fire();
        
        component.getEvent('slideOutEditEmail').fire();
    },
    cancel : function(component) {
        component.getEvent('slideOutEditEmail').fire();
    }
})