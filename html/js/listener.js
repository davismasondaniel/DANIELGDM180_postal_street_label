window.addEventListener('message', (event) => {
	const item = event.data;

	if (item.type === 'update') {
		const $hud = $('.DANIELGDM180_postal_street_label');

		if (!item.active) {
			$hud.hide();
			return;
		}

		$hud.css('display', 'flex');
		$hud.css('left', item.posX + '%');
		$hud.css('bottom', item.posY + '%');

		$('span.direction').text(item.direction);

		$('span.street').text(item.street);
		$('span.street').css('color', item.color);
		$('span.zone').text(item.zone);

		$('span.postal-code').text(item.postal);
	}

	if (item.action === 'hideUI') {
		document.body.style.display = 'none';
	}

	if (item.action === 'showUI') {
		document.body.style.display = 'block';
	}
});
