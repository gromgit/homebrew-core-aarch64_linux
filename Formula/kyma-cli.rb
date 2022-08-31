class KymaCli < Formula
  desc "Kyma command-line interface"
  homepage "https://kyma-project.io"
  url "https://github.com/kyma-project/cli/archive/2.6.1.tar.gz"
  sha256 "535035b946ee0f47d26f08157af951c2d2cdcbb65cfea0d13440e564bc41ad75"
  license "Apache-2.0"
  head "https://github.com/kyma-project/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d6da0e860837c02cf64ba5717ca60eb09f5fb8d606221134f4741b9ca828424a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "12913c2b3bff815506f2fff324c045f9799faa5ea218e07a7cc5bdb0329a5a27"
    sha256 cellar: :any_skip_relocation, monterey:       "0ee137ae9f4230dc7449bd7ff09cf2cd3a1bf67244c01e83476e4f3907a2ee90"
    sha256 cellar: :any_skip_relocation, big_sur:        "c069e65ca1afc1c2b8495eac7d776e4270be8022da880213a1923e6f400fdc2d"
    sha256 cellar: :any_skip_relocation, catalina:       "630cd2be65d8ed573a2e9960d73ee6002d406733470fa070236707232db621c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "72179278d9210d782b45cd173119c843daae48d5cd8999eb1de52267226eb8d4"
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
