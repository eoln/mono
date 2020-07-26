# @eoln/iz

## install mantra
```bash
npm install @eoln/iz --save
```


# TL;DR
run time type/class discovery by value inspection  
and custom class checkers registry (scoped)

# usage examples:

```coffee
iz = require '@eoln/iz'
```

## `name` - class/type name discovery from instance/value

```coffee
class NewClass
iz.name new NewClass
#=> 'NewClass'
```

## `register` - checkers registry
register custom `NewClass` in `global` scope instance/value

```coffee
iz.register new NewClass
iz.NewClass new NewClass
#=> true
```

register custom `NewestClass` in custom scope `eoln`
```coffee
class NewestClass
iz.register new NewestClass, 'eoln'
iz.eoln.NewestClass new NewestClass
#=> true
```

## checkers

do we have `Array`?
```coffee
iz.Array []
#=> true
```

do we have `Object`?
```coffee
iz.Object {}
#=> true

iz.Function Object
#=> true
```

do we have `String`?
```coffee
iz.String 'the-string'
#=> true
```

do we have `RegExp`?
```coffee
iz.RegExp /^i-am-regexp$/g
#=> true
```

do we have `Date`?
```coffee
iz.Date new Date()
#=> true
```

do we have `Number`?
```coffee
iz.Number 3.14
#=> true

iz.Number 1
#=> true
```

do we have `Function`?
```coffee
iz.Function (x) => x*x
#=> true
```

do we have `Boolean`
```coffee
iz.Boolean 1 == 2
#=> true

iz.Boolean false
#=> true
```

do we have `Undefined`?
```coffee
iz.Undefined undefined
#=> true
```

do we have `Null`?
```coffee
iz.Null null
#=> true
```

do we have `Symbol`?
```coffee
iz.Symbol Symbol()
#=> true
```
## `not` - checker negator
prefix `not` will negate checker  

we don't have `Function` on `global` scope
```coffee
iz.not.Symbol Symbol()
#=> false

iz.not.Symbol []
#=> true
```

negators in custom scope `eoln`
```coffee
iz.eoln.not.NewestClass {}
#=> true

iz.eoln.not.NewestClass new NewestClass
#=> false
```
