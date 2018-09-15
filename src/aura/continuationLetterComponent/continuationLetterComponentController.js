({
	doInit : function(component,event,helper) {
        helper.isCommunity(component);
        var defaultDays = '14';
        helper.callToServer(
            component,
            "c.contractContinuationStartDateCalculation",
            function(response) {
                component.set('v.startDate',response);  
                	var startDate= component.get("v.startDate");
                if(startDate!=null){
                	helper.callToServer(
                    	component,
                        "c.contractEndDateCalculation",
                        function(response) {
                            component.set('v.endDate',response);  
                        },
                        { days: '14',
                          startDate: component.get("v.startDate")} 
                    ); }
            	},
            { oppRecordId: component.get("v.oppRecordId")} 
        ); 
        
    },
    calculateEndDate : function(component, event, helper) {
        helper.callToServer(
            component,
            "c.contractEndDateCalculation",
            function(response) {
                component.set('v.endDate',response);  
            },
            { days: component.get("v.status"),
              startDate: component.get("v.startDate")} 
        );         
	},
    validateContinuation : function(component, event, helper) {
        helper.callToServer(
            component,
            "c.findTotalDaysOfContinuation",
            function(response) {
                debugger;
                if (response.includes("totalContinuationDays")) { 
                var str = response.replace("totalContinuationDays", "")
            	var evt = $A.get("e.force:navigateToComponent"); 
                component.set('v.noOfDaysOfExtendedContinuation',str);
                var isCommunity = component.get("v.isCommunity");
                 if(isCommunity) {
                      component.set("v.ismaincmp",false);  
                    }
                 else {
                    evt.setParams({
                    componentDef : "c:acceptanceForExtendedContinuation",
                    componentAttributes:{
                        oppRecordId: component.get("v.oppRecordId"),
                     	startDate: component.get("v.startDate"),
            			endDate: component.get("v.endDate"),
            			status: component.get("v.status"),
                        noOfDaysOfExtendedContinuation: str
                        }
                    });
					evt.fire();
                }
                }
                else {
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
                        acceptanceObtained: 'No'
                    }
        			);     
                }                      
            }, 
            {oppRecordId: component.get('v.oppRecordId'),
            startDate: component.get("v.startDate"),
            endDate: component.get("v.endDate")}
        );         
    },
    cancel : function(component, event, helper) {    
          var navEvt = $A.get("e.force:navigateToSObject");
                 navEvt.setParams({
                 "recordId": component.get("v.oppRecordId")    
                 });
            navEvt.fire();   
    },
    
    onBack : function(cmp, event, helper) {
        var startDate = event.getParam("startDate");
        var endDate = event.getParam("endDate");
        var status = event.getParam("status");
        var oppRecordId = event.getParam("oppRecordId");
        cmp.set("v.startDate",startDate);
        cmp.set("v.endDate",endDate);
        cmp.set("v.status",status);
        cmp.set("v.oppRecordId",oppRecordId);
		cmp.set("v.ismaincmp",true);
        
    }
})