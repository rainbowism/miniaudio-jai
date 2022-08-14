#run {
    set_build_options_dc(.{do_output=false});
    if !generate_bindings() {
        compiler_set_workspace_status(.FAILED);
    }
}

generate_bindings :: () -> bool {
    output_filename: string;
    opts: Generate_Bindings_Options;
    {
        using opts;

        #if OS == .WINDOWS {
            array_add(*libpaths, "win");
            output_filename                       = "windows.jai";
            generate_foreign_library_declarations = false;
            footer                                = WINDOWS_FOOTER;
        } else #if OS == .LINUX {
            #assert false;
            // @Todo(sushi): set up builds for linux and macos
            // array_add(*libpaths, "linux");
            // output_name                           = "unix.jai";
            // generate_foreign_library_declarations = false;
            // footer                                = UNIX_FOOTER;
        } else #if OS == .MACOS {
            #assert false;
            // @ToDo: Determine dynamically? Customize?
            // array_add(*system_include_paths, "/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/usr/include");
            // array_add(*libpaths, "mac");
            // output_name                           = "unix.jai";
            // generate_foreign_library_declarations = false;
            // footer                                = UNIX_FOOTER;
        } else {
            #assert false;
        }

        array_add(*libnames,                "miniaudio");
        array_add(*system_include_paths,    GENERATOR_DEFAULT_SYSTEM_INCLUDE_PATH);
        array_add(*source_files,            "src/miniaudio.h");
        auto_detect_enum_prefixes           = true;
        generate_compile_time_struct_checks = false;
    }

    return generate_bindings(opts, output_filename);
}

#import "Basic";
#import "Compiler";
#import "Bindings_Generator";
#import "File";

WINDOWS_FOOTER :: #string END
size_t :: s32;
wchar_t :: u16;

miniaudio :: #foreign_library,no_dll "win/miniaudio";

END

UNIX_FOOTER :: #string END
#if OS == .LINUX {
    miniaudio :: #foreign_library "linux/miniaudio";
} else {
    miniaudio :: #foreign_library "mac/miniaudio";
}

END
