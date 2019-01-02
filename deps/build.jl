# build.jl

depsdir = dirname(@__FILE__)
libfilename = "libqref.so"

if Sys.iswindows()
    libfilename = "libqref.dll"
else
    if Sys.isapple()
        libfilename = "libqref.dylib"
    end
    shared_flag = Sys.isapple() ? "-dynamiclib" : "-shared"

    cd(joinpath(depsdir, "qref"))
    run(`gcc $shared_flag -o ../$libfilename -fPIC qref.c`)
end

open(joinpath(depsdir, "deps.jl"), "w") do f
    print(f, "const libqref = \"$(escape_string(joinpath((depsdir), libfilename)))\"")
end