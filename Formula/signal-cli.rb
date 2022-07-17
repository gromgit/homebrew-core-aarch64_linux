class SignalCli < Formula
  desc "CLI and dbus interface for WhisperSystems/libsignal-service-java"
  homepage "https://github.com/AsamK/signal-cli"
  url "https://github.com/AsamK/signal-cli/archive/refs/tags/v0.10.9.tar.gz"
  sha256 "e261116bebb781594974c2894eb001a599a4ffac7a2d8d0da976b33315215747"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6326326ff300650c5abd3ab3e7319f6f40971ae3a81045f68ed18866be9b2702"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "246910c7fdc2523ad51c52640be835c035ba0bd6ca4c1d3c9f3b841621e95bea"
    sha256 cellar: :any_skip_relocation, monterey:       "6a05fcda560e5d685084f5b101ea8f82041810cefa2323f96b0454815c4a92ac"
    sha256 cellar: :any_skip_relocation, big_sur:        "5bf6b91caba2139604395e2200da2a7ff0d028915976495c257433bbcaf7106b"
    sha256 cellar: :any_skip_relocation, catalina:       "2d29ed255b33f74211587c7982b93a72997658c496c1522cb45d80d7be8fa19d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d64cff1e3c52cd2bb4125d21500f37cf1b6ab695c4e9cc388db90a45e5078ffc"
  end

  depends_on "gradle" => :build
  depends_on "protobuf" => :build
  # the libsignal-client build targets a specific rustc listed in the file
  # https://github.com/signalapp/libsignal/blob/#{libsignal-client.version}/rust-toolchain
  # which doesn't automatically happen if we use brew-installed rust. rustup-init
  # allows us to use a toolchain that lives in HOMEBREW_CACHE
  depends_on "rustup-init" => :build

  depends_on "openjdk"

  uses_from_macos "zip" => :build

  # per https://github.com/AsamK/signal-cli/wiki/Provide-native-lib-for-libsignal#libsignal-client
  # we want the specific libsignal-client version from 'signal-cli-#{version}/lib/libsignal-client-X.X.X.jar'
  resource "libsignal-client" do
    url "https://github.com/signalapp/libsignal/archive/refs/tags/v0.17.0.tar.gz"
    sha256 "7866ae9679c482a16dc4ef3fd3891e558ce0615234e7e775f887190782a88b63"
  end

  def install
    system "gradle", "build"
    system "gradle", "installDist"
    libexec.install Dir["build/install/signal-cli/*"]
    (libexec/"bin/signal-cli.bat").unlink
    (bin/"signal-cli").write_env_script libexec/"bin/signal-cli", Language::Java.overridable_java_home_env

    # this will install the necessary cargo/rustup toolchain bits in HOMEBREW_CACHE
    system Formula["rustup-init"].bin/"rustup-init", "-qy", "--no-modify-path"
    ENV.prepend_path "PATH", HOMEBREW_CACHE/"cargo_cache/bin"

    resource("libsignal-client").stage do |r|
      # https://github.com/AsamK/signal-cli/wiki/Provide-native-lib-for-libsignal#building-libsignal-client-yourself

      libsignal_client_jar = libexec/"lib/libsignal-client-#{r.version}.jar"
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
