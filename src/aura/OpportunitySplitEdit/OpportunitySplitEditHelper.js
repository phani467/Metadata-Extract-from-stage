({
    goBack : function(oppyId) {
        var navEvent = $A.get("e.force:navigateToSObject");
        navEvent.setParams({
            "recordId": oppyId,
            "isredirect" : true
        });
        navEvent.fire();
    },
    onPercentChange : function(lstSplit,event,component) {
        var index = event.getSource().get("v.name");
        var amount = component.get("v.oppySplitWrap.oppy.Amount");
        if(!amount) {
            amount=0;
        }
        lstSplit[index].SplitAmount = amount *(lstSplit[index].SplitPercentage/100);
        return lstSplit;
    },
    calculateTotal : function (lstSplit) {
        var totals = 0.00;
        for(var key in lstSplit) {
            totals =  parseFloat(totals) +  parseFloat(lstSplit[key].SplitPercentage);
        }
        console.log('--totals--',totals);
        return totals;
        
    },
    validateOverlay : function(component) {
        //check percent total
        var overlayTotal = component.get("v.overlayTotal");
        var isUserEmpty = false;
        var invalidMessage = '';
         var isDuplicate = false;
        var setSplitOwnerId = new Set();
        var lstOppySplitOverlay = component.get("v.lstOppySplitOverlay");
        for(var key in lstOppySplitOverlay ) {
            if(!lstOppySplitOverlay[key].SplitOwnerId) {
                isUserEmpty = true;
            }
            if(lstOppySplitOverlay[key].SplitOwnerId) {
                if(setSplitOwnerId.has(lstOppySplitOverlay[key].SplitOwnerId)) {
                    isDuplicate = true;
                }
                setSplitOwnerId.add(lstOppySplitOverlay[key].SplitOwnerId);
            }
        }
        if(overlayTotal>0 && overlayTotal!=100) {
            invalidMessage += "Overlay must total 100% for an Opportunity Split.<br/>";
        }
        if(isUserEmpty) {
            invalidMessage += "Please make sure all splits have user selected.<br/>";
        }
        if(isDuplicate) {
            invalidMessage += "Please make sure all splits have unique users.";
        }
        component.set("v.overlayInValidMessage",invalidMessage);
    },
    validateRevenue : function(component) {
        //check percent total
        var revenueTotal = component.get("v.revenueTotal");
        var isUserEmpty = false;
        var invalidMessage = '';
        var isDuplicate = false;
        var setSplitOwnerId = new Set();
        var lstOppySplitRevenue = component.get("v.lstOppySplitRevenue");
        for(var key in lstOppySplitRevenue ) {
            if(!lstOppySplitRevenue[key].SplitOwnerId) {
                isUserEmpty = true;
            }
            if(lstOppySplitRevenue[key].SplitOwnerId) {
                if(setSplitOwnerId.has(lstOppySplitRevenue[key].SplitOwnerId)) {
                    isDuplicate = true;
                }
                setSplitOwnerId.add(lstOppySplitRevenue[key].SplitOwnerId);
            }
        }
        if(revenueTotal>0 && revenueTotal!=100) {
            invalidMessage += "Revenue must total 100% for an Opportunity Split.<br/>";
        }
        if(isUserEmpty) {
            invalidMessage += "Please make sure all splits have user selected.<br/>";
        }
        if(isDuplicate) {
            invalidMessage += "Please make sure all splits have unique users.";
        }
        component.set("v.revenueInValidMessage",invalidMessage);
    },
    getParameterByName: function(component, event, name) {
        name = name.replace(/[\[\]]/g, "\\$&");
        var url = window.location.href;
        var regex = new RegExp("[?&]" + name + "(=([^&#]*)|&|#|$)");
        var results = regex.exec(url);
        if (!results) return null;
        if (!results[2]) return '';
        return decodeURIComponent(results[2].replace(/\+/g, " "));
    },
    renderOppySplitWrap: function(component) {
        //divide list to revenue and overlay
        var oppySplitWrap = component.get("v.oppySplitWrap");
        if(oppySplitWrap) {
            var lstOppySplit = oppySplitWrap.oppy.OpportunitySplits;
            var lstOppySplitRevenue =[];
            var lstOppySplitOverlay = [];
            var lstOppySplitOverlayDel = [];
            var revenueTotal = 0;
            var overlayTotal = 0;
            for(var key in lstOppySplit) {
                if(lstOppySplit[key].SplitType.DeveloperName==='Revenue') {                
                    lstOppySplitRevenue.push(lstOppySplit[key]);
                    revenueTotal+=lstOppySplit[key].SplitPercentage;
                }
                if(lstOppySplit[key].SplitType.DeveloperName==='Overlay') {
                    lstOppySplitOverlay.push(lstOppySplit[key]);
                    overlayTotal+=lstOppySplit[key].SplitPercentage;
                }
            }
            component.set("v.lstOppySplitRevenue",lstOppySplitRevenue);
            component.set("v.lstOppySplitOverlay",lstOppySplitOverlay);
            component.set("v.revenueTotal",revenueTotal);
            component.set("v.overlayTotal",overlayTotal);
            component.set("v.lstOppySplitOverlayDel",lstOppySplitOverlayDel);
        }
        
    }
})