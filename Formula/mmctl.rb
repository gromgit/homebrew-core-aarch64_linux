class Mmctl < Formula
  desc "Remote CLI tool for Mattermost server"
  homepage "https://github.com/mattermost/mmctl"
  url "https://github.com/mattermost/mmctl.git",
      tag:      "v5.27.0",
      revision: "1dc9cda2e80757ff8fc694f32efc7ea76e327635"
  license "Apache-2.0"
  head "https://github.com/mattermost/mmctl.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a246ec416a9acfc82bc61608b6ae24a459cd97c2f63e37cca9da0a98db086a0f" => :catalina
    sha256 "27706d9dfc8b7c322a111c2840042189fb8e16865e56a7166c782fad8539ad31" => :mojave
    sha256 "750170ce270d63a398a718082f88a0fda4920a271280025623421288484e621a" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOBIN"] = buildpath/bin
    ENV["ADVANCED_VET"] = "FALSE"
    ENV["BUILD_HASH"] = Utils.safe_popen_read("git", "rev-parse", "HEAD").chomp
    ENV["BUILD_VERSION"] = version.to_s
    (buildpath/"src/github.com/mattermost/mmctl").install buildpath.children
    cd "src/github.com/mattermost/mmctl" do
      system "make", "install"

      # Install the zsh and bash completions
      output = Utils.safe_popen_read("#{bin}/mmctl", "completion", "bash")
      (bash_completion/"mmctl").write output
      output = Utils.safe_popen_read("#{bin}/mmctl", "completion", "zsh")
      (zsh_completion/"_mmctl").write output
    end
  end

  test do
    output = pipe_output("#{bin}/mmctl help 2>&1")
    assert_no_match /.*No such file or directory.*/, output
    assert_no_match /.*command not found.*/, output
    assert_match /.*mmctl \[command\].*/, output
  end
end
