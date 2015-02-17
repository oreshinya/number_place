class Compact
  constructor: (attrs) ->
    return if not attrs?
    for attrName, attrVal of attrs
      @[attrName] = attrVal

  attributes: ->
    attrs = {}
    for key, value of @
      if not _isNotAllowedType(value)
        attrs[key] = value
    return attrs

  save: ->
    attrs = @attributes()
    _raiseIfIdNotFound(attrs)
    @constructor._records[@id] = attrs
    return

  destroy: ->
    attrs = @attributes()
    _raiseIfIdNotFound(attrs)
    delete @constructor._records[@id]
    return
  
  @_records: {}

  @storageName: "Compact"

  @_getStorageKey: ->
    return "Cpt-#{@storageName}"

  @loadFromDB: ->
    recordsStr = localStorage.getItem(@_getStorageKey())
    @_records = JSON.parse recordsStr if recordsStr?
    return

  @saveToDB: ->
    localStorage.setItem(@_getStorageKey(), JSON.stringify(@_records))
    return

  @populate: (values) ->
    @destroyAll()
    for val in values
      _raiseIfIdNotFound(val)
      @_records[val.id] = val
    return

  @destroyAll: ->
    @_records = {}
    return

  @all: ->
    results = []
    for id, record of @_records
      inst = new @(record)
      results.push inst
    return results

  @find: (id) ->
    record = @_records[id]
    return null if not record?
    return new @(record)

  _raiseIfIdNotFound = (attrs) ->
    throw "Id Not Found" if not attrs?.id?

  _is = (type, obj) ->
    klass = Object.prototype.toString.call(obj).slice(8, -1)
    return obj? and klass is type

  _isNotAllowedType = (value) ->
    result = false
    notAllowedTypes = [
      "Function"
    ]

    for notAllowedType in notAllowedTypes
      if _is(notAllowedType, value)
        result = true
        break

    return result

module.exports = Compact
