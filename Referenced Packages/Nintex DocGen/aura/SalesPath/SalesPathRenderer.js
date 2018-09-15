({
    render : function(component, helper) {
        var ret = this.superRender();
		helper.updateStep(component);
        return ret;
    },
    rerender : function(component, helper) {
		helper.updateStep(component);
    }
})