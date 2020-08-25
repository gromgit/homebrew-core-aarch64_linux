class Subfinder < Formula
  desc "Subdomain discovery tool"
  homepage "https://github.com/projectdiscovery/subfinder"
  url "https://github.com/projectdiscovery/subfinder/archive/v2.4.3.tar.gz"
  sha256 "6314065e39ae4e80ec2aaac21fa0bcbb4283ee624cd8051ebdc61fee8d0df650"
  license "MIT"
  head "https://github.com/projectdiscovery/subfinder.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f490794a560442d489ea2ab691dac654cb109bb25a0001f37c5b000e0d3a64b3" => :catalina
    sha256 "c9ec1982eafa292201419b49fcf7723c8ecbf5bab60052a8e69f0d543db367e2" => :mojave
    sha256 "a2486bc4ba8698b62d7ba0d26ff50147d32b3e29f21511b7dc7a60d328270895" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./cmd/subfinder"
  end

  test do
    assert_match "docs.brew.sh", shell_output("#{bin}/subfinder -d brew.sh")
    assert_predicate testpath/".config/subfinder/config.yaml", :exist?
  end
end
