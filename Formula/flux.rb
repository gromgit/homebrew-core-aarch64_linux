class Flux < Formula
  desc "Lightweight scripting language for querying databases"
  homepage "https://www.influxdata.com/products/flux/"
  url "https://github.com/influxdata/flux.git",
      tag:      "v0.101.0",
      revision: "3843d7f9d428a3d5f8743bffdd56a0f96973b850"
  license "MIT"
  head "https://github.com/influxdata/flux.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    cellar :any
    sha256 "20a7a2e8e5b2c78c199f907edf491a5b0f9003b895f991454af6727bc40342a8" => :big_sur
    sha256 "521c98fb66d2384b390a86340eccfb24635dca7498f777a30b42161957fe15bf" => :catalina
    sha256 "2728896a15fe821b2cf2a9d0f6d0aaff93990a016248b8582a9032f6d23b3df0" => :mojave
  end

  depends_on "go" => :build
  depends_on "rust" => :build

  def install
    system "make", "build"
    system "go", "build", "./cmd/flux"
    bin.install %w[flux]
    include.install "libflux/include/influxdata"
    lib.install Dir["libflux/target/*/release/libflux.{dylib,a}"]
  end

  test do
    assert_equal "8\n", shell_output("flux execute \"5.0 + 3.0\"")
  end
end
