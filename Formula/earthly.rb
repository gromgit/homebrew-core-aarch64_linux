class Earthly < Formula
  desc "Build automation tool for the container era"
  homepage "https://earthly.dev/"
  url "https://github.com/earthly/earthly.git",
      tag:      "v0.6.26",
      revision: "4a8d66e3b30d8ee758e7d71b40bc027f92e9adf4"
  license "MPL-2.0"
  head "https://github.com/earthly/earthly.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "560bb6f792845fcbffb8635e92f077ba0e7664dbeadefc16cfa54d8e4797d1a4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6adfa336ac3a745bccd159727b4720bd233570fdac9ab7b03c2a1d205a0b6746"
    sha256 cellar: :any_skip_relocation, monterey:       "8cd225c79d2edd9553258526a31f4426cd2bf5657db46a7b4a5201ea3ebbde25"
    sha256 cellar: :any_skip_relocation, big_sur:        "7f8e2c9ce277d9fa2959670be70aa1fb5f69b04ece03934aaa1f95d05e692f12"
    sha256 cellar: :any_skip_relocation, catalina:       "f58eeae51b2ae5b796c7fd6f8bb7dd295ef8a94542487fbbe2b0869c00a586d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fba50d35c30c66136cef38d20f5ed276f6fa17670da36131a167d3d2c09a320d"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.DefaultBuildkitdImage=earthly/buildkitd:v#{version}
      -X main.Version=v#{version}
      -X main.GitSha=#{Utils.git_head}
      -X main.BuiltBy=homebrew
    ]
    tags = "dfrunmount dfrunsecurity dfsecrets dfssh dfrunnetwork dfheredoc forceposix"
    system "go", "build", "-tags", tags, *std_go_args(ldflags: ldflags), "./cmd/earthly"

    generate_completions_from_executable(bin/"earthly", "bootstrap", "--source", shells: [:bash, :zsh])
  end

  test do
    # earthly requires docker to run; therefore doing a complete end-to-end test here is not
    # possible; however the "earthly ls" command is able to run without docker.
    (testpath/"Earthfile").write <<~EOS
      VERSION 0.6
      mytesttarget:
      \tRUN echo Homebrew
    EOS
    output = shell_output("#{bin}/earthly ls")
    assert_match "+mytesttarget", output
  end
end
