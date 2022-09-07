class Ser2net < Formula
  desc "Allow network connections to serial ports"
  homepage "https://ser2net.sourceforge.io"
  url "https://downloads.sourceforge.net/project/ser2net/ser2net/ser2net-4.3.5.tar.gz"
  sha256 "848c4fe863806e506832f1ee85b8b68258f06eb19dad43dbeee16a2cfe5d9053"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(%r{url=.*?/ser2net[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "0d2648450adb1aca66e67b48cd79906433f2541c8a21021288d7fd1c055f85ef"
    sha256 cellar: :any,                 arm64_big_sur:  "a78c036dada8ffa6024550bc80d09371beb874f95155b025fccb6b80a5ddff24"
    sha256 cellar: :any,                 monterey:       "2e5abbc0dc1808cec37576aa344af19550e8dde9dc4b9b0ce23d92172c806c6e"
    sha256 cellar: :any,                 big_sur:        "a00340cfaef84a27bad6d833a5296a701e0deaf9465e17cdff707234ab73f02b"
    sha256 cellar: :any,                 catalina:       "8476ff962f95e59718ff4c533c938c104bb77a242f1cc2fea184f9e7e2037692"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ae69e0697c9a26afd4a648b519e79ca9145fbfe2c4842600b18c535c42a2f11a"
  end

  depends_on "libyaml"

  resource "gensio" do
    url "https://downloads.sourceforge.net/project/ser2net/ser2net/gensio-2.3.2.tar.gz"
    sha256 "0b6333a5546f14396041900bbe5b83575a0e97d200a581a6ddb8fcf6e95adfbd"

    # Fix -flat_namespace being used on Big Sur and later.
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
      sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
    end
  end

  def install
    resource("gensio").stage do
      system "./configure", "--disable-dependency-tracking",
                            "--prefix=#{libexec}/gensio",
                            "--with-python=no",
                            "--with-tcl=no"
      system "make", "install"
    end

    ENV.append_path "PKG_CONFIG_PATH", "#{libexec}/gensio/lib/pkgconfig"
    ENV.append_path "CFLAGS", "-I#{libexec}/gensio/include"
    ENV.append_path "LDFLAGS", "-L#{libexec}/gensio/lib"

    if OS.mac?
      # Patch to fix compilation error
      # https://sourceforge.net/p/ser2net/discussion/90083/thread/f3ae30894e/
      # Remove with next release
      inreplace "addsysattrs.c", "#else", "#else\n#include <gensio/gensio.h>"
    end

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"

    (etc/"ser2net").install "ser2net.yaml"
  end

  def caveats
    <<~EOS
      To configure ser2net, edit the example configuration in #{etc}/ser2net/ser2net.yaml
    EOS
  end

  service do
    run [opt_sbin/"ser2net", "-p", "12345"]
    keep_alive true
    working_dir HOMEBREW_PREFIX
  end

  test do
    assert_match version.to_s, shell_output("#{sbin}/ser2net -v")
  end
end
