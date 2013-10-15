app.service('PhotoSvc', [
  function() {
    var album_array, album_lite, auto_fetch, fetch_album, fetch_album_photo, fetch_photo, get_album_from_dblite, get_photo_from_dblite, photo_array, photo_lite, ps;
    ps = {
      path: "/photo",
      sid: null,
      page_limit: 100
    };
    photo_lite = {};
    album_lite = {};
    photo_array = {
      data: [],
      count: 0,
      selected: 0,
      page: 0,
      looading: false
    };
    album_array = {
      data: [],
      count: 0,
      page: 0
    };
    get_photo_from_dblite = function(photo, album) {
      var id;
      id = $('id', photo).text();
      if (!photo_lite[id]) {
        photo_lite[id] = {
          id: id,
          type: 'photo',
          src: '/photo/api/thumb.php?f=' + id,
          output: '/photo/api/photo.php?&' + $.param({
            a: 'display',
            f: id,
            sid: ps.sid
          }),
          width: $('iWidth', photo).text(),
          height: $('iHeight', photo).text(),
          selected: false,
          album: []
        };
      }
      if (album) {
        photo_lite[id].album.push(album);
      }
      return photo_lite[id];
    };
    get_album_from_dblite = function(album) {
      var id;
      id = $('iPhotoAlbumId', album).text();
      if (!album_lite[id]) {
        album_lite[id] = {
          id: id,
          type: 'album',
          src: '/photo/api/thumb.php?f=' + id,
          count: $('PhotoCount', album).text(),
          title: $('cAlbumTitle', album).text(),
          created: $('DateCreated', album).text(),
          modified: $('DateModified', album).text(),
          selected: 0,
          data: [],
          page: 1,
          looading: false
        };
      }
      return album_lite[id];
    };
    fetch_photo = function(page, id) {
      var sid, svc, target;
      sid = ps.sid;
      if (id) {
        target = album_lite[id];
        svc = ps.path + "/api/list.php?t=albumPhotos&" + $.param({
          a: id,
          p: page,
          c: ps.page_limit
        });
      } else {
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
          var item;
          if ($('MediaType', this).text() === 'photo') {
            item = get_photo_from_dblite(this, target);
            target.data.push(item);
            if (item.selected) {
              return target.selected++;
            }
          }
        });
      });
    };
    fetch_album = function() {
      var sid;
      sid = ps.sid;
      return $.ajax({
        type: "GET",
        url: ps.path + "/api/list.php?t=albums&" + $.param({
          p: ++album_array.page,
          c: ps.page_limit
        }),
        cache: false,
        dataType: 'xml'
      }).always(function(res, status) {
        if (sid !== ps.sid) {
          return;
        }
        if (status === 'success') {
          $('FileItem', res).each(function() {
            return album_array.data.push(get_album_from_dblite(this));
          });
        }
        if (album_array.data.length < album_array.count) {
          return setTimeout(fetch_album, 500);
        }
      });
    };
    fetch_album_photo = function() {};
    this.photo = function(page, id) {
      var target;
      if (page < 1) {
        page = 1;
      }
      if (id) {
        target = album_lite[id];
      } else {
        target = photo;
      }
      if (!(target instanceof Object)) {
        return false;
      }
      if (target.data[page] instanceof Array) {
        if (target.data[page].length > 0) {
          return target.data[page];
        } else {
          return false;
        }
      } else {
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
        if (ps.sid) {
          fetch_album(page);
        }
        return false;
      }
    };
    this.reset_sid = function(sid) {
      if (sid !== ps.sid) {
        ps.sid = sid;
        photo.count = 0;
        while (photo.data.length) {
          photo.data.shift();
        }
        album.count = 0;
        while (album.data.length) {
          album.data.shift();
        }
        photo_lite = {};
        album_lite = {};
        return fetch_album();
      }
    };
    this.photo_count = function() {
      return photo.count;
    };
    return (auto_fetch = function() {
      return angular.forEach(album_array.data, function(album, key) {});
    })();
  }
]);

/*
//@ sourceMappingURL=photo_svc.js.map
*/