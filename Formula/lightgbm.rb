class Lightgbm < Formula
  desc "Fast, distributed, high performance gradient boosting framework"
  homepage "https://github.com/microsoft/LightGBM"
  url "https://github.com/microsoft/LightGBM.git",
      tag:      "v3.3.2",
      revision: "dce7e58b020bc14b69eefc31546c366971ecb2d9"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "7683c555fca349d6aa5b4d7c83e4499c911b4bbf49e1293c2580d8de2dd89695"
    sha256 cellar: :any,                 arm64_big_sur:  "d682a3c8519a8e53586e11cbe469cee7407ab3cf9c04c3e1cb3090718f2e1c37"
    sha256 cellar: :any,                 monterey:       "cd99e43dc3c64bf0416e13546a359e8c213c4b693a8bb90626b6f2c9f3ff5623"
    sha256 cellar: :any,                 big_sur:        "35ab7f3c1def696fa9800a98dd0a03f07046d6476f1a2ad35bf324e4907a97b6"
    sha256 cellar: :any,                 catalina:       "29d375544346e724143a1b145b1fa4cdfcdbc743fa7637b955b769274f238049"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cb2d01e4572ef9e7a4ab3e3415da0b4b7ccd3d379dd4020e4ec254e3c96faf75"
  end

  depends_on "cmake" => :build
  depends_on "libomp"

  def install
    mkdir "build" do
      system "cmake", *std_cmake_args, "-DAPPLE_OUTPUT_DYLIB=ON", ".."
      system "make"
      system "make", "install"
    end
    pkgshare.install "examples"
  end

  test do
    cp_r (pkgshare/"examples/regression"), testpath
    cd "regression" do
      system "#{bin}/lightgbm", "config=train.conf"
    end
  end
end
