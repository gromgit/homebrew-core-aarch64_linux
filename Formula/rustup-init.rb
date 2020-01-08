class RustupInit < Formula
  desc "The Rust toolchain installer"
  homepage "https://github.com/rust-lang/rustup.rs"
  url "https://github.com/rust-lang/rustup.rs/archive/1.21.1.tar.gz"
  sha256 "3dd54cb15313ff01c930ad4e36326f7d60caadd2d6707790d83bea26fbb8bbe1"

  bottle do
    cellar :any_skip_relocation
    sha256 "dcfa31ebf56502047530a96d741e8d5a5631e25cff964d108963327fd2f31068" => :catalina
    sha256 "59a05d34a7ac1dd39d96698c46865c6c6113a5465aaa9e82bfe99ce0c7d45f4f" => :mojave
    sha256 "8c279d7a186437297b3cb28359392ed779561142e38c898d6a02a2370f1f6b3c" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    cargo_home = buildpath/"cargo_home"
    cargo_home.mkpath
    ENV["CARGO_HOME"] = cargo_home

    system "cargo", "install", "--locked", "--root", prefix, "--path", ".",
                    "--features", "no-self-update"
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
