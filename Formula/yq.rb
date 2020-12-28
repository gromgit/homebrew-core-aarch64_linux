class Yq < Formula
  desc "Process YAML documents from the CLI"
  homepage "https://github.com/mikefarah/yq"
  url "https://github.com/mikefarah/yq/archive/v4.2.0.tar.gz"
  sha256 "19a75856c35cf99d7547faa5d00144b7a0d9e03ef04d10a20cd739dd8280ea7d"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "cbc1cbc2d97986e68c712a8209ae3bea8453bc26835e9785b4b8731d05986d0c" => :big_sur
    sha256 "748c60bb49b215125720b8f5fdf234ed1acda3b1325a54fb3eff37edd39939e5" => :arm64_big_sur
    sha256 "f7a59c64d025533a1aa2da66d8bd5170378fdc25f82d3778b707d115e1e6f829" => :catalina
    sha256 "a7e3858366f036092d10edc52f0a9b371d4afc1ff9db671b7200bb8e84101fe6" => :mojave
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
    assert_equal "cat", pipe_output("#{bin}/yq eval --null-input \".key\" -", "key: cat", 0).chomp
  end
end
