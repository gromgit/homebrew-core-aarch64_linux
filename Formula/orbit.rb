class Orbit < Formula
  desc "CORBA 2.4-compliant object request broker (ORB)"
  homepage "https://web.archive.org/web/20191222075841/projects-old.gnome.org/ORBit2/"
  url "https://download.gnome.org/sources/ORBit2/2.14/ORBit2-2.14.19.tar.bz2"
  sha256 "55c900a905482992730f575f3eef34d50bda717c197c97c08fa5a6eafd857550"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.0-only"]
  revision 1
  head "https://gitlab.gnome.org/Archive/orbit2.git"

  livecheck do
    url :stable
  end

  bottle do
    rebuild 1
    sha256 "a604838d3a9e9690eceefb5f798aa5c02a6d46b5e1f1cbb50bbc5cc95df451e9" => :catalina
    sha256 "367cb438ac5ee8c44cd932d259f82b43458af90df8df28803e2248ad75952800" => :mojave
    sha256 "50487080b7e4614d077b4cbb818a726a7bae7a7a281fc85fabd6ff88ed848016" => :high_sierra
  end

  # GNOME 2.19 deprecated Orbit2 in 2007; now even their webpage for it is gone as of 2020
  deprecate! date: "2020-12-25", because: :deprecated_upstream

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "libidl"

  # per MacPorts, re-enable use of deprecated glib functions
  patch :p0 do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/6b7eaf2b/orbit/patch-linc2-src-Makefile.in.diff"
    sha256 "572771ea59f841d74ac361d51f487cc3bcb2d75dacc9c20a8bd6cbbaeae8f856"
  end

  patch :p0 do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/6b7eaf2b/orbit/patch-configure.diff"
    sha256 "34d068df8fc9482cf70b291032de911f0e75a30994562d4cf56b0cc2a8e28e42"
  end

  def install
    ENV.deparallelize
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match /#{version}/, shell_output("#{bin}/orbit2-config --prefix --version")
  end
end
