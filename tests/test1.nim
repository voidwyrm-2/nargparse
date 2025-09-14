# To run these tests, simply execute `nimble test`.

import std/unittest

import nargparse


test "flagAndArgs":
  let
    argp = newArgparser("test-flagAndArgs")
    fA = argp.flag(["a"])
    fB = argp.flag(["b"])
    args = argp.parse(["-a", "cat", "dog"])

  require fA.exists
  require not fB.exists
  require args == @["cat", "dog"]

test "opt":
  let
    argp = newArgparser("test-opt")
    fOutput = argp.opt(["o", "output"])
    fWall = argp.flag(["Wall"])
    args = argp.parse(["-o", "main"])

  require fOutput.exists
  require fOutput.value() == "main"
  require not fWall.exists
  require args.len() == 0

test "optList":
  let
    argp = newArgparser("test-optList")
    fOutput = argp.opt(["o", "output"])
    fIncl = argp.optList(["incl"])
    args = argp.parse(["--incl", "libA", "--incl", "libB", "-incl", "libC"])

  require not fOutput.exists
  require fIncl.exists
  require fIncl.value() == @["libA", "libB", "libC"]
  require args.len() == 0

test "optSet":
  let
    argp = newArgparser("test-optSet")
    fColors = argp.optSet(["c", "colors"])
    args = argp.parse(["-c", "red", "--colors", "green", "-colors", "blue"])

  require fColors.exists
  require fColors.value() == toHashSet(["red", "green", "blue"])
  require args.len() == 0

test "optSetError":
  let
    argp = newArgparser("test-optSetError")
    fColors = argp.optSet(["c", "colors"])
  
  try:
    discard argp.parse(["-c", "red", "--colors", "red", "-colors", "purple"])
    require false
  except ArgparseError as e:
    require e.msg == "Argument 'red' was already passed for flag 'colors'"
