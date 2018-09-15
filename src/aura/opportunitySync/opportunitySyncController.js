({
	doInit : function(component,event,helper) {
        helper.callToServer(
            component,
            "c.deleteExistingContractLineItemsAndSchedules",
            function(response) {
                document.getElementById("alertSuccess").style.display = "block" ;
                document.getElementById("alertProcessing").style.display = "none" ;
                //To refresh the view
                $A.get('e.force:refreshView').fire();
            }, 
            {contractId: component.get('v.recordId')}
        );             
    }
})