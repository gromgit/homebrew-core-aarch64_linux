class Launch < Formula
  desc "Command-line launcher for macOS, in the spirit of `open`"
  homepage "https://sabi.net/nriley/software/#launch"
  url "https://sabi.net/nriley/software/launch-1.2.5.tar.gz"
  sha256 "486632b11bee04d9f6bcb595fd2a68b5fde2f748ebdc182274778cc5cf97ff70"
  license "BSD-3-Clause"
  head "https://github.com/nriley/launch.git", branch: "master"

  livecheck do
    url "https://sabi.net/nriley/software/"
    regex(/href=.*?launch[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 aarch64_linux: "45492fb95de6a5adad25722737543da5f5b1b1b0a26c1816138fb9b43673ab37" # fake aarch64_linux
  end

  depends_on xcode: :build
  depends_on :macos

  def install
    rm_rf "launch" # We'll build it ourself, thanks.
    xcodebuild "-configuration", "Deployment", "SYMROOT=build", "clean"
    xcodebuild "-arch", Hardware::CPU.arch, "-configuration", "Deployment", "SYMROOT=build"

    man1.install gzip("launch.1")
    bin.install "build/Deployment/launch"
  end

  test do
    assert_equal "/", shell_output("#{bin}/launch -n /").chomp
  end
end
