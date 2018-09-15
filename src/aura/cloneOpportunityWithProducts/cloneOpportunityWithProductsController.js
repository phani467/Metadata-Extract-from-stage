({
	doInit : function(component,event,helper) {
    $A.get("e.force:closeQuickAction").fire();
        helper.callToServer(
            component,
            "c.getOpptyAccess",
            function(response) {
                if(response == 'userHasNoAccess') {
                    document.getElementById("content2").style.display = "block";
                    return;
                }
                else {
                    document.getElementById("content1").style.display = "block";
                    helper.callToServer(
						component,
						"c.cloneOpportunityRecord",
						function(response) {
							$A.get("e.force:closeQuickAction").fire();
							var jsonObject=response;
							//alert('Hello hi - this is ur new oppty ---'+response);
                
							var navEvt = $A.get("e.force:navigateToSObject");
							navEvt.setParams({
								"recordId": jsonObject
							});
							navEvt.fire();
						}, 
						{ oppId: component.get('v.recordId') }
					);
                }
            }, 
            { oppId: component.get('v.recordId') }
        );	 	
	}
})