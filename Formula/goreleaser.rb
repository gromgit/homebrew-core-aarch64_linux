class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      tag:      "v0.147.1",
      revision: "40aa04fe714850150f76a61a9d311886ade74d7d"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "72d93a93da538973d8d2d69db1294a912d62846a353d114741bf8b7b6dea4f39" => :catalina
    sha256 "3e002fe98774d9ef4ca18c0054d185bd2686f5a6218195db7c20dc8ff62cd15d" => :mojave
    sha256 "fcef1b7126d47eec537c260902c28d1e5c80e75ffa8d768ff509d3c9ac627d9e" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags",
             "-s -w -X main.version=#{version} -X main.commit=#{stable.specs[:revision]} -X main.builtBy=homebrew",
             *std_go_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/goreleaser -v 2>&1")
    assert_match "config created", shell_output("#{bin}/goreleaser init --config=.goreleaser.yml 2>&1")
    assert_predicate testpath/".goreleaser.yml", :exist?
  end
end
