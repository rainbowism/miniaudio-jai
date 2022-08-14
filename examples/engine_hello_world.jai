#import "Basic";
#import "miniaudio";
#load "util.jai";

// give this program an audio file to try it out

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

    result = ma_engine_play_sound(*engine, args[1].data, null);
    if result != ma_result.SUCCESS {
        print("Invalid audio file.");
        exit(-1);
    }

    print("Press Enter to quit...");
    test := input();

    ma_engine_uninit(*engine);
}
