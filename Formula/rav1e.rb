class Rav1e < Formula
  desc "The fastest and safest AV1 encoder"
  homepage "https://github.com/xiph/rav1e"
  url "https://github.com/xiph/rav1e/archive/v0.3.3.tar.gz"
  sha256 "a091f3387055e472b6e028aa013cf0f37fb5acce9f4db2605d929bbffb448d01"

  bottle do
    cellar :any
    sha256 "353bdedd6e68900afdd0faa82f99575679a951f9bbdf7b7e2ff8bca88ff9ae62" => :catalina
    sha256 "6615644e65c6f7ea6fec24e7bc9164f9640d561111d9abaa8a39451e7c38fd7d" => :mojave
    sha256 "c12a118ba20b2c1a8c97c47984c28b99797f3958bbad9d380c93b855878da006" => :high_sierra
  end

  depends_on "cargo-c" => :build
  depends_on "nasm" => :build
  depends_on "rust" => :build

  resource "bus_qcif_7.5fps.y4m" do
    url "https://media.xiph.org/video/derf/y4m/bus_qcif_7.5fps.y4m"
    sha256 "1f5bfcce0c881567ea31c1eb9ecb1da9f9583fdb7d6bb1c80a8c9acfc6b66f6b"
  end

  def install
    system "cargo", "install", "--locked",
                               "--root", prefix,
                               "--path", "."
    system "cargo", "cinstall", "--prefix", prefix
  end

  test do
    resource("bus_qcif_7.5fps.y4m").stage do
      system "#{bin}/rav1e", "--tile-rows=2",
                                   "bus_qcif_7.5fps.y4m",
                                   "--output=bus_qcif_15fps.ivf"
    end
  end
end
