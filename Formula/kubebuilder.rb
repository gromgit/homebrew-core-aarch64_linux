class Kubebuilder < Formula
  desc "SDK for building Kubernetes APIs using CRDs"
  homepage "https://github.com/kubernetes-sigs/kubebuilder"
  url "https://github.com/kubernetes-sigs/kubebuilder.git",
      tag:      "v3.4.0",
      revision: "75241ab9ff9457de77e902645792cee41ba29fed"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/kubebuilder.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d0af64d511e0fcc2139d824f615dd6b4c08f24968559c173f459adc1f91217a8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6e6bb1dfaa0555b207743c519d30da7d8a0405fe0a55a0f51c47538d50fc4ac2"
    sha256 cellar: :any_skip_relocation, monterey:       "01f48b853108bd5fd059e22dd2caf309abeacf2f191f857bfec3ba78b4ecff0e"
    sha256 cellar: :any_skip_relocation, big_sur:        "ca3d9ea050a990d098df8b62310ae08bcecbe9a1be53d7c67a116e859253ce6e"
    sha256 cellar: :any_skip_relocation, catalina:       "07dda47a62aaf114b3c9880b349651d0c11b68de45424bcf9ce50bb21600acfa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9489ce54dab93d234511c3228e34d380ed8197f1a2dc773f4c3e88dca4a790bc"
  end

  depends_on "git-lfs" => :build
  depends_on "go"

  def install
    goos = Utils.safe_popen_read("#{Formula["go"].bin}/go", "env", "GOOS").chomp
    goarch = Utils.safe_popen_read("#{Formula["go"].bin}/go", "env", "GOARCH").chomp
    ldflags = %W[
      -X main.kubeBuilderVersion=#{version}
      -X main.goos=#{goos}
      -X main.goarch=#{goarch}
      -X main.gitCommit=#{Utils.git_head}
      -X main.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd"

    output = Utils.safe_popen_read(bin/"kubebuilder", "completion", "bash")
    (bash_completion/"kubebuilder").write output
    output = Utils.safe_popen_read(bin/"kubebuilder", "completion", "zsh")
    (zsh_completion/"_kubebuilder").write output
    output = Utils.safe_popen_read(bin/"kubebuilder", "completion", "fish")
    (fish_completion/"kubebuilder.fish").write output
  end

  test do
    assert_match "KubeBuilderVersion:\"#{version}\"", shell_output("#{bin}/kubebuilder version 2>&1")
    mkdir "test" do
      system "go", "mod", "init", "example.com"
      system "#{bin}/kubebuilder", "init",
        "--plugins", "go/v3", "--project-version", "3",
        "--skip-go-version-check"
    end
  end
end
