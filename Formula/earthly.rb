class Earthly < Formula
  desc "Build automation tool for the container era"
  homepage "https://earthly.dev/"
  url "https://github.com/earthly/earthly/archive/v0.5.1.tar.gz"
  sha256 "19bec5a21daa1ec34dc0079d6220b601389b6aa94fafd4eb1fecde12b023eb4b"
  license "BUSL-1.1"
  head "https://github.com/earthly/earthly.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "337903de07dd2f0d608da31225b2d3a6ed55a54bcd8396a558c8b9515459d96c"
    sha256 cellar: :any_skip_relocation, big_sur:       "1c7c12cd89b610e7d189e27b1347c0ce5ec581caeb148bd61d9332c676249a08"
    sha256 cellar: :any_skip_relocation, catalina:      "fd3df0a11513e6f33feb748fe65c52449c11ac585f8017cf92b6ceccde50ff39"
    sha256 cellar: :any_skip_relocation, mojave:        "04f38a2e7ccf6993271817d557a771399eacd8f806ffc2ccabf30d93783e2a89"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X main.DefaultBuildkitdImage=earthly/buildkitd:v#{version} -X main.Version=v#{version} -X" \
              " main.GitSha=243626a40e831bb8f3678860f4763f98e52cd4eb "
    tags = "dfrunmount dfrunsecurity dfsecrets dfssh dfrunnetwork"
    system "go", "build",
        "-tags", tags,
        "-ldflags", ldflags,
        *std_go_args,
        "./cmd/earthly/main.go"

    bash_output = Utils.safe_popen_read("#{bin}/earthly", "bootstrap", "--source", "bash")
    (bash_completion/"earthly").write bash_output
    zsh_output = Utils.safe_popen_read("#{bin}/earthly", "bootstrap", "--source", "zsh")
    (zsh_completion/"_earthly").write zsh_output
  end

  test do
    (testpath/"build.earthly").write <<~EOS

      default:
      \tRUN echo Homebrew
    EOS

    output = shell_output("#{bin}/earthly --buildkit-host 127.0.0.1 +default 2>&1", 1).strip
    assert_match "Error while dialing invalid address 127.0.0.1", output
  end
end
