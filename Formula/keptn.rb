class Keptn < Formula
  desc "Is the CLI for keptn.sh a message-driven control-plane for application delivery"
  homepage "https://keptn.sh"
  url "https://github.com/keptn/keptn/archive/0.14.2.tar.gz"
  sha256 "141b18f3ae1a1bab2ea4075883336380e46b6195c5dbf39ca83e8d66f7e53e45"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ba21814dbf7e354410e3f89658eb40faacc9dbab2f96b7481b939c229f756519"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fd3b93b894fcc4970c52dc8107587ba690cd6a6f41303c995940d3d732453ee5"
    sha256 cellar: :any_skip_relocation, monterey:       "b06b919c4934585db2d61873af2d82406110a93162cbc61d453f51ed5ba7ec32"
    sha256 cellar: :any_skip_relocation, big_sur:        "0a15c3964172896888b16fcfec08f4fda49ca73aaa15f537d840d2c7b81b472d"
    sha256 cellar: :any_skip_relocation, catalina:       "403b4f8b4e4ce0f616e07facc4e3998c810f6c53726227e527edbb49fbf0216e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1516863994bf2b13274d48f9f6b3f52d342e6efdf2100907d50d570d6b6e3621"
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
