class Axel < Formula
  desc "Light UNIX download accelerator"
  homepage "https://github.com/axel-download-accelerator/axel"
  url "https://github.com/axel-download-accelerator/axel/releases/download/v2.17.11/axel-2.17.11.tar.xz"
  sha256 "580b2c18692482fd7f1e2b2819159484311ffc50f6d18924dceb80fd41d4ccf9"
  license "GPL-2.0-or-later"
  head "https://github.com/axel-download-accelerator/axel.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/axel"
    sha256 aarch64_linux: "2861c0499b767e324470ac27ab746e4a4246da266ee38627f65cd591bcc6a0b3"
  end

  depends_on "autoconf" => :build
  depends_on "autoconf-archive" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "openssl@1.1"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}"
    system "make", "install"
  end

  test do
    filename = (testpath/"axel.tar.gz")
    system bin/"axel", "-o", "axel.tar.gz", stable.url
    filename.verify_checksum stable.checksum
    assert_predicate testpath/"axel.tar.gz", :exist?
  end
end
