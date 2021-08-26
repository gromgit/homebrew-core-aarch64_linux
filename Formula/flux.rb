class Flux < Formula
  desc "Lightweight scripting language for querying databases"
  homepage "https://www.influxdata.com/products/flux/"
  url "https://github.com/influxdata/flux.git",
      tag:      "v0.126.0",
      revision: "5daaedac25dfa11cf577e9a662e59e5c721f80ed"
  license "MIT"
  head "https://github.com/influxdata/flux.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "8058fe7c0a930c5a0f93ab1a1d3c3524b1c7e06edc5a7f4f26ca1c20e2a0274d"
    sha256 cellar: :any,                 big_sur:       "d0fa7eff1f68a3bf56b4e4d933689eca65e2b6dbcf56ee0f459141ccf0a67ad3"
    sha256 cellar: :any,                 catalina:      "57280d055bf98d6f8dc7b5ad96582dbe550e6c68eb8f672345db1910f6b87036"
    sha256 cellar: :any,                 mojave:        "db623af5b425e866861c679124c096827c7ca93110dfe4509f3debc7aea82e8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "51a683af64d00696c61363559f5244c294f3db73982921e2bf8c30fcd7f8d655"
  end

  depends_on "go" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
  end

  # Support go 1.17, remove when upstream patch is merged/released
  # https://github.com/influxdata/flux/pull/3982
  patch do
    url "https://github.com/influxdata/flux/commit/233c875bcb7d071d47149b0730d1cb5f15eb6a5a.patch?full_index=1"
    sha256 "fadb3ee0dc5efec615b6ffc4338f9a0947d42b58406b393587754fab0196ca62"
  end

  def install
    system "make", "build"
    system "go", "build", "./cmd/flux"
    bin.install %w[flux]
    include.install "libflux/include/influxdata"
    lib.install Dir["libflux/target/*/release/libflux.{dylib,a,so}"]
  end

  test do
    assert_equal "8\n", shell_output("flux execute \"5.0 + 3.0\"")
  end
end
