class Abnfgen < Formula
  desc "Quickly generate random documents that match an ABFN grammar"
  homepage "http://www.quut.com/abnfgen/"
  url "http://www.quut.com/abnfgen/abnfgen-0.20.tar.gz"
  sha256 "73ce23ab8f95d649ab9402632af977e11666c825b3020eb8c7d03fa4ca3e7514"

  livecheck do
    url :homepage
    regex(%r{href=.*?/abnfgen[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/abnfgen"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "244bd0b206f207f24bf00e09423ce0adae68eec56186f6deae2b0c2f6071a8e2"
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
    (testpath/"grammar").write 'ring = 1*12("ding" SP) "dong" CRLF'
    system "#{bin}/abnfgen", (testpath/"grammar")
  end
end
