({
	toggle : function(component, event, helper) {
        var element = component.find('section-node');
        var icon = component.find('section-icon');
        var lookup = component.find('searchContainer');
        var section = component.find('section');
        var label = component.find('label');

        component.set('v.expanded', !component.get('v.expanded'));
        $A.util.addClass(component.find('sectionHeader'), 'collapse');
        $A.util.addClass(component.find('searchContainer'), 'collapse');
        $A.util.toggleClass(element, 'accordion-content-expand');
        $A.util.toggleClass(icon, 'icon-on');
        $A.util.toggleClass(label, 'font');
        $A.util.toggleClass(lookup, 'search-hidden');
        $A.util.toggleClass(section, 'slds-is-selected tree-item-bottom-border');

        helper.displayBadges(component);
        var collapseOthers = component.getEvent('collapseOtherAccordionSections');
        collapseOthers.setParams({selectedAccordionSection: component.get('v.sectionName')});
        collapseOthers.fire();
    },
    collapse : function(component, event, helper) {
        $A.util.addClass(component.find('sectionHeader'), 'collapse');
        $A.util.addClass(component.find('searchContainer'), 'collapse');
        var element = component.find("section-node");
        var icon = component.find("section-icon");
        var lookup = component.find("searchContainer");
        var section = component.find('section');
        var label = component.find('label');
        
        component.set('v.expanded', false);
        if ($A.util.hasClass(element, "accordion-content-expand")) {
	        $A.util.removeClass(element, "accordion-content-expand");
        }
        if ($A.util.hasClass(icon, "icon-on")) {
	        $A.util.removeClass(icon, "icon-on");
        }
        if ($A.util.hasClass(label, "font")) {
	        $A.util.removeClass(label, "font");
        }
        if (!$A.util.hasClass(lookup, "search-hidden")) {
	        $A.util.addClass(lookup, "search-hidden");
        }
        if ($A.util.hasClass(section, "slds-is-selected")) {
	        $A.util.removeClass(section, "slds-is-selected");
        }
        if ($A.util.hasClass(section, "tree-item-bottom-border")) {
            $A.util.removeClass(section, "tree-item-bottom-border");
        }
        
        helper.displayBadges(component);
    },
    stopPropagation : function(component, event) {
        event.stopPropagation();
    },
    search : function(component, event) {
        var searchString = event.target.value;
        if (component.get('v.label') === 'Record') {
            component.set('v.searchString', searchString);
        } else {
            var selectComponent = component.get('v.body')[0];
            if (!selectComponent.search) {
                //For all other AccordionSection.cmp, the first body value is an instance of SelectTiles.cmp.
                //But for the Document AccordionSection, its body value is an instance of HorizontalSlider. The first body element of HorizontalSlider is SelectTiles.cmp. Check RunDdp.cmp to see this structure.
                selectComponent = selectComponent.get('v.body')[0];
            }
            //selectComponent should be an instance of SelectTiles.cmp.
            selectComponent.search(searchString);
            component.set('v.searchString', searchString);
        }
    },
    searchAll : function(component, event, helper) {
        helper.searchAll(component, event);
    },
    clearInput : function(component, event, helper) {
        component.set('v.searchString', '');
        component.find('searchBar').getElement().value = '';
        var selectComponent = component.get('v.body')[0];
        if (!selectComponent.search) {
            //For all other AccordionSection.cmp, the first body value is an instance of SelectTiles.cmp.
            //But for the Document AccordionSection, its body value is an instance of HorizontalSlider. The first body element of HorizontalSlider is SelectTiles.cmp. Check RunDdp.cmp to see this structure.
            selectComponent = selectComponent.get('v.body')[0];
        }
        if (component.get('v.label') === 'Record') {
            helper.searchAll(component, event);
        } else {
            selectComponent.search('');
        }
        event.stopPropagation();
    },
    handleKeyPress : function(component, event, helper) {
        if (component.get('v.label') === 'Record' && (event.key === 'Enter' || event.key === 'Escape')) {
            if (event.key === 'Escape') {
                component.set('v.searchString', '');
                component.find('searchBar').getElement().value = '';
            }
            helper.searchAll(component, event);
        }
    },
    setBadge : function(component, event, helper) {
        var text = event.getParams().arguments.text;
        component.set('v.badgeText', text);
    },
    toggleAccordionDisabled : function(component, event, helper) {
        var disable = event.getParams().arguments.disable;
        var section = component.find("section");
        
        if (disable) {
            $A.util.addClass(section, 'section-disabled');
        } else {
            $A.util.removeClass(section, 'section-disabled');
        }   
    },
    hideScrollBar : function(component) {
        $A.util.addClass(component.find("section-node"), "overflow-y-hidden");
    },
    showScrollBar : function(component) {
        $A.util.removeClass(component.find("section-node"), "overflow-y-hidden");
    },
    toggleSearch : function(component, event) {
        $A.util.toggleClass(component.find('searchContainer'), 'collapse');
        $A.util.toggleClass(component.find('sectionHeader'), 'collapse');
        event.stopPropagation();
    }
})