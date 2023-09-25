import terminal, strutils, os

const vowels = { 'a', 'e', 'i', 'o', 'u' }
proc pluralize*(word: string): string =
  ## Form English plural of word via all rules not needing a real dictionary.
  proc consOr1Vowel(s: string): bool =
    s[^1] notin vowels or (s.len > 1 and s[^2] notin vowels)
  let w = word.toLowerAscii
  if w.len < 2                            : word & "s"
  elif w[^1] == 'z'                       : word & "zes"
  elif w[^1] in { 's', 'x' }              : word & "es"
  elif w[^2..^1] == "sh"                  : word & "es"
  elif w[^2..^1] == "ch"                  : word & "es"   #XXX 'k'-sound => "s"
  elif w[^1] == 'y' and w[^2] notin vowels: word[0..^2] & "ies"
  elif w[^1] == 'f' and consOr1Vowel(w[0..^2]): word[0..^2] & "ves"
  elif w[^2..^1] == "fe" and consOr1Vowel(w[0..^3]): word[0..^3] & "ves"
  else                                    : word & "s"

iterator argsatty*(args: seq[string] = os.commandLineParams()): string =
  if args.len > 0: 
    for arg in args:
      yield arg
  elif not stdin.isatty:
    for line in stdin.lines():
      yield line

when isMainModule:
  for arg in argsatty():
    echo pluralize(arg)
