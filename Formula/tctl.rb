class Tctl < Formula
  desc "Temporal CLI (tctl)"
  homepage "https://temporal.io/"
  url "https://github.com/temporalio/temporal/archive/v1.14.1.tar.gz"
  sha256 "25beb6f8731f772adc73a24034c764ee9ab29a2ef2d85a53acbabf27342452bd"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2a4a0ffdd5329072dc05ecd76bb0295cad8ad8c6ab2fe9b153703ed95941af1f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e64481f69531ee80fe9a2991891f08e9ceef769877240d8b3fa8c78831e18953"
    sha256 cellar: :any_skip_relocation, monterey:       "62f3549b9554f0e39ec39f498053edba2e2c31772f7fa23de1f87794942b65c4"
    sha256 cellar: :any_skip_relocation, big_sur:        "6c68ab02d3ed6c492ba6eede877d34246887430feb7feaa551c8bf43f274cd4c"
    sha256 cellar: :any_skip_relocation, catalina:       "0e9ae649cf18f76bf9c0c438ecff6f98834922cfcd2dd016f38622dbf9227a59"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b7175c99e02fcad28f00c0b7f94e1ebdcf3bd80a3894653a39173fb5cb63a2aa"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/tools/cli/main.go"
    system "go", "build", *std_go_args(ldflags: "-s -w"), "-o", bin/"tctl-authorization-plugin",
      "./cmd/tools/cli/plugins/authorization/main.go"
  end

  test do
    # Given tctl is pointless without a server, not much intersting to test here.
    run_output = shell_output("#{bin}/tctl --version 2>&1")
    assert_match "tctl version", run_output

    run_output = shell_output("#{bin}/tctl --ad 192.0.2.0:1234 n l 2>&1", 1)
    assert_match "rpc error", run_output
  end
end
