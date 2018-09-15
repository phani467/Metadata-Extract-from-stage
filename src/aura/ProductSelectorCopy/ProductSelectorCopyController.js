({
	onProceed : function(cmp, event, helper) {
		var selectedProdIds = event.getParam("savedProducts");
        cmp.set("v.selectedProductIds",selectedProdIds);
	}
})