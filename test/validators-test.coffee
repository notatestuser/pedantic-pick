require 'coffee-script'
sinon = require 'sinon'

describe 'validators', ->

  validators = require '../src/validators'

  stuff =
    object: toMe: 'toYou'
    string: ' - the '
    number:       2
    function: ->   'chuckle brothers'
    array:           ['barry', 'paul']

  describe '#required', ->
    fn = validators.find 'required'
    it 'should validate the goodies', ->
      expect(fn stuff.object).to.be.ok
      expect(fn undefined).to.not.be.ok

  describe '#object', ->
    fn = validators.find 'object'
    it 'should validate the goodies', ->
      expect(fn stuff.object).to.be.ok
      expect(fn stuff.string).to.not.be.ok

  describe '#string', ->
    fn = validators.find 'string'
    it 'should validate the goodies', ->
      expect(fn stuff.string).to.be.ok
      expect(fn stuff.object).to.not.be.ok

  describe '#number', ->
    fn = validators.find 'number'
    it 'should validate the goodies', ->
      expect(fn stuff.number).to.be.ok
      expect(fn stuff.object).to.not.be.ok

  describe '#function', ->
    fn = validators.find 'function'
    it 'should validate the goodies', ->
      expect(fn stuff.function).to.be.ok
      expect(fn stuff.object).to.not.be.ok

  describe '#array', ->
    fn = validators.find 'array'
    it 'should validate the goodies', ->
      expect(fn stuff.array).to.be.ok
      expect(fn stuff.object).to.not.be.ok
