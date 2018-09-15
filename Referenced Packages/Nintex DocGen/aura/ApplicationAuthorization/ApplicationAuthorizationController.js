({
    /**
     * Handles initialization tasks for the ApplicationAuthorization component.
     * Initialization parameters retrieved: OAuthUrl, isAuthorized, hasCustomizeAppPermission, and IntegrationUser
     */
    onInit: function(component, event, helper) {
        helper.requestInitParams(component)
            .then($A.getCallback(response => {
                helper.setInitParams(component, response);
                return response;
            }))
            .then($A.getCallback(response => {
                helper.fireAuthInitCompleteEvent(component, response);
            }))
            .catch($A.getCallback(error => {
                helper.fireAuthInitFailedEvent(component, error.message);
                helper.setViewErrorState(component);
            }));
    },
    /**
     * Kicks off the Authorization flow.
     */
    startOAuthFlow: function(component, event, helper) {
        helper.createAuthListener(component);
        window.open(component.get('v.oAuthUrl'), 'Salesforce Authorization', 'height=810, width=680, location=0, status=0, titlebar=0');
    },
    /**
     * Updates the view based on attribute values changes
     */
    onViewStateChange: function(component, event, helper) {
        helper.updateAuthButtonVisibility(component);
    }
})