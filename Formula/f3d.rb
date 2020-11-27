class F3d < Formula
  desc "Fast and minimalist 3D viewer"
  homepage "https://kitware.github.io/F3D/"
  url "https://gitlab.kitware.com/f3d/f3d/-/archive/v1.0.1/f3d-v1.0.1.tar.gz"
  sha256 "fb362dba3ccf49db9e8841d8a5310f37399bfea8866b6e040ce85670d54b97f7"
  license "BSD-3-Clause"

  depends_on "cmake" => :build
  depends_on "vtk"

  def install
    # Is fixed upstream, remove this line for v1.1
    inreplace "src/F3DOptions.cxx",
      "directoryPath = vtksys::SystemTools::GetProgramPath(programFilePath);",
      "programFilePath = vtksys::SystemTools::GetRealPath(programFilePath);" \
      "directoryPath = vtksys::SystemTools::GetProgramPath(programFilePath);"

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
    assert_match /Loading.+obj/, f3d_out
    assert_match /Number of points: 3/, f3d_out
    assert_match /Number of polygons: 1/, f3d_out
  end
end
