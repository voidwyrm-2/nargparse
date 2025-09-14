import std/[
  os
]

import ../src/nargparse


const colors = ["red", "green", "blue"]


proc main() =
  let
    argp = newArgparser("example")
    fHelp = argp.flag("h", "help", help="Displays the help message.")
    fOutput = argp.opt("o", "output", help="Sets the file to write to; default is stdout.")
    fColors = argp.optSet("c", "colors", help="Defines a color.")
  
  var args: seq[string]
  try:
    args = argp.parse(commandLineParams())
  except ArgparseError as e:
    echo e.msg
    echo argp
    quit 1

  var f = stdout

  if fOutput.exists:
    if not open(f, fOutput.value, fmWrite):
      echo "Could not open '", fOutput.value, "'"
      quit 1

  defer:
    if fOutput.exists:
      f.close()

  if fHelp.exists:
    f.writeLine argp
    quit 0

  for color in colors:
    if color in fColors.value:
      f.writeLine "'", color, "' was passed"

when isMainModule:
  main()
