class Xctool < Formula
  desc "Drop-in replacement for xcodebuild with a few extra features"
  homepage "https://github.com/facebookarchive/xctool"
  url "https://github.com/facebookarchive/xctool/archive/0.3.7.tar.gz"
  sha256 "608522865dc42959a6240010c8295ce01278f4b7a8276d838f21a8973938206d"
  license "Apache-2.0"
  head "https://github.com/facebookarchive/xctool.git", branch: "master"

  bottle do
    sha256 aarch64_linux: "45492fb95de6a5adad25722737543da5f5b1b1b0a26c1816138fb9b43673ab37" # fake aarch64_linux
  end

  deprecate! date: "2021-05-24", because: :repo_archived

  depends_on :macos
  depends_on xcode: "7.0"

  def install
    xcodebuild "-workspace", "xctool.xcworkspace",
               "-scheme", "xctool",
               "-configuration", "Release",
               "SYMROOT=build",
               "-IDEBuildLocationStyle=Custom",
               "-IDECustomDerivedDataLocation=#{buildpath}",
               "XT_INSTALL_ROOT=#{libexec}"
    bin.install_symlink "#{libexec}/bin/xctool"
  end

  def post_install
    # all libraries need to be signed to avoid codesign errors when
    # injecting them into xcodebuild or Simulator.app.
    Dir.glob("#{libexec}/lib/*.dylib") do |lib_file|
      system "/usr/bin/codesign", "-f", "-s", "-", lib_file
    end
  end

  test do
    system "(#{bin}/xctool -help; true)"
  end
end
