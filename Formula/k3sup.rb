class K3sup < Formula
  desc "Utility to create k3s clusters on any local or remote VM"
  homepage "https://k3sup.dev"
  url "https://github.com/alexellis/k3sup.git",
      tag:      "0.9.13",
      revision: "95fc8b074a6e0ea48ea03a695491e955e32452ea"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "363e864b29ea1593d2f4346508d9d9ceb3f9635e1991259711a4b16a53637ecf" => :big_sur
    sha256 "54fd7175e82cbabba94660f3b99c7fe29867e9d008b115ff2b06b7bce30300a1" => :arm64_big_sur
    sha256 "fd21ede843c6e875c6849755dba5e67719a829e326c7dee1056df4b901a9faff" => :catalina
    sha256 "9a4d44bee7592c5ca2bcae669bffd81bd58d53940fe9076900b071afa5f4ceee" => :mojave
  end

  depends_on "go" => :build

  def install
    commit = Utils.safe_popen_read("git", "rev-parse", "--short", "HEAD").chomp

    system "go", "build", "-ldflags",
            "-s -w -X github.com/alexellis/k3sup/cmd.Version=#{version} -X github.com/alexellis/k3sup/cmd.GitCommit=#{commit}", *std_go_args
  end

  test do
    output = shell_output("#{bin}/k3sup install 2>&1", 1).split("\n").pop
    assert_match "unable to load the ssh key", output
  end
end
