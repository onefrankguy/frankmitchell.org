;(function (Elimossinary) {
'use strict';

function loadManifest (success) {
  var r = new XMLHttpRequest();
  r.open("GET", "/js/manifest.json", true);
  r.onreadystatechange = function () {
    if (r.readyState != 4 || r.status != 200) return;
    success && success(JSON.parse(r.responseText));
  };
  r.send(null);
}

function buildRelated (url, manifest) {
  var i = 0
    , related = []
    ;
  for (i = 0; i < manifest.length; i += 1) {
    if (manifest[i].url != url) {
      console.log(manifest[i].url);
    }
  }
}

Elimossinary.relate = function (url) {
  loadManifest(function (manifest) {
    buildRelated(url, manifest);
  });
}

})(window.Elimossinary = window.Elimossinary || {})
