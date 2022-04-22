class Kubevela < Formula
  desc "Application Platform based on Kubernetes and Open Application Model"
  homepage "https://kubevela.io"
  url "https://github.com/oam-dev/kubevela.git",
      tag:      "v1.3.2",
      revision: "d08aa7d12c8a3d130a2428b25fd75cf30ed23b25"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "520fddc1963630af7ecf37a814d4a105fdf167dd8ef317e111d946276499eb9c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "520fddc1963630af7ecf37a814d4a105fdf167dd8ef317e111d946276499eb9c"
    sha256 cellar: :any_skip_relocation, monterey:       "34564a41ae079f015812b5c50c1b89e8a5905e107339e288bbb73a834fbd0000"
    sha256 cellar: :any_skip_relocation, big_sur:        "34564a41ae079f015812b5c50c1b89e8a5905e107339e288bbb73a834fbd0000"
    sha256 cellar: :any_skip_relocation, catalina:       "34564a41ae079f015812b5c50c1b89e8a5905e107339e288bbb73a834fbd0000"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "96e4333a4412c5480d93b6fc3fe2ad6783b6c7093246dcc48847ccac796f0da1"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = %W[
      -s -w
      -X github.com/oam-dev/kubevela/version.VelaVersion=#{version}
      -X github.com/oam-dev/kubevela/version.GitRevision=#{Utils.git_head}
    ]

    system "go", "build", *std_go_args(output: bin/"vela", ldflags: ldflags), "./references/cmd/cli"
  end

  test do
    # Should error out as vela up need kubeconfig
    status_output = shell_output("#{bin}/vela up 2>&1", 1)
    assert_match "error: no configuration has been provided", status_output

    (testpath/"kube-config").write <<~EOS
      apiVersion: v1
      clusters:
      - cluster:
          certificate-authority-data: test
          server: http://127.0.0.1:8080
        name: test
      contexts:
      - context:
          cluster: test
          user: test
        name: test
      current-context: test
      kind: Config
      preferences: {}
      users:
      - name: test
        user:
          token: test
    EOS

    ENV["KUBECONFIG"] = testpath/"kube-config"
    version_output = shell_output("#{bin}/vela version 2>&1")
    assert_match "Version: #{version}", version_output
  end
end
