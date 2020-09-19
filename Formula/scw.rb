class Scw < Formula
  desc "Command-line Interface for Scaleway"
  homepage "https://github.com/scaleway/scaleway-cli"
  url "https://github.com/scaleway/scaleway-cli/archive/v2.1.0.tar.gz"
  sha256 "31348c29afa84a88f272492f4173a7c13a2fa7595eaddfcfb0a5eb843efb5e16"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "208f281b7f07ea134beea711b3b51504bfffbaa2360f71c800613b8401001407" => :catalina
    sha256 "3f1d0aef845c980ea49a2ea57ea6b164ec7528c7bf51904577055471a1f018fc" => :mojave
    sha256 "819714375ff096fb5b0bbdbf11105c0e3d97a5d027ead59bb1d784673cffa279" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./cmd/scw"

    zsh_output = Utils.safe_popen_read({ "SHELL" => "zsh" }, bin/"scw", "autocomplete", "script")
    (zsh_completion/"_scw").write zsh_output

    bash_output = Utils.safe_popen_read({ "SHELL" => "bash" }, bin/"scw", "autocomplete", "script")
    (bash_completion/"scw").write bash_output

    fish_output = Utils.safe_popen_read({ "SHELL" => "fish" }, bin/"scw", "autocomplete", "script")
    (fish_completion/"scw.fish").write fish_output
  end

  test do
    (testpath/"config.yaml").write ""
    output = shell_output(bin/"scw -c config.yaml config set access-key=SCWXXXXXXXXXXXXXXXXX")
    assert_match "✅ Successfully update config.", output
    assert_match "access_key: SCWXXXXXXXXXXXXXXXXX", File.read(testpath/"config.yaml")
  end
end
