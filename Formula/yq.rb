class Yq < Formula
  desc "Process YAML documents from the CLI"
  homepage "https://github.com/mikefarah/yq"
  url "https://github.com/mikefarah/yq/archive/v4.9.1.tar.gz"
  sha256 "7a15a78b9b6248f7207db54073fd685ca2966cdd9a4fd6601a9db446900b068e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b233737eb56868ab62e2a9d64ee4f798b97088cba2834671946112c60ac4cc46"
    sha256 cellar: :any_skip_relocation, big_sur:       "7dc5db8e42bb8b8eb147738a5c9a41eba06f18bc9cc29bc7aef356a8376deec6"
    sha256 cellar: :any_skip_relocation, catalina:      "8a452452cdd5e32e9a682be1290506d70b8519b780d3039239f9c7bc98d12976"
    sha256 cellar: :any_skip_relocation, mojave:        "24aaac5f6c5875456c953df2413e0357f9d9ccd091e79c8b36ce86d027bcd624"
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
