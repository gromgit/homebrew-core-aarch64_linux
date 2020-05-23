class Gau < Formula
  desc "Open Threat Exchange, Wayback Machine, and Common Crawl URL fetcher"
  homepage "https://github.com/lc/gau"
  url "https://github.com/lc/gau/archive/v1.0.2.tar.gz"
  sha256 "058a0818b3b1465af9878566c6cb01e2b2835903b5630f63afb0645c07b28663"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    output = shell_output("#{bin}/gau -providers wayback brew.sh")
    output.each_line do |line|
      assert_match %r{https?://brew\.sh(/|:)?.*}, line
    end
  end
end
