# build.jl
using Compat

depsdir = dirname(@__FILE__)
libfilename = "libqref.so"

if Compat.Sys.iswindows()
    libfilename = "libqref.dll"
else
    if Compat.Sys.isapple()
        libfilename = "libqref.dylib"
    end
    shared_flag = Compat.Sys.isapple() ? "-dynamiclib" : "-shared"

    cd(joinpath(depsdir, "qref"))
    run(`gcc $shared_flag -o ../$libfilename -fPIC qref.c`)
end

open(joinpath(depsdir, "deps.jl"), "w") do f
    print(f, "const libqref = \"$(escape_string(joinpath((depsdir), libfilename)))\"")
end