iz = require '../src/iz'


describe 'iz', () ->
    # map from value to type
    js = [
        { v: [],                t: 'Array' }
        { v: Array,             t: 'Function' }
        { v: true,              t: 'Boolean' }
        { v: Boolean,           t: 'Function' }
        { v: new Date(),        t: 'Date' }
        { v: Date,              t: 'Function' }
        { v: null,              t: 'Null' }
        { v: 1.0,               t: 'Number' }
        { v: 1,                 t: 'Number' }
        { v: Number,            t: 'Function' }
        { v: Promise.resolve(), t: 'Promise' }
        { v: new Promise(->),   t: 'Promise' }
        { v: Promise,           t: 'Function' }
        { v: {},                t: 'Object' }
        { v: new Object,        t: 'Object' }
        { v: Object,            t: 'Function' }
        { v: /./,               t: 'RegExp' }
        { v: new RegExp('.'),   t: 'RegExp' }
        { v: RegExp,            t: 'Function' }
        { v: '',                t: 'String' }
        { v: new String,        t: 'String' }
        { v: String,            t: 'Function' }
        { v: Symbol(),          t: 'Symbol' }
        { v: Symbol,            t: 'Function' }
        { v: undefined,         t: 'Undefined' }
    ]
    describe 'layout', () ->
        props = [
            # methods
            'name'
            'register'

            # registered native types
            'Array'
            'Boolean'
            'Date'
            'Function'
            'Null'
            'Number'
            'Promise'
            'Object'
            'RegExp'
            'String'
            'Symbol'
            'Undefined'
        ]
        # all props should be defined
        props.forEach (p) ->
            it "property #{p}", () ->
                expect(typeof iz[p]).toBe('function')
        it 'property not', () ->
            expect(typeof iz.not).toBe('object')
        undefined
    describe 'native checkers', () ->
        js.forEach (d) ->
            it "-> #{d.t}", () ->
                expect(iz[d.t] d.v).toBeTruthy()
        undefined
    describe 'native checkers negators', () ->
        js.forEach (d) ->
            js.forEach (e) ->
                if d.t != e.t
                    it "-> #{d.t} on #{e.t}", () ->
                        expect(iz.not[d.t] e.v).toBeTruthy()
        
        undefined
    describe 'name', () ->

        it 'should be a Function', () ->
            expect( typeof iz.name ).toBe 'function'
        describe 'should recognize native js types', () ->
            js.forEach (d) ->
                it "-> #{d.t}", () ->
                    expect(iz.name d.v).toEqual d.t
            undefined
        it 'should recognize the name of custom class by instance', () ->
            class NewClass
            expect(iz.name new NewClass).toEqual 'NewClass'
        undefined
    describe 'register', () ->
        it 'should be a Function', () ->
            expect( typeof iz.register ).toBe 'function'
        describe 'register native js types in global and intrenal scope', () ->
            js.forEach (d) ->
                it "-> #{d.t}", () ->
                    # ensure there is no entry
                    delete iz[d.t]
                    expect(iz[d.t]).toBeFalsy()
                    delete iz.not[d.t]
                    expect(iz.not[d.t]).toBeFalsy()

                    # do registration
                    rv = iz.register d.v
                    expect(rv).toEqual iz
                    expect(typeof iz[d.t]).toBe 'function'
                    
                    # check corresponding negator
                    expect(typeof iz.not[d.t]).toBe 'function'

                    # check registration in internal scope
                    rv = iz.register d.v, 'internal'
                    expect(rv).toEqual iz
                    expect(iz.internal).toBeDefined()
                    expect(iz.internal.not).toBeDefined()
                    expect(typeof iz.internal[d.t]).toBe 'function'
                    expect(typeof iz.internal.not[d.t]).toBe 'function'
        undefined
        it 'should throws error on scope conflicts', () ->
            expect( -> iz.register 1, 'Undefined' ).toThrow()
            undefined
        it 'should be able to register custom class', () ->
            class Class2
            iz.register new Class2
            expect(typeof iz.Class2).toBe 'function'
        undefined
    undefined
