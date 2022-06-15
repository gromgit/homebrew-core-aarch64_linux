class Gpp < Formula
  desc "General-purpose preprocessor with customizable syntax"
  homepage "https://logological.org/gpp"
  url "https://files.nothingisreal.com/software/gpp/gpp-2.27.tar.bz2"
  sha256 "49eb99d22af991e7f4efe2b21baa1196e9ab98c05b4b7ed56524a612c47b8fd3"
  license "GPL-3.0"

  livecheck do
    url "https://github.com/logological/gpp.git"
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/gpp"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "05a393804792d051ff34b58ff4d837f9627e744628ed8283d9603acbc4c477a4"
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--mandir=#{man}"
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    system "#{bin}/gpp", "--version"
  end
end
