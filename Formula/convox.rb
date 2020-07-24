class Convox < Formula
  desc "Command-line interface for the Convox PaaS"
  homepage "https://convox.com/"
  url "https://github.com/convox/convox/archive/3.0.36.tar.gz"
  sha256 "18087d6e2661abc4c8946a3ed0996145b22631c686cac06e2a3600dad576d59b"
  license "Apache-2.0"
  version_scheme 1

  bottle do
    cellar :any_skip_relocation
    sha256 "1d2375938de1ea2f017fb943113028d3774a839124a36d04d9a3e5afbaf946f5" => :catalina
    sha256 "4ece368dc31743934fe84c66f60d870e360d981f20d4b874fe4485716f8b08f6" => :mojave
    sha256 "96e99d3e3e4943aa453a28d834d2a77b8855642bd364b2639d7c72bbc2c120c7" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -X main.version=#{version}
    ].join(" ")

    system "go", "build", *std_go_args, "-mod=vendor", "-ldflags", ldflags, "./cmd/convox"
  end

  test do
    assert_equal "Authenticating with localhost... ERROR: invalid login\n",
      shell_output("#{bin}/convox login -t invalid localhost 2>&1", 1)
  end
end
