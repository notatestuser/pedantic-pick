pedantic-pick [![Build Status](https://travis-ci.org/notatestuser/pedantic-pick.png)](https://travis-ci.org/notatestuser/pedantic-pick) [![Dependency Status](https://david-dm.org/notatestuser/pedantic-pick.png)](https://david-dm.org/notatestuser/pedantic-pick) [![devDependency Status](https://david-dm.org/notatestuser/pedantic-pick/dev-status.png)](https://david-dm.org/notatestuser/pedantic-pick#info=devDependencies)
=============
This is an enhanced `_.pick` that runs validation functions on picked attributes.

## Usage
The function signature looks much like the one you're already used to: `pick(object, [expressions...], [thisArg])`

In addition to the [standard usage](http://underscorejs.org/#pick) of `_.pick`
```
pick({name: 'moe', age: 50, userid: 'moe1'}, 'name', 'age')
=> {name: 'moe', age: 50}
```
...you can do this with pedantic-pick:
```
pick({name: 'moe', age: 50, userid: 'moe1'}, '!string::name', 'number::age')
=> {name: 'moe', age: 50}
```
or, of course, use the shorthand form:
```
pick({name: 'moe', age: 50, userid: 'moe1'}, '!s::name', 'number::age')
=> {name: 'moe', age: 50}
```
and when something doesn't pass your rules an error is thrown:
```
pick({name: 'moe', age: 50, userid: 'moe1'}, '!s::name', '!alias')
=> Error: alias failed validation
```

## Expressions
Each given expression argument must conform to this "grammar": `[!][validator::]key`

## Validators
The following validators are built-in (and later we'll support passing custom validation functions in as arguments):

* required (prefix the expression with `!`)
* string
* number
* boolean
* function
* object
* array

## License
See LICENSE

