class Httpx < Formula
  desc "Fast and multi-purpose HTTP toolkit"
  homepage "https://projectdiscovery.io/open-source"
  url "https://github.com/projectdiscovery/httpx/archive/v1.0.1.tar.gz"
  sha256 "8ae65c0cc471f6fb066d5662ffb5ae45979dcbcaddad9df795776f5320ce7ef3"
  license "MIT"
  head "https://github.com/projectdiscovery/httpx.git"

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
