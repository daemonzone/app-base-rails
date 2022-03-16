// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
//= require jquery
//= require rails-ujs
//= require activestorage
//= require_tree .

require("@rails/ujs").start()
require("@rails/activestorage").start()
require("channels")
require("trix")
require("@rails/actiontext")

window.jQuery 		= require("jquery")
window.SweetAlert 	= require("sweetalert2")
window.Dropzone 	= require("dropzone")
window.Sortable 	= require('sortablejs').Sortable;
window.Chart 		= require('chart.js');
window.Datepicker 	= require('bootstrap-datepicker');

global.$ = require("jquery")

import 'bootstrap/dist/js/bootstrap'
import "@fortawesome/fontawesome-free/js/all";
import "@fortawesome/fontawesome-free/css/all.css";
import 'dropzone/dist/basic.css';
import 'dropzone/dist/dropzone.css';
import 'bootstrap-datepicker/dist/css/bootstrap-datepicker';
import '../stylesheets/application'

$(document).ready(function() {
	$('[data-toggle="tooltip"]').tooltip()
	$('[data-widget="tooltip"]').tooltip()

    $('.datepicker').datepicker( {format: 'dd/mm/yyyy', autoclose: true} );

	$("input[required], select[required]").attr("oninvalid", "this.setCustomValidity('Campo obbligatorio')");
	$("input[required], select[required]").attr("oninput", "setCustomValidity('')");

	// Fill modal with content from link href (privacy policy)
	$("#privacy-policy-modal").on("show.bs.modal", function(e) {
		var reqid = e.relatedTarget.dataset['id'];
		var title = e.relatedTarget.dataset['title'];
	    var link = $(e.relatedTarget);
	    $(this).find(".modal-title").text(title);
	    $(this).find(".modal-body").load(link.attr("href"));
	});

	// Loader
	var loading = $('#loading_progress_bar').hide();
	$(document)
	  .ajaxStart(function () { loading.show(); })
	  .ajaxStop(function () { loading.hide(); });

});