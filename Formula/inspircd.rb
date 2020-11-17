class Inspircd < Formula
  desc "Modular C++ Internet Relay Chat daemon"
  homepage "https://www.inspircd.org/"
  url "https://github.com/inspircd/inspircd/archive/v3.8.0.tar.gz"
  sha256 "2f847c6a091332faa7a647291f92ff3ed571b17967c85198d34c816c40e47e04"
  license "GPL-2.0-only"

  livecheck do
    url "https://github.com/inspircd/inspircd.git"
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 "7d4c77622a6ccef14d7a58548101ad1fd28e6b5add130eb7d2450d1ab41e0cf8" => :big_sur
    sha256 "34dc59aeda4825d28c49bf3eb70c8a48de780a5e468518bb6f4996062cb04243" => :catalina
    sha256 "9e958c6d286cd14e48c3da30b112dd85767559e10beb37da17d34691093bf4c9" => :mojave
    sha256 "ec15fcc66f27585110a022330567f08251617fca67ed96efe9079c67eead9508" => :high_sierra
  end

  depends_on "pkg-config" => :build

  skip_clean "data"
  skip_clean "logs"

  def install
    system "./configure", "--enable-extras=ldap"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match("ERROR: Cannot open config file", shell_output("#{bin}/inspircd", 2))
  end
end
