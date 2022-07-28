class Plow < Formula
  desc "High-performance and real-time metrics displaying HTTP benchmarking tool"
  homepage "https://github.com/six-ddc/plow"
  url "https://github.com/six-ddc/plow/archive/refs/tags/v1.3.1.tar.gz"
  sha256 "0ae69218fc61d4bc036a62f3cc8a4e5f29fad0edefe9e991f0446f71d9e6d9ba"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bdbdb17b932fcd47e52e65beb57b1917f0e62fa5e78ee6301e273a258a375b4d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "65f90d41e43b71ded4a070fc8dc3af7d3371d6ba210d730041331ce841239731"
    sha256 cellar: :any_skip_relocation, monterey:       "c78f54aeaf5e40485ffcde64629249c685770212349511d7a252e613b63f44aa"
    sha256 cellar: :any_skip_relocation, big_sur:        "b8521a8707a251267207edc66b5d990523836e1b7e6588f34c323f7447a7d32e"
    sha256 cellar: :any_skip_relocation, catalina:       "b31d2b22b0047bd7f6654e8338c46cc6d46dd3c42a3ce011f4dd4b9a25ace457"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c613c35223b31a5cf1c9e1168a5be07f1a466b4ab8f7bc8823adf792877f87d4"
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
