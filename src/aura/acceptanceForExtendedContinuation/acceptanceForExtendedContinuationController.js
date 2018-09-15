({
		doInit : function(component,event,helper) {
        helper.isCommunity(component);      
    },
    responseYes : function(component, event, helper) {
        helper.callToServer(
            component,
                    "c.createContinuationContractRecord",
                    function(response) { 
                        var jsonObject=response;                       	
                       	component.set('v.createdRecordId',jsonObject); 
                        var navEvt = $A.get("e.force:navigateToSObject");
                       navEvt.setParams({
                       "recordId": jsonObject    
                     });
                       navEvt.fire();  
                    }, 
                    {	oppRecordId: component.get("v.oppRecordId"),
                     	startDate: component.get("v.startDate"),
            			endDate: component.get("v.endDate"),
            			status: component.get("v.status"),
                        acceptanceObtained: 'Yes'
                    } 
        );         
	},
    responseNo : function(component, event, helper) {
        var isCommunity = component.get("v.isCommunity");
        if(isCommunity) {
            var goBack = component.getEvent("goBacktoParentCmp");
            var startDate = component.get("v.startDate");
            var endDate = component.get("v.endDate");
            var status = component.get("v.status");
            var oppRecordId = component.get("v.oppRecordId");
            goBack.setParams({
                "startDate": startDate,
                "endDate": endDate,
                "status": status,
                "oppRecordId": oppRecordId
            });
            goBack.fire();
        }
        else {
    	var evt = $A.get("e.force:navigateToComponent");
                    evt.setParams({
                    componentDef : "c:continuationLetterComponent",
                    componentAttributes:{
                        startDate: component.get("v.startDate"),
                     	endDate: component.get("v.endDate"),
            			status: component.get("v.status"),
            			oppRecordId: component.get("v.oppRecordId")
                        }
                    });
					evt.fire(); 
        }
	}
})