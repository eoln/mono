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
    if scope?.length > 0

        # throw when scope conflicts with js native types
        # below in this file the js native types are registered
        if @[scope]? and 'Function' == typeof @[scope]
            throw new Error "@eoln/is.register: scope `#{scope}` conflicts"
        
        # initialize scope with negation section
        root[scope] = {not:{}} unless root[scope]?

        # update root pointer
        root = root[scope]
   

    # finish if name already registered in root pointer
    #return @ if root[nx]?

    # create type checker at root pointer
    root[nx] = (y) => nx == @name y

    # create negated version
    root.not[nx] = (y) => nx != @name y

    @



#
# 'not' enables negation of checkers
#
exports.not = {}

#
# js (native) values
#
jsValues = [
    []                  # is.Array
    true                # is.Boolean
    new Date()          # is.Date
    Date                # is.Function
    null                # is.Null
    1.0                 # is.Number
    Promise.resolve()   # is.Promise
    {}                  # is.Object
    /./                 # is.RegExp
    ''                  # is.String
    Symbol()            # is.Symbol
    undefined           # is.Undefined
]

#
# register js(native) types in global scope
#
jsValues.forEach (v) -> exports.register v
