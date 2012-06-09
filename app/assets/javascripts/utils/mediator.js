define([], function(obj){

	var channels  = {};
	if (!obj) obj = {};

	obj.subscribe = function (channel, subscription, callback) {
		if (channels[channel] == null)
			channels[channel] = {};

		if (channels[channel][subscription] == null)
			channels[channel][subscription] = [];

		channels[channel][subscription].push(callback);
	};

	obj.publish = function (channel, subscription) {
		if (channels[channel] == null || channels[channel][subscription == null]) return;
		var args = [].slice.call(arguments, 2);
		for (var i = 0, l = channels[channel][subscription].length; i < l; i++)
			channels[channel][subscription][i].apply(this, args);
	};

	return obj;

});