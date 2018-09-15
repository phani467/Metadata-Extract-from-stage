({
    ///////////////////////////
    // region Business Logic
    /**
     * Makes a request to the controller for the OAuth URL, isAuthorized check, Customize Application permission status,
     * and integration username.
     * @param component
     * @return {Promise}
     */
    requestInitParams: function(component) {
        const that = this;
        return new Promise($A.getCallback((resolve, reject) => {
            const getInitParams = component.get('c.getInitParams');
            getInitParams.setParams({
                envPrefix: that.getDocGenEnvironmentPrefix(),
                origin: window.location.origin,
                useGenericLogin: component.get('v.businessContext') === 'OTHER_ORG_AUTH',
                redirectTarget: component.get('v.redirectTarget')
            });
            getInitParams.setCallback(this, response => {
                if (response.getState() === 'SUCCESS') {
                    const parsedResponse = JSON.parse(response.getReturnValue());
                    if (parsedResponse.isSuccess) {
                        resolve(parsedResponse);
                    } else {
                        reject(parsedResponse.errorMessage);
                    }
                } else {
                    const errors = response.getError();
                    let errorMessage = $A.get('$Label.loop.Generic_Error_Message');
                    if (errors && errors[0] && errors[0].message) {
                        errorMessage = $A.get('$Label.loop.Error_Label') + ': ' + errors[0].message;
                    }
                    reject(errorMessage);
                }
            });

            $A.enqueueAction(getInitParams);
        }));
    },
    /**
     * Creates a listener that will listen for the result of the authorization request.
     * Events will be handled based on the context that the component is in, via the redirectTarget attribute
     * Listens for: 'authorizeLoop', 'edition'
     * Fires: 'oAuthSuccess' and 'oAuthFailure'
     * @param component
     */
    createAuthListener: function(component) {
        switch (component.get('v.redirectTarget')) {
            case component.get('v.AuthTarget.AUTHORIZE_LOOP'):
                window.Drawloop.eventListener.addEventListener('authorizeLoop', this.handleAuthorizeLoop.bind(this, component));
                break;
            case component.get('v.AuthTarget.EDITION'):
                window.Drawloop.eventListener.addEventListener('edition', this.handleEdition.bind(this, component));
                break;
            default:
                break;
        }
    },
    /**
     * Handles authorization in the context of the Edition component. In the edition component,
     * we want to authorize an external production org from a sandbox, in order to transfer license information from the
     * production org to the sandbox.
     */
    handleEdition: function(component, event) {
        const oAuthEvent = component.getEvent('actionEvent');
        let sessionId;
        let location;
        if (event && event.data && event.data.payload) {
            const payload = JSON.parse(event.data.payload);
            sessionId = payload.sessionId;
            location = payload.location;
        }
        if (sessionId && location) {
            oAuthEvent.setParams({
                action: 'oAuthSuccess',
                params: JSON.stringify({
                    sessionId: sessionId,
                    location: location
                })
            });
        } else {
            oAuthEvent.setParams({action: 'oAuthFailure'});
        }
        oAuthEvent.fire();
    },
    /**
     * Handles authorization in a general context. Adds OAuth connect app to user.
     */
    handleAuthorizeLoop: function(component, event) {
        const oAuthEvent = component.getEvent('actionEvent');
        let username;
        if (event && event.data && event.data.payload) {
            username = JSON.parse(event.data.payload).user;
        }
        if (username) {
            oAuthEvent.setParams({action: 'oAuthSuccess'});
        } else {
            oAuthEvent.setParams({action: 'oAuthFailure'});
        }
        oAuthEvent.fire();
    },
    /**
     * Fires an oAuthInitComplete actionEvent, with an isAuthorized boolean if the initialization process returned determined
     * that the requesting user is authorized.
     * @param component
     * @param response - The parsed server response, via requestInitParams
     */
    fireAuthInitCompleteEvent: function(component, response) {
        const initComplete = component.getEvent('actionEvent');
        // The OAuth response always includes whether or not the requesting user is registered as authorized - so we include it in the oAuthInitComplete event
        initComplete.setParams({
            action: 'oAuthInitComplete',
            params: JSON.stringify({isAuthorized: response.data.isAuthorized})
        });
        initComplete.fire();
    },
    /**
     * Fires an oAuthInitFailed actionEvent, with a error message string parameter.
     * @param component
     * @param message - The error string
     */
    fireAuthInitFailedEvent: function(component, message) {
        const initFailed = component.getEvent('actionEvent');
        initFailed.setParams({
            action: 'oAuthInitFailed',
            params: JSON.stringify({message: message})
        });
        initFailed.fire();
    },
    /**
     * Find the value of the environment prefix (loopUrl) query parameter and return it, if it exists.
     * Returns an empty string if parameter cannot be found.
     * @returns The value assigned to the 'loopUrl' query parameter
     */
    getDocGenEnvironmentPrefix: function() {
        if (window && window.location) {
            const queryStrings = window.location.search.split('&');
            for (let i = 0; i < queryStrings.length; i++) {
                const parts = queryStrings[i].split('=');
                if (decodeURIComponent(parts[0]) === 'loopUrl') {
                    return decodeURIComponent(parts[1]);
                }
            }
        }
        return '';
    },
    // endregion Business Logic
    ///////////////////////////
    // region View Logic
    /**
     * Set the component's initialization parameter values. The values set are oAuthUrl, hasCustomizeApplication, and
     * integrationUser
     * @param component
     * @param response - The parsed server response containing the information that we are setting - via requestInitParams
     */
    setInitParams: function(component, response) {
        if (response && response.isSuccess) {
            if (response.data.oAuthUrl) {
                component.set('v.oAuthUrl', response.data.oAuthUrl);
            }
            if (response.data.hasCustomizeAppPermission) {
                component.set('v.hasCustomizeAppPermission', response.data.hasCustomizeAppPermission);
            }
            if (response.data.integrationUser) {
                component.set('v.integrationUsername', response.data.integrationUser);
            }
        }
        component.set('v.isAuthProcessing', false);
    },
    /**
     * Hide or show OAuth flow button based on business logic surrounding the component state and view context
     * @param component
     */
    updateAuthButtonVisibility: function(component) {
        const viewContext = component.get('v.viewContext');
        const isAuthProcessing = component.get('v.isAuthProcessing');
        const integrationUsername = component.get('v.integrationUsername');
        // Button should NOT be shown while we are generating the OAuthUrl OR if there exists an integration user in the DESCRIPTIVE view context
        component.set('v.showAuthFlowButton', !(isAuthProcessing || (viewContext === 'DESCRIPTIVE' && integrationUsername)));
    },
    /**
     * Sets the view on auth initialization error
     * @param component
     */
    setViewErrorState: function(component) {
        component.set('v.isAuthProcessing', false);
        component.set('v.showAuthFlowButton', false);
    },
    /**
     * Displays a toast given a title, message, and toast type
     * @param title - The title shown on the toast
     * @param message - The message shown on the toast
     * @param type - The type of toast (error, warning, etc.)
     */
    showErrorToast: function(message) {
        const toast = $A.get('e.force:showToast');
        toast.setParams({
            title: $A.get('$Label.loop.Error_Label'),
            message: message,
            type: 'error'
        });

        toast.fire();
    }
    // endregion View Logic
    ///////////////////////////
})