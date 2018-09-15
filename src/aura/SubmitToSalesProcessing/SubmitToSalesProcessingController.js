({
    doInit : function(component,event,helper) {
      
        helper.callToServer(
            component,
            "c.regionExist",
            function(response) {
                if(response == false) {
                    var dismissActionPanel = $A.get("e.force:closeQuickAction"); 
                    dismissActionPanel.fire(); 
                    alert('Sales Region is cannot be empty and Primary Contact must exist!'); 
                }
                else {
                    helper.callToServer(
                        component,
                        "c.submitToSalesProcessingQueue",
                        function(response) {
                            document.getElementById("alertSuccess").style.display = "block" ;
                            document.getElementById("alertProcessing").style.display = "none" ;
                            var navEvt = $A.get("e.force:navigateToSObject");
                            navEvt.setParams({
                                "recordId": response,
                                "slideDevName": "detail"
                            });
                            navEvt.fire();
                        }, 
                        {oppRecordId: component.get('v.recordId')});
                }
            },
            {oppRecordId: component.get('v.recordId')}
        );             
    }
})