class Rpcgen < Formula
  desc "Protocol Compiler"
  homepage "https://opensource.apple.com/"
  url "https://opensource.apple.com/tarballs/developer_cmds/developer_cmds-66.tar.gz"
  sha256 "99d6c4ef4f32593df937a42d50400c17054247e875ab8cfb3bf0f2de19a90860"
  # Sun-RPC license issue, https://github.com/spdx/license-list-XML/issues/906

  livecheck do
    url "https://opensource.apple.com/tarballs/developer_cmds/"
    regex(/href=.*?developer_cmds[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 aarch64_linux: "45492fb95de6a5adad25722737543da5f5b1b1b0a26c1816138fb9b43673ab37" # fake aarch64_linux
  end

  keg_only :provided_by_macos

  depends_on xcode: ["7.3", :build]
  depends_on :macos

  def install
    xcodebuild "-arch", Hardware::CPU.arch,
               "-project", "developer_cmds.xcodeproj",
               "-target", "rpcgen",
               "-configuration", "Release",
               "SYMROOT=build"
    bin.install "build/Release/rpcgen"
    man1.install "rpcgen/rpcgen.1"
  end

  test do
    assert_match "nettype", shell_output("#{bin}/rpcgen 2>&1", 1)
  end
end
