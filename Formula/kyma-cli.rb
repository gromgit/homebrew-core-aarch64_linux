class KymaCli < Formula
  desc "Kyma command-line interface"
  homepage "https://kyma-project.io"
  url "https://github.com/kyma-project/cli/archive/2.0.4.tar.gz"
  sha256 "096892c1773f40a8dc23551b2b211873e7a01572ec333bdedf0a3588941ca292"
  license "Apache-2.0"
  head "https://github.com/kyma-project/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a35cff5b12f383c4bf49c662f175ae9131c3ba3a505e187d01340e72811a0712"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "040aeecf3d8674da7753a89b9ca722d1244457fde7bf42af15ba48d42df80ea4"
    sha256 cellar: :any_skip_relocation, monterey:       "4185ae138d3480d04c222ee35528f436f960d7b6f4880798beef06b3b05e9293"
    sha256 cellar: :any_skip_relocation, big_sur:        "03d4b27a0159f318f2e848435de56966492ce0c39e8d305eae3a6d507d574e54"
    sha256 cellar: :any_skip_relocation, catalina:       "bffc109e4993252260bb0b12eeea96089d15009d8226e548d191217f5ee9ec67"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7d00bb6325a3d3a923cb9972c77809628eb6b8914401188cdb823f932fb28582"
  end

  depends_on "go" => :build
  depends_on macos: :catalina

  def install
    ldflags = %W[
      -s -w
      -X github.com/kyma-project/cli/cmd/kyma/version.Version=#{version}
    ]

    system "go", "build", *std_go_args(output: bin/"kyma", ldflags: ldflags), "./cmd"
  end

  test do
    touch testpath/"kubeconfig"
    assert_match "invalid configuration",
      shell_output("#{bin}/kyma install --kubeconfig ./kubeconfig 2>&1", 1)
  end
end
