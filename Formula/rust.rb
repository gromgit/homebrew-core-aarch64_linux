class Rust < Formula
  desc "Safe, concurrent, practical language"
  homepage "https://www.rust-lang.org/"
  license any_of: ["Apache-2.0", "MIT"]

  stable do
    url "https://static.rust-lang.org/dist/rustc-1.65.0-src.tar.gz"
    sha256 "5828bb67f677eabf8c384020582b0ce7af884e1c84389484f7f8d00dd82c0038"

    # From https://github.com/rust-lang/rust/tree/#{version}/src/tools
    resource "cargo" do
      url "https://github.com/rust-lang/cargo.git",
          tag:      "0.66.0",
          revision: "4bc8f24d3e899462e43621aab981f6383a370365"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "8aeff32ba973fa25f7f8aaf9505598301f8395c5cf7681ebad9c5399703712f8"
    sha256 cellar: :any,                 arm64_monterey: "8dc565cec1ce7e3de02767375cec3de456298d6be59143444b2a0315d2a04dbe"
    sha256 cellar: :any,                 arm64_big_sur:  "bd5fa05814c06b857ac3e5845a04377be0643ef6d7181663a5c09b77a7991de7"
    sha256 cellar: :any,                 ventura:        "045212c82a2e28150e68049ce669e1a57a63007049415684dd07ab60f844e165"
    sha256 cellar: :any,                 monterey:       "6c40aabd9b5cd781238d2194113ced08d7557179103c62860fa4a797eb6e4e6b"
    sha256 cellar: :any,                 big_sur:        "a505d9712f6c1218656ae5d6348d9147623964996b4b53a83ad398770dc1fe01"
    sha256 cellar: :any,                 catalina:       "83741144cb435e4fda92457c48e3b37f4283267301f3021c6294348739db5f9b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c6e831f278e98ae0fb59444b054f9cca1d6b9ec6eb30fb27985567d4da7321b9"
  end

  head do
    url "https://github.com/rust-lang/rust.git", branch: "master"

    resource "cargo" do
      url "https://github.com/rust-lang/cargo.git", branch: "master"
    end
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "python@3.10" => :build
  depends_on "libssh2"
  depends_on "openssl@1.1"
  depends_on "pkg-config"

  uses_from_macos "curl"
  uses_from_macos "zlib"

  resource "cargobootstrap" do
    on_macos do
      # From https://github.com/rust-lang/rust/blob/#{version}/src/stage0.json
      on_arm do
        url "https://static.rust-lang.org/dist/2022-09-22/cargo-1.64.0-aarch64-apple-darwin.tar.gz"
        sha256 "dbb26b73baefc8351a7024f307445758fe1e9c18d83000358c02b80a5b1003b3"
      end
      on_intel do
        url "https://static.rust-lang.org/dist/2022-09-22/cargo-1.64.0-x86_64-apple-darwin.tar.gz"
        sha256 "e032116e22f6d3a4cb078f21031794e88f2a87f066625b8eb7623777e42d6eca"
      end
    end

    on_linux do
      # From: https://github.com/rust-lang/rust/blob/#{version}/src/stage0.json
      url "https://static.rust-lang.org/dist/2022-09-22/cargo-1.64.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "12c2e61bf7de8b37c16d0323972a6085f9e01ee6d716549dd1ef4a92481b0610"
    end
  end

  def install
    ENV.prepend_path "PATH", Formula["python@3.10"].opt_libexec/"bin"

    # Ensure that the `openssl` crate picks up the intended library.
    # https://crates.io/crates/openssl#manual-configuration
    ENV["OPENSSL_DIR"] = Formula["openssl@1.1"].opt_prefix

    if OS.mac? && MacOS.version <= :sierra
      # Requires the CLT to be the active developer directory if Xcode is installed
      ENV["SDKROOT"] = MacOS.sdk_path
      # Fix build failure for compiler_builtins "error: invalid deployment target
      # for -stdlib=libc++ (requires OS X 10.7 or later)"
      ENV["MACOSX_DEPLOYMENT_TARGET"] = MacOS.version
    end

    args = %W[--prefix=#{prefix} --enable-vendor --set rust.jemalloc]
    if build.head?
      args << "--disable-rpath"
      args << "--release-channel=nightly"
    else
      args << "--release-channel=stable"
    end

    system "./configure", *args
    system "make"
    system "make", "install"

    resource("cargobootstrap").stage do
      system "./install.sh", "--prefix=#{buildpath}/cargobootstrap"
    end
    ENV.prepend_path "PATH", buildpath/"cargobootstrap/bin"

    resource("cargo").stage do
      ENV["RUSTC"] = bin/"rustc"
      args = %W[--root #{prefix} --path .]
      args += %w[--features curl-sys/force-system-lib-on-osx] if OS.mac?
      system "cargo", "install", *args
      man1.install Dir["src/etc/man/*.1"]
      bash_completion.install "src/etc/cargo.bashcomp.sh"
      zsh_completion.install "src/etc/_cargo"
    end

    (lib/"rustlib/src/rust").install "library"
    rm_rf prefix/"lib/rustlib/uninstall.sh"
    rm_rf prefix/"lib/rustlib/install.log"
  end

  def post_install
    Dir["#{lib}/rustlib/**/*.dylib"].each do |dylib|
      chmod 0664, dylib
      MachO::Tools.change_dylib_id(dylib, "@rpath/#{File.basename(dylib)}")
      chmod 0444, dylib
    end
  end

  test do
    system bin/"rustdoc", "-h"
    (testpath/"hello.rs").write <<~EOS
      fn main() {
        println!("Hello World!");
      }
    EOS
    system bin/"rustc", "hello.rs"
    assert_equal "Hello World!\n", shell_output("./hello")
    system bin/"cargo", "new", "hello_world", "--bin"
    assert_equal "Hello, world!", cd("hello_world") { shell_output("#{bin}/cargo run").split("\n").last }
  end
end
