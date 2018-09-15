({
    onInit : function(component, event, helper) {
        var getOAuthStartParams = component.get('c.getOAuthStartParams');
        getOAuthStartParams.setParams({
            subdomain: helper.getLoopUrl(),
            origin: window.location.origin,
            sitePath: $A.get('$SfdcSite.pathPrefix') //$SfdcSite.pathPrefix is not documented, but is used by $Resource to construct the right path for static resources.
        });
        getOAuthStartParams.setCallback(this, function(response) {
            if (response.getState() === 'SUCCESS') {
                var parsedResponse = JSON.parse(response.getReturnValue());
                if (parsedResponse.isSuccess) {
                    component.set('v.oAuthUrl', parsedResponse.oAuthUrl);
                }
                else {
                    var errorEvent = component.getEvent('actionEvent');
                    errorEvent.setParams({
                        action: 'oAuthError',
                        params: parsedResponse.errorMessage
                    });
                    errorEvent.fire();
                }
            }
            else {
                var errors = response.getError();
                var message = 'Error: Unknown Error';
                if (errors && errors[0] && errors[0].message) {
                    message = 'Error: ' + errors[0].message;
                }

                var errorEvent = component.getEvent('actionEvent');
                errorEvent.setParams({
                    action: 'oAuthError',
                    params: message
                });
                errorEvent.fire();
            }

            var actionEvent = component.getEvent('actionEvent');
            actionEvent.setParams({
                action: 'oAuthDoneLoading'
            });
            actionEvent.fire();
        });

        $A.enqueueAction(getOAuthStartParams);
    },
	startOAuthFlow : function(component, event, helper) {
	    if (component.get('v.isParentRunDdp')) {
            window.Drawloop.eventListener.addEventListener('authorizeLoop', function(event) {
                var username = JSON.parse(event.data.payload).user;
                var runDdpOAuthStatus = component.getEvent('actionEvent');
                if (!username) {
                    runDdpOAuthStatus.setParams({
                        action: 'runDdpOAuthDenied'
                    }).fire();
                } else {
                    runDdpOAuthStatus.setParams({
                        action: 'runDdpOAuthDone'
                    }).fire();
                }
            });
        }
        else {
            // Add authorizeLoopServices event to the window for the LandingPage to call after OAuth.
            window.Drawloop.eventListener.addEventListener('authorizeLoop', function(event) {
                var oAuthStartLoading = component.getEvent('actionEvent');
                oAuthStartLoading.setParams({
                    action: 'oAuthStartLoading'
                });
                oAuthStartLoading.fire();

                var oAuthDoneLoading = component.getEvent('actionEvent');
                oAuthDoneLoading.setParams({
                    action: 'oAuthDoneLoading'
                });

                var username = JSON.parse(event.data.payload).user;
                if (!username) {
                    var oAuthStatusUpdate = component.getEvent('actionEvent');
                    oAuthStatusUpdate.setParams({
                        action: 'oAuthStatusUpdate',
                        params: JSON.stringify({
                            'isAuthorized': false,
                            'authorizingUser': ''
                        })
                    });
                    oAuthStatusUpdate.fire();

                    oAuthDoneLoading.fire();
                } else {
                    //This apex action should add the integration user to the our database, update the integration user custom settings, and return the integration username.
                    var action = component.get("c.authorizeReports");
                    action.setParams({
                        domain: helper.getLoopUrl()
                    });
                    action.setCallback(this, function(response) {
                        if (response.getState() === "SUCCESS") {
                            var parsedResponse = JSON.parse(response.getReturnValue());
                            if (parsedResponse.isSuccess) {
                                var oAuthStatusUpdate = component.getEvent('actionEvent');
                                oAuthStatusUpdate.setParams({
                                    action: 'oAuthStatusUpdate',
                                    params: JSON.stringify({
                                        'isAuthorized': true,
                                        'authorizingUser': username
                                    })
                                });
                                oAuthStatusUpdate.fire();
                            }
                            else {
                                var errorEvent = component.getEvent('actionEvent');
                                errorEvent.setParams({
                                    action: 'oAuthError',
                                    params: parsedResponse.ErrorMessage
                                });
                                errorEvent.fire();
                            }
                        }

                        oAuthDoneLoading.fire();
                    });
                    $A.enqueueAction(action);
                }
            });
        }

        var unblockedWindow = window.open(component.get('v.oAuthUrl'), 'Salesforce Auth', 'height=811,width=680,location=0,status=0,titlebar=0');
	}
})