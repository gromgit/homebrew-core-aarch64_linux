class Yq < Formula
  desc "Process YAML documents from the CLI"
  homepage "https://github.com/mikefarah/yq"
  url "https://github.com/mikefarah/yq/archive/4.0.0.tar.gz"
  sha256 "343916095f92925f8ea00554fafa62110cb0f8220afc2961577abbc0c6e48e8f"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "cce7e56eea53fc1aa33bf8994a8528ad577f49fe118986f5c55f1c246d215edd" => :big_sur
    sha256 "00057268cd051af30c032b60cace608d4ce933db3d72720a04ddfa74f683086b" => :catalina
    sha256 "bf895832c539c38bdbe2958dd2f905dcf80c65fed75a3cc2778fed922b5fffe5" => :mojave
    sha256 "565f6be0a3c42a456985be592916773d394f2931b9d380692505188f9828290a" => :high_sierra
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
