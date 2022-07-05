class Zbctl < Formula
  desc "Zeebe CLI client"
  homepage "https://docs.camunda.io/docs/apis-clients/cli-client/index/"
  url "https://github.com/camunda/zeebe.git",
      tag:      "8.0.4",
      revision: "d9de58a0cee5a84df87cba1ebc0d4fee64836e7d"
  license "Apache-2.0"
  head "https://github.com/camunda/zeebe.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "012f352b14307801c64f5aeecf130d3c0baf4a5a069ea13e90a04dd97409dc72"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "012f352b14307801c64f5aeecf130d3c0baf4a5a069ea13e90a04dd97409dc72"
    sha256 cellar: :any_skip_relocation, monterey:       "060ccc72224c78befd5f2ba3a4063fff7c7fe9c424cc297addd143fe7f019990"
    sha256 cellar: :any_skip_relocation, big_sur:        "060ccc72224c78befd5f2ba3a4063fff7c7fe9c424cc297addd143fe7f019990"
    sha256 cellar: :any_skip_relocation, catalina:       "060ccc72224c78befd5f2ba3a4063fff7c7fe9c424cc297addd143fe7f019990"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "adcb93bd799afe4845a92c847a46e0ed89c4fd9fbf67c7121fb05d671c252615"
  end

  depends_on "go" => :build

  def install
    commit = Utils.git_short_head
    chdir "clients/go/cmd/zbctl" do
      project = "github.com/camunda/zeebe/clients/go/v8/cmd/zbctl/internal/commands"
      ldflags = %W[
        -w
        -X #{project}.Version=#{version}
        -X #{project}.Commit=#{commit}
      ]
      system "go", "build", "-tags", "netgo", *std_go_args(ldflags: ldflags)
    end
  end

  test do
    # Check status for a nonexistent cluster
    status_error_message =
      "Error: rpc error: code = " \
      "Unavailable desc = connection error: " \
      "desc = \"transport: Error while dialing dial tcp 127.0.0.1:26500: connect: connection refused\""
    output = shell_output("#{bin}/zbctl status 2>&1", 1)
    assert_match status_error_message, output
    # Check version
    commit = stable.specs[:revision][0..7]
    expected_version = "zbctl #{version} (commit: #{commit})"
    assert_match expected_version, shell_output("#{bin}/zbctl version")
  end
end
