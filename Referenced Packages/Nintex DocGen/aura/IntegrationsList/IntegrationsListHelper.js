({
    //Fetch the accounts from the Apex controller
    getIntegrationsList: function(component) {
        var action = component.get("c.getIntegrations");
        action.setCallback(this, function(actionResult) {
            var jsonObjects = JSON.parse(actionResult.getReturnValue());
            component.set("v.integrations", jsonObjects);
            var loadingRow = component.find('loadingRow').getElement();
            $A.util.addClass(loadingRow, 'hidden');

            var emptyRow = component.find('emptyRow').getElement();
            if (jsonObjects.length > 0) {
	            $A.util.addClass(emptyRow, 'hidden');
            } else {
	            $A.util.removeClass(emptyRow, 'hidden');
            }
        });
        $A.enqueueAction(action);
    },
    replaceLinkWithSpinner : function(component, event) {
        var link = event.target;
        $A.util.addClass(link, 'hidden');
        
        var index = link.getAttribute('data-index');
        var spinners = component.find('spinner');
        var spinner;
        for (var i in spinners) {
            var spinnerIndex = spinners[i].getElement().getAttribute('data-index');
            if (spinnerIndex === index) {
                spinner = spinners[i].getElement();
                break;
            }
        }
        
        $A.util.removeClass(spinner, 'hidden');
        $A.util.addClass(spinner, 'inlineBlock');
    }
})