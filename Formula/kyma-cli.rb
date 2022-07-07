class KymaCli < Formula
  desc "Kyma command-line interface"
  homepage "https://kyma-project.io"
  url "https://github.com/kyma-project/cli/archive/2.4.2.tar.gz"
  sha256 "c078ee797158c1f83115e01bb4731db9f7f13e0c5451b3134e81bb809fa30460"
  license "Apache-2.0"
  head "https://github.com/kyma-project/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bbb34b6a570a6356432080428e24d643039e66932b54354fc56d71d86bced201"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3ee02082c13d35e543adfe748f959269e8593eddcfd2fd84284979600d939157"
    sha256 cellar: :any_skip_relocation, monterey:       "eb32da2c7325b3c2b2bfb5e48733f3b338c689b8652ee7fdd529a0695999e731"
    sha256 cellar: :any_skip_relocation, big_sur:        "2201bd2aedb2ecf328b5faa6bf4047fc8b5867d949700f01f7966204b95d38c7"
    sha256 cellar: :any_skip_relocation, catalina:       "f0e17d02034f951db6564b7aba44d2fd531abc4919a7afb709ce457469722952"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7c000a6b62a5294262f278a9f5838699904acbf5a0565b1eb05538fff9d4d424"
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
