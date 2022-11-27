class Robodoc < Formula
  desc "Source code documentation tool"
  homepage "https://rfsber.home.xs4all.nl/Robo/index.html"
  url "https://rfsber.home.xs4all.nl/Robo/archives/robodoc-4.99.44.tar.bz2"
  sha256 "3721c3be9668a1503454618ed807ae0fba5068b15bc0ea63846787d7e9e78c0f"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://rfsber.home.xs4all.nl/Robo/archives/"
    regex(/href=.*?robodoc[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/robodoc"
    sha256 aarch64_linux: "df0f35977a0ed329a115f3665e082e4adf40779c616f45d3a79be640240c9e29"
  end

  head do
    url "https://github.com/gumpu/ROBODoc.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  def install
    system "autoreconf", "-f", "-i" if build.head?
    system "./configure", "--prefix=#{prefix}",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules"
    system "make", "install"
  end

  test do
    cp_r Dir["#{doc}/Examples/PerlExample/*"], testpath
    system bin/"robodoc"
  end
end
