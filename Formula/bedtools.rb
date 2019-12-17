class Bedtools < Formula
  desc "Tools for genome arithmetic (set theory on the genome)"
  homepage "https://github.com/arq5x/bedtools2"
  url "https://github.com/arq5x/bedtools2/archive/v2.29.1.tar.gz"
  sha256 "504c0992caa027ec1840ea9ca6909f7e59e7ebc1a2b422233b35abb9592aff5c"

  bottle do
    cellar :any
    sha256 "6a0c1ec3df37d3c4195f6ee3ff2ce0d093ff0b347d4620db228c100cde2e7239" => :catalina
    sha256 "3e30f5e4d1ef7184dec191d9c5ecf3d2575a8fd63195819f49207f37aa6c6c78" => :mojave
    sha256 "7f95922a3ce9210eb0ad5fee569032f5ce10147b97eef07061d193322e9d6ac7" => :high_sierra
    sha256 "281b63ca90868adecb3cdc2c1cf5e56761ad7e63aced8c35012320c9389b42c2" => :sierra
  end

  depends_on "xz"

  def install
    system "make"
    system "make", "install", "prefix=#{prefix}"
  end

  test do
    (testpath/"t.bed").write "c\t1\t5\nc\t4\t9"
    assert_equal "c\t1\t9", shell_output("#{bin}/bedtools merge -i t.bed").chomp
  end
end
