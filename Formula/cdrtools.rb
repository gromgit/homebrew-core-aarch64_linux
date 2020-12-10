class Cdrtools < Formula
  desc "CD/DVD/Blu-ray premastering and recording software"
  homepage "http://cdrecord.org/"
  url "https://downloads.sourceforge.net/project/cdrtools/alpha/cdrtools-3.02a09.tar.gz"
  mirror "https://fossies.org/linux/misc/cdrtools-3.02a09.tar.gz"
  sha256 "c7e4f732fb299e9b5d836629dadf5512aa5e6a5624ff438ceb1d056f4dcb07c2"

  livecheck do
    # For 3.0.2a we are temporarily using the "alpha" due to a long wait for release.
    # This can go back to "url :stable" later
    url "https://downloads.sourceforge.net/project/cdrtools/alpha"
    regex(%r{url=.*?/cdrtools[._-]v?(\d+(?:\.\d+)+(a\d\d)?)\.t}i)
  end

  bottle do
    rebuild 1
    sha256 "f0c2ea440dda7483202622453db62f883ce3872b86c325ba4de046ac44a5c53b" => :catalina
    sha256 "4a7ba59af434b1302056aafd200f273470e91d27c9ad2a19f05a834ee41dc3be" => :mojave
    sha256 "465c4ba80bc7733b2ac85a9d17ca7149a32072d453d750795374e8c2021e207b" => :high_sierra
    sha256 "f97ea5375a9dd443000397890ab8424905f02ea278ab8dd4568ff4c7288d038a" => :sierra
    sha256 "4724b3dfe367cf28dbd98dad6ddd47179e5b5d1b599a8fff8f0fa8cc4621acb2" => :el_capitan
    sha256 "5370586e423d9b842b7ebd0cdb3dd2c763c433be9896bcab636cc56ecd5e0634" => :yosemite
    sha256 "1b3f3ab5baf44ad31f8d09e36de6df59901ce036cc681c54187fe5f41dc8bb94" => :mavericks
  end

  depends_on "smake" => :build

  conflicts_with "dvdrtools",
    because: "both dvdrtools and cdrtools install binaries by the same name"

  def install
    # Speed-up the build by skipping the compilation of the profiled libraries.
    # This could be done by dropping each occurence of *_p.mk from the definition
    # of MK_FILES in every lib*/Makefile. But it is much easier to just remove all
    # lib*/*_p.mk files. The latter method produces warnings but works fine.
    rm_f Dir["lib*/*_p.mk"]
    # CFLAGS is required to work around autoconf breakages as of 3.02a
    system "smake", "INS_BASE=#{prefix}", "INS_RBASE=#{prefix}",
           "CFLAGS=-Wno-implicit-function-declaration",
           "install"
    # cdrtools tries to install some generic smake headers, libraries and
    # manpages, which conflict with the copies installed by smake itself
    (include/"schily").rmtree
    %w[libschily.a libdeflt.a libfind.a].each do |file|
      (lib/file).unlink
    end
    man5.rmtree
  end

  test do
    system "#{bin}/cdrecord", "-version"
    system "#{bin}/cdda2wav", "-version"
    date = shell_output("date")
    mkdir "subdir" do
      (testpath/"subdir/testfile.txt").write(date)
      system "#{bin}/mkisofs", "-r", "-o", "../test.iso", "."
    end
    assert_predicate testpath/"test.iso", :exist?
    system "#{bin}/isoinfo", "-R", "-i", "test.iso", "-X"
    assert_predicate testpath/"testfile.txt", :exist?
    assert_equal date, File.read("testfile.txt")
  end
end
