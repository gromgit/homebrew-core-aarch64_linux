class MmCommon < Formula
  desc "Build utilities for C++ interfaces of GTK+ and GNOME packages"
  homepage "https://www.gtkmm.org/"
  url "https://download.gnome.org/sources/mm-common/1.0/mm-common-1.0.0.tar.xz"
  sha256 "b97d9b041e5952486cab620b44ab09f6013a478f43b6699ae899b8a4da189cd4"

  bottle do
    cellar :any_skip_relocation
    sha256 "5894c91c768f38b87d9d69bf3afb5bc1e8675e07de0b4afda506865f5c7cd35a" => :catalina
    sha256 "cffdd1590271cec32a56b7b0a54f92e1b657e5b26ec7c62c8c18b8b49364f72d" => :mojave
    sha256 "42c9654bebbc472d90bc31d14e0832d55367d8d86d6750ab546a129a48de342b" => :high_sierra
    sha256 "42c9654bebbc472d90bc31d14e0832d55367d8d86d6750ab546a129a48de342b" => :sierra
    sha256 "42c9654bebbc472d90bc31d14e0832d55367d8d86d6750ab546a129a48de342b" => :el_capitan
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "python"

  def install
    mkdir "build" do
      system "meson", "--prefix=#{prefix}", ".."
      system "ninja"
      system "ninja", "install"
    end
  end
end
