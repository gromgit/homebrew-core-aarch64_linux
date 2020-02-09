class Movgrab < Formula
  desc "Downloader for youtube, dailymotion, and other video websites"
  homepage "https://sites.google.com/site/columscode/home/movgrab"
  url "https://github.com/ColumPaget/Movgrab/archive/3.1.2.tar.gz"
  sha256 "30be6057ddbd9ac32f6e3d5456145b09526cc6bd5e3f3fb3999cc05283457529"
  revision 1

  bottle do
    cellar :any
    sha256 "3256dfc0f04850842d1ed0580d56ed6ef2929b51bde9dab3b7ddded980e8c527" => :catalina
    sha256 "790aca486dbbff6d41ae8d61b99a1de73085b837625736dee323bf251ebd6609" => :mojave
    sha256 "465f017e9d4c849aefa02d1471e12625b4a98e8f425323f6966e0b81cd286a27" => :high_sierra
  end

  depends_on "libressl"

  # Fixes an incompatibility between Linux's getxattr and macOS's.
  # Reported upstream; half of this is already committed, and there's
  # a PR for the other half.
  # https://github.com/ColumPaget/libUseful/issues/1
  # https://github.com/ColumPaget/libUseful/pull/2
  patch do
    url "https://github.com/Homebrew/formula-patches/raw/936597e74d22ab8cf421bcc9c3a936cdae0f0d96/movgrab/libUseful_xattr_backport.diff"
    sha256 "d77c6661386f1a6d361c32f375b05bfdb4ac42804076922a4c0748da891367c2"
  end

  def install
    # Can you believe this? A forgotten semicolon! Probably got missed because it's
    # behind a conditional #ifdef.
    inreplace "libUseful-2.8/FileSystem.c", "result=-1", "result=-1;"

    # Later versions of libUseful handle the fact that setresuid is Linux-only, but
    # this one does not. https://github.com/ColumPaget/Movgrab/blob/master/libUseful/Process.c#L95-L99
    inreplace "libUseful-2.8/Process.c", "setresuid(uid,uid,uid)", "setreuid(uid,uid)"

    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking", "--enable-ssl"
    system "make"

    # because case-insensitivity is sadly a thing and while the movgrab
    # Makefile itself doesn't declare INSTALL as a phony target, we
    # just remove the INSTALL instructions file so we can actually
    # just make install
    rm "INSTALL"
    system "make", "install"
  end

  test do
    system "#{bin}/movgrab", "--version"
  end
end
