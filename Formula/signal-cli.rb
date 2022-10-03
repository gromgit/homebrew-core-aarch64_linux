class SignalCli < Formula
  desc "CLI and dbus interface for WhisperSystems/libsignal-service-java"
  homepage "https://github.com/AsamK/signal-cli"
  url "https://github.com/AsamK/signal-cli/archive/refs/tags/v0.11.0.tar.gz"
  sha256 "ec174af007ff1717ef820720182e7c0b21e75aae9cc5bed714f05c16b8381faf"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "596dca22450d4bdf73f421213154c35e3f3fc6fddd4108631d40a1d4e24259db"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4582f1efffd20a293edc968abb7d0d0c2eaa28b3869880d27725f611dd9b677b"
    sha256 cellar: :any_skip_relocation, monterey:       "81cc6fbd8a2965335c2cff8c7deb46357fd20bea5647a470a0cb48002993a609"
    sha256 cellar: :any_skip_relocation, big_sur:        "08c834623e4e628c38f1bf6a36b468c8e980f8ac4f361ead18f2d32ecc96c6b0"
    sha256 cellar: :any_skip_relocation, catalina:       "00969179a4427b191a7b4976dd63d4b13a4874147910aa1cafa60a7f50a51dcf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "424b76676ebcff162afe6e210810f8b03074dd5f57860637aa3435781449a113"
  end

  depends_on "cmake" => :build # For `boring-sys` crate in `libsignal-client`
  depends_on "gradle" => :build
  depends_on "protobuf" => :build
  # the libsignal-client build targets a specific rustc listed in the file
  # https://github.com/signalapp/libsignal/blob/#{libsignal-client.version}/rust-toolchain
  # which doesn't automatically happen if we use brew-installed rust. rustup-init
  # allows us to use a toolchain that lives in HOMEBREW_CACHE
  depends_on "rustup-init" => :build

  depends_on "openjdk"

  uses_from_macos "llvm" => :build # For `libclang`, used by `boring-sys` crate
  uses_from_macos "zip" => :build

  # per https://github.com/AsamK/signal-cli/wiki/Provide-native-lib-for-libsignal#libsignal-client
  # we want the specific libsignal-client version from 'signal-cli-#{version}/lib/libsignal-client-X.X.X.jar'
  resource "libsignal-client" do
    url "https://github.com/signalapp/libsignal/archive/refs/tags/v0.20.0.tar.gz"
    sha256 "baed0958835107fb96b565102a3bd1309f27c747b5b68d77cb12239acfd1b553"
  end

  def install
    system "gradle", "build"
    system "gradle", "installDist"
    libexec.install (buildpath/"build/install/signal-cli").children
    (libexec/"bin/signal-cli.bat").unlink
    (bin/"signal-cli").write_env_script libexec/"bin/signal-cli", Language::Java.overridable_java_home_env

    # this will install the necessary cargo/rustup toolchain bits in HOMEBREW_CACHE
    system Formula["rustup-init"].bin/"rustup-init", "-qy", "--no-modify-path"
    ENV.prepend_path "PATH", HOMEBREW_CACHE/"cargo_cache/bin"

    resource("libsignal-client").stage do |r|
      # https://github.com/AsamK/signal-cli/wiki/Provide-native-lib-for-libsignal#building-libsignal-client-yourself

      libsignal_client_jar = libexec.glob("lib/libsignal-client-*.jar").first
      embedded_jar_version = Version.new(libsignal_client_jar.to_s[/libsignal-client-(.*)\.jar$/, 1])
      odie "#{r.name} needs to be updated to #{embedded_jar_version}!" unless embedded_jar_version == r.version

      # rm originally-embedded libsignal_jni lib
      system "zip", "-d", libsignal_client_jar, "libsignal_jni.so", "libsignal_jni.dylib", "signal_jni.dll"

      # build & embed library for current platform
      cd "java" do
        inreplace "settings.gradle", "include ':android'", ""
        system "./build_jni.sh", "desktop"
        cd "shared/resources" do
          system "zip", "-u", libsignal_client_jar, shared_library("libsignal_jni")
        end
      end
    end
  end

  test do
    # test 1: checks class loading is working and version is correct
    output = shell_output("#{bin}/signal-cli --version")
    assert_match "signal-cli #{version}", output

    # test 2: ensure crypto is working
    begin
      io = IO.popen("#{bin}/signal-cli link", err: [:child, :out])
      sleep 24
    ensure
      Process.kill("SIGINT", io.pid)
      Process.wait(io.pid)
    end
    assert_match "sgnl://linkdevice?uuid=", io.read
  end
end
