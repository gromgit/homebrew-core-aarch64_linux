class Helm < Formula
  desc "Kubernetes package manager"
  homepage "https://helm.sh/"
  url "https://github.com/helm/helm.git",
      tag:      "v3.8.2",
      revision: "6e3701edea09e5d55a8ca2aae03a68917630e91b"
  license "Apache-2.0"
  head "https://github.com/helm/helm.git", branch: "main"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/helm"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "913f1b4b8fb0dc135ee2c37e11a43d8fc9f5cac5bf6c0d8637e7912a64682137"
  end

  depends_on "go" => :build

  def install
    # Don't dirty the git tree
    rm_rf ".brew_home"

    system "make", "build"
    bin.install "bin/helm"

    mkdir "man1" do
      system bin/"helm", "docs", "--type", "man"
      man1.install Dir["*"]
    end

    output = Utils.safe_popen_read(bin/"helm", "completion", "bash")
    (bash_completion/"helm").write output

    output = Utils.safe_popen_read(bin/"helm", "completion", "zsh")
    (zsh_completion/"_helm").write output

    output = Utils.safe_popen_read(bin/"helm", "completion", "fish")
    (fish_completion/"helm.fish").write output
  end

  test do
    system bin/"helm", "create", "foo"
    assert File.directory? testpath/"foo/charts"

    version_output = shell_output(bin/"helm version 2>&1")
    assert_match "GitTreeState:\"clean\"", version_output
    if build.stable?
      revision = stable.specs[:revision]
      assert_match "GitCommit:\"#{revision}\"", version_output
      assert_match "Version:\"v#{version}\"", version_output
    end
  end
end
