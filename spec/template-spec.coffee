path = require 'path'

Template = require '../lib/template'

describe 'Template', ->
  beforeEach ->
    atom.config.set 'auto-copyright',
      owner: 'Test Owner'

    spyOn(Date::, 'getFullYear').andReturn 3000

  describe 'without user replacements', ->
    it 'returns the initial text', ->
      expect(new Template('foo').toString()).toEqual 'foo'

    it 'replaces text in the template', ->
      template = new Template('foo {{bar}} baz')
      template.replacements =
        bar: -> 'bar'

      expect(template.toString()).toEqual 'foo bar baz'

    it 'has default replacements', ->
      expect(new Template('foo {{owner}} baz').toString()).toEqual 'foo Test Owner baz'
      expect(new Template('foo {{year}} baz').toString()).toEqual 'foo 3000 baz'

    it 'will replace the old-style %y and %o still', ->
      expect(new Template('%y %o').toString()).toEqual '3000 Test Owner'

  describe 'with user-defined replacements', ->
    beforeEach ->
      spyOn(atom, 'getConfigDirPath').andReturn path.join(__dirname, 'fixtures')

    it 'will replace text using those replacements', ->
      text = new Template('foo {{foozle}} baz').toString()

      expect(text).toEqual 'foo supercalifragilisticexpialidocious baz'
