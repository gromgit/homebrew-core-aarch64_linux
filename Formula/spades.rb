class Spades < Formula
  desc "De novo genome sequence assembly"
  homepage "http://cab.spbu.ru/software/spades/"
  url "https://github.com/ablab/spades/releases/download/v3.14.0/SPAdes-3.14.0.tar.gz"
  mirror "http://cab.spbu.ru/files/release3.14.0/SPAdes-3.14.0.tar.gz"
  sha256 "18988dd51762863a16009aebb6e873c1fbca92328b0e6a5af0773e2b1ad7ddb9"

  bottle do
    cellar :any_skip_relocation
    sha256 "57d10f39e017dda291cdcdc3e6b2b3ea41cbfd745c802c2833e4c6e606cc5854" => :catalina
    sha256 "5ba1f271f5489004b1a2758259164e7cd9319e291893a1aebc68fdba5ab0ba41" => :mojave
    sha256 "9bec40cdba00c2c4798770cdce92091c209db9e7d4ea97ee1ad167a2cdafb04f" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "libomp"

  uses_from_macos "bzip2"
  uses_from_macos "ncurses"
  uses_from_macos "python@2"
  uses_from_macos "readline"
  uses_from_macos "zlib"

  def install
    # Use libomp due to issues with headers in GCC.
    libomp = Formula["libomp"]
    args = std_cmake_args
    args << "-DOpenMP_C_FLAGS=\"-Xpreprocessor -fopenmp -I#{libomp.opt_include}\""
    args << "-DOpenMP_CXX_FLAGS=\"-Xpreprocessor -fopenmp -I#{libomp.opt_include}\""
    args << "-DOpenMP_CXX_LIB_NAMES=omp"
    args << "-DOpenMP_C_LIB_NAMES=omp"
    args << "-DOpenMP_omp_LIBRARY=#{libomp.opt_lib}/libomp.dylib"
    args << "-DAPPLE_OUTPUT_DYLIB=ON"

    mkdir "src/build" do
      system "cmake", "..", *args
      system "make", "install"
    end
  end

  test do
    assert_match "TEST PASSED CORRECTLY", shell_output("#{bin}/spades.py --test")
  end
end
