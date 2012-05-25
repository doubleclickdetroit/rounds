define([], function(require) {

	/*
	 * Cookie Get/Set Mutator
	 *
	 * @access : private
	 * @param  : string
	 * @param  : string
	 * @param  : object
	 * @return : string
	*/
	return function(key, value, options) {
		if (arguments.length > 1 && (value || value === null)) {
			options = $.extend({}, options);

			if (value === null) options.expires = -1;
			else if (typeof value === 'object') {
				value = core.stringJSON(value);
			}

			if (typeof options.expires === 'number') {
				var days = options.expires, t = options.expires = new Date();
				t.setDate(t.getDate() + days);
			}

			return (document.cookie = [
				encodeURIComponent(key), '=',
				options.raw ? String(value) : encodeURIComponent(String(value)),

				// using "expires" attribute as "max-age" is not supported by IE
				options.expires ? '; expires=' + options.expires.toUTCString() : '',

				options.path ? '; path=' + options.path : '',
				options.domain ? '; domain=' + options.domain : '',
				options.secure ? '; secure' : ''
			].join(''));
		}

		// key and possibly options given, get cookie...
		options = value || {};
		var result, decode = options.raw ? function (s) { return s; } : decodeURIComponent;
		return (result = new RegExp('(?:^|; )' + encodeURIComponent(key) + '=([^;]*)').exec(document.cookie)) ? decode(result[1]) : null;
	};

});