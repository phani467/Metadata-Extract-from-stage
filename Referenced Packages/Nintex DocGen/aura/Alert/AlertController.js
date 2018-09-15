({
	init : function(component, event, helper) {
        var alert = component.find('alert');
        switch (component.get('v.type').toLowerCase()) {
            case 'success':
	            $A.util.addClass(alert, 'slds-theme--success');
                break;
            case 'error':
	            $A.util.addClass(alert, 'slds-theme--error');
                break;
            case 'offline':
	            $A.util.addClass(alert, 'slds-theme--offline');
                break;
            default:
                //doesn't require an additional class
                break;
        }
        if (component.get('v.texture')) {
            $A.util.addClass(alert, 'slds-theme--alert-texture');
        }
	}
})