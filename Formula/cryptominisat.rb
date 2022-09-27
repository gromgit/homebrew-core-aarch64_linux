class Cryptominisat < Formula
  desc "Advanced SAT solver"
  homepage "https://www.msoos.org/cryptominisat5/"
  url "https://github.com/msoos/cryptominisat/archive/5.11.2.tar.gz"
  sha256 "c9116668e472444408950d09d393f6178d059e4b4273bb085ba9b93c297c02a1"
  # Everything that's needed to run/build/install/link the system is MIT licensed. This allows
  # easy distribution and running of the system everywhere.
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "0f01c25fcbfe2ec654faf7f42a122d7e684e89f57c03936737d6c3ad62d9a751"
    sha256 cellar: :any,                 arm64_big_sur:  "5230c1c09d8f3996041f78bb6d622acaba14c84ba17c1f7f2cc52cf8a284471b"
    sha256 cellar: :any,                 monterey:       "246de85b15ae915de106c7aec13f0df5767decde6ca0686fb83bffbc221b8940"
    sha256 cellar: :any,                 big_sur:        "36ec6d9910b162731f2c98bec360a8fe902eae7bf621c10dd76d75ea4db7722e"
    sha256 cellar: :any,                 catalina:       "9731237c0d573505f6fe9d6b6d3795112cda2e7fb5fff14e759de5fee691a0ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7da0f58dfb0fc4890538be6c133d4e1f5a9f280fd4191b378fb0d93066d66303"
  end

  depends_on "cmake" => :build
  depends_on "python@3.10" => [:build, :test]
  depends_on "boost"

  def python3
    "python3.10"
  end

  def install
    # fix audit failure with `lib/libcryptominisat5.5.7.dylib`
    inreplace "src/GitSHA1.cpp.in", "@CMAKE_CXX_COMPILER@", ENV.cxx

    args = %W[-DNOM4RI=ON -DMIT=ON -DCMAKE_INSTALL_RPATH=#{rpath}]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    system python3, *Language::Python.setup_install_args(prefix, python3)
  end

  test do
    (testpath/"simple.cnf").write <<~EOS
      p cnf 3 4
      1 0
      -2 0
      -3 0
      -1 2 3 0
    EOS
    result = shell_output("#{bin}/cryptominisat5 simple.cnf", 20)
    assert_match "s UNSATISFIABLE", result

    (testpath/"test.py").write <<~EOS
      import pycryptosat
      solver = pycryptosat.Solver()
      solver.add_clause([1])
      solver.add_clause([-2])
      solver.add_clause([-1, 2, 3])
      print(solver.solve()[1])
    EOS
    assert_equal "(None, True, False, True)\n", shell_output("#{python3} test.py")
  end
end
