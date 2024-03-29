class DartSdk < Formula
  desc "Dart Language SDK, including the VM, dart2js, core libraries, and more"
  homepage "https://dart.dev"
  url "https://github.com/dart-lang/sdk/archive/refs/tags/2.18.5.tar.gz"
  sha256 "81bbc28a148fe147676a8dde1dae4579cd7e760be60c332c2dfd3dcfbade0a93"
  license "BSD-3-Clause"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/dart-sdk"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "a1a4d7c832154e1df3cea6d860a26de690b8c534f357a4918a2834e896c0b74c"
  end

  depends_on "ninja" => :build
  depends_on "rust" => :build

  uses_from_macos "curl" => :build
  uses_from_macos "python" => :build
  uses_from_macos "xz" => :build

  resource "depot-tools" do
    url "https://chromium.googlesource.com/chromium/tools/depot_tools.git",
        revision: "6fde0fbe9226ae3fc9f5c709adb93249924e5c49"
  end

  def install
    mkdir "build" do
      resource("depot-tools").stage(buildpath/"depot-tools")

      ENV.append_path "PATH", "#{buildpath}/depot-tools"
      system "fetch", "--no-history", "dart"
      arch = Hardware::CPU.arm? ? "arm64" : "x64"
      chdir "sdk" do
        system "./tools/build.py", "--no-goma", "--mode=release", "--arch=#{arch}", "create_sdk"
      end
      out = OS.linux? ? "out" : "xcodebuild"
      libexec.install Dir["#{out}/Release#{arch.capitalize}/dart-sdk/*"]
    end
    bin.install_symlink libexec/"bin/dart"
  end

  test do
    system bin/"dart", "create", "dart-test"
    chdir "dart-test" do
      assert_match "Hello world: 42!", shell_output(bin/"dart run")
    end
  end
end
