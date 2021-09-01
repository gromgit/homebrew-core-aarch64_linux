class NodeBuild < Formula
  desc "Install NodeJS versions"
  homepage "https://github.com/nodenv/node-build"
  url "https://github.com/nodenv/node-build/archive/v4.9.53.tar.gz"
  sha256 "500b2ab6b166001d65b1058498e35b2e9d2505be1ef78cab2381c5833de25f00"
  license "MIT"
  head "https://github.com/nodenv/node-build.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "b512c3350058fafe15454508593776738ed84d764252305ae2c4f83420144e53"
  end

  depends_on "autoconf"
  depends_on "openssl@1.1"
  depends_on "pkg-config"

  def install
    ENV["PREFIX"] = prefix
    system "./install.sh"
  end

  test do
    system "#{bin}/node-build", "--definitions"
  end
end
