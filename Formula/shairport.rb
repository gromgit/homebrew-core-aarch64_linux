class Shairport < Formula
  desc "Airtunes emulator"
  homepage "https://github.com/abrasive/shairport"
  url "https://github.com/abrasive/shairport/archive/1.1.1.tar.gz"
  sha256 "1b60df6d40bab874c1220d7daecd68fcff3e47bda7c6d7f91db0a5b5c43c0c72"
  license "MIT"
  revision 1
  head "https://github.com/abrasive/shairport.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/shairport"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "806a1c28252a7e2d713e651019846091c02e1fc1529b37549adebd87643fb83c"
  end

  depends_on "pkg-config" => :build
  depends_on "openssl@1.1"

  def install
    system "./configure"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/shairport", "-h"
  end
end
