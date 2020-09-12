#
# discover type name from instance/value
#
exports.name = ( x ) ->
    return 'Undefined' if typeof x == 'undefined'
    return 'Null' if x == null

    # x is function or instance
    x.constructor.name


#
# registers type in scope by value or class function
#
exports.register = ( x, scope ) ->

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
    true                            # iz.Boolean
    new DataView new ArrayBuffer 1  # iz.DataView
    new Date                        # iz.Date
    Date                            # iz.Function
    new Map                         # iz.Map
    null                            # iz.Null
    1.0                             # iz.Number
    Promise.resolve()               # iz.Promise
    {}                              # iz.Object
    /./                             # iz.RegExp
    new Set                         # iz.Set
    ''                              # iz.String
    Symbol()                        # iz.Symbol
    undefined                       # iz.Undefined
]


#
# register js(native) types in global scope
#
jsValues.forEach (v) -> exports.register v
