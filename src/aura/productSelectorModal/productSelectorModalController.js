({
    doInit : function(cmp, event, helper) {
        
        var environmentType = cmp.get("v.environmentType");
        console.log("environmentType"+environmentType);
        var oppyId = cmp.get("v.oppyId");
        if(environmentType==="Community" && !oppyId) {
            oppyId = helper.getParameterByName(cmp , event, 'recordId');
            cmp.set("v.oppyId", oppyId);
        }
        cmp.set("v.isBack",true);
    },
    onProceed : function(cmp, event, helper) {
        console.log("modalProceed Entered")
        var selectedProdIds = event.getParam("savedProducts");
        cmp.set("v.selectedProductIds",selectedProdIds);
        var legalEntity = event.getParam("legalEntity");
        var legalEntityName = event.getParam("legalEntityName");
        var oppyId = cmp.get("v.oppyId");
        cmp.set("v.legalEntity",legalEntity);
        cmp.set("v.legalEntityName",legalEntityName);
        cmp.set("v.isBack",false);
    },
    onBack : function(cmp, event, helper) {
        var isBack = event.getParam("isBackPressed");
        cmp.set("v.isBack",true);
    }
})