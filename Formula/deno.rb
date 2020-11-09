class Deno < Formula
  desc "Secure runtime for JavaScript and TypeScript"
  homepage "https://deno.land/"
  url "https://github.com/denoland/deno/releases/download/v1.5.2/deno_src.tar.gz"
  sha256 "28730fcbbf6c99202b1d5121241dcb2b60267576e02f0e1d627ecc4490ef772b"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "f6688b6b2a5cff865af2ac2d51387cb17fb8482cd0a0c4e7815a7fe1fc48b3d0" => :catalina
    sha256 "f74dc854ff06e923bec88f2ae6045400f6c7cfd93d6af3d724565d754893edad" => :mojave
    sha256 "6c03fd0b758eeb270ad78580cd1a6d31d436467f6618ef99f5ae0b8b64f4f69a" => :high_sierra
  end

  depends_on "llvm" => :build
  depends_on "rust" => :build
  depends_on xcode: ["10.0", :build] # required by v8 7.9+
  depends_on :macos # Due to Python 2 (see https://github.com/denoland/deno/issues/2893)

  uses_from_macos "xz"

  def install
    # env args for building a release build with our clang, ninja and gn
    ENV["GN"] = buildpath/"gn/out/gn"
    # build rusty_v8 from source
    ENV["V8_FROM_SOURCE"] = "1"
    # overwrite Chromium minimum sdk version of 10.15
    ENV["FORCE_MAC_SDK_MIN"] = "10.13"
    # build with llvm and link against system libc++ (no runtime dep)
    ENV["CLANG_BASE_PATH"] = Formula["llvm"].prefix
    ENV.remove "HOMEBREW_LIBRARY_PATHS", Formula["llvm"].opt_lib

    cd "cli" do
      system "cargo", "install", "-vv", *std_cargo_args
    end

    # Install bash and zsh completion
    output = Utils.safe_popen_read("#{bin}/deno", "completions", "bash")
    (bash_completion/"deno").write output
    output = Utils.safe_popen_read("#{bin}/deno", "completions", "zsh")
    (zsh_completion/"_deno").write output
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
