class Entityx < Formula
  desc "Fast, type-safe C++ Entity Component System"
  homepage "https://github.com/alecthomas/entityx"
  url "https://github.com/alecthomas/entityx/archive/1.3.0.tar.gz"
  sha256 "2cd56d4fc5c553b786b8caf0b5bd9231434f21d43ca0e963d3bc5ee503a06222"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/entityx"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "5c1f927c0138afe40318d3d082967d88809b05680415d71ddda6f85d8be92eb0"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", "-DENTITYX_BUILD_SHARED=off", "-DENTITYX_BUILD_TESTING=off", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<-EOS
      #include <entityx/entityx.h>

      int main(int argc, char *argv[]) {
        entityx::EntityX ex;

        entityx::Entity entity = ex.entities.create();
        entity.destroy();

        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-std=c++11", "-L#{lib}", "-lentityx", "-o", "test"
    system "./test"
  end
end
