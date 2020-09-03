class Earthly < Formula
  desc "Build automation tool for the post-container era"
  homepage "https://earthly.dev/"
  url "https://github.com/earthly/earthly/archive/v0.3.5.tar.gz"
  sha256 "254bb12e1300b879165e112b90294065988c5bc2253c662c0829ea0019d6116f"
  license "MPL-2.0"
  head "https://github.com/earthly/earthly.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ca96e9fb32bfcc97e56209acc828215233c00f7b95b55f75b96a26b2ee695e75" => :catalina
    sha256 "1c3f2406e102f84e51db882eb73ce318de4014d68dbac24b1f37ec0871aad01a" => :mojave
    sha256 "49aca926afea28b90052d9a9fc67bc909439531d419ea6f642563a433f95d006" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ldflags = "-X main.DefaultBuildkitdImage=earthly/buildkitd:v0.3.5 -X main.Version=v0.3.5 -X" \
              " main.GitSha=557634495eb6cf9d48d05bc25461f34b2f86f06f "
    tags = "dfrunmount dfrunsecurity dfsecrets dfssh dfrunnetwork"
    system "go", "build",
        "-tags", tags,
        "-ldflags", ldflags,
        *std_go_args,
        "-o", bin/"earth",
        "./cmd/earth/main.go"
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
