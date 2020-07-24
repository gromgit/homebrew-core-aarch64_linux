class Earthly < Formula
  desc "Build automation tool for the post-container era"
  homepage "https://earthly.dev/"
  url "https://github.com/earthly/earthly/archive/v0.2.2.tar.gz"
  sha256 "2b09408f60572d70df83cdc2f6fc6805d19f2fbe852c54360a7a37eae55f8076"
  license "MPL-2.0"
  head "https://github.com/earthly/earthly.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "8af948a11c9acc34927450d5d6a8cc5ee95972cfb41d963ed5f236d3351b5725" => :catalina
    sha256 "246bf88d1fca5fff6fed8bb837653261661faabaf112507020673c7414521ed3" => :mojave
    sha256 "f051918f8bc439e6fcc02622097e0b4147dc2c68ef4147fa54eea7f041f7bb8d" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags",
        "-X main.DefaultBuildkitdImage=earthly/buildkitd:v#{version} -X main.Version=v#{version}",
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
