({
	displayToast : function(title, message, typeOfToast){
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "message": message,
            "type": typeOfToast
        });
        toastEvent.fire();
    }
})