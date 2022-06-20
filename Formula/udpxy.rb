class Udpxy < Formula
  desc "UDP-to-HTTP multicast traffic relay daemon"
  homepage "http://gigapxy.com/udpxy-en.html"
  url "http://gigapxy.com/download/1_23/udpxy.1.0.23-12-prod.tar.gz"
  mirror "https://fossies.org/linux/www/old/udpxy.1.0.23-12-prod.tar.gz"
  version "1.0.23-12"
  sha256 "16bdc8fb22f7659e0427e53567dc3e56900339da261199b3d00104d699f7e94c"
  license "GPL-3.0-or-later"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/udpxy"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "7bc72a1afd5353b52f921fb9f3506fef02053a1d1c6d4ea1662642fe49da2507"
  end

  # As of writing, www.udpxy.com is a parked domain page (though gigapxy.com
  # hosts the same site). The homepage states, "development has been on hold
  # since 2012, with most of the effort routed toward enterprise-grade products,
  # such as Gigapxy, RoWAN, GigA+ and GigaTools." The udpxy `README` (last
  # modified 2018-01-18) has a "Project Status" section that states, "udpxy has
  # not been extended or supported for 4+ years, having been replaced by
  # Gigapxy - a superior enterprise-oriented product. Please see more info at
  # http://gigapxy.com, thank you."
  deprecate! date: "2022-05-03", because: :unsupported

  def install
    system "make"
    system "make", "install", "DESTDIR=#{prefix}", "PREFIX=''"
  end

  service do
    run [opt_bin/"udpxy", "-p", "4022"]
    keep_alive true
    working_dir HOMEBREW_PREFIX
  end
end
