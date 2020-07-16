class Naabu < Formula
  desc "Fast port scanner"
  homepage "https://github.com/projectdiscovery/naabu"
  url "https://github.com/projectdiscovery/naabu/archive/v1.1.4.tar.gz"
  sha256 "fb5fae5ef7ef45217a238b59ed16095960c197c6f8b2f460873a445dbc80c2b4"
  license "GPL-3.0"
  head "https://github.com/projectdiscovery/naabu.git"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./cmd/naabu"
  end

  test do
    assert_match "brew.sh:443", shell_output("#{bin}/naabu -host brew.sh -ports 443")
  end
end
