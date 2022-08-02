class KymaCli < Formula
  desc "Kyma command-line interface"
  homepage "https://kyma-project.io"
  url "https://github.com/kyma-project/cli/archive/2.5.0.tar.gz"
  sha256 "12c06832e8083e620e8b8509d43309d578f8cedb2c1e865a091102b6e44004e3"
  license "Apache-2.0"
  head "https://github.com/kyma-project/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "976b0344f0da39b66ee0d7f3f0d540065354a655c5a4c2b2c848fd21438ca496"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c8886134b0ceaa0de54197e5237632c724d15f1021007e75cee92f04ebef565e"
    sha256 cellar: :any_skip_relocation, monterey:       "adc137113c584ca9de3cf590d199f46ae90d097585fd0840ce7bc2afe12cae8d"
    sha256 cellar: :any_skip_relocation, big_sur:        "9ba99ad0923b2737aea0b0dd794af37c197f6f80320e7f38d8cf5ee66df12c2f"
    sha256 cellar: :any_skip_relocation, catalina:       "58fb434ec970df66972e1ba848708fcfe8474692424651cd300194bfef4078bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4a0cb5b64288876d8359c36d34938b16fd12d877c262892c8144f3eceb181bf5"
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
