class Debianutils < Formula
  desc "Miscellaneous utilities specific to Debian"
  homepage "https://packages.debian.org/sid/debianutils"
  url "https://deb.debian.org/debian/pool/main/d/debianutils/debianutils_4.11.tar.xz"
  sha256 "bb5ce6290696b0d623377521ed217f484aa98f7346c5f7c48f9ae3e1acfb7151"

  bottle do
    cellar :any_skip_relocation
    sha256 "91343603e1d52380fd28a65781e2cc8e7f9708cd94fd710a60261cc626509286" => :catalina
    sha256 "0968d5be34075a8d95c5884baee76f3147216d403446cf2d121931a20664925b" => :mojave
    sha256 "632fac3d90523c039bc7ab6829de0a27cd3f1fc39ce41337ba90ea6d14f2be89" => :high_sierra
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make"

    # Some commands are Debian Linux specific and we don't want them, so install specific tools
    bin.install "run-parts", "ischroot", "tempfile"
    man1.install "ischroot.1", "tempfile.1"
    man8.install "run-parts.8"
  end

  test do
    output = shell_output("#{bin}/tempfile -d #{Dir.pwd}").strip
    assert_predicate Pathname.new(output), :exist?
  end
end
