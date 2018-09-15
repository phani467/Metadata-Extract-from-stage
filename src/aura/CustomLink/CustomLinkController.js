({
    doInit : function(component,event,helper) {
        var pageSize = component.get("v.pageSize");
        helper.callToServer(
            component,
            "c.loadCustomLinks",
            function(response) {
                /*
                if(response.length < 1) {
                    document.getElementById("links").style.display = "none" ;
                    document.getElementById("nolinks").style.display = "block" ;
                }
                else {
                    document.getElementById("links").style.display = "block" ;
                    document.getElementById("nolinks").style.display = "none" ;
                }
                */
                component.set("v.customLinks",response);
                component.set("v.totalSize", component.get("v.customLinks").length);
                if(component.get("v.totalSize")>= pageSize) {
                    component.set("v.hideButtons",false);
                }
                component.set("v.start",0);
                component.set("v.end",pageSize-1);
                var paginationList = [];
                for(var i=0; i< pageSize; i++) {
                    paginationList.push(response[i]);    
                }
                console.log('v.paginationList' + paginationList);
                component.set('v.paginationList', paginationList);
                component.set('v.initComplete',true);
                var spinner = component.find("spinner");
                $A.util.addClass(spinner, 'slds-hide');
                $A.util.removeClass(spinner, 'slds-show');
            });             
    },
    next : function(component, event, helper) {
        var customLinks = component.get("v.customLinks");
        var end = component.get("v.end");
        var start = component.get("v.start");
        var pageSize = component.get("v.pageSize");
        var paginationList = [];
        var counter = 0;
        for(var i=end+1; i<end+pageSize+1; i++) {
            if(customLinks.length > end) {
                paginationList.push(customLinks[i]);
                counter ++ ;
            }
        }
        start = start + counter;
        end = end + counter;
        component.set("v.start",start);
        component.set("v.end",end);
        component.set('v.paginationList', paginationList);
    },
    previous : function(component, event, helper) {
        var customLinks = component.get("v.customLinks");
        var end = component.get("v.end");
        var start = component.get("v.start");
        var pageSize = component.get("v.pageSize");
        var paginationList = [];        
        var counter = 0;
        for(var i= start-pageSize; i < start ; i++) {
            if(i > -1) {
                paginationList.push(customLinks[i]);
                counter ++;
            }
            else {
                start++;
            }
        }
        start = start - counter;
        end = end - counter;
        component.set("v.start",start);
        component.set("v.end",end);
        component.set('v.paginationList', paginationList);
    }
})