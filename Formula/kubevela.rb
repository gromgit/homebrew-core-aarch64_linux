class Kubevela < Formula
  desc "Application Platform based on Kubernetes and Open Application Model"
  homepage "https://kubevela.io"
  url "https://github.com/kubevela/kubevela.git",
      tag:      "v1.3.3",
      revision: "45e1de19dc736b10b3eb2d908d809210f470b24f"
  license "Apache-2.0"
  head "https://github.com/kubevela/kubevela.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/kubevela"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "f99620366c27ac3d537f01b2f1ba269dcaf48eafa3ce4450d0b8298da506a583"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = %W[
      -s -w
      -X github.com/kubevela/kubevela/version.VelaVersion=#{version}
      -X github.com/kubevela/kubevela/version.GitRevision=#{Utils.git_head}
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
