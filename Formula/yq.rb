class Yq < Formula
  desc "Process YAML documents from the CLI"
  homepage "https://github.com/mikefarah/yq"
  url "https://github.com/mikefarah/yq/archive/v4.13.2.tar.gz"
  sha256 "7a7275b9c67cfcb9de9dd94496510861319590f82fa42340777ab92999e6adb9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "4dba98d234b071ae4771626bb66880e5698d1488386441b0feb4f9e8b2cc6f0c"
    sha256 cellar: :any_skip_relocation, big_sur:       "1a27e336f9253a49f8ca84413c4bb65a8bb68346ff8eaae7710634633c9ad2db"
    sha256 cellar: :any_skip_relocation, catalina:      "653d837aa25dcdad6fe6a04158d796fe1f3ec5c32b372a068feac084c9eb9783"
    sha256 cellar: :any_skip_relocation, mojave:        "fc5857fdac7f1e53a5eb9fc2dc4be05f53f100b8507deebeb19a6f9891c4c63e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dbaea8d7da4db2e483f192191fdc3a9b5070cc4fd2e8fe747821c2afc53eff97"
  end

  depends_on "go" => :build

  conflicts_with "python-yq", because: "both install `yq` executables"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    (bash_completion/"yq").write Utils.safe_popen_read("#{bin}/yq", "shell-completion", "bash")
    (zsh_completion/"_yq").write Utils.safe_popen_read("#{bin}/yq", "shell-completion", "zsh")
    (fish_completion/"yq.fish").write Utils.safe_popen_read("#{bin}/yq", "shell-completion", "fish")
  end

  test do
    assert_equal "key: cat", shell_output("#{bin}/yq eval --null-input --no-colors '.key = \"cat\"'").chomp
    assert_equal "cat", pipe_output("#{bin}/yq eval \".key\" -", "key: cat", 0).chomp
  end
end
