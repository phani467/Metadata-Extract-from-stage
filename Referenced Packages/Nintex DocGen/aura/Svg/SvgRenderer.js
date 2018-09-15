({
    render: function(component) {
        const classname = component.get('v.class');
        const xlinkhref = component.get('v.xlinkHref');
        const mouseOver = component.get('v.mouseOver');
        const mouseOut = component.get('v.mouseOut');
        const onclick = component.get('v.onclick');
        const id = component.get('v.id');
        const display = component.get('v.display');
        const style = component.get('v.style');

        const svg = document.createElementNS('http://www.w3.org/2000/svg', 'svg');
        svg.setAttribute('class', classname);
        svg.setAttribute('display', display ? 'inline' : 'none');

        if (xlinkhref) {
            svg.innerHTML = '<use xlink:href="' + xlinkhref + '"></use>';
        } else {
            return;
        }
        if (mouseOver) {
            svg.setAttribute('onmouseover', mouseOver);
        }
        if (mouseOut) {
            svg.setAttribute('onmouseout', mouseOut);
        }
        if (onclick) {
            svg.setAttribute('onclick', onclick);
        }
        if (id) {
            svg.setAttribute('id', id);
        }
        if (style) {
            svg.setAttribute('style', style);
        }
        return svg;
    }
})