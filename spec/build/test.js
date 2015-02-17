(function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);throw new Error("Cannot find module '"+o+"'")}var f=n[o]={exports:{}};t[o][0].call(f.exports,function(e){var n=t[o][1][e];return s(n?n:e)},f,f.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({1:[function(require,module,exports){
var Compact;

Compact = (function() {
  var _is, _isNotAllowedType, _raiseIfIdNotFound;

  function Compact(attrs) {
    var attrName, attrVal;
    if (attrs == null) {
      return;
    }
    for (attrName in attrs) {
      attrVal = attrs[attrName];
      this[attrName] = attrVal;
    }
  }

  Compact.prototype.attributes = function() {
    var attrs, key, value;
    attrs = {};
    for (key in this) {
      value = this[key];
      if (!_isNotAllowedType(value)) {
        attrs[key] = value;
      }
    }
    return attrs;
  };

  Compact.prototype.save = function() {
    var attrs;
    attrs = this.attributes();
    _raiseIfIdNotFound(attrs);
    this.constructor._records[this.id] = attrs;
  };

  Compact.prototype.destroy = function() {
    var attrs;
    attrs = this.attributes();
    _raiseIfIdNotFound(attrs);
    delete this.constructor._records[this.id];
  };

  Compact._records = {};

  Compact.storageName = "Compact";

  Compact._getStorageKey = function() {
    return "Cpt-" + this.storageName;
  };

  Compact.loadFromDB = function() {
    var recordsStr;
    recordsStr = localStorage.getItem(this._getStorageKey());
    if (recordsStr != null) {
      this._records = JSON.parse(recordsStr);
    }
  };

  Compact.saveToDB = function() {
    localStorage.setItem(this._getStorageKey(), JSON.stringify(this._records));
  };

  Compact.populate = function(values) {
    var val, _i, _len;
    this.destroyAll();
    for (_i = 0, _len = values.length; _i < _len; _i++) {
      val = values[_i];
      _raiseIfIdNotFound(val);
      this._records[val.id] = val;
    }
  };

  Compact.destroyAll = function() {
    this._records = {};
  };

  Compact.all = function() {
    var id, inst, record, results, _ref;
    results = [];
    _ref = this._records;
    for (id in _ref) {
      record = _ref[id];
      inst = new this(record);
      results.push(inst);
    }
    return results;
  };

  Compact.find = function(id) {
    var record;
    record = this._records[id];
    if (record == null) {
      return null;
    }
    return new this(record);
  };

  _raiseIfIdNotFound = function(attrs) {
    if ((attrs != null ? attrs.id : void 0) == null) {
      throw "Id Not Found";
    }
  };

  _is = function(type, obj) {
    var klass;
    klass = Object.prototype.toString.call(obj).slice(8, -1);
    return (obj != null) && klass === type;
  };

  _isNotAllowedType = function(value) {
    var notAllowedType, notAllowedTypes, result, _i, _len;
    result = false;
    notAllowedTypes = ["Function"];
    for (_i = 0, _len = notAllowedTypes.length; _i < _len; _i++) {
      notAllowedType = notAllowedTypes[_i];
      if (_is(notAllowedType, value)) {
        result = true;
        break;
      }
    }
    return result;
  };

  return Compact;

})();

module.exports = Compact;


},{}],2:[function(require,module,exports){
var Compact,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

Compact = require('../../../app/libs/compact.coffee');

describe("Compact", function() {
  return describe("Class Methods", function() {
    describe("_getStorageKey", function() {
      return it("Cpt-storageNameを返す", function() {
        var TestModel;
        TestModel = (function(_super) {
          __extends(TestModel, _super);

          function TestModel() {
            return TestModel.__super__.constructor.apply(this, arguments);
          }

          TestModel.storageName = "TestModel";

          return TestModel;

        })(Compact);
        return expect(TestModel._getStorageKey()).to.equal("Cpt-TestModel");
      });
    });
    return describe("populate", function() {
      it("レコードがオブジェクトに格納されている", function() {
        var records;
        Compact.populate([
          {
            id: 3,
            name: "taro"
          }, {
            id: 5,
            name: "jiro"
          }
        ]);
        records = Compact._records;
        expect(records[3]["name"]).to.equal("taro");
        return expect(records[5]["name"]).to.equal("jiro");
      });
      describe("idがないとき", function() {
        return it("例外を投げる", function() {
          return expect(function() {
            return Compact.populate([
              {
                name: "taro"
              }, {
                name: "jiro"
              }
            ]);
          }).to["throw"]("Id Not Found");
        });
      });
      return describe("すでにrecordがあるとき", function() {
        return it("受け取ったvalues以外は消される", function() {
          var records;
          Compact.populate([
            {
              id: 3,
              name: "taro"
            }, {
              id: 5,
              name: "jiro"
            }
          ]);
          Compact.populate([
            {
              id: 6,
              name: "saburo"
            }
          ]);
          records = Compact._records;
          expect(records[3]).to.be.undefined;
          expect(records[5]).to.be.undefined;
          return expect(records[6]["name"]).to.equal("saburo");
        });
      });
    });
  });
});


},{"../../../app/libs/compact.coffee":1}]},{},[2])