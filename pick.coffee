#     pick.coffee
#     Copyright 2013 Luke Plaster <http://lukep.org/>
#     https://github.com/notatestuser/node-pick.js

_ = require './lib/lodash-abridged'

validators = require './lib/validators'

pick = (source, exprs..., thisArg = @) ->
  if typeof thisArg is 'string'
    exprs.push thisArg
    thisArg = @

  exprs.every (_el) ->
    if type = typeof _el isnt 'string'
      throw Error("All pick expressions must be strings (found #{type})")

  validateFns = Object.create null
  attrs = exprs.map (_el) ->
    return _el unless ~_el.indexOf '::'
    sepTokenIdx = _el.indexOf  '::'
    attrName    = _el.substring    sepTokenIdx + 2
    fnName      = _el.substring(0, sepTokenIdx).match(/!?(.*)/)[1]
    if _el.charAt(0) is '!' and not source[attrName]?
      # catch breached 'required' constraints here
      throw Error("#{attrName} is required")
    validationFn = validators.find(fnName)
    validateFns[attrName] = validationFn if validationFn?
    attrName

  # call _.pick with params
  picked = _.pick.apply _, [source].concat(attrs)
  return picked if typeof picked isnt 'object'

  # make our validations. are we in sync or async mode?
  syncMode = _.values(validateFns).every (_fn) ->
    # async validation fns would have an additional callback param
    _fn.length <= 1

  if not syncMode
    throw Error('Async validations are to be implemented; check fns must take 1 arg')

  # run validation
  lastAttrName = null
  pass = attrs.every (_attrName) ->
    lastAttrName = _attrName
    if picked[_attrName]? and fn = validateFns[_attrName]
      fn.call(thisArg, picked[_attrName])
    else true

  unless pass then throw Error("#{lastAttrName} failed validation")
  else picked

module.exports = pick
