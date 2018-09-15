({
	doInit : function(component, event, helper) {
		var meetingNote = component.get("v.MeetingNote");       
        helper.callToServer(
            component,
            "c.getOpportunititesListToAdd",
            function(response) {
                component.set("v.opportunityId", null);
                component.set("v.opportunityList", response);
            }, 
            {meetingNote: meetingNote}
        );
		
        //Add the Opportunity into related list when Event is linked with Opportunity
        if(!$A.util.isEmpty(meetingNote.Opportunity__c) && !component.get("v.hasAlreadyLoaded")){
            
            helper.callToServer (
                component,
                "c.addRelatedOpportunitiesForMeetingId",
                function(response) {
                    var arr = component.get("v.relatedOpportunityList");
                    arr.push(response);
                    component.set("v.relatedOpportunityList", arr);
                }, 
                {
                    meetingNoteId: component.get("v.recordId"),
                 	opportunityId: meetingNote.Opportunity__c
                }
            );
        }      
	},
    cancel : function(component,event, helper){
        helper.navigateToObject({"recordId": component.get("v.eventId")});
	},
    addAttendees : function(component,event, helper){
        var evt = $A.get("e.force:navigateToComponent");
        evt.setParams({
            componentDef : "c:addAttendees",
            componentAttributes: {
                "eventId":  component.get("v.eventId"),
                "MeetingNote": component.get("v.MeetingNote"),
                "relatedOpportunityList": component.get("v.relatedOpportunityList"),
                "meetingAttendeeList" : component.get("v.meetingAttendeeList"),
                "hasGoneNext": component.get("v.hasGoneNext"),
                "hasAlreadyLoaded": component.get("v.hasAlreadyLoaded")
            }
        });
        evt.fire();
	},
    deleteRelatedOpportunity : function (component, event, helper){
        var serialNumber = event.currentTarget.getAttribute('value');
        var arr = component.get("v.relatedOpportunityList");
        var meetingNoteObj = arr.splice(serialNumber, 1);//remove one
        component.set("v.relatedOpportunityList", arr);
    },
    onSelectChange : function(component,event, helper){
        var selectOpportunity = component.find("opportunities");
        component.set("v.opportunityId", selectOpportunity.get("v.value"));
	}, 
    addRelatedOpportunity : function(component, event, helper){
        var opp = null;
        var oppLookup = component.find("opportunityLookupid");
        if(! $A.util.isEmpty(oppLookup.get("v.value"))){
            opp = oppLookup.get("v.value");
        } else if (! $A.util.isEmpty(component.get("v.opportunityId"))){
            opp = component.get("v.opportunityId");
        }
        if (! $A.util.isEmpty(opp)){
            helper.callToServer (
                component,
                "c.addRelatedOpportunitiesForMeetingId",
                function(response) {
                    var arr = component.get("v.relatedOpportunityList");
                    arr.push(response);
                    component.set("v.relatedOpportunityList", arr);
                }, 
                {meetingNoteId: component.get("v.recordId"),
                 opportunityId: opp}
            );
        } else {
            helper.displayToast('Error','Please select any opportunity.', 'Error');
        }    
    },
    //Go Back to Meeting Notes detail
    goBackToMeetingNoteDetail : function(component, event, helper){
        var evt = $A.get("e.force:navigateToComponent");
            evt.setParams({
                componentDef : "c:CreateMeetingNoteComponent",
                componentAttributes: {
                    "meetingNote" : component.get("v.MeetingNote"),
                    "eventId": component.get("v.eventId"),
                    "relatedOpportunityList": component.get("v.relatedOpportunityList"),
                    "meetingAttendeeList" : component.get("v.meetingAttendeeList"),
                    "hasAlreadyLoaded" : true,
                    "hasGoneNext": component.get("v.hasGoneNext")
                }
            });
        evt.fire();    
    },
	doSave : function(component, event, helper){
        //Get the related Opportunities Id
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