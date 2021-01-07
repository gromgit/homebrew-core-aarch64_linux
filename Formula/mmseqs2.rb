class Mmseqs2 < Formula
  desc "Software suite for very fast sequence search and clustering"
  homepage "https://mmseqs.com/"
  url "https://github.com/soedinglab/MMseqs2/archive/12-113e3.tar.gz"
  version "12-113e3"
  sha256 "81fa0d77eab9d74b429567da00aa7ec2d46049537ce469595d7356b6d8b5458a"
  license "GPL-3.0-or-later"
  revision 1
  head "https://github.com/soedinglab/MMseqs2.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "8bce632fcf02e77832aa363509cf025f6161355026767fe77c2fc36742c4f707" => :big_sur
    sha256 "180bd9ce0ca379906e9ecea89e37ceacb6a268b49093d92c71ef3c967e58505b" => :arm64_big_sur
    sha256 "e148e2ada88473dae80b9d56651ede55b134468ec4753d82fccef4951f2b59ab" => :catalina
    sha256 "da9562c1ef7b42a9fd0e3bb5892e4e0ed5464c5d2be4b1a515cfc51f6ce25a83" => :mojave
  end

  depends_on "cmake" => [:build, :test]
  depends_on "libomp"
  depends_on "wget"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  resource "documentation" do
    url "https://github.com/soedinglab/MMseqs2.wiki.git",
        revision: "d53d8be3761ee625b0dcddda29b092bbd02244ef"
  end

  resource "testdata" do
    url "https://github.com/soedinglab/MMseqs2/releases/download/12-113e3/MMseqs2-Regression-Minimal.zip"
    sha256 "ab0c2953d1c27736c22a57a1ccbb976c1320435fad82b5c579dbd716b7bae4ce"
  end

  def install
    args = *std_cmake_args << "-DHAVE_TESTS=0" << "-DHAVE_MPI=0"
    args << "-DVERSION_OVERRIDE=#{version}"
    args << if Hardware::CPU.arm?
      "-DHAVE_ARM8=1"
    else
      "-DHAVE_SSE4_1=1"
    end

    libomp = Formula["libomp"]
    args << "-DOpenMP_C_FLAGS=-Xpreprocessor\ -fopenmp\ -I#{libomp.opt_include}"
    args << "-DOpenMP_C_LIB_NAMES=omp"
    args << "-DOpenMP_CXX_FLAGS=-Xpreprocessor\ -fopenmp\ -I#{libomp.opt_include}"
    args << "-DOpenMP_CXX_LIB_NAMES=omp"
    args << "-DOpenMP_omp_LIBRARY=#{libomp.opt_lib}/libomp.a"

    # Fix SIMDe on AppleClang11, fixed upstream, remove in next release
    args << "-DCMAKE_CXX_FLAGS=-DSIMDE_NO_CHECK_IMMEDIATE_CONSTANT=1" if DevelopmentTools.clang_build_version == 1100

    system "cmake", ".", *args
    system "make", "install"

    resource("documentation").stage { doc.install Dir["*"] }
    pkgshare.install "examples"
    bash_completion.install "util/bash-completion.sh" => "mmseqs.sh"
  end

  def caveats
    "MMseqs2 requires at least SSE4.1 CPU instruction support." if !Hardware::CPU.sse4? && !Hardware::CPU.arm?
  end

  test do
    resource("testdata").stage do
      system "./run_regression.sh", "#{bin}/mmseqs", "scratch"
    end
  end
end
