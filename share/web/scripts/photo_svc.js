app.service('PhotoSvc', [
  function() {
    var album, albumPhoto, dblite, fetch_album, fetch_photo, get_photo_from_dblite, photo, ps;
    ps = {
      path: "/photo",
      sid: null,
      page_limit: 100
    };
    dblite = {};
    photo = {
      data: [],
      count: 0
    };
    album = {
      data: [],
      count: 0
    };
    albumPhoto = {};
    get_photo_from_dblite = function(photo) {
      var id;
      id = $('id', photo).text();
      if (!dblite[id]) {
        dblite[id] = {
          id: id,
          type: 'photo',
          src: '/photo/api/thumb.php?f=' + id,
          output: location.protocol + '//' + location.host + '/photo/api/photo.php?&' + $.param({
            a: 'display',
            f: id,
            sid: ps.sid
          }),
          width: $('iWidth', photo).text(),
          height: $('iHeight', photo).text()
        };
      }
      return dblite[id];
    };
    fetch_photo = function(page, id) {
      var sid, svc, target;
      sid = ps.sid;
      if (id) {
        albumPhoto[id].data[page] = [];
        target = albumPhoto[id];
        svc = ps.path + "/api/list.php?t=albumPhotos&" + $.param({
          a: id,
          p: page,
          c: ps.page_limit
        });
      } else {
        photo.data[page] = [];
        target = photo;
        svc = ps.path + "/api/list.php?t=photos&" + $.param({
          p: page,
          c: ps.page_limit
        });
      }
      return $.ajax({
        type: "GET",
        url: svc,
        cache: false,
        dataType: 'xml'
      }).done(function(res) {
        var count;
        if (sid !== ps.sid) {
          return;
        }
        count = $('photoCount', res).text();
        if (count > 0) {
          target.count = count;
        }
        return $('FileItem', res).each(function() {
          if ($('MediaType', this).text() === 'photo') {
            return target.data[page].push(get_photo_from_dblite(this));
          }
        });
      });
    };
    fetch_album = function(page) {
      var sid;
      sid = ps.sid;
      album.data[page] = [];
      return $.ajax({
        type: "GET",
        url: ps.path + "/api/list.php?t=albums&" + $.param({
          p: page,
          c: ps.page_limit
        }),
        cache: false,
        dataType: 'xml'
      }).done(function(res) {
        if (sid !== ps.sid) {
          return;
        }
        return $('FileItem', res).each(function() {
          var id;
          id = $('iPhotoAlbumId', this).text();
          return album.data[page].push({
            id: id,
            type: 'album',
            src: '/photo/api/thumb.php?f=' + id,
            count: $('PhotoCount', this).text(),
            title: $('cAlbumTitle', this).text(),
            created: $('DateCreated', this).text(),
            modified: $('DateModified', this).text()
          });
        });
      });
    };
    this.photo = function(page, id) {
      var target;
      if (page < 1) {
        page = 1;
      }
      if (id) {
        if (!albumPhoto[id]) {
          albumPhoto[id] = {
            data: [],
            count: 0
          };
        }
        target = albumPhoto[id];
      } else {
        target = photo;
      }
      if (target.data[page] instanceof Array) {
        if (target.data[page].length > 0) {
          return target.data[page];
        } else {
          return false;
        }
      } else {
        console.log('req photo');
        if (ps.sid) {
          fetch_photo(page, id);
        }
        return false;
      }
    };
    this.album = function(page) {
      if (page < 1) {
        page = 1;
      }
      if (album.data[page] instanceof Array) {
        if (album.data[page].length > 0) {
          return album.data[page];
        } else {
          return false;
        }
      } else {
        console.log('req album');
        if (ps.sid) {
          fetch_album(page);
        }
        return false;
      }
    };
    this.reset_sid = function(sid) {
      var i, item, _i, _j, _len, _len1, _ref, _ref1;
      if (sid !== ps.sid) {
        ps.sid = sid;
        photo.count = 0;
        _ref = photo.data;
        for (i = _i = 0, _len = _ref.length; _i < _len; i = ++_i) {
          item = _ref[i];
          photo.data[i] = null;
        }
        album.count = 0;
        _ref1 = photo.data;
        for (i = _j = 0, _len1 = _ref1.length; _j < _len1; i = ++_j) {
          item = _ref1[i];
          album.data[i] = null;
        }
        return albumPhoto = {};
      }
    };
    return this.photo_count = function() {
      return photo.count;
    };
  }
]);

/*
//@ sourceMappingURL=photo_svc.js.map
*/