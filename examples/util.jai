#if OS == .WINDOWS {
    input :: () -> string {
        stdin = GetStdHandle(STD_INPUT_HANDLE);
        MAX_BYTES_TO_READ :: 1024;
        buffer: [MAX_BYTES_TO_READ]u8;
        result: string = ---;
        bytes_read : s32;

        if !ReadConsoleA(stdin, buffer.data, xx buffer.count, *bytes_read) return "";

        result.data  = alloc(bytes_read);
        result.count = bytes_read;
        memcpy(result.data, buffer.data, bytes_read);
        return result;
    }
} else #if OS == .LINUX || OS == .MACOS {
    input :: () -> string {
        MAX_BYTES_TO_READ :: 1024;
        buffer: [MAX_BYTES_TO_READ]u8;
        result: string = ---;

        bytes_read := read(STDIN_FILENO, buffer.data, buffer.count-1);

        result.data  = alloc(bytes_read);
        result.count = bytes_read;
        memcpy(result.data, buffer.data, bytes_read);
        return result;
    }
}

#scope_file

#if OS == .WINDOWS {
    #import "Windows";

    kernel32 :: #foreign_system_library "kernel32";

    stdin:  HANDLE;
    stdout: HANDLE;

    ReadConsoleA  :: (
        hConsoleHandle:   HANDLE,
        buff:             *u8,
        chars_to_read:    s32,
        chars_read:       *s32,
        lpInputControl := *void
    ) -> BOOL #foreign kernel32;
} else #if OS == .LINUX || OS == .MACOS {
    #import "Basic";
    #import "POSIX";
}
