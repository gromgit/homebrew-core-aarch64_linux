class Valabind < Formula
  desc "Vala bindings for radare, reverse engineering framework"
  homepage "https://github.com/radare/valabind"
  url "https://github.com/radare/valabind/archive/1.7.2.tar.gz"
  sha256 "643c1ddc85e31de975df361a20e3f39d385f5ced0e50483c6e96b33bb3d32261"
  license "GPL-3.0-or-later"
  head "https://github.com/radare/valabind.git"

  bottle do
    cellar :any
    sha256 "c5ad6fe97fa944521c3848f282a940aa3f37d22bc96a472d6f320715f679b38b" => :catalina
    sha256 "e120768e4de31c6d5efcfd3e09eacf59c9b8d2388f3a402a296fc13a50c35263" => :mojave
    sha256 "90ee3663f74b52b5efb182792bbb4bd76780929bc7444dd319dcf51d27888390" => :high_sierra
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
