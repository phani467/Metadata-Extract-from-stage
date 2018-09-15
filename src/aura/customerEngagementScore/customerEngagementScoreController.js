({
    doInit : function(component, event, helper) {
         helper.callToServer(
            component,
            "c.getContactScore",
            function(response) {
                component.set("v.survey", response);
                if(response !=null ) {
                	var a = component.get("c.setup");
        			$A.enqueueAction(a);
                }
                else {
                    component.set("v.isContactNull",true);
                }
            },
            {  "caseId": component.get("v.recordId") }
        ); 
         helper.callToServer(
            component,
            "c.getAccountScore",
            function(response) {
                
                if(response.avgscore !=null && response.avgscore>0) {
                    component.set("v.avgScore", response.avgscore);
			        component.set("v.accountId",response.accountId); 
                    component.set("v.accountName",response.accName);
                	var a = component.get("c.setupAccScore");
        			$A.enqueueAction(a);
                }
                else {
                   component.set("v.isAccountNull",true);
                } 
            },
            {  "caseId": component.get("v.recordId") }
        );
        helper.callToServer(
            component,
            "c.getLastIncidentTicket",
            function(response) {
                
                if(response !=null) {
                    component.set("v.incidentTicket", response);
                } else {
                    component.set("v.isINCNull",true);
                }
            },
            {  "caseId": component.get("v.recordId") }
        );  
    },
    setup : function(component, event, helper) {
        var canvas = component.find("myCanvas").getElement();
        var context = canvas.getContext('2d');
        var al = Math.round((100/7) * Number(component.get("v.survey.CESScore__c")));  // 7 point CES scale - convert value into a percentage to display
        if(al > 100) {
            al=100;
        }
        var start=4.72;
        var cw=context.canvas.width/2;
        var ch=context.canvas.height/2;
        var diff;
        
        function progressBar() {
            diff=(al/100)*Math.PI*2;
            context.clearRect(0,0,400,200);
            context.beginPath();
            context.arc(cw,ch,25,0,2*Math.PI,false);
            context.fillStyle='#FFF';
            context.fill();
            context.strokeStyle='#d8edff';
            context.stroke();
			if(al > 70.9) {
                context.strokeStyle='#4bca81';
                context.fillStyle='#4bca81';
            } else {
                    context.strokeStyle='#CD0000';
                	context.fillStyle='#CD0000';  
                   }
            context.textAlign='center';
            context.lineWidth=4;
            context.font = '10pt Salesforce Sans';
            context.beginPath();
            context.arc(cw,ch,25,start,diff+start,false);
            context.stroke();
            context.fillText(al+'%',cw+2,ch+6);
        }
        progressBar();
	},
    
    setupAccScore : function(component, event, helper) {
				var canvas = component.find("myCanvasA").getElement();
				var context = canvas.getContext('2d');
				var al = Math.round((100/7) * Number(component.get("v.avgScore")));  // 7 point CES scale - convert value into a percentage to display
				if(al > 100) {
            		al=100;
        		}
        		var start=4.72;
				var cw=context.canvas.width/2;
				var ch=context.canvas.height/2;
				var diff;
				
				function progressBar() {
					diff=(al/100)*Math.PI*2;
					context.clearRect(0,0,400,200);
					context.beginPath();
					context.arc(cw,ch,25,0,2*Math.PI,false);
					context.fillStyle='#FFF';
					context.fill();
					context.strokeStyle='#d8edff';
					context.stroke();
					if(al > 70.9) {
                		context.strokeStyle='#4bca81';
                		context.fillStyle='#4bca81';
            		} else {
                        	context.strokeStyle='#CD0000';
                			context.fillStyle='#CD0000';  
                        }
                    
					context.textAlign='center';
					context.lineWidth=4;
					context.font = '10pt Salesforce Sans';
					context.beginPath();
					context.arc(cw,ch,25,start,diff+start,false);
					context.stroke();
					context.fillText(al+'%',cw+2,ch+6);
				}
				progressBar();
	}
})