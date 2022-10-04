class Cutter < Formula
  desc "Unit Testing Framework for C and C++"
  homepage "https://cutter.osdn.jp/"
  url "https://osdn.mirror.constant.com/cutter/73761/cutter-1.2.8.tar.gz"
  sha256 "bd5fcd6486855e48d51f893a1526e3363f9b2a03bac9fc23c157001447bc2a23"
  license "LGPL-3.0"
  head "https://github.com/clear-code/cutter.git", branch: "master"

  livecheck do
    url "https://osdn.net/projects/cutter/releases/"
    regex(%r{value=["'][^"']*?/rel/cutter/v?(\d+(?:\.\d+)+)["']}i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/cutter"
    sha256 aarch64_linux: "9da730679a9611e7140dc1e0820159eeb46c7462ee6593b216caf93b37d6a50f"
  end

  depends_on "intltool" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "glib"

  uses_from_macos "perl" => :build

  def install
    ENV.prepend_path "PERL5LIB", Formula["intltool"].libexec/"lib/perl5" unless OS.mac?

    system "./configure", "--prefix=#{prefix}",
                          "--disable-glibtest",
                          "--disable-goffice",
                          "--disable-gstreamer",
                          "--disable-libsoup"
    system "make"
    system "make", "install"
  end

  test do
    touch "1.txt"
    touch "2.txt"
    system bin/"cut-diff", "1.txt", "2.txt"
  end
end
