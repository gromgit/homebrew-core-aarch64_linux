class Clib < Formula
  desc "Package manager for C programming"
  homepage "https://github.com/clibs/clib"
  url "https://github.com/clibs/clib/archive/2.1.13.tar.gz"
  sha256 "744b5e88d4c9cf9ed31b69c141b66b250ec710852480cb3f7f9a9f13f760f31f"
  license "MIT"
  head "https://github.com/clibs/clib.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "25c13570c9486ed52c0a1f285c013c9b8f4db98103140f55c0a673e4b8e46ce0" => :catalina
    sha256 "af594da332369909e8ba994ac1a426aac01d596e515aea128371297c5bb35bae" => :mojave
    sha256 "1b016514f58713a2de92b2a11d3e199ea77313547a168c26db1145d55fd03c98" => :high_sierra
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
