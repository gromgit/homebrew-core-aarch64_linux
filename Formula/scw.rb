class Scw < Formula
  desc "Command-line Interface for Scaleway"
  homepage "https://github.com/scaleway/scaleway-cli"
  url "https://github.com/scaleway/scaleway-cli/archive/v2.0.0.tar.gz"
  sha256 "3f219c83e3766eb253791ac74c6bf92f8b2234e147cf5d268254cf5cc6ab7d03"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "1534981c7a030117408095b219d79614333acbb4ead6ecf4b11625acf7b186c7" => :catalina
    sha256 "1c7a69355bafd8c035bb2878f6c9c7a9a013dacc8cdbdc1997b66bc49f7fd7f0" => :mojave
    sha256 "87a2f754ab3e1c5434a2b24b855de6e5da39990bf9cf558416fc2e259d66d0ab" => :high_sierra
    sha256 "b5727720c3f4173012c81b8dfee1a942262d430ae6951c0f39a9c28aefc21b83" => :sierra
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
