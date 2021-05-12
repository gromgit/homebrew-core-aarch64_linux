class Deno < Formula
  desc "Secure runtime for JavaScript and TypeScript"
  homepage "https://deno.land/"
  url "https://github.com/denoland/deno/releases/download/v1.10.1/deno_src.tar.gz"
  sha256 "947fa815f24d85d70bc3196c1180abe846ab104c9213c6b2b1a42c4a065ef5a5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "9c23361576802fdea1576381634d9ee423909cfcebc649d7206f1d2adea09d3f"
    sha256 cellar: :any_skip_relocation, big_sur:       "b0af185b3b0a98eb1cfcc61a9be05a3365c6a7db7557d5940c7e6935ad50cb9a"
    sha256 cellar: :any_skip_relocation, catalina:      "9546e9b38f1e70bfd3d54355fdba33df5c74347bd55cb0d2ef43d4636dca12f0"
    sha256 cellar: :any_skip_relocation, mojave:        "f4493e6a9ad71355a93d82cd5b0388d867de5f79163e0ff2058bf1a5cc1e2e17"
  end

  depends_on "llvm" => :build
  depends_on "ninja" => :build
  depends_on "rust" => :build
  depends_on xcode: ["10.0", :build] # required by v8 7.9+
  depends_on :macos # Due to Python 2 (see https://bugs.chromium.org/p/chromium/issues/detail?id=942720)

  uses_from_macos "xz"

  # To find the version of gn used:
  # 1. Find rusty_v8 version: https://github.com/denoland/deno/blob/v#{version}/core/Cargo.toml
  # 2. Find buildtools submodule commit: https://github.com/denoland/rusty_v8/tree/v#{rusty_v8_version}
  # 3. Check gn_version: https://github.com/denoland/chromium_buildtools/blob/#{buildtools_commit}/DEPS
  resource "gn" do
    url "https://gn.googlesource.com/gn.git",
        revision: "dfcbc6fed0a8352696f92d67ccad54048ad182b3"
  end

  def install
    # Overwrite Chromium minimum SDK version of 10.15
    ENV["FORCE_MAC_SDK_MIN"] = MacOS.version if MacOS.version < :mojave

    # env args for building a release build with our clang, ninja and gn
    ENV["GN"] = buildpath/"gn/out/gn"
    ENV["NINJA"] = Formula["ninja"].opt_bin/"ninja"
    # build rusty_v8 from source
    ENV["V8_FROM_SOURCE"] = "1"
    # Build with llvm and link against system libc++ (no runtime dep)
    ENV["CLANG_BASE_PATH"] = Formula["llvm"].prefix
    ENV.remove "HOMEBREW_LIBRARY_PATHS", Formula["llvm"].opt_lib

    resource("gn").stage buildpath/"gn"
    cd "gn" do
      system "python", "build/gen.py"
      system "ninja", "-C", "out"
    end

    cd "cli" do
      # cargo seems to build rusty_v8 twice in parallel, which causes problems,
      # hence the need for -j1
      system "cargo", "install", "-vv", "-j1", *std_cargo_args
    end

    bash_output = Utils.safe_popen_read("#{bin}/deno", "completions", "bash")
    (bash_completion/"deno").write bash_output
    zsh_output = Utils.safe_popen_read("#{bin}/deno", "completions", "zsh")
    (zsh_completion/"_deno").write zsh_output
    fish_output = Utils.safe_popen_read("#{bin}/deno", "completions", "fish")
    (fish_completion/"deno.fish").write fish_output
  end

  test do
    (testpath/"hello.ts").write <<~EOS
      console.log("hello", "deno");
    EOS
    assert_match "hello deno", shell_output("#{bin}/deno run hello.ts")
    assert_match "console.log",
      shell_output("#{bin}/deno run --allow-read=#{testpath} https://deno.land/std@0.50.0/examples/cat.ts " \
                   "#{testpath}/hello.ts")
  end
end
