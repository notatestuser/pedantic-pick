require 'coffee-script'
sinon = require 'sinon'

describe 'pick()', ->

  pick   = require '../pick.coffee'

  source =
    roses:   'red',
    violets: 'blue'

  describe 'inherited functionality', ->

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
      expect(fn).to.throw Error('hemp is required')

  describe 'when attributes are validated', ->

    it 'should pick out the validated attributes if satisified', ->
      res = pick source, 'string::roses', 'string::violets'
      expect(res).to.deep.equal source

    it 'should pick out the validated attributes if satisified (shorthand)', ->
      res = pick source, 's::roses', 's::violets'
      expect(res).to.deep.equal source

    it 'should throw an error if validation did not pass', ->
      fn = pick.bind(@, source, 's::roses', 'o::violets')
      expect(fn).to.throw Error('violets failed validation')


