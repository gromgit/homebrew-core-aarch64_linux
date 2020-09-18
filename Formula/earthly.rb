class Earthly < Formula
  desc "Build automation tool for the post-container era"
  homepage "https://earthly.dev/"
  url "https://github.com/earthly/earthly/archive/v0.3.7.tar.gz"
  sha256 "f8e9e9afb466e9fe6525f867c8825eb1fa1c6614e60004dd88e1bd542cf6a8ff"
  license "MPL-2.0"
  head "https://github.com/earthly/earthly.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "7b7a2d7c06c3ee570c394142b1625c23cd37b4b42eb90c574ea4bf1337d65824" => :catalina
    sha256 "89238fa6a55f65040f893cf71eff6013ac8ceefb68fa9700ee34d79a79bbb2f8" => :mojave
    sha256 "03c9bde23b6ded40292c16fb84e66083d72ad0862e2d88afb66b7d9a03b364b5" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ldflags = "-X main.DefaultBuildkitdImage=earthly/buildkitd:v#{version} -X main.Version=v#{version} -X" \
              " main.GitSha=de7bfb10fcb6dc26b74aa2a76bc021773f8c9069 "
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
