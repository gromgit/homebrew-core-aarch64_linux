class Sourcekitten < Formula
  desc "Framework and command-line tool for interacting with SourceKit"
  homepage "https://github.com/jpsim/SourceKitten"
  url "https://github.com/jpsim/SourceKitten.git",
      tag:      "0.32.0",
      revision: "817dfa6f2e09b0476f3a6c9dbc035991f02f0241"
  license "MIT"
  head "https://github.com/jpsim/SourceKitten.git", branch: "master"

  bottle do
    sha256 aarch64_linux: "45492fb95de6a5adad25722737543da5f5b1b1b0a26c1816138fb9b43673ab37" # fake aarch64_linux
  end

  depends_on xcode: ["12.0", :build]
  depends_on :macos
  depends_on xcode: "6.0"

  def install
    system "make", "prefix_install", "PREFIX=#{prefix}", "TEMPORARY_FOLDER=#{buildpath}/SourceKitten.dst"
  end

  test do
    system "#{bin}/sourcekitten", "version"
    return if MacOS::Xcode.version < 13

    ENV["IN_PROCESS_SOURCEKIT"] = "YES"
    system "#{bin}/sourcekitten", "syntax", "--text", "import Foundation // Hello World"
  end
end
