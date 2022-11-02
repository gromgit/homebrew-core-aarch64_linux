class RustupInit < Formula
  desc "Rust toolchain installer"
  homepage "https://github.com/rust-lang/rustup"
  url "https://github.com/rust-lang/rustup/archive/1.25.1.tar.gz"
  sha256 "4d062c77b08309bd212f22dd7da1957c1882509c478e57762f34ec4fb2884c9a"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/rustup-init"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "59db57b07bff5ddebb6c49d78706d58af288c02d3d8376060bac3c042248f690"
  end

  depends_on "rust" => :build

  uses_from_macos "curl"
  uses_from_macos "xz"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@1.1"
  end

  def install
    system "cargo", "install", "--features", "no-self-update", *std_cargo_args
  end

  test do
    ENV["CARGO_HOME"] = testpath/".cargo"
    ENV["RUSTUP_HOME"] = testpath/".multirust"

    system bin/"rustup-init", "-y"
    (testpath/"hello.rs").write <<~EOS
      fn main() {
        println!("Hello World!");
      }
    EOS
    system testpath/".cargo/bin/rustc", "hello.rs"
    assert_equal "Hello World!", shell_output("./hello").chomp
  end
end
