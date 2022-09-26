class Frugal < Formula
  desc "Cross language code generator for creating scalable microservices"
  homepage "https://github.com/Workiva/frugal"
  url "https://github.com/Workiva/frugal/archive/v3.16.2.tar.gz"
  sha256 "ad0b8b04dc82c30f70251bb2253f0678146c1546dbb874d01e1249d702b230bc"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/frugal"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "380c7e60a934e8cf3dbf19ff6997aabc4fa6d96d1c89f2abd6b8c9c78b854e73"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    (testpath/"test.frugal").write("typedef double Test")
    system "#{bin}/frugal", "--gen", "go", "test.frugal"
    assert_match "type Test float64", (testpath/"gen-go/test/f_types.go").read
  end
end
