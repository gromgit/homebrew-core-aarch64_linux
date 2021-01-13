class Xgboost < Formula
  desc "Scalable, Portable and Distributed Gradient Boosting Library"
  homepage "https://xgboost.ai/"
  url "https://github.com/dmlc/xgboost.git",
      tag:      "v1.3.2",
      revision: "3e343159efaab1ec18ceab3a0425e5de6b50075b"
  license "Apache-2.0"

  bottle do
    cellar :any
    sha256 "c5e9eba15f0cc7ad17f9d2f5702dd1d3991742ee54228236aa5ea39d52878099" => :big_sur
    sha256 "edbc24cbd487da78603ed223d7ae55828757b089dc17d8267f1960f2cba000da" => :arm64_big_sur
    sha256 "c62dbca19d3958ff374479d8cd3cd2c926d7b5e422d31d3bf9ae01feb01d294e" => :catalina
    sha256 "b316dbad3eb0dea34062f11b6de052e414a22cb795c6b185054ef47ed2788812" => :mojave
  end

  depends_on "cmake" => :build
  depends_on "libomp"
  depends_on "numpy"
  depends_on "scipy"

  def install
    mkdir "build" do
      system "cmake", *std_cmake_args, ".."
      system "make"
      system "make", "install"
    end
    pkgshare.install "demo"
  end

  test do
    cp_r (pkgshare/"demo"), testpath
    cd "demo/data" do
      cp "../CLI/binary_classification/mushroom.conf", "."
      system "#{bin}/xgboost", "mushroom.conf"
    end
  end
end
