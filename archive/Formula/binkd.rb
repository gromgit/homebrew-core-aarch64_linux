class Binkd < Formula
  desc "TCP/IP FTN Mailer"
  homepage "https://2f.ru/binkd/"
  url "https://happy.kiev.ua/pub/fidosoft/mailer/binkd/binkd-1.0.4.tar.gz"
  sha256 "917e45c379bbd1a140d1fe43179a591f1b2ec4004b236d6e0c4680be8f1a0dc0"
  license "GPL-2.0-or-later"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/binkd"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "c22507b230be44d9b087a1155bcb03e09f2f1b42c1fa8a92f954b12d406c6a33"
  end

  uses_from_macos "zlib"

  def install
    cp Dir["mkfls/unix/*"].select { |f| File.file? f }, "."
    inreplace "binkd.conf", "/var/", "#{var}/"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
    system "#{sbin}/binkd", "-v"
  end
end
