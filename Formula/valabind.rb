class Valabind < Formula
  desc "Vala bindings for radare, reverse engineering framework"
  homepage "https://github.com/radare/valabind"
  url "https://github.com/radare/valabind/archive/1.7.2.tar.gz"
  sha256 "643c1ddc85e31de975df361a20e3f39d385f5ced0e50483c6e96b33bb3d32261"
  license "GPL-3.0-or-later"
  head "https://github.com/radare/valabind.git"

  bottle do
    cellar :any
    sha256 "e34f9429315d89d56a6fae0264a874d8502498367cc7fe0689bd2ade0ba247b2" => :catalina
    sha256 "bd3e953ae31b4a28fe43f7ec7ba12df304073796bd4384839cef7220bbcdd603" => :mojave
    sha256 "2cb71440c4d1e3716e3f669c66ec3942f80f56c08250130691daea0eab58dbb3" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "swig"
  depends_on "vala"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system bin/"valabind", "--help"
  end
end
