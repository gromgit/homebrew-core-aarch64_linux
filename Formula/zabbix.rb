class Zabbix < Formula
  desc "Availability and monitoring solution"
  homepage "https://www.zabbix.com/"
  url "https://cdn.zabbix.com/zabbix/sources/stable/6.0/zabbix-6.0.4.tar.gz"
  sha256 "5743b6cc2e29d9bd242aa88b2835f3ded0be177509000d84db74e1159c5afa75"
  license "GPL-2.0-or-later"
  head "https://github.com/zabbix/zabbix.git", branch: "master"

  livecheck do
    url "https://www.zabbix.com/download_sources"
    regex(/href=.*?zabbix[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "e0a1ca6d07205330596a02216d1cab6a6418115eaba6eb4674dc1c9d4b9b58a4"
    sha256 arm64_big_sur:  "2d95a5ba43b604a9cbc9b75810405376404dc1ff55ab4e138d9843d7b623e29a"
    sha256 monterey:       "c76485c47a36607cd4572f2b3c6abf4a7157bec471bdbbeba5fcb3e5c7834731"
    sha256 big_sur:        "34a9b442f2cb2d2e3482b613a0ee334000a5b2264d32177545351760b1774726"
    sha256 catalina:       "a7057ed1ac6d60c3a0e22cf95ccd1dae9c753dddc1945981c5dda5377c32dd40"
    sha256 x86_64_linux:   "8a011bf0af56542f13da387b21e4987f6e8830692fe6996c0f99c8dd874370d2"
  end

  depends_on "openssl@1.1"
  depends_on "pcre2"

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --sysconfdir=#{etc}/zabbix
      --enable-agent
      --with-libpcre2
      --with-openssl=#{Formula["openssl@1.1"].opt_prefix}
    ]

    if OS.mac?
      sdk = MacOS::CLT.installed? ? "" : MacOS.sdk_path
      args << "--with-iconv=#{sdk}/usr"
    end

    system "./configure", *args
    system "make", "install"
  end

  test do
    system sbin/"zabbix_agentd", "--print"
  end
end
