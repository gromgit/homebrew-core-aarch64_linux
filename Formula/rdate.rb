class Rdate < Formula
  desc "Set the system's date from a remote host"
  homepage "https://www.aelius.com/njh/rdate/"
  url "https://www.aelius.com/njh/rdate/rdate-1.5.tar.gz"
  sha256 "6e800053eaac2b21ff4486ec42f0aca7214941c7e5fceedd593fa0be99b9227d"
  license "GPL-2.0"

  livecheck do
    url :homepage
    regex(/href=.*?rdate[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/rdate"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "6a75769c527985aef42d2c271043360e622554d83d4fea90f6d900a5fe21ffe6"
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
    # NOTE: The server must support RFC 868
    system "#{bin}/rdate", "-p", "-t", "10", "time-b-b.nist.gov"
  end
end
