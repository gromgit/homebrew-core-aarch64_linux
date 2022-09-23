class Frei0r < Formula
  desc "Minimalistic plugin API for video effects"
  homepage "https://frei0r.dyne.org/"
  url "https://files.dyne.org/frei0r/releases/frei0r-plugins-1.8.0.tar.gz"
  sha256 "45a28655caf057227b442b800ca3899e93490515c81e212d219fdf4a7613f5c4"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://files.dyne.org/frei0r/releases/"
    regex(/href=.*?frei0r-plugins[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/frei0r"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "bf6938860270273b8e1f18c68cb5748712f9d4611901e76e5df6b65de4ba1bb3"
  end

  depends_on "cmake" => :build

  def install
    # Disable opportunistic linking against Cairo
    inreplace "CMakeLists.txt", "find_package (Cairo)", ""
    cmake_args = std_cmake_args + %w[
      -DWITHOUT_OPENCV=ON
      -DWITHOUT_GAVL=ON
    ]
    system "cmake", ".", *cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <frei0r.h>

      int main()
      {
        int mver = FREI0R_MAJOR_VERSION;
        if (mver != 0) {
          return 0;
        } else {
          return 1;
        }
      }
    EOS
    system ENV.cc, "-L#{lib}", "test.c", "-o", "test"
    system "./test"
  end
end
