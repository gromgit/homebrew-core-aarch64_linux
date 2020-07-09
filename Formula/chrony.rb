class Chrony < Formula
  desc "Versatile implementation of the Network Time Protocol (NTP)"
  homepage "https://chrony.tuxfamily.org"
  url "https://download.tuxfamily.org/chrony/chrony-3.5.tar.gz"
  sha256 "4e02795b1260a4ec51e6ace84149036305cc9fc340e65edb9f8452aa611339b5"
  license "GPL-2.0"

  depends_on "nettle"

  uses_from_macos "libedit"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--localstatedir=#{var}"
    system "make", "install"
  end

  test do
    (testpath/"test.conf").write "pool pool.ntp.org iburst\n"
    output = shell_output(sbin/"chronyd -Q -f #{testpath}/test.conf 2>&1")
    assert_match /System clock wrong by -?\d+\.\d+ seconds \(ignored\)/, output
  end
end
