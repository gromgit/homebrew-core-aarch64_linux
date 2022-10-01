class Frugal < Formula
  desc "Cross language code generator for creating scalable microservices"
  homepage "https://github.com/Workiva/frugal"
  url "https://github.com/Workiva/frugal/archive/v3.16.4.tar.gz"
  sha256 "dcfb329ab790dc55bf168f0eecc7d84a33bf07bf5e6da1c8e5ca5f66adabea1e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4992794514907538d774db052c783ae0e392c6466a0a7bb4341e5d8846b7adc0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4992794514907538d774db052c783ae0e392c6466a0a7bb4341e5d8846b7adc0"
    sha256 cellar: :any_skip_relocation, monterey:       "2a6d1d8ff2e2ea10e40d9a16459e55647fb7b4fbc13157e89d7455f4cc2d4299"
    sha256 cellar: :any_skip_relocation, big_sur:        "2a6d1d8ff2e2ea10e40d9a16459e55647fb7b4fbc13157e89d7455f4cc2d4299"
    sha256 cellar: :any_skip_relocation, catalina:       "2a6d1d8ff2e2ea10e40d9a16459e55647fb7b4fbc13157e89d7455f4cc2d4299"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d0c26b137ac366ce68d16b82e4b763574eebac4fd73e117051029bc70fb3c922"
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
