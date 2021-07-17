class Dcd < Formula
  desc "Auto-complete program for the D programming language"
  homepage "https://github.com/dlang-community/DCD"
  url "https://github.com/dlang-community/DCD.git",
      tag:      "v0.13.6",
      revision: "02acaa534b9be65142aed7b202a6a8d5524abf2a"
  license "GPL-3.0-or-later"
  head "https://github.com/dlang-community/dcd.git"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:      "80150a1144639d87e282d8bbae2586a9530ed9aea22d71ba87b693a753947481"
    sha256 cellar: :any_skip_relocation, catalina:     "f8410040eb2862fe4e4eb1c81db06e771f2264975a0b3a1aab86a3afaf862203"
    sha256 cellar: :any_skip_relocation, mojave:       "06741cfea8cacf2c13ed861fdef7b5db9e9500fd2b309f7286b92eb1b1974f42"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "b47af3d85e3087be8a424316db75a06f8c0a7974491f6684f597b921f1f56d09"
  end

  depends_on "dmd" => :build

  def install
    system "make"
    bin.install "bin/dcd-client", "bin/dcd-server"
  end

  test do
    port = free_port

    # spawn a server, using a non-default port to avoid
    # clashes with pre-existing dcd-server instances
    server = fork do
      exec "#{bin}/dcd-server", "-p", port.to_s
    end
    # Give it generous time to load
    sleep 0.5
    # query the server from a client
    system "#{bin}/dcd-client", "-q", "-p", port.to_s
  ensure
    Process.kill "TERM", server
    Process.wait server
  end
end
