const $ = require('jquery');
const bootstrap = require('bootstrap');
require('bootstrap/dist/css/bootstrap.css');
require('../css/main.css');

$(document).on('change', ':file', function() {
  const input = $(this),
  numFiles = input.get(0).files ? input.get(0).files.length : 1,
  label = input.val().replace(/\\/g, '/').replace(/.*\//, '');
  $('.file-name-text').val(label);

  const files = !!this.files ? this.files : [];
  if (!files.length || !window.FileReader) return;
  if (/^image/.test( files[0].type)){
    const reader = new FileReader();
    reader.readAsDataURL(files[0]);
    reader.onloadend = function() {
      const img = new Image();
      img.src = this.result;
      $('.imagePreview').show();
      $('.imagePreview').css("background-image", "url("+this.result+")");
    }
  }
});
