class Lv < Formula
  desc "Powerful multi-lingual file viewer/grep"
  homepage "https://web.archive.org/web/20160310122517/www.ff.iij4u.or.jp/~nrt/lv/"
  url "https://web.archive.org/web/20150915000000/www.ff.iij4u.or.jp/~nrt/freeware/lv451.tar.gz"
  version "4.51"
  sha256 "e1cd2e27109fbdbc6d435f2c3a99c8a6ef2898941f5d2f7bacf0c1ad70158bcf"
  license "GPL-2.0"
  revision 1

  # The first-party website is no longer available (as of 2016) and there are no
  # alternatives. The current release of this software is from 2004-01-16, so
  # it's safe to say this is no longer actively developed or maintained.
  livecheck do
    skip "No available sources to check for versions"
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/lv"
    sha256 aarch64_linux: "dc2695fe42bcc3a5300adf8addb92675dd85c644713538931eb3acba5eb8b0d5"
  end

  uses_from_macos "ncurses"

  on_linux do
    depends_on "gzip"
  end

  # See https://github.com/Homebrew/homebrew-core/pull/53085
  patch :DATA

  def install
    if OS.mac?
      # zcat doesn't handle gzip'd data on OSX.
      # Reported upstream to nrt@ff.iij4u.or.jp
      inreplace "src/stream.c", 'gz_filter = "zcat"', 'gz_filter = "gzcat"'
    end

    cd "build" do
      system "../src/configure", "--prefix=#{prefix}"
      system "make"
      bin.install "lv"
      bin.install_symlink "lv" => "lgrep"
    end

    man1.install "lv.1"
    (lib+"lv").install "lv.hlp"
  end

  test do
    system "lv", "-V"
  end
end

__END__
--- a/src/escape.c
+++ b/src/escape.c
@@ -62,6 +62,10 @@
 	break;
     } while( 'm' != ch );
 
+    if( 'K' == ch ){
+        return TRUE;
+    }
+
     SIDX = index;
 
     if( 'm' != ch ){
