require 'coffee-script'
sinon = require 'sinon'

describe 'pick()', ->

  pick = require '../pick.coffee'
  {ValidationError} = pick

  source =
    roses:   'red',
    violets: 'blue'

  describe 'passing expressions that are not strings', ->

    it 'should throw us an error upside our head',  ->
      fn = pick.bind(@, source, (->), null)
      expect(fn).to.throw Error('All pick expressions must be strings (found function)')

  describe 'inherited functionality', ->

    it 'should pass back a bare object if nothing is to be picked', ->
      res = pick source
      expect(res).to.deep.equal {}

    it 'should pick out the attributes we specify', ->
      res = pick source, 'roses'
      expect(res).to.deep.equal roses: 'red'

    it 'should not have modified the original object', ->
      res = pick source, 'roses'
      expect(source).to.deep.equal
        roses:   'red',
        violets: 'blue'

  describe 'when attributes are required', ->

    it 'should pick out the required attributes if satisified', ->
      res = pick source, '!::roses', '!::violets'
      expect(res).to.deep.equal source

    it 'should throw an error if requirements are not satisifed', ->
      fn = pick.bind(@, source, '!::roses', '!::hemp')
      expect(fn).to.throw ValidationError('hemp failed validation')

    it 'should throw an error if requirements are not satisifed (alt expr form)', ->
      fn = pick.bind(@, source, '!roses', '!hemp')
      expect(fn).to.throw ValidationError('hemp failed validation')

  describe 'when attributes are validated', ->

    it 'should pick out the validated attributes if satisified', ->
      res = pick source, 'string::roses', 'string::violets'
      expect(res).to.deep.equal source

    it 'should pick out the validated attributes if satisified (shorthand)', ->
      res = pick source, 's::roses', 's::violets'
      expect(res).to.deep.equal source

    it 'should not complain if a non-required but validated attribute was omitted', ->
      res = pick source, 's::roses', 's::foxglove', 'violets'
      expect(res).to.deep.equal source

    it 'should throw an error if validation did not pass', ->
      fn = pick.bind(@, source, 's::roses', 'o::violets')
      expect(fn).to.throw ValidationError('violets failed validation')
