class Glslang < Formula
  desc "OpenGL and OpenGL ES reference compiler for shading languages"
  homepage "https://www.khronos.org/opengles/sdk/tools/Reference-Compiler/"
  url "https://github.com/KhronosGroup/glslang/archive/11.1.0.tar.gz"
  sha256 "a47f1f9ed17a1f53a074fef20787110ef49522c6de68b218db68d04a81d649c5"
  head "https://github.com/KhronosGroup/glslang.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "770b8efbe5dfe0112ff68dcc70e27d456089a167ad50f0cf710805da60dd126e" => :big_sur
    sha256 "b2fed640a79567039b2f90735bec3acd3754c6f8666c0d875e722f08a2e443d1" => :arm64_big_sur
    sha256 "9db9f4d0af3d3945270e3fcfbb2e502f377f15d76810facf80862093a18b7a5d" => :catalina
    sha256 "24e6cb49dac7d598a0d12e055a67cd036196eb8cfb7f688b58240219e1a144b9" => :mojave
    sha256 "02af3328d6edf389d340d0c106c4366f575e5abf8db478e6b5c6fc99111b2c2c" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "python@3.9" => :build

  def install
    args = %w[
      -DBUILD_EXTERNAL=OFF
      -DENABLE_CTEST=OFF
    ]

    system "cmake", ".", *std_cmake_args, *args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.frag").write <<~EOS
      #version 110
      void main() {
        gl_FragColor = vec4(1.0, 1.0, 1.0, 1.0);
      }
    EOS
    (testpath/"test.vert").write <<~EOS
      #version 110
      void main() {
          gl_Position = gl_ModelViewProjectionMatrix * gl_Vertex;
      }
    EOS
    system "#{bin}/glslangValidator", "-i", testpath/"test.vert", testpath/"test.frag"
  end
end
