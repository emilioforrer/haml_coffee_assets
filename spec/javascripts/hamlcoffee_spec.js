describe('HAML', function() {
  describe('.escape', function() {
    it('escapes an ampersand', function() {
      return expect(HAML.escape('house & garden')).toEqual('house &amp; garden');
    });
    it('escapes the less than sign', function() {
      return expect(HAML.escape('money < fun')).toEqual('money &lt; fun');
    });
    it('escapes the greater than sign', function() {
      return expect(HAML.escape('love > hate')).toEqual('love &gt; hate');
    });
    it('escapes a double quote', function() {
      return expect(HAML.escape('Michael "netzpirat" Kessler')).toEqual('Michael &quot;netzpirat&quot; Kessler');
    });
    return it('escapes a single quote', function() {
      return expect(HAML.escape("Michael 'netzpirat' Kessler")).toEqual('Michael &#39;netzpirat&#39; Kessler');
    });
  });
  describe('.cleanValue', function() {
    it('returns an empty string for null', function() {
      return expect(HAML.cleanValue(null)).toEqual('');
    });
    it('returns an empty string for undefined', function() {
      return expect(HAML.cleanValue(void 0)).toEqual('');
    });
    it('marks a boolean true with unicode character u0093', function() {
      return expect(HAML.cleanValue(true)).toEqual('\u0093true');
    });
    it('marks a boolean true with unicode character u0093', function() {
      return expect(HAML.cleanValue(false)).toEqual('\u0093false');
    });
    return it('passes everything else unchanged', function() {
      return expect(HAML.cleanValue('Still the same')).toEqual('Still the same');
    });
  });
  describe('.extend', function() {
    it('extends the given object from a source object', function() {
      var object;
      object = HAML.extend({}, {
        a: 1,
        b: 2
      });
      expect(object.a).toEqual(1);
      return expect(object.b).toEqual(2);
    });
    it('extends the given object from multipe source objects', function() {
      var object;
      object = HAML.extend({}, {
        a: 1
      }, {
        b: 2
      }, {
        c: 3,
        d: 4
      });
      expect(object.a).toEqual(1);
      expect(object.b).toEqual(2);
      expect(object.c).toEqual(3);
      return expect(object.d).toEqual(4);
    });
    return it('overwrites existing properties', function() {
      var object;
      object = HAML.extend({}, {
        a: 1
      }, {
        b: 2
      }, {
        a: 2,
        b: 4
      });
      expect(object.a).toEqual(2);
      return expect(object.b).toEqual(4);
    });
  });
  describe('.globals', function() {
    it('retuns the global object', function() {
      return expect(HAML.globals).toEqual(Object(HAML.globals));
    });
    return it('returns an empty object', function() {
      return expect(Object.keys(HAML.globals).length).toEqual(0);
    });
  });
  describe('.context', function() {
    return it('merges the locals into the globals', function() {
      var context;
      spyOn(HAML, 'globals').and.callFake(function() {
        return {
          b: 2,
          d: 4
        };
      });
      context = HAML.context({
        a: 1,
        c: 3
      });
      expect(context.a).toEqual(1);
      expect(context.b).toEqual(2);
      expect(context.c).toEqual(3);
      return expect(context.d).toEqual(4);
    });
  });
  describe('.preserve', function() {
    return it('preserves all newlines', function() {
      return expect(HAML.preserve("Newlines\nall\nthe\nway\n")).toEqual("Newlines&#x000A;all&#x000A;the&#x000A;way&#x000A;");
    });
  });
  describe('.findAndPreserve', function() {
    return it('replaces newlines within the preserved tags', function() {
      return expect(HAML.findAndPreserve("<pre>\n  This will\n  be preserved\n</pre>\n<p>\n  This will not\n  be preserved\n</p>\n<textarea>\n  This will\n  be preserved\n</textarea>")).toEqual("<pre>&#x000A;  This will&#x000A;  be preserved&#x000A;</pre>\n<p>\n  This will not\n  be preserved\n</p>\n<textarea>&#x000A;  This will&#x000A;  be preserved&#x000A;</textarea>");
    });
  });
  describe('.surround', function() {
    return it('surrounds the text to the function result', function() {
      return expect(HAML.surround('Prefix', 'Suffix', function() {
        return '<p>text</p>';
      })).toEqual('Prefix<p>text</p>Suffix');
    });
  });
  describe('.succeed', function() {
    return it('appends the text to the function result', function() {
      return expect(HAML.succeed('Suffix', function() {
        return '<p>text</p>';
      })).toEqual('<p>text</p>Suffix');
    });
  });
  describe('.precede', function() {
    return it('prepends the text to the function result', function() {
      return expect(HAML.precede('Prefix', function() {
        return '<p>text</p>';
      })).toEqual('Prefix<p>text</p>');
    });
  });
  return describe('.reference', function() {
    describe('class generation', function() {
      it('uses the constructor name as name', function() {
        var MyUser;
        MyUser = (function() {
          function MyUser() {}

          MyUser.prototype.id = 42;

          return MyUser;

        })();
        return expect(HAML.reference(new MyUser())).toEqual("class='my_user' id='my_user_42'");
      });
      it('uses the custom name from #hamlObjectRef', function() {
        var MyUser;
        MyUser = (function() {
          function MyUser() {}

          MyUser.prototype.id = 23;

          MyUser.prototype.hamlObjectRef = function() {
            return 'custom_name';
          };

          return MyUser;

        })();
        return expect(HAML.reference(new MyUser())).toEqual("class='custom_name' id='custom_name_23'");
      });
      it('defaults to `object` without consturctor name', function() {
        return expect(HAML.reference({
          id: 666
        })).toEqual("class='object' id='object_666'");
      });
      return it('prepends a given prefix', function() {
        var MyUser;
        MyUser = (function() {
          function MyUser() {}

          MyUser.prototype.id = 42;

          return MyUser;

        })();
        return expect(HAML.reference(new MyUser(), 'prefix')).toEqual("class='prefix_my_user' id='prefix_my_user_42'");
      });
    });
    return describe('id generation', function() {
      it('uses the object #id property', function() {
        var FromIdProp;
        FromIdProp = (function() {
          function FromIdProp() {}

          FromIdProp.prototype.id = 42;

          return FromIdProp;

        })();
        return expect(HAML.reference(new FromIdProp())).toEqual("class='from_id_prop' id='from_id_prop_42'");
      });
      it('uses the object #to_key function', function() {
        var FromToKeyFunc;
        FromToKeyFunc = (function() {
          function FromToKeyFunc() {}

          FromToKeyFunc.prototype.to_key = function() {
            return 23;
          };

          return FromToKeyFunc;

        })();
        return expect(HAML.reference(new FromToKeyFunc())).toEqual("class='from_to_key_func' id='from_to_key_func_23'");
      });
      it('uses the object #id function', function() {
        var FromIdFunc;
        FromIdFunc = (function() {
          function FromIdFunc() {}

          FromIdFunc.prototype.id = function() {
            return 123;
          };

          return FromIdFunc;

        })();
        return expect(HAML.reference(new FromIdFunc())).toEqual("class='from_id_func' id='from_id_func_123'");
      });
      return it('uses the object itself', function() {
        return expect(HAML.reference(123)).toEqual("class='number' id='number_123'");
      });
    });
  });
});