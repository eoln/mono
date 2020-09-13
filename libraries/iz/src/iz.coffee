#
# discover type name from instance/value
#
exports.name = (x) ->
    return 'Undefined' if typeof x == 'undefined'
    return 'Null' if x == null

    # x is function or instance
    x.constructor.name


#
# registers type in scope by value or class function
#
exports.register = (x, scope) ->

    # extract type's name
    nx = @name x

    # root pointer by default points at global scope
    root = @

    # init scope if necessary
    if scope?.length

        # throw when scope conflicts with js native types
        # below in this file the js native types are registered
        if @[scope]? and 'Function' is typeof @[scope]
            throw new Error "@eoln/iz.register: scope `#{scope}` conflicts"
        
        # initialize scope with negation section
        root[scope] = { not: {} } unless root[scope]?

        # update root pointer
        root = root[scope]
   

    # finish if name already registered in root pointer
    #return @ if root[nx]?

    # create type checker at root pointer
    root[nx] = (y) => nx is @name y

    # create negated version
    root.not[nx] = (y) => nx isnt @name y

    @


#
# 'not' enables negation of checkers
#
exports.not = {}


#
# js (native) objects
# https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference
#
jsValues = [
    []                              # iz.Array
    new ArrayBuffer 1               # iz.ArrayBuffer
    BigInt 1                        # iz.BigInt
    new BigInt64Array               # iz.BigInt64Array
    new BigUint64Array              # iz.BigUint64Array
    true                            # iz.Boolean
    new DataView new ArrayBuffer 1  # iz.DataView
    new Date                        # iz.Date
    new Error                       # iz.Error
    # node v13.0.0
    # new FinalizationRegistry(() ->) # iz.FinalizationRegistry
    new Float32Array                # iz.Float32Array
    new Float64Array                # iz.Float64Array
    () ->                           # iz.Function
    # todo investigate Generator value
    # (() -> yield 1)()             # iz.Generator
    (() -> yield 1)                 # iz.GeneratorFunction
    new Int16Array                  # iz.Int16Array
    new Int32Array                  # iz.Int32Array
    new Int8Array                   # iz.Int8Array
    new Map                         # iz.Map
    null                            # iz.Null
    1.0                             # iz.Number
    {}                              # iz.Object
    Promise.resolve()               # iz.Promise
    new RangeError                  # iz.RangeError
    new ReferenceError              # iz.ReferenceError
    /./                             # iz.RegExp
    new Set                         # iz.Set
    new SharedArrayBuffer 1         # iz.SharedArrayBuffer
    ''                              # iz.String
    Symbol()                        # iz.Symbol
    new SyntaxError                 # iz.SyntaxError
    new TypeError                   # iz.TypeError
    new URIError                    # iz.URIError
    new Uint16Array 1               # iz.Uint16Array
    new Uint32Array 1               # iz.Uint32Array
    new Uint8Array 1                # iz.Uint8Array
    new Uint8ClampedArray 1         # iz.Uint8ClampedArray
    new WeakMap                     # iz.WeakMap
    # new WeakRef                     # iz.WeakRef
    new WeakSet                     # iz.WeakSet
    undefined                       # iz.Undefined
]


#
# register js(native) types in global scope
#
jsValues.forEach (v) -> exports.register v
