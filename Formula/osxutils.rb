class Osxutils < Formula
  desc "Collection of macOS command-line utilities"
  homepage "https://github.com/specious/osxutils"
  url "https://github.com/specious/osxutils/archive/v1.9.0.tar.gz"
  sha256 "9c11d989358ed5895d9af7644b9295a17128b37f41619453026f67e99cb7ecab"
  license "GPL-2.0"
  head "https://github.com/specious/osxutils.git", branch: "master"

  bottle do
    sha256 aarch64_linux: "45492fb95de6a5adad25722737543da5f5b1b1b0a26c1816138fb9b43673ab37" # fake aarch64_linux
  end

  depends_on :macos

  def install
    system "make"
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    assert_match "osxutils", shell_output("#{bin}/osxutils")
  end
end
