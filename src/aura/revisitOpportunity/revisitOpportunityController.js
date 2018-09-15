({
    init : function(component, event, helper) {
        var today = new Date();
        var monthDigit = today.getMonth() + 1;
        if (monthDigit <= 9) {
            monthDigit = '0' + monthDigit;
        }
        component.set('v.today', today.getFullYear() + "-" + monthDigit + "-" + today.getDate());
	},
    cancel : function(component, event, helper) {
        var oppyId = component.get("v.recordId");
        var navevent = $A.get("e.force:navigateToSObject");
        navevent.setParams({
            "recordId": oppyId,
            "slideDevName": "detail",
            "isredirect":true
        });
        navevent.fire();
    },
    save : function(component, event, helper) {  
        var dueDateForTask = component.get("v.taskObj.ActivityDate");
        var todayDate = component.get("v.today");        
        if (dueDateForTask == '' || dueDateForTask==null) {
            alert('Please enter a due date for this task.');
            //helper.displayToast('Error', 'Task cannot be created without a due date.', 'Error');
            return;
        }        
        else if (new Date(dueDateForTask)<new Date(todayDate)){ 
            alert('Please select a future due date for task.');
            return
        }
        var action = component.get("c.creatTask");
        action.setParams({"taskObj":component.get("v.taskObj"),"parentId":component.get("v.recordId")});
            action.setCallback(this,function(result){
            component.set("v.isShow",false);
            var taskId = result.getReturnValue();
            alert('Task succesfully created, you would be redirected to the same.'); 
            $A.get("e.force:closeQuickAction").fire();	
                var navEvt = $A.get("e.force:navigateToSObject");
							navEvt.setParams({
								"recordId": taskId
							});
							navEvt.fire();
        });
         $A.enqueueAction(action);
    }
})