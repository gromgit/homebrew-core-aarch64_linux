class Yq < Formula
  desc "Process YAML documents from the CLI"
  homepage "https://github.com/mikefarah/yq"
  url "https://github.com/mikefarah/yq/archive/v4.26.1.tar.gz"
  sha256 "aa280a6facafc8fc5d0f3b5926a0f990ed16520dec8cb18f33752dbf6b8dc998"
  license "MIT"
  head "https://github.com/mikefarah/yq.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a3521bdc09529e647180a9dc09382c031696702295ae5581a0ff82230bc794ee"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f0d3ceba912448bf487ed915b31068ce49ae162b2cab3553399cf98d00af22ee"
    sha256 cellar: :any_skip_relocation, monterey:       "3f81e7e9295c4c52b1f81ad59a4549f7ddec567fdc670d0dce11df7a0e350425"
    sha256 cellar: :any_skip_relocation, big_sur:        "5623c7c77b09cddac5d2fe2fad1957a02e88bf1e03ac0b4a070480a74f5dd735"
    sha256 cellar: :any_skip_relocation, catalina:       "5f4361e3a5e5e674b5ac88fd4c70b283f17a31263a6ee89548574750afb3b2c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b797b360866bcca5c8a6872edc1fb057a1ab9fa6a18ed2518d78b2424f93c7fd"
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
