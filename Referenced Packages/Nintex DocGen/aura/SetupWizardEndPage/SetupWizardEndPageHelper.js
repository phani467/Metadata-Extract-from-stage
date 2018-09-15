({
	navigateToUrl : function(component, url) {
        if (component.get("v.isLightning")) {
            if (sforce !== undefined && sforce.one && sforce.one.navigateToURL) {
                sforce.one.navigateToURL(url);
            }  
        } else {
            window.location.href = url;
        }
	}
})