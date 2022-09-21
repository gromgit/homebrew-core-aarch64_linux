class ObjcCodegenutils < Formula
  desc "Three small tools to help work with XCode"
  homepage "https://github.com/square/objc-codegenutils"
  url "https://github.com/square/objc-codegenutils/archive/v1.0.tar.gz"
  sha256 "98b8819e77e18029f1bda56622d42c162e52ef98f3ba4c6c8fcf5d40c256e845"
  license "Apache-2.0"
  head "https://github.com/square/objc-codegenutils.git", branch: "master"

  bottle do
    sha256 aarch64_linux: "45492fb95de6a5adad25722737543da5f5b1b1b0a26c1816138fb9b43673ab37" # fake aarch64_linux
  end

  depends_on xcode: :build
  depends_on :macos

  def install
    xcodebuild "-arch", Hardware::CPU.arch, "-project", "codegenutils.xcodeproj", "-target", "assetgen",
               "-configuration", "Release", "SYMROOT=build", "OBJROOT=build"
    bin.install "build/Release/objc-assetgen"
    xcodebuild "-arch", Hardware::CPU.arch, "-target", "colordump", "-configuration", "Release", "SYMROOT=build",
               "OBJROOT=build"
    bin.install "build/Release/objc-colordump"
    xcodebuild "-arch", Hardware::CPU.arch, "-target", "identifierconstants", "-configuration", "Release",
               "SYMROOT=build", "OBJROOT=build"
    bin.install "build/Release/objc-identifierconstants"
  end

  test do
    # Would do more verification here but it would require fixture Xcode projects not in the main repo
    system "#{bin}/objc-assetgen", "-h"
    system "#{bin}/objc-colordump", "-h"
    system "#{bin}/objc-identifierconstants", "-h"
  end
end
