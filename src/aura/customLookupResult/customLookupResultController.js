({
   selectRecord : function(component, event, helper){      
    // get the selected record from list  
      var getSelectRecord = component.get("v.oRecord");
    // call the event   
      var compEvent = component.getEvent("oSelectedRecordEvent");
    // set the Selected sObject Record to the event attribute.  
         compEvent.setParams({"recordByEvent" : getSelectRecord,
                              "recordId":getSelectRecord.Id,
                              "valueChanged":getSelectRecord.Id
                             });  
    // fire the event  
         compEvent.fire();
    },
})