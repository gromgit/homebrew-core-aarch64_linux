class Catimg < Formula
  desc "Insanely fast image printing in your terminal"
  homepage "https://github.com/posva/catimg"
  url "https://github.com/posva/catimg/archive/2.7.0.tar.gz"
  sha256 "3a6450316ff62fb07c3facb47ea208bf98f62abd02783e88c56f2a6508035139"
  license "MIT"
  head "https://github.com/posva/catimg.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "5388da00655624b77735420cc87607ade50709aed7141341dcd78d1ca09f327e" => :catalina
    sha256 "c969dbc14fe8778d997abe119365a9a5b72a5192a2a73724edf820f4cc3d73c6" => :mojave
    sha256 "afc3fe119461f26efece013456a43798b2898e4c903d80e37998222081e7699f" => :high_sierra
    sha256 "2a7088bcac247d0dde972240369c4e7708511072f95e4bf43e3a1e2daa8e4e30" => :sierra
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-DMAN_OUTPUT_PATH=#{man1}", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    system "#{bin}/catimg", test_fixtures("test.png")
  end
end
