class Vegeta < Formula
  desc "HTTP load testing tool and library"
  homepage "https://github.com/tsenart/vegeta"
  url "https://github.com/tsenart/vegeta/archive/v12.8.4.tar.gz"
  sha256 "418249d07f04da0a587df45abe34705166de9e54a836e27e387c719ebab3e357"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/vegeta"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "4f478511da1453a60f5f1fc13522c99ee88eccbe637ee129fc2185a1e1b59804"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.Version=#{version}
      -X main.Date=#{time.iso8601}
    ].join(" ")

    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    input = "GET https://google.com"
    output = pipe_output("#{bin}/vegeta attack -duration=1s -rate=1", input, 0)
    report = pipe_output("#{bin}/vegeta report", output, 0)
    assert_match(/Success +\[ratio\] +100.00%/, report)
  end
end
