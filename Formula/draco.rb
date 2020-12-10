class Draco < Formula
  desc "3D geometric mesh and point cloud compression library"
  homepage "https://google.github.io/draco/"
  url "https://github.com/google/draco/archive/1.4.1.tar.gz"
  sha256 "83aa5637d36a835103a61f96af7ff04c6d6528e643909466595d51ee715417a9"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "611eca0461a36721a4ca8459a97bfa550dd55cad396545a7149e4c32d0072906" => :big_sur
    sha256 "ed3b1c70f396fa6858008614fdaaa93bf97332ffdb8299e462d58bf131cb8c95" => :catalina
    sha256 "d96f680abdc31d252a1da824124fb7d502fd2ce593d893488288cd8de73383e3" => :mojave
  end

  depends_on "cmake" => :build

  def install
    mkdir "build" do
      system "cmake", "..", * std_cmake_args
      system "make", "install"
    end
    pkgshare.install "testdata/cube_att.ply"
  end

  test do
    system "#{bin}/draco_encoder", "-i", "#{pkgshare}/cube_att.ply",
           "-o", "cube_att.drc"
    assert_predicate testpath/"cube_att.drc", :exist?
  end
end
