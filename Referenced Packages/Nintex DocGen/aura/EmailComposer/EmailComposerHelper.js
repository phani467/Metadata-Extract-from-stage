({
	getFileIdParam : function(url) {
        var a = document.createElement('a');
        a.href = url;
        var query = a.search.substring(1);
        var vars = query.split('&');
        
        for (var i = 0; i < vars.length; i++) {
            var pair = vars[i].split('=');
            if (pair[0] === 'fileId') {
                return pair[1];
            }
        }
		return '';
	},
    parseQueryString : function(url) {
        var params = {};
        if (url.indexOf('?') > -1) {
            var queryString = url.substring(url.indexOf('?') + 1);
            var queries = queryString.split('&');
            for (var i = 0; i < queries.length; i++) {
                var parts = queries[i].split('=');
                params[parts[0]] = decodeURIComponent(parts[1]);
            }
        }
        return params;
    }
})