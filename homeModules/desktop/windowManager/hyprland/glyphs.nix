# Nerd Font glyph by code point. Literal glyphs get lost when files are written, escapes do not.
{ lib }:

code:
let
  offset = lib.fromHexString code - 65536;
  high = lib.toHexString (55296 + offset / 1024);
  low = lib.toHexString (56320 + lib.mod offset 1024);
in
builtins.fromJSON ''"\u${high}\u${low}"''
