class Tilt < Formula
  desc "Define your dev environment as code. For microservice apps on Kubernetes"
  homepage "https://tilt.dev/"
  url "https://github.com/tilt-dev/tilt.git",
    tag:      "v0.23.6",
    revision: "5f22972fe19de54b3d66e31b30622adf056fe6d0"
  license "Apache-2.0"
  head "https://github.com/tilt-dev/tilt.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "195a43a927f61cb439ccc0e1bc516e2b51d586ea6acd0c4d85c5b820dfc0640e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "00773e358fae9d8b589d505b0b2a0b13736e618ba64bb19114dfd9a6813c961a"
    sha256 cellar: :any_skip_relocation, monterey:       "14a61d8b5510ea239a2ee0af9547abb5be41afd70e0f8a5f43f3f63364493dd7"
    sha256 cellar: :any_skip_relocation, big_sur:        "51cead6f66fbd428f2c447030746e6ffec1699f66da8f418ec42a0f53ea83237"
    sha256 cellar: :any_skip_relocation, catalina:       "844960648e420e1427a6b57c5321ff345e1bd2bf279ab016b79736ce1c61419c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "07cf56d694ad501036425d16cbf88d5b1d65ec783802ef3d530d19e5a739dc16"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1"
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{Utils.git_head}
      -X main.date=#{time.iso8601}
    ].join(" ")
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/tilt"
    # Install bash completion
    output = Utils.safe_popen_read("#{bin}/tilt", "completion", "bash")
    (bash_completion/"tilt").write output

    # Install zsh completion
    output = Utils.safe_popen_read("#{bin}/tilt", "completion", "zsh")
    (zsh_completion/"_tilt").write output

    # Install fish completion
    output = Utils.safe_popen_read("#{bin}/tilt", "completion", "fish")
    (fish_completion/"tilt.fish").write output
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tilt version")

    assert_match "Error: No tilt apiserver found: tilt-default", shell_output("#{bin}/tilt api-resources 2>&1", 1)
  end
end
