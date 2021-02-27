class Earthly < Formula
  desc "Build automation tool for the container era"
  homepage "https://earthly.dev/"
  url "https://github.com/earthly/earthly/archive/v0.5.4.tar.gz"
  sha256 "51890c6cd4c269f5414091c0e30ae240871f07aaa39bfc867fef7403e2193cc8"
  license "BUSL-1.1"
  head "https://github.com/earthly/earthly.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "96c082fd77293140b50a602a93bf5f40f59b262c532973334baa4ada8fcc4c78"
    sha256 cellar: :any_skip_relocation, big_sur:       "c21141390522a59074123624c5564aaef8caa1e1e9d507846a1d78d35eed9aa0"
    sha256 cellar: :any_skip_relocation, catalina:      "e416d54d0d327d8143d071852cf9454d7de8e015b2a117ef8fc7b947876c2faf"
    sha256 cellar: :any_skip_relocation, mojave:        "07e94a1265811798006285f81351691c2df32dcc9cb7a55168018e9b157d1e20"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X main.DefaultBuildkitdImage=earthly/buildkitd:v#{version} -X main.Version=v#{version} -X" \
              " main.GitSha=4a161eb9fc46344715a8aeff40e0eeeb1123ea84 "
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
