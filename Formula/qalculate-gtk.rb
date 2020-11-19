class QalculateGtk < Formula
  desc "Multi-purpose desktop calculator"
  homepage "https://qalculate.github.io/"
  url "https://github.com/Qalculate/qalculate-gtk/releases/download/v3.14.0/qalculate-gtk-3.14.0.tar.gz"
  sha256 "704dd3a98b47e0a84eb61b80c50cd6c445b37a1d28c1b1c271d7aef3592657e7"
  license "GPL-2.0-or-later"

  bottle do
    sha256 "33b81f8c101d9b5f62604c4e92ea1ee3dccc4d36b68239bfe75979700d09ac64" => :big_sur
    sha256 "75b81c74cf19289d81ff5af2aca7c6589a150bc443875c463aeec9c771bcf506" => :catalina
    sha256 "83a982057c2ccd6db4a535a480696134affb0f1ce00b86ac4999ac70fd3f12dc" => :mojave
    sha256 "6b372cbcd32dbb3a9fd6a178277b3996f7bcd9ef9ed054432d653c2471619ae2" => :high_sierra
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
