class Yq < Formula
  desc "Process YAML documents from the CLI"
  homepage "https://github.com/mikefarah/yq"
  url "https://github.com/mikefarah/yq/archive/v4.25.1.tar.gz"
  sha256 "2f0736f0650bef121e31332e1f52c67e9bd975ca651e1507a2e5e3744c10e766"
  license "MIT"
  head "https://github.com/mikefarah/yq.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3fc9b1d59f24581951558ef8fd544f4e48ace2d459787fe5da8bc226cb52b44f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1b1ad4bbba155bbeaf4e490d020d112e69388c076dceed9c574303fc009b3979"
    sha256 cellar: :any_skip_relocation, monterey:       "3fd6ea80cf85413b429eef0de7b904859396c12107c42309797346f0ec44d980"
    sha256 cellar: :any_skip_relocation, big_sur:        "1cacaa1e83ffc595dad3b02838ee017ea76f93901196d9995c23e2ae7c79247a"
    sha256 cellar: :any_skip_relocation, catalina:       "eae4d9570b589dcb436703670d4ff0cdff43e58848aeca1eafd617d45aa81efd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c5e09f4a7ee45ed444c9e05f86b54e11487a89331442c092c83de17304d1a8a0"
  end

  depends_on "go" => :build
  depends_on "pandoc" => :build

  conflicts_with "python-yq", because: "both install `yq` executables"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    # Install shell completions
    (bash_completion/"yq").write Utils.safe_popen_read(bin/"yq", "shell-completion", "bash")
    (zsh_completion/"_yq").write Utils.safe_popen_read(bin/"yq", "shell-completion", "zsh")
    (fish_completion/"yq.fish").write Utils.safe_popen_read(bin/"yq", "shell-completion", "fish")

    # Install man pages
    system "./scripts/generate-man-page-md.sh"
    system "./scripts/generate-man-page.sh"
    man1.install "yq.1"
  end

  test do
    assert_equal "key: cat", shell_output("#{bin}/yq eval --null-input --no-colors '.key = \"cat\"'").chomp
    assert_equal "cat", pipe_output("#{bin}/yq eval \".key\" -", "key: cat", 0).chomp
  end
end
