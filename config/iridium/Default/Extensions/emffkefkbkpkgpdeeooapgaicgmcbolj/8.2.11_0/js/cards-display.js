
var escapeHtml = function(s) {
	return s.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(
		/"/g, '&quot;').replace(/'/g, '&#x27;');
};
var getHoverCardFromTitle = function(title, lang) {
	var url = 'https://www.wikiwand.com/hover-card/proxy/' + lang;
	return $.ajax({
		dataType: 'json',
		type: 'GET',
		url: url,
		data: {
			action: 'query',
			format: 'json',
			prop: 'extracts|pageimages|revisions|info|categories|links',
			pllimit: 50,
			redirects: true,
			exintro: false,
			exsentences: 2,
			explaintext: true,
			piprop: 'thumbnail',
			pithumbsize: 320,
			rvprop: 'timestamp',
			inprop: 'watched',
			indexpageids: true,
			titles: title
		},
		success: function(response) {
			var href, html;
			html = '<div class="ocd-content"></div>';
			if (!response.error) {
				var id = response.query.pageids[0];
				var page = response.query.pages[id];
				var disambig;
				page.categories.forEach(function(category) {
					if (category.title.indexOf('disambig') > -1) {
						disambig = true;
					}
				});
				href = 'https://www.wikiwand.com/' + lang + '/' + page.title.split(' ').join('_');
				html = '';
				html += '<div class="ocd-content">';
				if (page.title != null) {
					html += "<div class='ww_title'><a href='" + href +
						"' target='_blank'>" + (escapeHtml(page.title)) + "</a></div>";
				}
				if (page.thumbnail != null) {
					html += "<div class='ww_image'><img src='" +
						(escapeHtml(page.thumbnail.source)) +
						"' onerror='this.style.display=\"none\"' /></div>";
				}
				if (page.extract != null && !disambig) {
					var MAX_LENGTH = 400;
					if (page.extract.length > MAX_LENGTH) {
						page.extract = page.extract.slice(0, MAX_LENGTH-3) + '...';
					}
					html += "<div class='ww_text'>" + (escapeHtml(page.extract)) + "</div>";
				}
				if (disambig) {
					var disambigHtml = page.title + ' has multiple meanings, it may refer to:<br><br>';
					var count = 0;
					page.links.forEach(function(link, index) {
						if (count < 12 && link.title.toLowerCase().indexOf(page.title.toLowerCase()) > -1) {
							count++;
							disambigHtml += '<a class="ww_disambig_option" target="_blank" href="https://www.wikiwand.com/' + lang +
								'/' + link.title.split(' ').join('_') + '">' + link.title + '</a>';
						}
					});


					html += "<div class='ww_disambig'>" + disambigHtml + "</div>";
				}
				if (!disambig) {
					html += "<div class='ww_readmore'><a href='" + href +
						"' target='_blank'></a></div>";
				}else{
					if(page.links.length > 12){
						html += "<div class='ww_readmore_dis'><a href='" + href +
							"' target='_blank'>...</a></div>";
					}
				}

				html += '<div class="ww_button ww_settings_button"></div>';
				html += '<div class="ww_button ww_x_button"></div>';
				html += '<div class="ww_button ww_feedback_button"></div>';

				html += '</div>';
				html += '</a>';

				$('.tooltipster-base').remove();///remove tooltipster if exists
				$('#ww_hovercard').remove();
				var $newdiv1 = $("<div id='ww_hovercard'/>");
				$("body").append($newdiv1);
				$('#ww_hovercard').html(html);

				$('.ww_settings_button').on('click', function(event) {
					chrome.runtime.sendMessage({command: "openOptionsPage"});
					chrome.extension.sendMessage({command: 'analytics',category:'hovercard',action:'settings',label:'open'});
				});
				$('.ww_readmore').on('click', function(event) {
					chrome.extension.sendMessage({command: 'analytics',category:'hovercard',action:'follow',label:window.location.hostname});
				});
				$('.ww_readmore_dis').on('click', function(event) {
					chrome.extension.sendMessage({command: 'analytics',category:'hovercard',action:'follow',label:window.location.hostname});
				});
				$('.ww_feedback_button').on('click', function(event) {
					window.open("https://mail.google.com/mail/?view=cm&fs=1&tf=1&to=popup@wikiwand.com&su=Wikiwand+quick-definition+popup+feedback");
				});


				var topOffset = 50;
				var leftOffset = -250;
				var classY = 'vert_bottom';
				var classX = 'hoz_center';
				if (lastY >= (window.innerHeight / 2)) {
					topOffset = -300;
					classY = 'vert_top';
				}

				if (lastX <= (window.innerWidth / 4)) {
					leftOffset = 50;
					classX = 'hoz_right';
				}
				if (lastX >= (window.innerWidth * 4 / 5)) {
					leftOffset = -400;
					classX = 'hoz_leftt';
				}

				$('#ww_hovercard').css({
					left: lastX + leftOffset,
					top: lastY + topOffset
				});
				$('#ww_hovercard').addClass(classX).addClass(classY);
				$('#ww_progress').hide();
				$('#ww_nomatches').remove();
				window.onscroll =  function(event) {
					$('#ww_hovercard').remove();
					$('#ww_progress').remove();
				};

			}
		},
		error: function(jqXHR, textStatus, errorThrow) {
			//analytics.gaEvent('hovercard', 'hovercard-api-response-error', textStatus);
			// return hideAll();
		}
	});
};
