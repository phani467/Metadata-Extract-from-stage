({
    doInit : function(component, event, helper) {        
        helper.callToServer (
            component,
            "c.getOptyProdLineDetails",
            function(response) {
                var optyLineItem = component.get("v.listOfProducts");
                if ( component.get( "v.listOfProducts" ).length > 0 ) {
                    var i=0;
                    //component.get("v.listOfProducts")
                    var toastEvent = $A.get("e.force:showToast");
                    var msg = "The " + '\n';
                    msg += "  " + component.get ( "v.listOfProducts" ) + '\n';
                    msg += "  " + '\n';
                    msg += " Product(s) is no longer available for sale. Please either change the Opportunity Product Status to Lost (Renewals only) or remove the record.";
                                        
                    toastEvent.setParams ( {
                        "title": "Warning",
                        "message": msg,
                     	"type" : "warning",
                        "duration":"50000ms",
                        "mode":"sticky"
                    } );
                    toastEvent.fire();   
                }
            }, 
            { oppRecordId: component.get( 'v.recordId' ) } );   
    }
})