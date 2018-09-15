({

navigate : function(component, event, helper) {

	    //Find the text value of the component with aura:id set to "address"
	    var address = component.get("v.btnURL");
			if (address.toLowerCase().indexOf("http:") == 0 || address.toLowerCase().indexOf("https:") == 0) {
					var urlEvent = $A.get("e.force:navigateToURL");
					urlEvent.setParams({
						"url": encodeURI(address),
						"isredirect" :false
					});
					urlEvent.fire();
			}else{
				alert('Protocol not allowed .Your Configured URL should begin with HTTP or HTTPS');
			}
	}

})