class Cliclick < Formula
  desc "Tool for emulating mouse and keyboard events"
  homepage "https://www.bluem.net/jump/cliclick/"
  url "https://github.com/BlueM/cliclick/archive/5.0.1.tar.gz"
  sha256 "798fb8b26f6a42b5002ca58e018b91f7677162c4f035b38aee8d905829db64a7"
  license "BSD-3-Clause"
  head "https://github.com/BlueM/cliclick.git", branch: "master"

  bottle do
    sha256 aarch64_linux: "45492fb95de6a5adad25722737543da5f5b1b1b0a26c1816138fb9b43673ab37" # fake aarch64_linux
  end

  depends_on :macos

  def install
    system "make"
    bin.install "cliclick"
  end

  test do
    system bin/"cliclick", "p:OK"
  end
end
