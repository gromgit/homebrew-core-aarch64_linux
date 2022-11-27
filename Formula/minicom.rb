class Minicom < Formula
  desc "Menu-driven communications program"
  homepage "https://packages.debian.org/sid/minicom"
  url "https://deb.debian.org/debian/pool/main/m/minicom/minicom_2.8.orig.tar.bz2"
  sha256 "38cea30913a20349326ff3f1763ee1512b7b41601c24f065f365e18e9db0beba"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://deb.debian.org/debian/pool/main/m/minicom/"
    regex(/href=.*?minicom[._-]v?(\d+(?:\.\d+)+)\.orig\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/minicom"
    sha256 aarch64_linux: "a90fc7e5cd45681288e2faa66a1881b217c32ae58eee9eb26b9e7104be936b65"
  end

  uses_from_macos "ncurses"

  def install
    # There is a silly bug in the Makefile where it forgets to link to iconv. Workaround below.
    ENV["LIBS"] = "-liconv" if OS.mac?

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"

    (prefix/"etc").mkdir
    (prefix/"var").mkdir
    (prefix/"etc/minirc.dfl").write "pu lock #{prefix}/var\npu escape-key Escape (Meta)\n"
  end

  def caveats
    <<~EOS
      Terminal Compatibility
      ======================
      If minicom doesn't see the LANG variable, it will try to fallback to
      make the layout more compatible, but uglier. Certain unsupported
      encodings will completely render the UI useless, so if the UI looks
      strange, try setting the following environment variable:

        LANG="en_US.UTF-8"

      Text Input Not Working
      ======================
      Most development boards require Serial port setup -> Hardware Flow
      Control to be set to "No" to input text.
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/minicom -v", 1)
  end
end
