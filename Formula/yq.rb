class Yq < Formula
  desc "Process YAML documents from the CLI"
  homepage "https://github.com/mikefarah/yq"
  url "https://github.com/mikefarah/yq/archive/v4.9.2.tar.gz"
  sha256 "ef0e2090e6c3b420b4af93cf1611ecfba15472f8ad4428bb4e2d3b507b2dd857"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ab7aa0c7eb3f1f25289aec491e8a36afe2cf9b41f06ea61278d5c0a99f73ee2e"
    sha256 cellar: :any_skip_relocation, big_sur:       "5a3dfdada48bb74e506df610c50d10544b5b4e33f0015c0af7b8cd31ca846830"
    sha256 cellar: :any_skip_relocation, catalina:      "21a556c5f3902305fb47de2bf03a2adc4bf320f63811de359f3babd4f6abb88e"
    sha256 cellar: :any_skip_relocation, mojave:        "5a7a6ecffadf1af022a3e2d77877dc70b680c04b271759f6aedaf62b7126b540"
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
