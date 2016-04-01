class Direnv < Formula
  desc "Load/unload environment variables based on $PWD"
  homepage "http://direnv.net"
  url "https://github.com/zimbatm/direnv/archive/v2.8.0.tar.gz"
  sha256 "86c69a907e0990fa54631335fe4131642d4f0d7737e2337462ec4c759fdc33d0"

  head "https://github.com/zimbatm/direnv.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "fd4b19d7b08fa7f3c433beefd5fbd8b032331ead9e7e1213b5818b75df4e7e3b" => :el_capitan
    sha256 "031385622db694e37bbf25dba6607f23b8a79a6dcae14391ac12bc0642e3ad38" => :yosemite
    sha256 "3b00b27671a1b9d33843e78af30d140aa0bf23e25a883aa6f53cacd8dbf0d74d" => :mavericks
  end

  depends_on "go" => :build

  def install
    system "make", "install", "DESTDIR=#{prefix}"
  end

  def caveats
    "Finish setup by following: https://github.com/zimbatm/direnv#setup"
  end

  test do
    system bin/"direnv", "status"
  end
end
