({
    displayBadges : function(component) {
        var badge = component.find('badge');
        var requiredBadge = component.find('requiredBadge');
        var expanded = component.get('v.expanded');
        var text = component.get('v.badgeText');
        if (!expanded) {
            if (text) {
                //selection made
                $A.util.removeClass(badge, 'hidden');
                $A.util.addClass(requiredBadge, 'hidden');
            } else if (!text && component.get('v.required')) {
                //selection not made, but required
                $A.util.addClass(badge, 'hidden');
                $A.util.removeClass(requiredBadge, 'hidden');
            } else {
                //selection not made, not required
                $A.util.addClass(badge, 'hidden');
                $A.util.addClass(requiredBadge, 'hidden');
            }    
        } else {
            //hide when expanded
            $A.util.addClass(badge, 'hidden');
            $A.util.addClass(requiredBadge, 'hidden');
        }
    },
    searchAll : function(component, event) {
        //For the RecordSelection.cmp, search all records instead of just filtering the list of tiles.
        var searchString = component.get('v.searchString');
        var selectComponent = component.get('v.body')[0];
        selectComponent.searchAll(searchString);
        event.stopPropagation();
    }
})