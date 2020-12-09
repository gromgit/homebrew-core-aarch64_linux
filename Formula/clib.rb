class Clib < Formula
  desc "Package manager for C programming"
  homepage "https://github.com/clibs/clib"
  url "https://github.com/clibs/clib/archive/2.5.0.tar.gz"
  sha256 "74643374883651a272ed8ac8e8a6789c0b4a4b13e20a9d45798fd770821e620d"
  license "MIT"
  head "https://github.com/clibs/clib.git"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "b3ce0068a31ec45750ad6c1e6e6ca0a4dff2806bbffa37bf60ae9a34f53b3802" => :big_sur
    sha256 "50ff2470931e566aee66cbf67bc18bd7912af9ac7ce98bbe22b15f491e05310a" => :catalina
    sha256 "65757d988620552ed9d906d5d5b092618d61fc89b5f9feee8095f960cb0768f2" => :mojave
    sha256 "a623ed010d9a701cfbce18360486fe96c5cfea54ffbdad53a31c66959bdf9da6" => :high_sierra
  end

  uses_from_macos "curl"

  def install
    ENV["PREFIX"] = prefix
    system "make", "install"
  end

  test do
    system "#{bin}/clib", "install", "stephenmathieson/rot13.c"
  end
end
