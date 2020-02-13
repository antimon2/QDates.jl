using PackageCompiler

ENV["QDATES_BUILD_APP"] = "1"
create_app(".", "build", force=true)
