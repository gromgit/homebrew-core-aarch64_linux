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
    regex(%r{href=.*?/tag/?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "b7e0f8b937cb4f02682d9dbd5538a9935d4ddffbfc7bae057d50376b6aff8bd6" => :big_sur
    sha256 "53f6867bbd187b582c1d6e3e8a3cebfa6b2eba8368564a8d28c3491aefba3b7e" => :arm64_big_sur
    sha256 "1dbdb2ddf6906b4a52d395c55a104fb3b95f57b8be5c30b39e69e241877d3cf7" => :catalina
    sha256 "c6331b1dcc087e01600504993f80a5f6e9f4437779ef336a293ec5ea7349cd4a" => :mojave
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
