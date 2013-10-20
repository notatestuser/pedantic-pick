_ = require './lodash-abridged'

validators = [
  ['required',              (v) -> v isnt undefined and v isnt null]

  ['string', 's',           (v) -> typeof v is 'string']

  ['nempstring', 'nes',     (v) -> typeof v is 'string' and v.length > 0]

  ['number', 'num', 'n',    (v) -> typeof v is 'number']

  ['boolean', 'bool', 'b',  (v) -> v is true or v is false]

  ['function', 'fun', 'f',  (v) -> typeof v is 'function']

  ['object', 'o',           (v) -> typeof v is 'object' and not _.isArray(v)]

  ['array', 'a',            _.isArray]

  ['nemparray', 'nea',      (v) -> _.isArray(v) and v.length > 0]
]

findValidatorFn = (name) ->
  found = validators.filter (arr) -> name in arr
  return null if not found.length
  found[0][ found[0].length - 1 ]

module.exports =
  validators: validators
  find: findValidatorFn
