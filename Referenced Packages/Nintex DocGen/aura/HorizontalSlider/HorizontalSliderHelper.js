({
	slide : function(component) {
        var horizontalSlide = component.find('horizontalSlideContainer');
        if (!$A.util.hasClass(horizontalSlide, 'slide')) {
            $A.util.addClass(horizontalSlide, 'slide');
            
            var left = component.find('leftContainer');
            var right = component.find('rightContainer');
            $A.util.addClass(left, 'collapse');
            $A.util.removeClass(right, 'collapse');
        }
    }
})