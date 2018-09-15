({
    startTimeout : function(component, event, helper) {
        component.set('v.timedOut', false);
        
        setTimeout($A.getCallback(function() {
            component.set('v.timedOut', true);
        }), 7 * 60 * 1000); // 7 minutes
    },
    downloadFile : function(component, event, helper) {
        var downloadCard = event.currentTarget;
        var downloadLink = downloadCard.id;
        var sitePathPrefix = $A.get('$SfdcSite.pathPrefix') || '';
        var url = sitePathPrefix + '/apex/loop__downloadLightningFile?url=' + encodeURIComponent(downloadLink);

        //If the user is running in Safari on an iOS device, use window.open. Otherwise, use window.parent.location
        if (
            ($A.get('$Browser.isIOS') || $A.get('$Browser.isIPad') || $A.get('$Browser.isIPhone')) // using iOS/iPad/iPhone
            && /(Safari)/g.test(navigator.userAgent) && !/(Chrome)/g.test(navigator.userAgent) // using Safari browser
        ) {
            window.open(url);
        } else {
            window.parent.location = downloadLink
                + '&sessionId=' + encodeURIComponent(component.get('v.sessionId'))
                + '&location=' + encodeURIComponent(component.get('v.partnerServerUrl'))
                + '&userId=' + component.get('v.userId')
                + '&sandbox=' + component.get('v.isSandbox');
        }

        $A.util.removeClass(downloadCard, 'hideSpinner');
        $A.util.addClass(downloadCard, 'hideIcon');

        setTimeout($A.getCallback(function(){
            $A.util.addClass(downloadCard, 'hideSpinner');
            $A.util.removeClass(downloadCard, 'hideIcon');
        }, 3000));
    },
    composeEmail : function(component, event, helper) {
        var composeEmail = component.getEvent('slideInEmailComposer');
        composeEmail.setParams({
            returnUri: component.get('v.returnUri')
        });
        composeEmail.fire();
    },
    showLoading : function(component, event) {
        $A.util.addClass(component.find('continueButtonContainer'), 'hidden');
        component.set('v.downloadLinks', []);
        component.set('v.isLoading', true);

        var continueDelivery = component.getEvent('continueDelivery');
        continueDelivery.setParams({disableModify: true});
        continueDelivery.fire();
    },
    showSuccess : function(component, event) {
        component.set('v.successMessage', event.getParam('arguments').message);
        
        component.set("v.isLoading", false);
        component.set('v.isSuccess', true);

        var continueDelivery = component.getEvent('continueDelivery');
        continueDelivery.setParams({disableModify: false});
        continueDelivery.fire();
    }
})