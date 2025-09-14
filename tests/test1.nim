# To run these tests, simply execute `nimble test`.

import std/unittest

import nargparse


test "flag-and-args":
  let
    argp = newArgparser("test-flag-and-args")
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

test "multi-opt":
  let
    argp = newArgparser("test-multi-opt")
    fOutput = argp.opt(["o", "output"])
    fIncl = argp.opts(["incl"])
    args = argp.parse(["--incl", "libA", "--incl", "libB", "-incl", "libC"])

  require not fOutput.exists
  require fIncl.exists
  require fIncl.value() == @["libA", "libB", "libC"]
  require args.len() == 0
