class Naabu < Formula
  desc "Fast port scanner"
  homepage "https://github.com/projectdiscovery/naabu"
  url "https://github.com/projectdiscovery/naabu/archive/v2.0.2.tar.gz"
  sha256 "e42c01b62f7ddb5d5f30615caf1888e2d706c1c54842d2f8565ac8cf290cadef"
  license "MIT"
  head "https://github.com/projectdiscovery/naabu.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e1e9c6b69d6b8c8c325fb351e26f0820802fcb6bbdb35359a88845a69ffb2df1" => :catalina
    sha256 "e300d1ecc613eea764fd9826cf7c46b2c98f1e92cc9a49463aa7e20f5d068e35" => :mojave
    sha256 "a12a9444acb90e7f1b790f5f4535de9f7889a3beedd89b03d8dc56d3c4954be9" => :high_sierra
  end

  depends_on "go" => :build

  def install
    cd "v2" do
      system "go", "build", *std_go_args, "./cmd/naabu"
    end
  end

  test do
    assert_match "brew.sh:443", shell_output("#{bin}/naabu -host brew.sh -p 443")
  end
end
