class Glslang < Formula
  desc "OpenGL and OpenGL ES reference compiler for shading languages"
  homepage "https://www.khronos.org/opengles/sdk/tools/Reference-Compiler/"
  url "https://github.com/KhronosGroup/glslang/archive/11.11.0.tar.gz"
  sha256 "26c216c3062512c018cbdd752224b8dad703b7e5bb90bf338ba2dbb5d4f11438"
  license all_of: ["BSD-3-Clause", "GPL-3.0-or-later", "MIT", "Apache-2.0"]
  head "https://github.com/KhronosGroup/glslang.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/glslang"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "5c200fa42866a166a4470d88cd6ba4a0efb14ce5d8c4ed03ae565834501ebbfe"
  end

  depends_on "cmake" => :build
  depends_on "python@3.10" => :build

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
