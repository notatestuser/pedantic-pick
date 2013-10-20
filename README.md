pedantic-pick [![Build Status](https://travis-ci.org/notatestuser/pedantic-pick.png)](https://travis-ci.org/notatestuser/pedantic-pick) [![Dependency Status](https://david-dm.org/notatestuser/pedantic-pick.png)](https://david-dm.org/notatestuser/pedantic-pick) [![devDependency Status](https://david-dm.org/notatestuser/pedantic-pick/dev-status.png)](https://david-dm.org/notatestuser/pedantic-pick#info=devDependencies)
=============
This is an enhanced `_.pick` that runs validation functions on picked attributes.

It's common for API developers to use underscore or lodash's `pick` to extract only the 
desired attributes of an incoming object when turning it into a JSON blob for storage in a 
database or whatever. The problem with that is that additional code is needed to verify 
that the attributes are actually the types that you expect them to be. 
Using pedantic-pick will allow you to kill two birds with one stone, so to speak.

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
pick({name: 'moe', age: 50, userid: 'moe1'}, '!s::name', 'n::age')
=> {name: 'moe', age: 50}
```
and when something doesn't pass your rules an error is thrown (protip: use try/catch):
```
pick({name: 'moe', age: 50, userid: 'moe1'}, '!s::name', '!alias')
=> Error: alias failed validation
```

## Expressions
Each given expression argument must conform to this "grammar": `[!][validator::]key`

## Validators
The following validators are built-in (and later we'll accept custom validation functions as arguments):

* required (prefix the expression with `!`)
* string (or `s`)
* number (or `num` or `n`)
* boolean (or `bool` or `b`)
* function (or `fun` or `f`)
* object (or `o`)
* array (or `a`)

## License
See LICENSE
