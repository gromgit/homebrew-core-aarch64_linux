class Gau < Formula
  desc "Open Threat Exchange, Wayback Machine, and Common Crawl URL fetcher"
  homepage "https://github.com/lc/gau"
  url "https://github.com/lc/gau/archive/v1.0.5.tar.gz"
  sha256 "06571649695da43ef49e19e77df7bf7e9720a942558f7c3b6fe12a62b2d6a2d6"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "acd31e742a34052b22d9a3d0ecf7c860e2769a25cdd8a25f33117448ad197fd7" => :catalina
    sha256 "b3f05dc95db2591f2207cb16007206881162f25ed5866a3758edd26c2d407daa" => :mojave
    sha256 "48f9dddb0b66a03e0616231ff2ad25669914593b170e4a42f9501748671eb14d" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    output = shell_output("#{bin}/gau -providers wayback brew.sh")
    assert_match %r{https?://brew\.sh(/|:)?.*}, output
  end
end
