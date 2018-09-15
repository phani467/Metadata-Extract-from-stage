({
    init : function(component, event, helper) {
        var body = component.get('v.body');
        var header;
        var main;
        var footer;

        if (body[0]) {
            header = body[0];
        }
        if (body[1]) {
            main = body[1];
        }
        if (body[2]) {
            footer = body[2];
        }

        component.set('v.header', header);
        component.set('v.main', main);
        component.set('v.footer', footer);
    }
})