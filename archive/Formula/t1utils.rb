class T1utils < Formula
  desc "Command-line tools for dealing with Type 1 fonts"
  homepage "https://www.lcdf.org/type/"
  url "https://www.lcdf.org/type/t1utils-1.42.tar.gz"
  sha256 "61877935b1987044ddff4bb90a05200ca7164678a355e170bf5f1a5556cc9f29"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/t1utils"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "7902b095ceabc8eb24f80c79814e489cb6b8d59c4760879e6252d4f4e20e9219"
  end

  head do
    url "https://github.com/kohler/t1utils.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  def install
    system "./bootstrap.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/t1mac", "--version"
  end
end
