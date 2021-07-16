class Yq < Formula
  desc "Process YAML documents from the CLI"
  homepage "https://github.com/mikefarah/yq"
  url "https://github.com/mikefarah/yq/archive/v4.10.0.tar.gz"
  sha256 "69f2f8de1e0c5a2d6e529b471f47c2cfacf072ee751e936fd81d645a09346f30"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "68fe081b507e2b84858ca7078b20d9642620bf7f3f9afc24797bd4f03bc70c26"
    sha256 cellar: :any_skip_relocation, big_sur:       "8fe4011508695d98e1adedc9feb517f5b11d4c638917576c6cda73357536c4e1"
    sha256 cellar: :any_skip_relocation, catalina:      "79c49538120e39cc069d31548e19faed317b5a7d585e7842986671e897c66e21"
    sha256 cellar: :any_skip_relocation, mojave:        "51c03c5a2e2c4b942b4a44e815842e888aac048fe8073d0263acc9ce930708f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5cbd88b87ca528342c671527fe91c7cd773e39fc8cecf3b5d4307290451662a4"
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
