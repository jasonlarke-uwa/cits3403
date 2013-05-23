function obtain_geo(lo, la, a) {
	if (navigator.geolocation) {
		navigator.geolocation.getCurrentPosition(function(pos) {
			var c = pos.coords;
			lo.value = c.longitude;
			la.value = c.latitude;
			a.value = c.accuracy;
		})
	}
}

$(document).ready(function() {
	$('#upload_use_geo').click(function() {
		var longitude = document.getElementById('geo_longitude') || {};
		var latitude = document.getElementById('geo_latitude') || {};
		var accuracy = document.getElementById('geo_accuracy') || {};
		
		if (this.value == 'Y' && (!longitude.value || longitude.value === '')) {
			obtain_geo(longitude, latitude, accuracy);
		}
	})
});