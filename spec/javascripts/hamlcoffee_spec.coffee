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
      expect(HAML.escape("Michael 'netzpirat' Kessler")).toEqual 'Michael &#39;netzpirat&#39; Kessler'

  describe '.cleanValue', ->
    it 'returns an empty string for null', ->
      expect(HAML.cleanValue(null)).toEqual ''

    it 'returns an empty string for undefined', ->
      expect(HAML.cleanValue(undefined)).toEqual ''

    it 'marks a boolean true with unicode character u0093', ->
      expect(HAML.cleanValue(true)).toEqual '\u0093true'

    it 'marks a boolean true with unicode character u0093', ->
      expect(HAML.cleanValue(false)).toEqual '\u0093false'

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
      spyOn(HAML, 'globals').and.callFake -> { b: 2, d: 4 }
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

  describe '.reference', ->
    describe 'class generation', ->
      it 'uses the constructor name as name', ->
        class MyUser
          id: 42
        expect(HAML.reference(new MyUser())).toEqual "class='my_user' id='my_user_42'"

      it 'uses the custom name from #hamlObjectRef', ->
        class MyUser
          id: 23
          hamlObjectRef: -> 'custom_name'
        expect(HAML.reference(new MyUser())).toEqual "class='custom_name' id='custom_name_23'"

      it 'defaults to `object` without consturctor name', ->
        expect(HAML.reference({ id: 666 })).toEqual "class='object' id='object_666'"

      it 'prepends a given prefix', ->
        class MyUser
          id: 42
        expect(HAML.reference(new MyUser(), 'prefix')).toEqual "class='prefix_my_user' id='prefix_my_user_42'"

    describe 'id generation', ->
      it 'uses the object #id property', ->
        class FromIdProp
          id: 42
        expect(HAML.reference(new FromIdProp())).toEqual "class='from_id_prop' id='from_id_prop_42'"

      it 'uses the object #to_key function', ->
        class FromToKeyFunc
          to_key: -> 23
        expect(HAML.reference(new FromToKeyFunc())).toEqual "class='from_to_key_func' id='from_to_key_func_23'"

      it 'uses the object #id function', ->
        class FromIdFunc
          id: -> 123
        expect(HAML.reference(new FromIdFunc())).toEqual "class='from_id_func' id='from_id_func_123'"

      it 'uses the object itself', ->
        expect(HAML.reference(123)).toEqual "class='number' id='number_123'"
