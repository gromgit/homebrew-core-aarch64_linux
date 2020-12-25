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
    rebuild 2
    sha256 "df877ac8003a21bc6e626b6769bee6c062a97bc9a0ad4c8696f1edbce84e2952" => :big_sur
    sha256 "e045b7442c08b71b665de30269248130508dc54615b2a231ef430e81a5e80bcf" => :arm64_big_sur
    sha256 "a5d0bd3e20410a7ca44b081e0282d1b379a35dca178c5742aaf4f565142994e1" => :catalina
    sha256 "650966efa8e12742e8db315777831955842731bc2aa8f2d149f2969ff87b356a" => :mojave
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
