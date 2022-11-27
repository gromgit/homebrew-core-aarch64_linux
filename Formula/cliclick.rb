class Cliclick < Formula
  desc "Tool for emulating mouse and keyboard events"
  homepage "https://www.bluem.net/jump/cliclick/"
  url "https://github.com/BlueM/cliclick/archive/5.1.tar.gz"
  sha256 "58bb36bca90fdb91b620290ba9cc0f885b80716cb7309b9ff4ad18edc96ce639"
  license "BSD-3-Clause"
  head "https://github.com/BlueM/cliclick.git", branch: "master"

  depends_on :macos

  def install
    system "make"
    bin.install "cliclick"
  end

  test do
    system bin/"cliclick", "p:OK"
  end
end
