({
    init : function(component, event, helper) {
        if (component.get('v.isLightning')) {
            component.find('viewDdps').set("v.visible", false);
            component.find('createDdps').set("v.visible", false);
        }
        var sampleDdpObjects = component.get('v.sampleDdpObjects');
        var layoutButtonObjects = component.get('v.layoutButtonObjects');
        var union = [];
        for (var i in sampleDdpObjects) {
            var obj = sampleDdpObjects[i];
            if (layoutButtonObjects.indexOf(obj) > -1 && union.indexOf(obj) < 0) {
                union.push(obj);
            }
        }
        var priority = ['Opportunity', 'Account', 'Contact', 'Lead', 'Case', 'Contract'];
        var sampleObject = '';
        for (var j in priority) {
            if (union.indexOf(priority[j]) > -1) {
                sampleObject = priority[j];
                component.set('v.sampleObject', sampleObject);
                break;
            }
        }
        
        var action = component.get("c.getSampleDdpRecords");
        action.setParams({
            objName : sampleObject ? sampleObject : 'none'
        });
        action.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                var parsedJSON = JSON.parse(response.getReturnValue());
                if (parsedJSON.status === 'success') {
                    if (sampleObject) {
                        component.set("v.columns", parsedJSON.columns);
                        component.set("v.records", parsedJSON.records);
                    }
                    component.set("v.ddpPrefix", parsedJSON.ddpPrefix);
                } else {
                    component.getEvent('showError').setParams({
                        message: parsedJSON.errorMessage
                    }).fire();
                    component.find('viewDdps').set("v.visible", false);
                    component.find('createDdps').set("v.visible", false);
                    component.find('ddpAdmin').set("v.visible", false);
                }
            }
            
            var actionEvent = component.getEvent('actionEvent');
            actionEvent.setParams({
                action: 'doneLoading'
            });
            actionEvent.fire();
        });
        $A.enqueueAction(action);
    },
    viewDdps : function(component, event, helper) {
        var url = '/' + component.get("v.ddpPrefix") + '/o';
        helper.navigateToUrl(component, url);
    },
    createDdps : function(component, event, helper) {
        var url = '/apex/Loop__ddpWizard?retURL=' + encodeURIComponent('/' + component.get("v.ddpPrefix") + '/o') + '&save_new=1';
        helper.navigateToUrl(component, url);
    },
    ddpAdmin : function(component, event, helper) {
        var url = '/apex/Loop__aboutloop?sfdc.tabName=123456';
        helper.navigateToUrl(component, url);
    }
})