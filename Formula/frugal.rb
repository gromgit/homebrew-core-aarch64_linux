class Frugal < Formula
  desc "Cross language code generator for creating scalable microservices"
  homepage "https://github.com/Workiva/frugal"
  url "https://github.com/Workiva/frugal/archive/v3.15.0.tar.gz"
  sha256 "a7f97de2dd6765bf166d5763a44bdc30cc067b06d3f236cb1715c3bed5a0e557"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/frugal"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "2e08c8d010a2d8615d4f7bcfa416eea65cc12c239a7ac7225e2c322e9c9d2a76"
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
