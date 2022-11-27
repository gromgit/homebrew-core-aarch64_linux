class Rdb < Formula
  desc "Redis RDB parser"
  homepage "https://github.com/HDT3213/rdb/"
  url "https://github.com/HDT3213/rdb/archive/refs/tags/v1.0.4.tar.gz"
  sha256 "156df3d22f5291cba6da07808d43a3add2e97a9c054316c53f296e2ab0ab9829"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/rdb"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "c06c788b63fbb7f5f090c68b74d580779bf099fa1031182467caebd82780bba1"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
    pkgshare.install "cases"
  end

  test do
    cp_r pkgshare/"cases", testpath
    system bin/"rdb", "-c", "memory", "-o", testpath/"mem1.csv", testpath/"cases/memory.rdb"
    assert_equal (testpath/"cases/memory.csv").read, (testpath/"mem1.csv").read
  end
end
