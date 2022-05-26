class KubernetesCli < Formula
  desc "Kubernetes command-line interface"
  homepage "https://kubernetes.io/"
  url "https://github.com/kubernetes/kubernetes.git",
      tag:      "v1.24.1",
      revision: "3ddd0f45aa91e2f30c70734b175631bec5b5825a"
  license "Apache-2.0"
  head "https://github.com/kubernetes/kubernetes.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "199c8ce749bba4e4db631af6c7ff2c15fc1d42d6f3ee3eed2044427484739ef8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "74ac0aeeb34d57c543c37d71b6d4531381b124d79b7941cff89ba4a2ff8fde6a"
    sha256 cellar: :any_skip_relocation, monterey:       "a99fd01e6408f2bf6f8a2fffe73d9f35da79e9339f96ad3433e17f44cff63df0"
    sha256 cellar: :any_skip_relocation, big_sur:        "71472417ab135dace54486426953c2270b8f25af28b5217ab8a3155140636a8d"
    sha256 cellar: :any_skip_relocation, catalina:       "0d1c833fabf2be6865ac957f9e702b511421ff60cd5c0aca362bfabe89fdc899"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "94376340a1f9558ff2d630dc1e9639cc330a645be6ca44ea1221f4847ff9dbfd"
  end

  depends_on "bash" => :build
  depends_on "coreutils" => :build
  depends_on "go" => :build

  uses_from_macos "rsync" => :build

  def install
    # Don't dirty the git tree
    rm_rf ".brew_home"

    # Make binary
    # Deparallelize to avoid race conditions in creating symlinks, creating an error like:
    #   ln: failed to create symbolic link: File exists
    # See https://github.com/kubernetes/kubernetes/issues/106165
    ENV.deparallelize
    ENV.prepend_path "PATH", Formula["coreutils"].libexec/"gnubin" # needs GNU date
    system "make", "WHAT=cmd/kubectl"
    bin.install "_output/bin/kubectl"

    # Install bash completion
    output = Utils.safe_popen_read(bin/"kubectl", "completion", "bash")
    (bash_completion/"kubectl").write output

    # Install zsh completion
    output = Utils.safe_popen_read(bin/"kubectl", "completion", "zsh")
    (zsh_completion/"_kubectl").write output

    # Install fish completion
    output = Utils.safe_popen_read(bin/"kubectl", "completion", "fish")
    (fish_completion/"kubectl.fish").write output

    # Install man pages
    # Leave this step for the end as this dirties the git tree
    system "hack/update-generated-docs.sh"
    man1.install Dir["docs/man/man1/*.1"]
  end

  test do
    run_output = shell_output("#{bin}/kubectl 2>&1")
    assert_match "kubectl controls the Kubernetes cluster manager.", run_output

    version_output = shell_output("#{bin}/kubectl version --client 2>&1")
    assert_match "GitTreeState:\"clean\"", version_output
    if build.stable?
      revision = stable.specs[:revision]
      assert_match revision.to_s, version_output
    end
  end
end
