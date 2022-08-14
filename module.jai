// Bindings for miniaudio.

// @@ Module options:

#if OS == .WINDOWS {
    #load "windows.jai";
} else {
    #load "unix.jai";
}
