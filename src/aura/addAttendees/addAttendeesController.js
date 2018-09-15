({
	doInit : function(component, event, helper) {
        var hasGoneNext = component.get("v.hasGoneNext");
        //Don't call the server on load if attendees screen has been already visited
        if(!hasGoneNext){
            helper.callToServer(
                component,
                "c.getMeetingAttendees",
                function(response) {
                    debugger;
                    component.set("v.meetingAttendeeList", response);
                }, 
                {eventId: component.get("v.eventId"), meetingNote: component.get('v.MeetingNote')}
            ); 
        } 
	},
    addAttendee : function(component, event, helper) {
        var conLookup = component.find("contactId");
        var contactId = null;

        if(!$A.util.isEmpty(conLookup.get("v.value"))){
            contactId = conLookup.get("v.value");
            
			helper.callToServer(
                component,
                "c.addMeetingAttendee",
                function(response) {
                    component.set("v.record1", response);
                    var PL = component.get("v.meetingAttendeeList");     
                    PL.push(response); 
                    component.set("v.meetingAttendeeList",PL);  
                }, 
                {
                    meetingContactId: contactId
                }
        	);
        }    
        else
            helper.displayToast('Error','Please select any attendee.', 'Error');
	},
    deleteAttendee : function(component, event, helper){
        var serialNumber = event.currentTarget.getAttribute('value');
        var arr = component.get("v.meetingAttendeeList");
        var cAttendeeObj = arr.splice(serialNumber, 1);
        component.set("v.meetingAttendeeList", arr);
    }, 
    backToRelatedOpportunity : function(component, event, helper){
        var evt = $A.get("e.force:navigateToComponent");
        evt.setParams({
            componentDef : "c:MeetingNoteRelatedOpportunity",
            componentAttributes: {
                "eventId": component.get("v.eventId"),
                "MeetingNote": component.get('v.MeetingNote'),
                "relatedOpportunityList": component.get('v.relatedOpportunityList'),
                "meetingAttendeeList" : component.get("v.meetingAttendeeList"),
                "hasGoneNext": true,
                "hasAlreadyLoaded" : true
            }
        });
        evt.fire();
    }, 
    cancel : function(component, event, helper){
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({"recordId": component.get("v.eventId")});
        navEvt.fire();
    },

    doSave : function(component, event, helper){
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
                meetingNote: component.get('v.MeetingNote'), 
                lstRelatedOppIds: oppIds, 
                jsonLstAttendees: JSON.stringify(component.get("v.meetingAttendeeList")),
                eventId: component.get('v.eventId')
            }
        );

    }    
})