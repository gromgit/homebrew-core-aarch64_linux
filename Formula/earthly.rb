class Earthly < Formula
  desc "Build automation tool for the post-container era"
  homepage "https://earthly.dev/"
  url "https://github.com/earthly/earthly/archive/v0.3.2.tar.gz"
  sha256 "11ea5a1ca7f9f78197cb2ec374b030e9f6844081c37a81f1e3788814d0ba05c8"
  license "MPL-2.0"
  head "https://github.com/earthly/earthly.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "276ce792b11e3a7167a16b5ec5fe9817b52e774aec3f306fe0c677156f1b57fb" => :catalina
    sha256 "4eeee0dead303506a9f4b415de4f4c4ac46cf190eb092219f0c89fc627b1d426" => :mojave
    sha256 "a75b91d1675f527c13bb65ee3c0b2ff2bf88ecaa7c5d2ac18dc410edeb809a0f" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ldflags = "-X main.DefaultBuildkitdImage=earthly/buildkitd:v0.3.2 " \
              "-X main.Version=v0.3.2 -X main.GitSha=71a2f1746a3ffc15bb95260a6270edcdda7138eb"
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
