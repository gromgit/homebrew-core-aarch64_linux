class Clib < Formula
  desc "Package manager for C programming"
  homepage "https://github.com/clibs/clib"
  url "https://github.com/clibs/clib/archive/2.6.0.tar.gz"
  sha256 "c5502aeaa70ba4ca95c8fd5a5e19a9b6ca8e37f24878c9969b156ce4f9c30d93"
  license "MIT"
  head "https://github.com/clibs/clib.git"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "5c09d1b21de092b57a9fb16170dba836e5f4df51b9a6a47302aa4f2f90b565a0" => :big_sur
    sha256 "498960fdece8741fdb2e650d5d8a4931666402ca1229a73c93934bf9cd48455c" => :arm64_big_sur
    sha256 "e6f3ca8fbc6b39325af968a81e8f09045de75e90dae2d6db3a5a6e72afee2766" => :catalina
    sha256 "acebab1f84196d10519777630a1dec10858f2729208c111094bdaf49a11b77bb" => :mojave
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
