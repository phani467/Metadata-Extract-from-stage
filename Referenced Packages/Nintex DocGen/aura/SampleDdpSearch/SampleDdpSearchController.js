({
    fetchData : function(component, event, helper) {
        var action = component.get("c.getDdps");
        action.setParams({
            sessionId: component.get('v.sessionId'),
            domain: component.get('v.loopUrl')
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var groupsJson = response.getReturnValue();
                var groups = JSON.parse(groupsJson);
                
                var industries = [];
                var businessUsers = [];

                if ('error' in groups) {
                    component.getEvent('showError').setParams({
                        message: $A.get('$Label.loop.Sample_Retrieval_Error_Message')
                    }).fire();
                } else {
                    for (var i in groups.ddpGroups) {
                        var group = groups.ddpGroups[i];
                        for (var j in group.ddpItems) {
                            var item = group.ddpItems[j];
                            for (var k in item.businessUsers) {
                                var bu = item.businessUsers[k];
                                if (bu && businessUsers.indexOf(bu) < 0) {
                                    businessUsers.push(bu);
                                }
                            }
                        }
                    }   
                }
                component.set("v.businessUsers", businessUsers.sort());
            } else if (state === "ERROR") {
                component.getEvent('showError').setParams({
                    message: $A.get('$Label.loop.Sample_Retrieval_Error_Message')
                }).fire();
            }
        });
        $A.enqueueAction(action);
    },
	filterDdps : function(component, event, helper) {
        helper.filterDdps(component);
	},
    detectEnter : function(component, event, helper) {
        if (event.getParams() && event.getParams().keyCode && event.getParams().keyCode === 13) {
	        helper.filterDdps(component);
        }
    }
})