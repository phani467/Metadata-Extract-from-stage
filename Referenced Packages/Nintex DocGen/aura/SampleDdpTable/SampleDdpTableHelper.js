({
    performFilter : function(component, searchText, searchIndustry) {
        var sanitizedSearchText = this.escapeRegExp(searchText);
        var sampleDdpParentRows = component.get("v.sampleDdpParentRows");
        
        if (sanitizedSearchText) {
        	var filteredRowCount = 0;
            
            if (searchIndustry) {
                for (var i = 0; i < sampleDdpParentRows.length; i++) {
                    if (sampleDdpParentRows[i].industryName === searchIndustry) {
                        sampleDdpParentRows[i].isHidden = true;
                        sampleDdpParentRows[i].isChildRowsHidden = true;
                        for (var j = 0; j < sampleDdpParentRows[i].childRows.length; j++) {
                            var childRow = sampleDdpParentRows[i].childRows[j];
                            var addToFilteredList = childRow.documentPackage.includes(sanitizedSearchText)
                                || childRow.businessUsers.includes(sanitizedSearchText)
                                || childRow.recordType.includes(sanitizedSearchText)
                                || childRow.documentTypes.includes(sanitizedSearchText);
                            
                            if (addToFilteredList) {
                                sampleDdpParentRows[i].isHidden = false;
                                sampleDdpParentRows[i].isChildRowsHidden = false;
                                sampleDdpParentRows[i].childRows[j].isHidden = false;
                                filteredRowCount++;
                            }
                            else {
                                sampleDdpParentRows[i].childRows[j].isHidden = true;
                            }
                        }
                    }
                    else {
                        sampleDdpParentRows[i].isHidden = true;
                        sampleDdpParentRows[i].isChildRowsHidden = true;
                        for (var j = 0; j < sampleDdpParentRows[i].childRows.length; j++) {
                            sampleDdpParentRows[i].childRows[j].isHidden = true;
                        }
                    }
                }
            }
            else {
                for (var i = 0; i < sampleDdpParentRows.length; i++) {
                    sampleDdpParentRows[i].isHidden = true;
                    sampleDdpParentRows[i].isChildRowsHidden = true;
                    for (var j = 0; j < sampleDdpParentRows[i].childRows.length; j++) {
                        var childRow = sampleDdpParentRows[i].childRows[j];
                        var addToFilteredList = childRow.documentPackage.includes(sanitizedSearchText)
                            || childRow.businessUsers.includes(sanitizedSearchText)
                            || childRow.recordType.includes(sanitizedSearchText)
                            || childRow.documentTypes.includes(sanitizedSearchText);
                        
                        if (addToFilteredList) {
                            sampleDdpParentRows[i].isHidden = false;
                            sampleDdpParentRows[i].isChildRowsHidden = false;
                            sampleDdpParentRows[i].childRows[j].isHidden = false;
                            filteredRowCount++;
                        }
                        else {
                            sampleDdpParentRows[i].childRows[j].isHidden = true;
                        }
                    }
                }
            }
            
            component.set('v.noRows', filteredRowCount == 0);
        }
        else {
            for (var i = 0; i < sampleDdpParentRows.length; i++) {
                sampleDdpParentRows[i].isHidden = false;
                sampleDdpParentRows[i].isChildRowsHidden = true;
                for (var j = 0; j < sampleDdpParentRows[i].childRows.length; j++) {
                    sampleDdpParentRows[i].childRows[j].isHidden = true;
                }
            }
            
            component.set('v.noRows', false);
        }
        
        component.set('v.sampleDdpParentRows', sampleDdpParentRows);
    },
    escapeRegExp : function(str) {
    	return str.replace(/[\-\[\]\/\{\}\(\)\*\+\?\.\\\^\$\|]/g, "\\$&");
	},
    fireErrorEvent : function(component, message) {
        component.getEvent('showError').setParams({
            message: message
        }).fire();
    }
})