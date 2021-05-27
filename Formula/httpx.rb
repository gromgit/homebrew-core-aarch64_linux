class Httpx < Formula
  desc "Fast and multi-purpose HTTP toolkit"
  homepage "https://github.com/projectdiscovery/httpx"
  url "https://github.com/projectdiscovery/httpx/archive/v1.0.8.tar.gz"
  sha256 "38b600934ea0dbe31b23c5e1a13f3c201f6392f38bf46ce02f94a2b55d824c5e"
  license "MIT"
  head "https://github.com/projectdiscovery/httpx.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "09ee8166577c0f14c0c66d51b35efca6bc9aa03b910c6778c66a85b3af2e0892"
    sha256 cellar: :any_skip_relocation, big_sur:       "42c7585bcf75e7e58e18efe938e268c3368f311127c5091d098d4b7f8c43ad7e"
    sha256 cellar: :any_skip_relocation, catalina:      "a61811749795fecbd1b8138859aa1c859c047191ef3565f1afcea80de6ce1325"
    sha256 cellar: :any_skip_relocation, mojave:        "4ae4b51cf613a83bb3043d67ec1bf51f91a27604b5e038eb552debe9d85c47a2"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./cmd/httpx"
  end

  test do
    output = JSON.parse(pipe_output("#{bin}/httpx -silent -status-code -title -json", "example.org"))
    assert_equal 200, output["status-code"]
    assert_equal "Example Domain", output["title"]
  end
end
