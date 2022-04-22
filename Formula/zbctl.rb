class Zbctl < Formula
  desc "Zeebe CLI client"
  homepage "https://docs.camunda.io/docs/apis-clients/cli-client/index/"
  url "https://github.com/camunda/zeebe.git",
      tag:      "8.0.1",
      revision: "e5f40db49e43e769c1834aa8c98f12710e9cee0c"
  license "Apache-2.0"
  head "https://github.com/camunda/zeebe.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "383d2f58cfcbb39181ed65e2721925eae25e7c33eef8f0a96a508eec886a255c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "383d2f58cfcbb39181ed65e2721925eae25e7c33eef8f0a96a508eec886a255c"
    sha256 cellar: :any_skip_relocation, monterey:       "8ae918621b134cbc10ecc723f60fe1a7989c98d27e45e89fa8ec94d6a67b7be2"
    sha256 cellar: :any_skip_relocation, big_sur:        "8ae918621b134cbc10ecc723f60fe1a7989c98d27e45e89fa8ec94d6a67b7be2"
    sha256 cellar: :any_skip_relocation, catalina:       "8ae918621b134cbc10ecc723f60fe1a7989c98d27e45e89fa8ec94d6a67b7be2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "869c97ed9fa8237416fb945320ca3c1d38b9a078d5ad7dfeb2b678c69ebe8536"
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
      "Error: rpc error: code =" \
      " Unavailable desc = connection error:" \
      " desc = \"transport: Error while dialing dial tcp 127.0.0.1:26500: connect: connection refused\""
    output = shell_output("#{bin}/zbctl status 2>&1", 1)
    assert_match status_error_message, output
    # Check version
    commit = stable.specs[:revision][0..7]
    expected_version = "zbctl #{version} (commit: #{commit})"
    assert_match expected_version, shell_output("#{bin}/zbctl version")
  end
end
