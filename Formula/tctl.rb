class Tctl < Formula
  desc "Temporal CLI (tctl)"
  homepage "https://temporal.io/"
  url "https://github.com/temporalio/temporal/archive/v1.10.1.tar.gz"
  sha256 "ce2effab4f757eb1940c6bdeebc1fc91f069fc453af02893c15a32d4a0701a2e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ec241cf40b10dc3c679fbbcdfeb9b4a8405e2903be7b0b91f4bc6be746a6dfb4"
    sha256 cellar: :any_skip_relocation, big_sur:       "9b338a81315d89b26627ccc0fd88b28eed697fb131fe8859e1feb8474cc91ce2"
    sha256 cellar: :any_skip_relocation, catalina:      "c85d85169d68f2eeb0bbf7f9099eae2c01979a30e2f4b00b8b927a77bec7ecb0"
    sha256 cellar: :any_skip_relocation, mojave:        "2d98be5fcbb70d4b70288f795c7335c803c8353533d26a85d16815bbae54affd"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-ldflags", "-s -w", "./cmd/tools/cli/main.go"
  end

  test do
    # Given tctl is pointless without a server, not much intersting to test here.
    run_output = shell_output("#{bin}/tctl --version 2>&1")
    assert_match "tctl version", run_output

    run_output = shell_output("#{bin}/tctl --ad 192.0.2.0:1234 n l 2>&1", 1)
    assert_match "rpc error", run_output
  end
end
