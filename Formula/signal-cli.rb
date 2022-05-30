class SignalCli < Formula
  desc "CLI and dbus interface for WhisperSystems/libsignal-service-java"
  homepage "https://github.com/AsamK/signal-cli"
  url "https://github.com/AsamK/signal-cli/archive/refs/tags/v0.10.7.tar.gz"
  sha256 "c577673b40c82ca3242d2ec5ed3305b380cd400856cf3f8504afea56845c7538"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7b86b1d7df87deeb644f5c05259a0b652729ec55962575a5299371e568218597"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8073a963756f5941714309ae2b8a9e96b21abc50fab59fbed8087cd7593eab8f"
    sha256 cellar: :any_skip_relocation, monterey:       "03351fc76ddb40e4b3d6681c3a361bc85c01d16030702a43e9d7e8ff53768ab5"
    sha256 cellar: :any_skip_relocation, big_sur:        "f54a9ab39ffb9a5a8e97174fed7ceeca1853b25760abb207d86f7eb65b60ea4e"
    sha256 cellar: :any_skip_relocation, catalina:       "2b92d438aaddbfefcc618affd038dbe7941e99d131c3987309bd589b64c0981a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "773b9bc0521d6266d598b63c91cba1b138c9b7b1b21cf0e6c2dabb9ae970f06c"
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
