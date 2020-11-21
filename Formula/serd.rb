class Serd < Formula
  desc "C library for RDF syntax"
  homepage "https://drobilla.net/software/serd/"
  url "https://download.drobilla.net/serd-0.30.6.tar.bz2"
  sha256 "f5a2c74c659d8b318059068f135a43a3771491c367b6947e053a713b23cd37ef"
  license "ISC"

  bottle do
    cellar :any
    sha256 "1e37820a695b8146fd21d544816b2e413cf93d7865ccabfd96d562ae4e006ee4" => :big_sur
    sha256 "3361f452fbde6a02d8dfe77fdd53c6c5ff99e0bcb9df4504526674641cc4b24e" => :catalina
    sha256 "e511ee4c7bb634cef312c139535c537aaafd70bbf2c62900a2b2950901f9eebf" => :mojave
    sha256 "6d5a775d35f00fca2fb98c9177616322e3a868204c2c3f93614102e5ece3237f" => :high_sierra
  end

  depends_on "pkg-config" => :build

  def install
    system "./waf", "configure", "--prefix=#{prefix}"
    system "./waf"
    system "./waf", "install"
  end

  test do
    pipe_output("serdi -", "() a <http://example.org/List> .", 0)
  end
end
