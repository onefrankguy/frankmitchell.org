var Keen = Keen || {
  configure: function (a, b, c) {
    this._pId = a;
    this._ak = b;
    this._op = c;
  },
  addEvent: function (a, b, c, d) {
    this._eq = this._eq || [];
    this._eq.push([a, b, c, d]);
  },
  setGlobalProperties: function (a) {
    this._gp = a;
  },
  onChartsReady: function (a) {
    this._ocrq = this._ocrq || [];
    this._ocrq.push([a]);
  }
};

(function () {
  var p = 'https:' == document.location.protocol ? 'https://' : 'http://';
  var a = document.createElement('script');
  a.type = 'text/javascript';
  a.async = !0;
  a.src = p + 'dc8na2hxrj29i.cloudfront.net/code/keen-2.0.0-min.js';
  var b = document.getElementsByTagName('script')[0];
  b.parentNode.insertBefore(a, b);
})();

Keen.configure('02e4a51c8a214831b6ec45ba941ccda0');
Keen.addEvent('pageView', {
  page: window.location.href,
  time: new Date().toISOString(),
  referrer: document.referrer,
  agent: window.navigator.userAgent
});
