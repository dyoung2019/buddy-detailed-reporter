let failedTests = 5
let skippedTests = 15
let todoTests = 2
let passedTests = 2
let noOfTests = 24

// ansi-styles
const modifiers = {
  reset: [0, 0],
  // 21 isn't widely supported and 22 does the same thing
  bold: [1, 22],
  dim: [2, 22],
  italic: [3, 23],
  underline: [4, 24],
  overline: [53, 55],
  inverse: [7, 27],
  hidden: [8, 28],
  strikethrough: [9, 29]
}

const textColors = {
  black: [30, 39],
  red: [31, 39],
  green: [32, 39],
  yellow: [33, 39],
  blue: [34, 39],
  magenta: [35, 39],
  cyan: [36, 39],
  white: [37, 39],
  gray: [90, 39], // blackBright
  // grey: [90, 39], // blackBright
}

const expressValue = (value, key, dictionary) => {
  const keyValue = dictionary[key]
  if (!!key && !!keyValue) {
    const [start, end] = keyValue
    return `\u001B[${start}m${value}\u001B[${end}m`
  } else {
    return value
  }
}

const expressStyle = (value, modifier) => {
  return expressValue(value, modifier, modifiers)
}

const expressColor = (value, color) => {
  return expressValue(value, color, textColors)
}

const express = (value, color = null, modifier = null) => {
  return expressColor(expressStyle(value, modifier), color)
}

function tag(values) {
  return expressColor(expressStyle(values[0], values[2]), values[1])
}

// Tagged templates functions
function short(values, colorExp, modifierExp) {
  const color = `${colorExp}`
  const modifier = `${modifierExp}`
  return expressColor(expressStyle(values[0], modifier), color)
}

const RED = 'red'

console.log(
  short`Tests:       ${RED}${'inverse'}`,
  '',
  express(`${failedTests} failed,`, 'red', 'bold'), 
  ' ',
  express(`${skippedTests} skipped,`, 'yellow', 'bold'), 
  ' ',
  express(`${todoTests} todo,`, 'magenta', 'bold'), 
  ' ',
  express(`${passedTests} passed`, 'green', 'bold'),
  '',
  express('tests')
  )
