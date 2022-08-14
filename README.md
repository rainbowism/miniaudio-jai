miniaudio-jai
=============
Jai bindings for [miniaudio](https://github.com/mackron/miniaudio).

Example
-------

This example shows one way to play a sound using the high level API.

```go
#import "Basic";
#import "miniaudio";
#load "util.jai";

main :: () {
    args := get_command_line_arguments();
    if args.count < 2 {
        print("No file given.");
        exit(-1);
    }

    result: ma_result;
    engine: ma_engine;

    result = ma_engine_init(null, *engine);
    if result != ma_result.SUCCESS {
        print("Failed to initialize audio engine.");
        exit(-1);
    }
    defer ma_engine_uninit(*engine);

    result = ma_engine_play_sound(*engine, args[1].data, null);
    if result != ma_result.SUCCESS {
        print("Invalid audio file.");
        exit(-1);
    }

    print("Press Enter to quit...");
    input();
}
```

More examples can be found in the examples folder or the original examples here: https://miniaud.io/docs/examples/