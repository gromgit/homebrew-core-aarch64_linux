class Cwlogs < Formula
  desc "CLI tool for reading logs from Cloudwatch Logs"
  homepage "https://github.com/segmentio/cwlogs"
  url "https://github.com/segmentio/cwlogs/archive/v1.2.0.tar.gz"
  sha256 "3f7b56b49c42c1de0e697fc391abad07b03434cff36b153249dd2af3107e064e"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/cwlogs"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "8c57e727450442828ee46ce6efd534e029c871851bd6f38c22509518d6bff988"
  end

  # https://github.com/segmentio/cwlogs/issues/37
  deprecate! date: "2021-02-21", because: :unmaintained

  depends_on "go" => :build
  depends_on "govendor" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["CGO_ENABLED"] = "0"
    ENV["GO111MODULE"] = "auto"

    path = buildpath/"src/github.com/segmentio/cwlogs"
    path.install Dir["{*,.git}"]

    cd "src/github.com/segmentio/cwlogs" do
      system "govendor", "sync"
      system "go", "build", *std_go_args(ldflags: "-X main.Version=#{version}")
    end
  end

  test do
    output = shell_output("#{bin}/cwlogs help")
    assert_match "cloudwatch logs", output
  end
end
