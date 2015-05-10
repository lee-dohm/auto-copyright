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

  describe 'default replacements', ->
    it 'will replace the legacy %y and %o', ->
      expect(new Template('%y %o').toString()).toEqual '3000 Test Owner'

    it 'inserts the owner text', ->
      text = new Template('{{owner}}').toString()

      expect(text).toEqual 'Test Owner'

    it 'inserts the current year', ->
      text = new Template('{{year}}').toString()

      expect(text).toEqual '3000'

  describe 'with user-defined replacements', ->
    beforeEach ->
      spyOn(atom, 'getConfigDirPath').andReturn path.join(__dirname, 'fixtures')

    it 'will replace text using those replacements', ->
      text = new Template('foo {{foozle}} baz').toString()

      expect(text).toEqual 'foo supercalifragilisticexpialidocious baz'

    it 'will use user-defined replacements over the defaults', ->
      text = new Template('foo {{owner}} baz').toString()

      expect(text).toEqual 'foo Some Other Owner baz'
