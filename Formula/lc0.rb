class Lc0 < Formula
  desc "Open source neural network based chess engine"
  homepage "https://lczero.org/"
  url "https://github.com/LeelaChessZero/lc0.git",
      tag:      "v0.28.2",
      revision: "fa5864bb5838e131d832ad63300517f4684913e7"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "666d41e8d5ee92d8dd34a66bc7fb6f9e1b0bf8f5fd5bdce7cc29fc780fcda0f4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8865002a4605a5368e5533de55c3914090c369866b3545122741fd1447127a06"
    sha256 cellar: :any_skip_relocation, monterey:       "973d981bbd609eafba260aad2030a3ec3eaadd4ab23156e06feaaba92a1cc650"
    sha256 cellar: :any_skip_relocation, big_sur:        "b436e4f9c90c8b2dbab9cedeb37143b1d3590ff331c706eeb5ebb4293f497473"
    sha256 cellar: :any_skip_relocation, catalina:       "6dc5d083b4a07dd198b9418ff430c5e6a3056bee045faad81d4977ecefadabc0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3e81c98844914e7c1f93ed48bf42ddd43a029e41b4fd654febcfdc950ac83035"
  end

  depends_on "cmake" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.10" => :build # required to compile .pb files
  depends_on "eigen"

  uses_from_macos "zlib"

  on_linux do
    depends_on "gcc" # for C++17
    depends_on "openblas"
  end

  fails_with gcc: "5"

  resource "network" do
    url "https://training.lczero.org/get_network?sha=00af53b081e80147172e6f281c01daf5ca19ada173321438914c730370aa4267", using: :nounzip
    sha256 "12df03a12919e6392f3efbe6f461fc0ff5451b4105f755503da151adc7ab6d67"
  end

  def install
    args = ["-Dgtest=false"]
    if OS.linux?
      args << "-Dopenblas_include=#{Formula["openblas"].opt_include}"
      args << "-Dopenblas_libdirs=#{Formula["openblas"].opt_lib}"
    end
    system "meson", *std_meson_args, *args, "build/release"

    cd "build/release" do
      system "ninja", "-v"
      libexec.install "lc0"
    end

    bin.write_exec_script libexec/"lc0"
    resource("network").stage { libexec.install Dir["*"].first => "42850.pb.gz" }
  end

  test do
    assert_match "Creating backend [blas]",
      shell_output("lc0 benchmark --backend=blas --nodes=1 --num-positions=1 2>&1")
    assert_match "Creating backend [eigen]",
      shell_output("lc0 benchmark --backend=eigen --nodes=1 --num-positions=1 2>&1")
  end
end
