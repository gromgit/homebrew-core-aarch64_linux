class F3d < Formula
  desc "Fast and minimalist 3D viewer"
  homepage "https://kitware.github.io/F3D/"
  url "https://gitlab.kitware.com/f3d/f3d/-/archive/v1.1.0/f3d-v1.1.0.tar.gz"
  sha256 "93aa9759efcc4e77beac4568280aaeaca21bfb233d3c9f60262207ca595bde79"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "67e85676f297dc249379c3dee5a104916db059d0d2dd0b433e66d7ccc5bd262c"
    sha256 cellar: :any, big_sur:       "b3a8a87f495b54c0e24585027d708ffc11977da7ca3da1955470ebcc58f1de2b"
    sha256 cellar: :any, catalina:      "d623106fcedf416df23733c760a2ba1b9b19fd5ae74a90c6cb40a651a12e7c4c"
    sha256 cellar: :any, mojave:        "daabb4fbf371fff17de6befc2b71f803c1d22fe4cdc1879f0f8ba50dd784928f"
  end

  depends_on "cmake" => :build
  depends_on "vtk"

  def install
    args = std_cmake_args + %W[
      -DMACOSX_BUILD_BUNDLE:BOOL=OFF
      -DBUILD_SHARED_LIBS:BOOL=ON
      -DBUILD_TESTING:BOOL=OFF
      -DF3D_INSTALL_DEFAULT_CONFIGURATION_FILE:BOOL=ON
      -DCMAKE_INSTALL_NAME_DIR:STRING=#{lib}
      -DCMAKE_INSTALL_RPATH:STRING=#{lib}
    ]

    mkdir "build" do
      system "cmake", "..", *args
      system "make"
      system "make", "install"
    end
  end

  test do
    # create a simple OBJ file with 3 points and 1 triangle
    (testpath/"test.obj").write <<~EOS
      v 0 0 0
      v 1 0 0
      v 0 1 0
      f 1 2 3
    EOS

    f3d_out = shell_output("#{bin}/f3d --verbose --no-render --geometry-only #{testpath}/test.obj 2>&1").strip
    assert_match(/Loading.+obj/, f3d_out)
    assert_match "Number of points: 3", f3d_out
    assert_match "Number of polygons: 1", f3d_out
  end
end
