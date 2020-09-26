class ChartTesting < Formula
  desc "Testing and linting Helm charts"
  homepage "https://github.com/helm/chart-testing"
  url "https://github.com/helm/chart-testing.git",
      tag:      "v3.1.1",
      revision: "3fc5a5010805e92d099ecacfba57b7c60c12d44a"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "2da98bb66be3b8bf89f22715b41ac5d34c575edf9dba3c03029f06088b312c59" => :catalina
    sha256 "0cabedffe7f3b96dedaf3ffc12ebe3f669e66bb026a6a2dd503d338c54ff41e0" => :mojave
    sha256 "c29b17cde85ef7b98ab5a590b43fa8cbabd8d7bba2115e46a9c0630c4ea9203f" => :high_sierra
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
