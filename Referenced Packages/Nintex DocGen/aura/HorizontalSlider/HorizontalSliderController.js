({
	init : function(component, event, helper) {
        // Move each into its own side
        var body = component.get('v.body');
        var left = body[0];
        var right = body[1];
        component.set('v.body', left);
        component.set('v.rightSide', right);
        
        if (component.get('v.startOnRight')) {
	        helper.slide(component);
        }
	},
    slide : function(component, event, helper) {
        helper.slide(component);
    },
    slideBack : function(component) {
        var horizontalSlide = component.find('horizontalSlideContainer');
        if ($A.util.hasClass(horizontalSlide, 'slide')) {
            $A.util.removeClass(horizontalSlide, 'slide');
            
            var left = component.find('leftContainer');
            var right = component.find('rightContainer');
            $A.util.removeClass(left, 'collapse');
            $A.util.addClass(right, 'collapse');
        }
    }
})