Compact = require('../../../app/libs/compact.coffee')

describe "Compact", ->
  describe "Class Methods", ->
    describe "_getStorageKey", ->
      it "Cpt-storageNameを返す", ->
        class TestModel extends Compact
          @storageName: "TestModel"

        expect(TestModel._getStorageKey()).to.equal "Cpt-TestModel"

    describe "populate", ->
      it "レコードがオブジェクトに格納されている", ->
        Compact.populate [{id: 3, name: "taro"}, {id: 5, name: "jiro"}]
        records = Compact._records
        expect(records[3]["name"]).to.equal "taro"
        expect(records[5]["name"]).to.equal "jiro"

      describe "idがないとき", ->
        it "例外を投げる", ->
          expect(-> Compact.populate([{name: "taro"}, {name: "jiro"}])).to.throw("Id Not Found")

      describe "すでにrecordがあるとき", ->
        it "受け取ったvalues以外は消される", ->
          Compact.populate [{id: 3, name: "taro"}, {id: 5, name: "jiro"}]
          Compact.populate [{id: 6, name: "saburo"}]
          records = Compact._records
          expect(records[3]).to.be.undefined
          expect(records[5]).to.be.undefined
          expect(records[6]["name"]).to.equal "saburo"
