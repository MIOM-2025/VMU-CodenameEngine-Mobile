#!/usr/bin/env python3
"""Keep a single definition of lime::JNI::GetEnv on Android.

cne-lime currently defines it in both src/system/JNI.cpp (Android only) and
src/backend/sdl/SDLSystem.cpp (all LIME_SDL targets), which makes the Android
link fail with a duplicate symbol.  Keep the JNI.cpp implementation on Android
and leave the SDLSystem fallback for the other platforms.
"""

import sys

OLD = (
    "\tvoid *JNI::GetEnv () {\n"
    "\n"
    "\t\t#ifdef ANDROID\n"
    "\t\treturn SDL_GetAndroidJNIEnv ();\n"
    "\t\t#else\n"
    "\t\treturn 0;\n"
    "\t\t#endif\n"
    "\n"
    "\t}\n"
)

NEW = (
    "\t#ifndef ANDROID\n"
    "\tvoid *JNI::GetEnv () {\n"
    "\n"
    "\t\treturn 0;\n"
    "\n"
    "\t}\n"
    "\t#endif\n"
)


def main(path: str) -> int:
    with open(path, "r", encoding="utf-8") as handle:
        source = handle.read()

    if OLD not in source:
        # Upstream may have fixed it already: nothing to patch.
        print(f"JNI::GetEnv block not found in {path} (already fixed?)")
        return 0

    with open(path, "w", encoding="utf-8") as handle:
        handle.write(source.replace(OLD, NEW, 1))
    print(f"patched {path}")
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1]))
