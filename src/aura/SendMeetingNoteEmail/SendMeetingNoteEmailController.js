({
    doInit : function(component, event, helper) {
		helper.loadRecipients(component, event, helper);
    },
    addRecipient : function(component, event, helper) {
 		helper.addRecipient(component, event, helper);
    },
    deleteRecipient : function(component, event, helper) {
        helper.deleteRecipient(component, event, helper);
    },
    doSend : function(component, event, helper) {
        helper.doSendEmail(component, event, helper)
    }, 
    cancel : function(component, event, helper) {
        helper.navigateToObject({"recordId": component.get("v.mnId")});
    }
})