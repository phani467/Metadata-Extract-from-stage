({
    openDropdown : function(component) {
        component.find("dropdownMenu").getElement().hidden = false;
    },
    closeDropdown : function(component) {
        component.find("dropdownMenu").getElement().hidden = true;
    },
    toggleDropdown : function(component) {
        var isHidden = component.find("dropdownMenu").getElement().hidden;
        var dropdownMenuElement = component.find("dropdownMenu").getElement();
        
        //Within the RunDdp context:
        //Can't pop out the dropdown menu due to `overflow-y: auto;` on AccordionSection.cmp. Instead, use `position:fixed;` and insta-snap the menu to where it's suppose to be.
        var buttonBoundingRect = component.find('dropdownButton').getElement().getBoundingClientRect();
        var width = buttonBoundingRect.width;
        var left = buttonBoundingRect.left;
        var top = buttonBoundingRect.top + buttonBoundingRect.height;
        
        if (isHidden) {
            //This won't work on the SF1 app. Mobile browsers read 'position:fixed' as 'position:absolute'.
            //We need to either figure out a solution without using 'position:fixed' or rework things inside AccordionSection.cmp.
            dropdownMenuElement.hidden = false;
            dropdownMenuElement.style.position = 'fixed';
            dropdownMenuElement.style.width = width + 'px';
            dropdownMenuElement.style.left = left + 'px';
            dropdownMenuElement.style.top = top + 'px';
        }
        else {
            dropdownMenuElement.hidden = true;
            dropdownMenuElement.style='';
        }
    },
	optionClicked : function(component, event, helper) {
        var selectedItem;
        var dropdownList = component.get("v.dropdownList");
        var showTitles = component.get('v.showTitles');
        
        for (var i = 0; i < dropdownList.length; i++) {
            if (event.currentTarget.id === dropdownList[i].Id) {
                selectedItem = dropdownList[i];
                break;
            }
        }
        
        component.find("selectedValue").getElement().innerText = event.target.textContent;
        
        component.find("dropdownMenu").getElement().hidden = true;
        
        component.getEvent("recipientSelected").setParams({
            id: selectedItem.Id
        }).fire();
	}
})