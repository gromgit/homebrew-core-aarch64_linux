class Rem < Formula
  desc "Command-line tool to access OSX Reminders.app database"
  homepage "https://github.com/kykim/rem"
  url "https://github.com/kykim/rem/archive/20150618.tar.gz"
  sha256 "e57173a26d2071692d72f3374e36444ad0b294c1284e3b28706ff3dbe38ce8af"
  license "Apache-2.0"

  bottle do
    sha256 aarch64_linux: "45492fb95de6a5adad25722737543da5f5b1b1b0a26c1816138fb9b43673ab37" # fake aarch64_linux
  end

  depends_on xcode: :build
  depends_on :macos

  conflicts_with "remind", because: "both install `rem` binaries"

  def install
    xcodebuild "-arch", Hardware::CPU.arch, "SYMROOT=build"
    bin.install "build/Release/rem"
  end

  test do
    system "#{bin}/rem", "version"
  end
end
