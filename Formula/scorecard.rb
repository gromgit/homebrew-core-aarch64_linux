class Scorecard < Formula
  desc "Security health metrics for Open Source"
  homepage "https://github.com/ossf/scorecard"
  url "https://github.com/ossf/scorecard.git",
      tag:      "v4.1.0",
      revision: "33f80c93dc79f860d874857c511c4d26d399609d"
  license "Apache-2.0"
  revision 1
  head "https://github.com/ossf/scorecard.git", branch: "main"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/scorecard"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "22093357206ccc57605b2c428c66a4ae2bb4cce3612ba59fedc2bc92d64c7ebf"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/ossf/scorecard/v4/pkg.gitVersion=#{version}
      -X github.com/ossf/scorecard/v4/pkg.gitCommit=#{Utils.git_head}
      -X github.com/ossf/scorecard/v4/pkg.gitTreeState=clean
      -X github.com/ossf/scorecard/v4/pkg.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)
    system "make", "generate-docs"
    doc.install "docs/checks.md"
  end

  test do
    ENV["GITHUB_AUTH_TOKEN"] = "test"
    output = shell_output("#{bin}/scorecard --repo=github.com/kubernetes/kubernetes --checks=Maintained 2>&1", 2)
    expected_output = "InitRepo: repo unreachable: GET https://api.github.com/repos/google/oss-fuzz: 401"
    assert_match expected_output, output

    assert_match version.to_s, shell_output("#{bin}/scorecard version")
  end
end
