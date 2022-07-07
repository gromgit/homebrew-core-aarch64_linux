class KymaCli < Formula
  desc "Kyma command-line interface"
  homepage "https://kyma-project.io"
  url "https://github.com/kyma-project/cli/archive/2.4.2.tar.gz"
  sha256 "c078ee797158c1f83115e01bb4731db9f7f13e0c5451b3134e81bb809fa30460"
  license "Apache-2.0"
  head "https://github.com/kyma-project/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b64373407b736e48ed5400bf3eb65b67997888f2ccfa3722539296949aef924a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1c07d75f369e3b805299089b70141f1b217ef12d40680ebc9cc4d1aaa4b5a7b6"
    sha256 cellar: :any_skip_relocation, monterey:       "32af410aa44659c8833632aaa36de9d760decc2134f73ac2e4b5aa0fdbb4cd23"
    sha256 cellar: :any_skip_relocation, big_sur:        "89b087ff93ce7ade5a2bbf080ff4606705347508f23ef0446727f04737de7f96"
    sha256 cellar: :any_skip_relocation, catalina:       "49df019adc82bd1ae706e29acd629cfde2d968a41693db761c5142f21dfb84f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c4b8b6488d0a1b6b75e80499cb114eb6a1ab18473b0d79c80caa8ffba7d4982b"
  end

  depends_on "go" => :build

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
      shell_output("#{bin}/kyma deploy --kubeconfig ./kubeconfig 2>&1", 1)
  end
end
