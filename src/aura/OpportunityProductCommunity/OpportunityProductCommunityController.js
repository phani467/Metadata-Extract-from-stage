({
    doInit : function(component, event, helper) {
        //check if oppyId is not null
        var oppyId = component.get("v.oppyId");
        if(!oppyId) {
            //fetch the oppyId from URL
            oppyId = helper.getParameterByName(component,event,'recordId');
            if(!oppyId) {
                return;
            }
        }
        var environmentType = component.get("v.environmentType");
        //if control reaches here that means the component has oppyId
        $A.createComponent(
                "c:OpportunityProductEditPage",
                {
                    "oppyId":oppyId,
                    "environmentType":environmentType
                    
                },function(oppyProdEdit,status, errorMessage) {
                    if (status === "SUCCESS") {
                        component.set("v.body", oppyProdEdit);
                    } else if (status === "INCOMPLETE") {
                        console.log("No response from server or client is offline.")
                        // Show offline error
                    } else if (status === "ERROR") {
                            console.log("Error: " + errorMessage);
                            // Show error message
                        }
                }
            );
        
      
    }
})