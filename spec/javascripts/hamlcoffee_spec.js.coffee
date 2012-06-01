describe 'HAML', ->
  describe '.escape', ->
    it 'escapes an ampersand', ->
      expect(HAML.escape('house & garden')).toEqual 'house &amp; garden'

    it 'escapes the less than sign', ->
      expect(HAML.escape('money < fun')).toEqual 'money &lt; fun'

    it 'escapes the greater than sign', ->
      expect(HAML.escape('love > hate')).toEqual 'love &gt; hate'

    it 'escapes a double quote', ->
      expect(HAML.escape('Michael "netzpirat" Kessler')).toEqual 'Michael &quot;netzpirat&quot; Kessler'

    it 'escapes a single quote', ->
      expect(HAML.escape("Michael 'netzpirat' Kessler")).toEqual 'Michael &apos;netzpirat&apos; Kessler'

  describe '.cleanValue', ->
    it 'returns an empty string for null', ->
      expect(HAML.cleanValue(null)).toEqual ''

    it 'returns an empty string for undefined', ->
      expect(HAML.cleanValue(undefined)).toEqual ''

    it 'passes everything else unchanged', ->
      expect(HAML.cleanValue('Still the same')).toEqual 'Still the same'

  describe '.extend', ->
    it 'extends the given object from a source object', ->
      object = HAML.extend {}, { a: 1, b: 2 }

      expect(object.a).toEqual 1
      expect(object.b).toEqual 2

    it 'extends the given object from multipe source objects', ->
      object = HAML.extend {}, { a: 1 }, { b: 2 }, { c: 3, d: 4 }

      expect(object.a).toEqual 1
      expect(object.b).toEqual 2
      expect(object.c).toEqual 3
      expect(object.d).toEqual 4

    it 'overwrites existing properties', ->
      object = HAML.extend {}, { a: 1 }, { b: 2 }, { a: 2, b: 4 }

      expect(object.a).toEqual 2
      expect(object.b).toEqual 4

  describe '.globals', ->
    it 'retuns the global object', ->
      expect(HAML.globals).toEqual Object(HAML.globals)

    it 'returns an empty object', ->
      expect(Object.keys(HAML.globals).length).toEqual 0

  describe '.context', ->
    it 'merges the locals into the globals', ->
      spyOn(HAML, 'globals').andCallFake -> { b: 2, d: 4 }
      context = HAML.context({ a: 1, c: 3 })

      expect(context.a).toEqual 1
      expect(context.b).toEqual 2
      expect(context.c).toEqual 3
      expect(context.d).toEqual 4

  describe '.preserve', ->
    it 'preserves all newlines', ->
      expect(HAML.preserve("Newlines\nall\nthe\nway\n")).toEqual "Newlines&#x000A;all&#x000A;the&#x000A;way&#x000A;"

  describe '.findAndPreserve', ->
    it 'replaces newlines within the preserved tags', ->
      expect(HAML.findAndPreserve("""
        <pre>
          This will
          be preserved
        </pre>
        <p>
          This will not
          be preserved
        </p>
        <textarea>
          This will
          be preserved
        </textarea>
      """)).toEqual """
        <pre>&#x000A;  This will&#x000A;  be preserved&#x000A;</pre>
        <p>
          This will not
          be preserved
        </p>
        <textarea>&#x000A;  This will&#x000A;  be preserved&#x000A;</textarea>
      """

  describe '.surround', ->
    it 'surrounds the text to the function result', ->
      expect(HAML.surround('Prefix', 'Suffix', -> '<p>text</p>')).toEqual 'Prefix<p>text</p>Suffix'

  describe '.succeed', ->
    it 'appends the text to the function result', ->
      expect(HAML.succeed('Suffix', -> '<p>text</p>')).toEqual '<p>text</p>Suffix'

  describe '.precede', ->
    it 'prepends the text to the function result', ->
      expect(HAML.precede('Prefix', -> '<p>text</p>')).toEqual 'Prefix<p>text</p>'
