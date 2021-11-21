class Oil < Formula
  desc "Bash-compatible Unix shell with more consistent syntax and semantics"
  homepage "https://www.oilshell.org/"
  url "https://www.oilshell.org/download/oil-0.9.4.tar.gz"
  sha256 "a94cc6b83f459f0517a69d1f43629b9efdc8ba456c9e1b922c642a28c40d958f"
  license "Apache-2.0"

  livecheck do
    url "https://www.oilshell.org/releases.html"
    regex(/href=.*?oil[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "cdd879f2254a34987c7128521294168b0d370808dbdbf3bac8365ab4da1b852e"
    sha256 arm64_big_sur:  "27204d21705651ddb5404b7bef1fb6ba545ef36be79f06e36efb179c22fe9bd4"
    sha256 monterey:       "e08b9d7d99f4619dec16a79a4a76206dc2352dbef57fa9b165370d2d714c57ad"
    sha256 big_sur:        "b9124be06181631ec93536e04efc7da4528822dc83a1cfbe2f5c8183b1ea3952"
    sha256 catalina:       "dd582393bc065529f3ee22bce30bd3a01e8c948020661b109e65b3fdf22294a5"
    sha256 x86_64_linux:   "cdf734db883ab2a0c0040c3886fa49ef1afd14c97b2eff5232c1bce799f03ba8"
  end

  depends_on "readline"

  conflicts_with "omake", because: "both install 'osh' binaries"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--with-readline=#{Formula["readline"].opt_prefix}"
    system "make"
    system "./install"
  end

  test do
    system "#{bin}/osh", "-c", "shopt -q parse_backticks"
    assert_equal testpath.to_s, shell_output("#{bin}/osh -c 'echo `pwd -P`'").strip

    system "#{bin}/oil", "-c", "shopt -q parse_equals"
    assert_equal "bar", shell_output("#{bin}/oil -c 'var foo = \"bar\"; write $foo'").strip
  end
end
