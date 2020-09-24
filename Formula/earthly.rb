class Earthly < Formula
  desc "Build automation tool for the post-container era"
  homepage "https://earthly.dev/"
  url "https://github.com/earthly/earthly/archive/v0.3.8.tar.gz"
  sha256 "29437680c22ba68028df5200cb0582b61bc02a3fe0a83cc9e1df54405b013268"
  license "MPL-2.0"
  head "https://github.com/earthly/earthly.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "0e8963af3534f7c8561d7bab453ba11f7b8e00f7e088d1ba0ffcf64a2ef2d84a" => :catalina
    sha256 "c37cf466dc2b6cce8647901bdc600964bae97ec771577b5e2122b79f669c60df" => :mojave
    sha256 "c1c36918db7d1586a62407780abb5623c6cf15a5acef1b58a9758d1b154d765b" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ldflags = "-X main.DefaultBuildkitdImage=earthly/buildkitd:v#{version} -X main.Version=v#{version} -X" \
              " main.GitSha=4c01bae32ab1ecea65910e06f20d30c30923e225 "
    tags = "dfrunmount dfrunsecurity dfsecrets dfssh dfrunnetwork"
    system "go", "build",
        "-tags", tags,
        "-ldflags", ldflags,
        *std_go_args,
        "-o", bin/"earth",
        "./cmd/earth/main.go"
    (bash_completion/"earth").write `#{bin}/earth bootstrap --source bash`
    (zsh_completion/"_earth").write `#{bin}/earth bootstrap --source zsh`
  end

  test do
    (testpath/"build.earth").write <<~EOS

      default:
      \tRUN echo Homebrew
    EOS

    output = shell_output("#{bin}/earth --buildkit-host 127.0.0.1 +default 2>&1", 1).strip
    assert_match "Error while dialing invalid address 127.0.0.1", output
  end
end
