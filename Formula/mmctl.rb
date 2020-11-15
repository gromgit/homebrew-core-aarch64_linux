class Mmctl < Formula
  desc "Remote CLI tool for Mattermost server"
  homepage "https://github.com/mattermost/mmctl"
  url "https://github.com/mattermost/mmctl.git",
      tag:      "v5.29.0",
      revision: "fc2ffd482f5062fef373444f3878252a33367683"
  license "Apache-2.0"
  head "https://github.com/mattermost/mmctl.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "987612c5e599cc1a91afabc2629f258bc2f6703382e9f49a4a2f841fb2361154" => :big_sur
    sha256 "e8286b3dca1fc493717c788e4b4c826966ad54bb09b46d2138cc0f1086a0797c" => :catalina
    sha256 "865ba6d1a37ce690118b408c001310b31ee20f7d86e0c0cf5c2862f819512714" => :mojave
    sha256 "bb55ff1ce984bab1079145f84fb1cd5c37ffe29538451f582ee9eaba9571569d" => :high_sierra
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
