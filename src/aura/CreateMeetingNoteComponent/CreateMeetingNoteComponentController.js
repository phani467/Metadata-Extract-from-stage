({
    //Load a MeetingNote instance and set the default name
    doInit : function(component, event, helper) {
        var hasAlreadyLoaded = component.get("v.hasAlreadyLoaded");
        if(!hasAlreadyLoaded){
            helper.callToServer(
                component,
                "c.getPrePopulatedMeetingNote",
                function(response) {
                    component.set("v.meetingNote", response);
                }, 
                {eventId: component.get("v.eventId")}
            ); 
        }
    },

    //Create a MeetingNote instance and move to next screen to add related Opportunities
    addRelatedOpps :function(component,event, helper){
        var meetingNoteObj = component.get("v.meetingNote");
        if($A.util.isEmpty(meetingNoteObj.NextSteps__c) ||
           $A.util.isEmpty(meetingNoteObj.Achieved__c) || 
           $A.util.isEmpty(meetingNoteObj.Name) ||
           $A.util.isEmpty(meetingNoteObj.Info__c)){
			
            helper.displayToast('Error','Please populate mandatory fields', 'Error');    
        }
        //To check if someone only added space or new line. doing trim when value is undefiend will throw error
        //hence its handled in different elseIf block
        else if($A.util.isEmpty(meetingNoteObj.NextSteps__c.trim()) ||
           $A.util.isEmpty(meetingNoteObj.Achieved__c.trim()) || 
           $A.util.isEmpty(meetingNoteObj.Name.trim()) ||
           $A.util.isEmpty(meetingNoteObj.Info__c.trim())){
			
            helper.displayToast('Error','Please populate mandatory fields', 'Error');    
        }
        else {
            
            var evt = $A.get("e.force:navigateToComponent");
                    evt.setParams({
                        componentDef : "c:MeetingNoteRelatedOpportunity",
                        componentAttributes: {
                            "MeetingNote" : component.get("v.meetingNote"),
                            "eventId": component.get("v.eventId"),
                            "relatedOpportunityList": component.get("v.relatedOpportunityList"),
                            "meetingAttendeeList" : component.get("v.meetingAttendeeList"),
                            "hasAlreadyLoaded" : component.get("v.hasAlreadyLoaded"),
                            "hasGoneNext" : component.get("v.hasGoneNext")
                        }
                    });
             evt.fire();
        }
    },
    //Create a MeetingNote recrd and redirect to new record
    doSave :function(component,event, helper){
        var meetingNoteObj = component.get("v.meetingNote");
        if($A.util.isEmpty(meetingNoteObj.NextSteps__c) ||
           $A.util.isEmpty(meetingNoteObj.Achieved__c) || 
           $A.util.isEmpty(meetingNoteObj.Name) ||
           $A.util.isEmpty(meetingNoteObj.Info__c)){

            helper.displayToast('Error','Please populate mandatory fields.', 'Error');
        }
        //To check if someone only added space or new line. doing trim when value is undefiend will throw error
        //hence its handled in different elseIf block
        else if($A.util.isEmpty(meetingNoteObj.NextSteps__c.trim()) ||
           $A.util.isEmpty(meetingNoteObj.Achieved__c.trim()) || 
           $A.util.isEmpty(meetingNoteObj.Name.trim()) ||
           $A.util.isEmpty(meetingNoteObj.Info__c.trim())){
			
            helper.displayToast('Error','Please populate mandatory fields.', 'Error');    
        } 
        else {
            
            //Fetch Opportunity related list
            var relatedOpps = component.get("v.relatedOpportunityList");
            var oppIds = [];
            for(var i = 0; i < relatedOpps.length; i++){
                oppIds.push(relatedOpps[i].Opportunity__c);
            }
            
            helper.callToServer(
                component,
                "c.saveMeetingNotesAndRelatedData", 
                function(response) {
                    if(response.message === 'success' && !$A.util.isEmpty(response.mnId)){
                        helper.navigateToObject({"recordId": response.mnId});
                    }
                    else{
                        helper.displayToast('Error', response.message, 'Error');
                    }
                }, 
                {
                    meetingNote: component.get('v.meetingNote'), 
                    lstRelatedOppIds: oppIds, 
                    jsonLstAttendees: JSON.stringify(component.get("v.meetingAttendeeList")),
                    eventId: component.get('v.eventId')
                }
        	);
        }
    },
    cancel : function(component,event, helper){
        helper.navigateToObject({"recordId": component.get("v.eventId")});
    }
 })