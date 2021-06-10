class Yq < Formula
  desc "Process YAML documents from the CLI"
  homepage "https://github.com/mikefarah/yq"
  url "https://github.com/mikefarah/yq/archive/v4.9.5.tar.gz"
  sha256 "6b5213acf183db262653ad0790114505281aac025e2c4f140e04877d5c43bd9c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "4e5f6923b5f1d12ee1e7d3c8810561365a2f02fc39e8ea00398fe9b7d7452883"
    sha256 cellar: :any_skip_relocation, big_sur:       "1835cb295a791f82b5356c2d30a6c0949f57d4ef38cba6fe8552bddabb08a856"
    sha256 cellar: :any_skip_relocation, catalina:      "6dbbbe70c8a6562760eb6421b258a946b9a201db6c0669ebea0111b55fba1c97"
    sha256 cellar: :any_skip_relocation, mojave:        "92bf7cf0c9c01d923d16f0f902f59c5e7d945f5d31805c375d124f474cb0ed58"
  end

  depends_on "go" => :build

  conflicts_with "python-yq", because: "both install `yq` executables"

  def install
    system "go", "build", "-ldflags", "-s -w", *std_go_args

    (bash_completion/"yq").write Utils.safe_popen_read("#{bin}/yq", "shell-completion", "bash")
    (zsh_completion/"_yq").write Utils.safe_popen_read("#{bin}/yq", "shell-completion", "zsh")
    (fish_completion/"yq.fish").write Utils.safe_popen_read("#{bin}/yq", "shell-completion", "fish")
  end

  test do
    assert_equal "key: cat", shell_output("#{bin}/yq eval --null-input --no-colors '.key = \"cat\"'").chomp
    assert_equal "cat", pipe_output("#{bin}/yq eval \".key\" -", "key: cat", 0).chomp
  end
end
