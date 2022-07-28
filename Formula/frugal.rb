class Frugal < Formula
  desc "Cross language code generator for creating scalable microservices"
  homepage "https://github.com/Workiva/frugal"
  url "https://github.com/Workiva/frugal/archive/v3.16.1.tar.gz"
  sha256 "e201f1e8108bf21a2d921c6446ce4eada01d5c238c626d4813ffb7bf412a3d01"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cd552150cee6e802de07b3ec76703558316e635d440ac6855328625263b7c0e9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cd552150cee6e802de07b3ec76703558316e635d440ac6855328625263b7c0e9"
    sha256 cellar: :any_skip_relocation, monterey:       "0ced82e6ddec3b531660b97d3b6cbca8efa26bd76dd1e6a450bc76d6c5df2aab"
    sha256 cellar: :any_skip_relocation, big_sur:        "0ced82e6ddec3b531660b97d3b6cbca8efa26bd76dd1e6a450bc76d6c5df2aab"
    sha256 cellar: :any_skip_relocation, catalina:       "0ced82e6ddec3b531660b97d3b6cbca8efa26bd76dd1e6a450bc76d6c5df2aab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b96a32dad9137a5528f8047dc146114d29f1367b7688e79e1bb16d720df096d0"
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
