require "language/node"

class Emscripten < Formula
  desc "LLVM bytecode to JavaScript compiler"
  homepage "https://emscripten.org/"

  stable do
    url "https://github.com/emscripten-core/emscripten/archive/1.39.17.tar.gz"
    sha256 "27240a87c7d30eedab3a4cb0af35c15da03e7ced6c91890f8e455e87028a7227"

    resource "fastcomp" do
      url "https://github.com/emscripten-core/emscripten-fastcomp/archive/1.39.17.tar.gz"
      sha256 "417ae794b92bb1f4bd5e88ba2292fe50c8622f7e2f77e6e91afcf90d3fc4e35a"
    end

    resource "fastcomp-clang" do
      url "https://github.com/emscripten-core/emscripten-fastcomp-clang/archive/1.39.17.tar.gz"
      sha256 "7d83e04971bdd0dca3767ab0755d00fa5fba4f38cc2a679d8cff8256837fef64"
    end
  end

  bottle do
    cellar :any
    sha256 "302adf7f4f17fe9bd2d595dbda3f4ce1b7b8f4246b6bfc1b21eb6a18c8bbbf79" => :catalina
    sha256 "eaf8320f5ab7f70e8bcf3b5f4597cdc2b9d58ff615eddc76b8f791fcaae5e106" => :mojave
    sha256 "509d3d0b14d1ff6629e402d6486501988fcdf1d3c7e21ee486de9c3906eb5fea" => :high_sierra
  end

  head do
    url "https://github.com/emscripten-core/emscripten.git", :branch => "incoming"

    resource "fastcomp" do
      url "https://github.com/emscripten-core/emscripten-fastcomp.git", :branch => "incoming"
    end

    resource "fastcomp-clang" do
      url "https://github.com/emscripten-core/emscripten-fastcomp-clang.git", :branch => "incoming"
    end
  end

  depends_on "cmake" => :build
  depends_on "binaryen"
  depends_on "node"
  depends_on "python@3.8"
  depends_on "yuicompressor"

  def install
    ENV.cxx11

    # All files from the repository are required as emscripten is a collection
    # of scripts which need to be installed in the same layout as in the Git
    # repository.
    libexec.install Dir["*"]

    (buildpath/"fastcomp").install resource("fastcomp")
    (buildpath/"fastcomp/tools/clang").install resource("fastcomp-clang")

    cmake_args = std_cmake_args.reject { |s| s["CMAKE_INSTALL_PREFIX"] }
    cmake_args = [
      "-DCMAKE_BUILD_TYPE=Release",
      "-DCMAKE_INSTALL_PREFIX=#{libexec}/llvm",
      "-DLLVM_TARGETS_TO_BUILD='X86;JSBackend'",
      "-DLLVM_INCLUDE_EXAMPLES=OFF",
      "-DLLVM_INCLUDE_TESTS=OFF",
      "-DCLANG_INCLUDE_TESTS=OFF",
      "-DOCAMLFIND=/usr/bin/false",
      "-DGO_EXECUTABLE=/usr/bin/false",
    ]

    mkdir "fastcomp/build" do
      system "cmake", "..", *cmake_args
      system "make"
      system "make", "install"
    end

    cd libexec do
      system "npm", "install", *Language::Node.local_npm_install_args
      rm_f "node_modules/ws/builderror.log" # Avoid references to Homebrew shims
    end

    %w[em++ em-config emar emcc emcmake emconfigure emlink.py emmake
       emranlib emrun emscons].each do |emscript|
      (bin/emscript).write_env_script libexec/emscript, :PYTHON => Formula["python@3.8"].opt_bin/"python3"
    end
  end

  def caveats
    <<~EOS
      Manually set LLVM_ROOT to
        #{opt_libexec}/llvm/bin
      and BINARYEN_ROOT to
        #{Formula["binaryen"].opt_prefix}
      in ~/.emscripten after running `emcc` for the first time.
    EOS
  end

  test do
    system bin/"emcc"
    assert_predicate testpath/".emscripten", :exist?, "Failed to create sample config"
  end
end
