class Zip < Formula
  desc "Compression and file packaging/archive utility"
  homepage "https://infozip.sourceforge.io/Zip.html"
  url "https://downloads.sourceforge.net/project/infozip/Zip%203.x%20%28latest%29/3.0/zip30.tar.gz"
  version "3.0"
  sha256 "f0e8bb1f9b7eb0b01285495a2699df3a4b766784c1765a8f1aeedf63c0806369"

  livecheck do
    url :stable
    regex(%r{url=.*?/v?(\d+(?:\.\d+)+)/zip\d+\.(?:t|zip)}i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/zip"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "79086327b5451cb0a9c5c2ef7235b3de846bfea68277d754d11b6dada33d5b76"
  end

  keg_only :provided_by_macos

  uses_from_macos "bzip2"

  # Upstream is unmaintained so we use the Debian patchset:
  # https://packages.debian.org/sid/zip
  patch do
    url "https://deb.debian.org/debian/pool/main/z/zip/zip_3.0-11.debian.tar.xz"
    sha256 "c5c0714a88592f9e02146bfe4a8d26cd9bd97e8d33b1efc8b37784997caa40ed"
    apply %w[
      patches/01-typo-it-is-transferring-not-transfering
      patches/02-typo-it-is-privileges-not-priviliges
      patches/03-manpages-in-section-1-not-in-section-1l
      patches/04-do-not-set-unwanted-cflags
      patches/05-typo-it-is-preceding-not-preceeding
      patches/06-stack-markings-to-avoid-executable-stack
      patches/07-fclose-in-file-not-fclose-x
      patches/08-hardening-build-fix-1
      patches/09-hardening-build-fix-2
      patches/10-remove-build-date
    ]
  end

  def install
    system "make", "-f", "unix/Makefile", "CC=#{ENV.cc}", "generic"
    system "make", "-f", "unix/Makefile", "BINDIR=#{bin}", "MANDIR=#{man1}", "install"
  end

  test do
    (testpath/"test1").write "Hello!"
    (testpath/"test2").write "Bonjour!"
    (testpath/"test3").write "Moien!"

    system "#{bin}/zip", "test.zip", "test1", "test2", "test3"
    assert_predicate testpath/"test.zip", :exist?
    # zip -T needs unzip, disabled under Linux to avoid a circular dependency
    assert_match "test of test.zip OK", shell_output("#{bin}/zip -T test.zip") if OS.mac?

    # test bzip2 support that should be automatically linked in using the bzip2 library in macOS
    system "#{bin}/zip", "-Z", "bzip2", "test2.zip", "test1", "test2", "test3"
    assert_predicate testpath/"test2.zip", :exist?
    # zip -T needs unzip, disabled under Linux to avoid a circular dependency
    assert_match "test of test2.zip OK", shell_output("#{bin}/zip -T test2.zip") if OS.mac?
  end
end
