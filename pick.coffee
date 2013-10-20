#     pick.coffee
#     Copyright 2013 Luke Plaster <http://lukep.org/>
#     https://github.com/notatestuser/node-pick.js

_ = require './lib/lodash-abridged'

validators = require './lib/validators'

REQUIRED_ATTR_TOKEN  = '!'
EXPR_SEPARATOR_TOKEN = '::'

class ValidationError extends Error
  constructor: (@field) ->
    @message = "#{@field} failed validation"

  toString: ->
    "Error: #{@message}"

pick = (source, exprs..., thisArg = @) ->
  if typeof thisArg is 'string'
    exprs.push thisArg
    thisArg = @

  exprs.every (_el) ->
    if type = typeof _el isnt 'string'
      throw Error("All pick expressions must be strings (found #{type})")

  validationSpec = exprs.reduce (accum, _expr) ->
    # catch expressions that look like previous use of _.pick
    unless ~_expr.indexOf EXPR_SEPARATOR_TOKEN
      # attr could still be required (shorthand form)
      if _expr.length and _expr.charAt(0) is REQUIRED_ATTR_TOKEN
        attrName = _expr.substring 1
        accum[attrName] = [validators.find 'required']
        return accum
      accum[_expr] = []
      return accum
    # sep token present in expression
    sepTokenIdx = _expr.indexOf EXPR_SEPARATOR_TOKEN
    attrName    = _expr.substring sepTokenIdx + 2
    fnName      = _expr.substring(0, sepTokenIdx).match(/!?(.*)/)[1]
    validateFns = accum[attrName] or= []
    if _expr.charAt(0) is REQUIRED_ATTR_TOKEN
      validateFns.push validators.find 'required'
    validatorFn = validators.find(fnName)
    validateFns.push(validatorFn) if validatorFn?
    accum
  , {}

  # call _.pick with params
  attrs = Object.keys(validationSpec)
  picked = _.pick.apply _, [source].concat(attrs)
  return picked if typeof picked isnt 'object'

  # make our validations. are we in sync or async mode?
  syncMode = _.values(validationSpec).every (fns) ->
    # async validation fns would have an additional callback param
    fns.every (fn) -> fn.length <= 1

  if not syncMode
    throw Error('Async validations are to be implemented; check fns must take 1 arg')

  # run validation
  lastAttrName = null
  pass = attrs.every (attrName, idx) ->
    isRequired = exprs[idx].charAt(0) is REQUIRED_ATTR_TOKEN
    lastAttrName = attrName
    if (isRequired or picked[attrName] isnt undefined) and fns = validationSpec[attrName]
      fns.every (fn) ->
        fn.call(thisArg, picked[attrName])
    else true

  unless pass then throw new ValidationError(lastAttrName)
  else picked

module.exports = pick
module.exports.ValidationError = ValidationError
