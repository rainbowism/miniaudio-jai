#import "Basic";
#import "miniaudio";
#load "util.jai";

DELAY_IN_SECONDS :: 0.2;
DECAY            :: 0.25; /* Volume after each echo. */

// give this program an audio file to try it out

main :: () {
    args := get_command_line_arguments();
    if args.count < 2 {
        print("No file given.");
        exit(-1);
    }


    result:     ma_result;
    engine:     ma_engine;
    sound:      ma_sound;      /* This example will play only a single sound at once, so we only need one ma_sound object. */
    delay_node: ma_delay_node; /* The echo effect is achieved using a delay node. */

    /* The engine needs to be initialized first. */
    result = ma_engine_init(null, *engine);
    if result != ma_result.SUCCESS {
        print("Failed to initialize audio engine.");
        exit(-1);
    }
    defer ma_engine_uninit(*engine);


    /*
    We'll build our graph starting from the end so initialize the delay node now. The output of
    this node will be connected straight to the output. You could also attach it to a sound group
    or any other node that accepts an input.

    Creating a node requires a pointer to the node graph that owns it. The engine itself is a node
    graph. In the code below we can get a pointer to the node graph with ma_engine_get_node_graph()
    or we could simple cast the engine to a *ma_node_graph like so:

        `cast(*ma_node_graph) *engine` or `xx *engine`

    The endpoint of the graph can be retrieved with ma_engine_get_endpoint().
    */

    channels          := ma_engine_get_channels(*engine);
    sample_rate       := ma_engine_get_sample_rate(*engine);
    delay_node_config := ma_delay_node_config_init(channels, sample_rate, xx (sample_rate * DELAY_IN_SECONDS), DECAY);

    result = ma_delay_node_init(ma_engine_get_node_graph(*engine), *delay_node_config, null, *delay_node);
    // alternative, autocast the engine pointer using `xx`
    // result = ma_delay_node_init(xx *engine, *delay_node_config, null, *delay_node);
    if result != ma_result.SUCCESS {
        print("Failed to initialize delay node.");
        exit(-1);
    }
    defer ma_delay_node_uninit(*delay_node, null);

    /* Connect the output of the delay node to the input of the endpoint. */
    result = ma_node_attach_output_bus(*delay_node, 0, ma_engine_get_endpoint(*engine), 0);
    if result != ma_result.SUCCESS {
        print("Failed to attach delay node to the output bus.");
        exit(-1);
    }


    /* Now we can load the sound and connect it to the delay node. */
    result = ma_sound_init_from_file(*engine, args[1].data, 0, null, null, *sound);
    if result != ma_result.SUCCESS {
        print("Failed to initialize sound \"%s\".", args[1]);
        exit(-1);
    }

    /* Connect the output of the sound to the input of the effect. */
    ma_node_attach_output_bus(*sound, 0, *delay_node, 0);

    /*
    Start the sound after it's applied to the sound. Otherwise there could be a scenario where
    the very first part of it is read before the attachment to the effect is made.
    */
    ma_sound_start(*sound);
    defer ma_sound_uninit(*sound);


    print("Press Enter to quit...");
    input();
}