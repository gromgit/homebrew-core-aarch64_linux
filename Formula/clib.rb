class Clib < Formula
  desc "Package manager for C programming"
  homepage "https://github.com/clibs/clib"
  url "https://github.com/clibs/clib/archive/2.1.8.tar.gz"
  sha256 "ce51dbf4176549ee63d5e221fbbab5acf539a89f9a3cbe54614c72e6811e0538"
  license "MIT"
  head "https://github.com/clibs/clib.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "7882a46e2fcbd6555fe592cdbde91fe8c3a31d2380d720c2ea5332bffa8ddbba" => :catalina
    sha256 "5b75e0f5b379f174a7c9bcb00fe1e8156d2abdf98f90c0b69e591d31541488c6" => :mojave
    sha256 "99980929866e1dc1754d1736b0461ab284414428dc4ccc34a567a5eb5c49237a" => :high_sierra
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
