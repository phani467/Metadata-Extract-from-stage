({
    onLoad : function(cmp) {
        var action = cmp.get("c.currentPauseToEditSetting");
        action.setCallback(this, function(response) {
            var retVal = response.getReturnValue();
            if (!retVal || retVal === "Upload"){
                cmp.find("r1").set("v.value", true);
                cmp.set("v.selection", "Upload");
            } else {
                cmp.find("r2").set("v.value", true);
                cmp.set("v.selection", retVal);
            }
        });
        $A.enqueueAction(action);
    },
    changeSelection : function(cmp, event) {
        var selected = event.getSource().get("v.text");
        cmp.set("v.selection", selected);
    },
    save : function(cmp) {
        var selected = cmp.get("v.selection");
        var action = cmp.get("c.updatePauseToEditSetting");
        action.setParams({ "selection" : selected });
        $A.enqueueAction(action);
    }
})