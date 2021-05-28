class Earthly < Formula
  desc "Build automation tool for the container era"
  homepage "https://earthly.dev/"
  url "https://github.com/earthly/earthly/archive/v0.5.15.tar.gz"
  sha256 "11a0c6c6efd6c6ff56cbb4d997d04412d811178fd7acb3610c0296eab035ca83"
  license "BUSL-1.1"
  head "https://github.com/earthly/earthly.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "728e12d29502b23b2c3c4e8b9d7048888a8a71226da61f48f595f7c6bcbd3531"
    sha256 cellar: :any_skip_relocation, big_sur:       "1bc4de4028bb7a1d115ca9f29852fedcb2943846540f91ed167ab48efee36dc6"
    sha256 cellar: :any_skip_relocation, catalina:      "388964d0ffb14a5a4ad9b438195e358e4572b51260e89a978f45640c84a858cd"
    sha256 cellar: :any_skip_relocation, mojave:        "b54b1d8aa3590dc5be197c7669e614bb83762b7fccb26c66a6919233b69dbf85"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X main.DefaultBuildkitdImage=earthly/buildkitd:v#{version} -X main.Version=v#{version} " \
              "-X main.GitSha=78717c4363e0893e0a5d55f81dd2e069d7b6ec65 "
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

    output = shell_output("#{bin}/earthly --buildkit-host 127.0.0.1 +default 2>&1", 6).strip
    assert_match "buildkitd failed to start", output
  end
end
