class Chkrootkit < Formula
  desc "Rootkit detector"
  homepage "http://www.chkrootkit.org/"
  url "ftp://ftp.pangeia.com.br/pub/seg/pac/chkrootkit-0.54.tar.gz"
  mirror "https://fossies.org/linux/misc/chkrootkit-0.54.tar.gz"
  sha256 "154c926921f53db60728a7cbc97ca88658b694c14b7d288efe383e0849915607"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?download[^>]*>chkrootkit v?(\d+(?:\.\d+)+)/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "5744d8fb6169d25dee805a879b3e27bc9a690becb6ad1ede0a5ac81d21357e84" => :big_sur
    sha256 "2255d52041c7f2ab54d2ada28a0f6e193d900e1ff2e4b5a9fd85e65dd26b4f75" => :catalina
    sha256 "fca54772544e396cfcf2dc9391835513088068eadd8ddb8590e90d141a9a2354" => :mojave
  end

  def install
    system "make", "CC=#{ENV.cc}", "CFLAGS=#{ENV.cflags}",
                   "STATIC=", "sense", "all"

    bin.install Dir[buildpath/"*"].select { |f| File.executable? f }
    doc.install %w[README README.chklastlog README.chkwtmp]
  end

  test do
    assert_equal "chkrootkit version #{version}",
                 shell_output("#{bin}/chkrootkit -V 2>&1", 1).strip
  end
end
