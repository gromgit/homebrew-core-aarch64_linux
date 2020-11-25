class QalculateGtk < Formula
  desc "Multi-purpose desktop calculator"
  homepage "https://qalculate.github.io/"
  url "https://github.com/Qalculate/qalculate-gtk/releases/download/v3.15.0/qalculate-gtk-3.15.0.tar.gz"
  sha256 "3ecf5fc0a465e651ceb47aeea4ebb9f166771f9676c6ff78e9bccdb9d8494c6a"
  license "GPL-2.0-or-later"

  bottle do
    sha256 "52ad7189e1a9e1b24cc072c807796f0b6f31eff42dbb7cb2202dbff4a65e358f" => :big_sur
    sha256 "d159b4287212ebf82c9f699dd886fcf94712454c3079e57c7c6bd34c99d28895" => :catalina
    sha256 "2de05c4349f359fbba723e26a13a9f8268ce9e8da907418a977b3c7fd08bcb77" => :mojave
  end

  depends_on "intltool" => :build
  depends_on "pkg-config" => :build
  depends_on "adwaita-icon-theme"
  depends_on "gtk+3"
  depends_on "libqalculate"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/qalculate-gtk", "-v"
  end
end
