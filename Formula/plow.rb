class Plow < Formula
  desc "High-performance and real-time metrics displaying HTTP benchmarking tool"
  homepage "https://github.com/six-ddc/plow"
  url "https://github.com/six-ddc/plow/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "aa579bfa7fee552d84723b6f49d7851759bfd2ff15c9a5d0f216c11a838472a8"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/plow"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "065cd2e338c63fccc7cddbef1f804b19d36fdb517cc4488bded0433feeec313d"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    output = "2xx"
    assert_match output.to_s, shell_output("#{bin}/plow -n 1 https://httpbin.org/get")
  end
end
