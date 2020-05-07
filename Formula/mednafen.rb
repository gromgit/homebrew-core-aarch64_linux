class Mednafen < Formula
  desc "Multi-system emulator"
  homepage "https://mednafen.github.io/"
  url "https://mednafen.github.io/releases/files/mednafen-1.24.3.tar.xz"
  sha256 "3dea853f784364557fa59e9ba11a17eb2674fc0fb93205f33bdbdaba1da3f70f"

  bottle do
    sha256 "9717843bf5d8d022042b782bd1239a18fd2d83086b9738abd115189eae5b87fc" => :catalina
    sha256 "6b4b6408d9d7e07937b12083e0175eab8c7c30eb0f79d3c439b96346416f51eb" => :mojave
    sha256 "54b53e70803b4849cc38f214212e26bb33a8eeb7b492cb665d5a40286b728166" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "libsndfile"
  depends_on :macos => :sierra # needs clock_gettime
  depends_on "sdl2"

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make", "install"
  end

  test do
    cmd = "#{bin}/mednafen | head -n1 | grep -o '[0-9].*'"
    assert_equal version.to_s, shell_output(cmd).chomp
  end
end
