class Ksync < Formula
  desc "Sync files between your local system and a kubernetes cluster"
  homepage "https://ksync.github.io/ksync/"
  url "https://github.com/ksync/ksync.git",
      tag:      "0.4.5",
      revision: "9f40bf134329814a57e1a58d73b84761a2b06c73"
  license "Apache-2.0"
  head "https://github.com/ksync/ksync.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "01c1dfd22817646205cfc6605ffeeafc04102ed9f472f719cd99aa3ffa0c858c" => :big_sur
    sha256 "1973e9cc12928e1680bc63c948404a81ae0eb83a083ecfcc593c0f9ba6799f2b" => :catalina
    sha256 "253963ea2fe87fd45fb16ea131273878368964637140de4b0eeb9b2150e290c7" => :mojave
    sha256 "b86ba3886a09fa0a5d78d86cf46bdd2dbcf524ef99cd4342e6c176698e0b5d00" => :high_sierra
  end

  depends_on "go" => :build

  def install
    project = "github.com/ksync/ksync"
    ldflags = %W[
      -w
      -X #{project}/pkg/ksync.GitCommit=#{Utils.git_short_head}
      -X #{project}/pkg/ksync.GitTag=#{version}
      -X #{project}/pkg/ksync.BuildDate=#{Utils.safe_popen_read("date", "+%Y%m%dT%H%M%S").chomp}
      -X #{project}/pkg/ksync.VersionString=Homebrew
      -X #{project}/pkg/ksync.GoVersion=go#{Formula["go"].version}
    ]
    system "go", "build", "-ldflags", ldflags.join(" "), *std_go_args, "#{project}/cmd/ksync"
  end

  test do
    # Basic build test. Potential for more sophisticated tests in the future
    # Initialize the local client and see if it completes successfully
    expected = "level=fatal"
    assert_match expected.to_s, shell_output("#{bin}/ksync init --local --log-level debug", 1)
  end
end
