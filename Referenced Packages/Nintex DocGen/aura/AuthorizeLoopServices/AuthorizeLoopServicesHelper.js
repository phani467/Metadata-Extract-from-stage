({
    getLoopUrl : function() {
        var loopUrl = '';

        if (window && window.location) {
            var params = window.location.search.substring(1).split('&');
            for (var i = 0; i < params.length; i++) {
                var parts = params[i].split('=');
                if (decodeURIComponent(parts[0]) === 'loopUrl') {
                    loopUrl = decodeURIComponent(parts[1]);
                    break;
                }
            }
        }

        return loopUrl;
    }
})