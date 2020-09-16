class Rubberband < Formula
  desc "Audio time stretcher tool and library"
  homepage "https://breakfastquay.com/rubberband/"
  url "https://breakfastquay.com/files/releases/rubberband-1.9.0.tar.bz2"
  sha256 "4f5b9509364ea876b4052fc390c079a3ad4ab63a2683aad09662fb905c2dc026"
  license "GPL-2.0"
  head "https://hg.sr.ht/~breakfastquay/rubberband", using: :hg

  livecheck do
    url :homepage
    regex(/Rubber Band Library v?(\d+(?:\.\d+)+) released/i)
  end

  bottle do
    cellar :any
    rebuild 1
    sha256 "dcfa2c05cc251d0c5e810040646fb5f9511fda2d1cad20ccadce96544a1ad7e3" => :catalina
    sha256 "629837bd83bfcef1003bfb29759d15c29bb7c22740a70f6143bd4c16a5bd3362" => :mojave
    sha256 "f592baa6b5e82c542a92df87789a51b6603e7e8070dfa7f910349a388135b6da" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "libsamplerate"
  depends_on "libsndfile"

  def install
    system "make", "-f", "Makefile.osx"
    # HACK: Manual install because "make install" is broken
    # https://github.com/Homebrew/homebrew-core/issues/28660
    bin.install "bin/rubberband"
    lib.install "lib/librubberband.dylib" => "librubberband.2.1.1.dylib"
    lib.install_symlink lib/"librubberband.2.1.1.dylib" => "librubberband.2.dylib"
    lib.install_symlink lib/"librubberband.2.1.1.dylib" => "librubberband.dylib"
    include.install "rubberband"

    cp "rubberband.pc.in", "rubberband.pc"
    inreplace "rubberband.pc", "%PREFIX%", opt_prefix
    (lib/"pkgconfig").install "rubberband.pc"
  end

  test do
    output = shell_output("#{bin}/rubberband -t2 #{test_fixtures("test.wav")} out.wav 2>&1")
    assert_match "Pass 2: Processing...", output
  end
end
