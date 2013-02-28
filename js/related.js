;(function (Elimossinary) {
'use strict';

function intersect(a, b) {
  var ai = 0
    , bi = 0
    , result = new Array()

  while (ai < a.length && bi < b.length) {
    if (a[ai] < b[bi]) {
      ai += 1
    } else if (a[ai] > b[bi]) {
      bi += 1
    } else {
      result.push(a[ai])
      ai += 1
      bi += 1
    }
  }

  return result
}

function shuffle (array) {
  var i = 0
    , j = 0
    , temp

  for (i = array.length - 1; i > 0; i -= 1) {
    j = Math.floor(Math.random() * (i + 1))
    temp = array[i]
    array[i] = array[j]
    array[j] = temp
  }
}

function loadManifest (success) {
  var r = new XMLHttpRequest();
  r.open("GET", "/js/related.json", true);
  r.onreadystatechange = function () {
    if (r.readyState != 4 || r.status != 200) return;
    success && success(JSON.parse(r.responseText));
  };
  r.send(null);
}

function buildRelated (url, manifest) {
  var i = 0
    , related = []
    , tags = []
    , temp = []
    , html = ''

  for (i = 0; i < manifest.length; i += 1) {
    if (manifest[i].url === url) {
      tags = manifest[i].tags.slice(0)
      break
    }
  }
  for (i = 0; i < manifest.length; i += 1) {
    if (manifest[i].url != url) {
      temp = intersect(manifest[i].tags, tags);
      if (temp.length / tags.length >= 0.5) {
        related.push(manifest[i])
      }
    }
  }

  shuffle(related)
  related = related.slice(0, 5)
  related.sort(function (a, b) {
    return Date.parse(b.date.time) - Date.parse(a.date.time)
  })

  html += ''
  for (i = 0; i < related.length; i += 1) {
    html += '<li>'
    html += '<a'
    html += ' title="Read &ldquo;' + related[i].title+ '&rdquo;"'
    html += ' href="' +related[i].url+ '"'
    html += '>' +related[i].title+ '</a>'
    html += '<time'
    html += ' datetime="' +related[i].date.time+ '"'
    html += ' title="' +related[i].date.title+ '"'
    html += '>' +related[i].date.abbr+ '</time>'
    html += '</li>'
  }
  html += ''

  related = document.getElementById('related')
  if (related && related.hasChildNodes()) {
    for (i = 0; i < related.childNodes.length; i += 1) {
      if (related.childNodes[i].nodeName === 'UL') {
        related.childNodes[i].innerHTML = html
        break
      }
    }
  }
}

Elimossinary.relate = function (url) {
  loadManifest(function (manifest) {
    buildRelated(url, manifest);
  });
}

})(window.Elimossinary = window.Elimossinary || {})
