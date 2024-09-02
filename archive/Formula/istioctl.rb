class Istioctl < Formula
  desc "Istio configuration command-line utility"
  homepage "https://istio.io/"
  url "https://github.com/istio/istio.git",
      tag:      "1.13.3",
      revision: "b28579cb30c12c428ea58279b7c06f3302abe924"
  license "Apache-2.0"
  head "https://github.com/istio/istio.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4f9af8f525a14e85b0f47ef143183d716773a494fa5c814bcdf28990cdc57727"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4f9af8f525a14e85b0f47ef143183d716773a494fa5c814bcdf28990cdc57727"
    sha256 cellar: :any_skip_relocation, monterey:       "a1f68aa18ab260b020f172d00f74dd5d0ff426d223999014aa5efe8c047783b0"
    sha256 cellar: :any_skip_relocation, big_sur:        "a1f68aa18ab260b020f172d00f74dd5d0ff426d223999014aa5efe8c047783b0"
    sha256 cellar: :any_skip_relocation, catalina:       "a1f68aa18ab260b020f172d00f74dd5d0ff426d223999014aa5efe8c047783b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ea9bfae503906e4a6f33f69cfcd14f0d446d81dab62af04268333787f86bfcdc"
  end

  depends_on "go" => :build
  depends_on "go-bindata" => :build

  uses_from_macos "curl" => :build

  def install
    ENV["VERSION"] = version.to_s
    ENV["TAG"] = version.to_s
    ENV["ISTIO_VERSION"] = version.to_s
    ENV["HUB"] = "docker.io/istio"
    ENV["BUILD_WITH_CONTAINER"] = "0"

    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "amd64" : Hardware::CPU.arch.to_s

    system "make", "istioctl"
    bin.install "out/#{os}_#{arch}/istioctl"

    # Install bash completion
    output = Utils.safe_popen_read(bin/"istioctl", "completion", "bash")
    (bash_completion/"istioctl").write output

    # Install zsh completion
    output = Utils.safe_popen_read(bin/"istioctl", "completion", "zsh")
    (zsh_completion/"_istioctl").write output

    # Install fish completion
    output = Utils.safe_popen_read(bin/"istioctl", "completion", "fish")
    (fish_completion/"istioctl.fish").write output
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/istioctl version --remote=false").strip
  end
end
