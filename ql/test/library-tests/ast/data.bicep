// Array's
var multiLineArray = [
  'abc'
  'def'
  'ghi'
]

var singleLineArray = ['abc', 'def', 'ghi']

var mixedArray = ['abc', 'def'
    'ghi']

var exampleArray = [1, 2, 3]
output firstElement int = exampleArray[0] // 1
output thirdElement int = exampleArray[2] // 3

var index = 1
output secondElement int = exampleArray[index] // 2

// Booleans
param exampleBool bool = true

// Integers
param exampleInt int = 1

// Objects
param singleLineObject object = {name: 'test name', id: '123-abc', isCurrent: true, tier: 1}

param multiLineObject object = {
  name: 'test name'
  id: '123-abc'
  isCurrent: true
  tier: 1
}

param mixedObject object = {name: 'test name', id: '123-abc', isCurrent: true
    tier: 1}

// Strings
// evaluates to "what's up?"
var myVar = 'what\'s up?'
type direction = 'north' | 'south' | 'east' | 'west'
var storageName = 'storage${uniqueString(resourceGroup().id)}'

// evaluates to "hello!"
var myVar = '''hello!'''

// evaluates to "hello!" because the first newline is skipped
var myVar2 = '''
hello!'''

// evaluates to "hello!\n" because the final newline is included
var myVar3 = '''
hello!
'''

// evaluates to "  this\n    is\n      indented\n"
var myVar4 = '''
  this
    is
      indented
'''
