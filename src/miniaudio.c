#define STB_VORBIS_HEADER_ONLY
#include "stb_vorbis.c" /* Enables Vorbis decoding. */

#define MINIAUDIO_IMPLEMENTATION
// #define DRFLAC_NO_SSE41
#include "miniaudio.h"

/* stb_vorbis implementation must come after the implementation of miniaudio. */
#undef STB_VORBIS_HEADER_ONLY
#include "stb_vorbis.c"