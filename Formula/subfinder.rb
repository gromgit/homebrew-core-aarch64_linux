class Subfinder < Formula
  desc "Subdomain discovery tool"
  homepage "https://github.com/projectdiscovery/subfinder"
  url "https://github.com/projectdiscovery/subfinder/archive/v2.3.6.tar.gz"
  sha256 "c8ccc886cf1d0759a03c9e6c53e2b470839579f31bfaf6bbe820b80df1e66ec6"
  license "MIT"
  head "https://github.com/projectdiscovery/subfinder.git"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./cmd/subfinder"
  end

  test do
    assert_match "docs.brew.sh", shell_output("#{bin}/subfinder -d brew.sh")
    assert_predicate testpath/".config/subfinder/config.yaml", :exist?
  end
end
