class ChartTesting < Formula
  desc "Testing and linting Helm charts"
  homepage "https://github.com/helm/chart-testing"
  url "https://github.com/helm/chart-testing.git",
      tag:      "v3.2.0",
      revision: "2407e7df462ea3bc85cefd9b5870526bc7806a9f"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "1fff6489d5da97f4e3842355ed53d15319ef11b70b109fa52c77169ddb9d226a" => :catalina
    sha256 "c0a62b14709e97d855cc42cc4dba59ba4d1d7f954701d56e23c121e0976857fc" => :mojave
    sha256 "a98358affb60b107631ad50e8b36d5b16c87f5a9517f033cc28ff34facadced4" => :high_sierra
  end

  depends_on "go" => :build
  depends_on "helm" => :test
  depends_on "yamllint" => :test

  def install
    commit = Utils.safe_popen_read("git", "rev-parse", "HEAD").chomp
    ldflags = %W[
      -X github.com/helm/chart-testing/v#{version.major}/ct/cmd.Version=#{version}
      -X github.com/helm/chart-testing/v#{version.major}/ct/cmd.GitCommit=#{commit}
      -X github.com/helm/chart-testing/v#{version.major}/ct/cmd.BuildDate=#{Date.today}
    ].join(" ")
    system "go", "build", *std_go_args, "-ldflags", ldflags, "-o", bin/"ct", "./ct/main.go"
    etc.install "etc" => "ct"
  end

  test do
    assert_match "Lint and test", shell_output("#{bin}/ct --help")
    assert_match /Version:\s+#{version}/, shell_output("#{bin}/ct version")

    # Lint an empty Helm chart that we create with `helm create`
    system "helm", "create", "testchart"
    output = shell_output("#{bin}/ct lint --charts ./testchart --validate-chart-schema=false" \
                          " --validate-maintainers=false").lines.last.chomp
    assert_match "All charts linted successfully", output
  end
end
