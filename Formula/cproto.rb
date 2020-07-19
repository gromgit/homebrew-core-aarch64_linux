class Cproto < Formula
  desc "Generate function prototypes for functions in input files"
  homepage "https://invisible-island.net/cproto/"
  url "https://invisible-mirror.net/archives/cproto/cproto-4.7p.tgz"
  mirror "https://deb.debian.org/debian/pool/main/c/cproto/cproto_4.7p.orig.tar.gz"
  sha256 "d202334ff47fb40a1f57425135ebeefcbb272103f8fd7572e8ea21ee093aa16e"

  bottle do
    cellar :any_skip_relocation
    sha256 "1bd13cfb0cbaf739a6108287a8b9fbe0489370d7306acead182a49ba63f7a562" => :catalina
    sha256 "10ca6eb5bb793309be3dc367b013b97f3ab199cccfc27b0fac2dbdfcb8b73a62" => :mojave
    sha256 "c3cb1dc57b52471d2ce88ee243dbc72bd96984ee23c6508f316fd037f283d144" => :high_sierra
    sha256 "371d43e22636bad41b4a37d7abd06bc42b504b0790a14a6c54f0b5d03b693cf3" => :sierra
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"

    system "make", "install"
  end

  test do
    (testpath/"woot.c").write("int woot() {\n}")
    assert_match(/int woot.void.;/, shell_output("#{bin}/cproto woot.c"))
  end
end
