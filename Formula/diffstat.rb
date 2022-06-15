class Diffstat < Formula
  desc "Produce graph of changes introduced by a diff file"
  homepage "https://invisible-island.net/diffstat/"
  url "https://invisible-mirror.net/archives/diffstat/diffstat-1.64.tgz"
  sha256 "b8aee38d9d2e1d05926e6b55810a9d2c2dd407f24d6a267387563a4436e3f7fc"
  license "MIT-CMU"

  livecheck do
    url "https://invisible-mirror.net/archives/diffstat/"
    regex(/href=.*?diffstat[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/diffstat"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "d765f1a238cf436c6a02507ff631398da90e03f30b93a6784333581a0b7da8d4"
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"diff.diff").write <<~EOS
      diff --git a/diffstat.rb b/diffstat.rb
      index 596be42..5ff14c7 100644
      --- a/diffstat.rb
      +++ b/diffstat.rb
      @@ -2,9 +2,8 @@
      -  url 'https://deb.debian.org/debian/pool/main/d/diffstat/diffstat_1.58.orig.tar.gz'
      -  version '1.58'
      -  sha256 'fad5135199c3b9aea132c5d45874248f4ce0ff35f61abb8d03c3b90258713793'
      +  url 'https://deb.debian.org/debian/pool/main/d/diffstat/diffstat_1.61.orig.tar.gz'
      +  sha256 'b8aee38d9d2e1d05926e6b55810a9d2c2dd407f24d6a267387563a4436e3f7fc'
    EOS
    output = shell_output("#{bin}/diffstat diff.diff")
    assert_match "2 insertions(+), 3 deletions(-)", output
  end
end
