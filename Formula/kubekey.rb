class Kubekey < Formula
  desc "Installer for Kubernetes and / or KubeSphere, and related cloud-native add-ons"
  homepage "https://kubesphere.io"
  url "https://github.com/kubesphere/kubekey.git",
      tag:      "v2.0.0",
      revision: "ff9d30b7a07ed2219b0c82f1946307dbcc76975b"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/kubekey"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "42db4a35be1524de8a4e70c18ffeaf9f1ba4998139e379f1b31f1fd3f105fe15"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/kubesphere/kubekey/version.version=v#{version}
      -X github.com/kubesphere/kubekey/version.gitCommit=#{Utils.git_head}
      -X github.com/kubesphere/kubekey/version.gitTreeState=clean
    ]
    system "go", "build", *std_go_args(ldflags: ldflags, output: bin/"kk"), "./cmd"

    (zsh_completion/"_kk").write Utils.safe_popen_read(bin/"kk", "completion", "--type", "zsh")
    (bash_completion/"kk").write Utils.safe_popen_read(bin/"kk", "completion", "--type", "bash")
  end

  test do
    version_output = shell_output(bin/"kk version")
    assert_match "Version:\"v#{version}\"", version_output
    assert_match "GitTreeState:\"clean\"", version_output

    system bin/"kk", "create", "config", "-f", "homebrew.yaml"
    assert_predicate testpath/"homebrew.yaml", :exist?
  end
end
