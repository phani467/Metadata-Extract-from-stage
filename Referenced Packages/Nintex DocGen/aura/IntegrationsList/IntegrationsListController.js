({
    doInit: function(component, event, helper) {
        helper.getIntegrationsList(component);
    },
    deleteIntegration : function(component, event, helper) {
        helper.replaceLinkWithSpinner(component, event);

        var dataIndex = event.target.getAttribute('data-index');
        dataIndex = dataIndex.substring(0, dataIndex.length - 1);
		var integration = component.get('v.integrations')[parseInt(dataIndex)];

        var action = component.get("c.deleteIntegrationInfos");
        action.setParams({
            integrationId: integration.id
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (response.getState() === 'SUCCESS') {
                var returnedMap = JSON.parse(response.getReturnValue());
                if (returnedMap.isSuccess) {
                    helper.getIntegrationsList(component);
                    component.getEvent('actionEvent').setParams({
                        action: 'deleteIntegration'
                    }).fire();
                } else {
                    component.getEvent('showError').setParams({
                        message: 'There was a problem deleting this integration.'
                    }).fire();
                }
            } else {
                var errors = response.getError();
                var message = 'Unknown error';
                if (errors && errors[0] && errors[0].message) {
                    message = 'Error message: ' + errors[0].message;
                }
                component.getEvent('showError').setParams({
                    message: message
                }).fire();
            }
        });
        $A.enqueueAction(action);
    },
    editIntegration : function(component, event, helper) {
        helper.replaceLinkWithSpinner(component, event);
        var dataIndex = event.target.getAttribute('data-index');
        dataIndex = dataIndex.substring(0, dataIndex.length - 1);
        var integration = component.get('v.integrations')[parseInt(dataIndex, 10)];

        component.getEvent('actionEvent').setParams({
            action: 'editIntegration',
            params: JSON.stringify(integration)
        }).fire();
    },
    replaceSpinnersWithLinks : function(component, event) {
        var spinners = component.find('spinner');
        var spinner;
        for (var i in spinners) {
            spinner = spinners[i].getElement();
            if ($A.util.hasClass(spinner, 'inlineBlock')) {
                $A.util.addClass(spinner, 'hidden');
                $A.util.removeClass(spinner, 'inlineBlock');
                break;
            }
        }
        var index = spinner.getAttribute('data-index');
        var links = component.find('link');
        for (var i in links) {
            var linkIndex = links[i].getElement().getAttribute('data-index');
            if (linkIndex === index) {
                $A.util.removeClass(links[i].getElement(), 'hidden');
                break;
            }
        }
    }
})