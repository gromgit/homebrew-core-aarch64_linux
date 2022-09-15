class Libidn < Formula
  desc "International domain name library"
  homepage "https://www.gnu.org/software/libidn/"
  url "https://ftp.gnu.org/gnu/libidn/libidn-1.41.tar.gz"
  mirror "https://ftpmirror.gnu.org/libidn/libidn-1.41.tar.gz"
  sha256 "884d706364b81abdd17bee9686d8ff2ae7431c5a14651047c68adf8b31fd8945"
  license any_of: ["GPL-2.0-or-later", "LGPL-3.0-or-later"]

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/libidn"
    sha256 aarch64_linux: "5d31c9adecba628b47ec689e84aada9de34f2ac7f502fbee549716636f99bb72"
  end


  depends_on "pkg-config" => :build

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-csharp",
                          "--with-lispdir=#{elisp}"
    system "make", "install"
  end

  test do
    ENV["CHARSET"] = "UTF-8"
    system bin/"idn", "räksmörgås.se", "blåbærgrød.no"
  end
end
