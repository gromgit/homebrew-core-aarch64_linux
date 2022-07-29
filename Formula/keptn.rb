class Keptn < Formula
  desc "Is the CLI for keptn.sh a message-driven control-plane for application delivery"
  homepage "https://keptn.sh"
  url "https://github.com/keptn/keptn/archive/0.18.0.tar.gz"
  sha256 "cd75cb9848bf22b5b61034807b0aa8e048dddad16bfa5b0ee090d2aebea3cce5"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5c70bc4712a53f767f7d827959036d86ceef2538f484ad4d111d9e80fb761f8d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "57bdbdd3ee49abd130f28c84f2ba84f81247ab3c02f6e5c4b3888087acfd124b"
    sha256 cellar: :any_skip_relocation, monterey:       "7d68abcb38accbbda6031c9f9850f46602c8beb074cdb601ea9f0ba7b59bd328"
    sha256 cellar: :any_skip_relocation, big_sur:        "21d173536e135c07eb411ec91355cd1e40e7fd31c23a350a9bf6c2c33f911490"
    sha256 cellar: :any_skip_relocation, catalina:       "2f3e5b95ce4814f4fb2faaf62112e94ed216e4564cfce3779edf23235a494653"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5cefe3841ad85cc2c412ff721398cc2e79bff3056400ae6ec99ec29ae627bdee"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/keptn/keptn/cli/cmd.Version=#{version}
      -X main.KubeServerVersionConstraints=""
    ]

    cd buildpath/"cli" do
      system "go", "build", *std_go_args(ldflags: ldflags)
    end
  end

  test do
    system bin/"keptn", "set", "config", "AutomaticVersionCheck", "false"
    system bin/"keptn", "set", "config", "kubeContextCheck", "false"

    assert_match "Keptn CLI version: #{version}", shell_output(bin/"keptn version 2>&1")

    output = shell_output(bin/"keptn status 2>&1", 1)
    if OS.mac?
      assert_match "Error: credentials not found in native keychain", output
    else
      assert_match ".keptn/.keptn____keptn: no such file or directory", output
    end
  end
end
