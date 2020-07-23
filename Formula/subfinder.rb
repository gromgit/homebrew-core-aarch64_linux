class Subfinder < Formula
  desc "Subdomain discovery tool"
  homepage "https://github.com/projectdiscovery/subfinder"
  url "https://github.com/projectdiscovery/subfinder/archive/v2.3.8.tar.gz"
  sha256 "78dda45f508ea699e762aec3a9160e8cec069f5af7bba722f09f2278eda9050d"
  license "MIT"
  head "https://github.com/projectdiscovery/subfinder.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "22bef7e58bc97d8bbe86e327636d5e0758e80fc679e7714e6fe1229549d97403" => :catalina
    sha256 "1ef2345879a75ad84de7cd92fc83a0f7d88638b4b8bd2f02325f7c57f2825b3b" => :mojave
    sha256 "094900a9b6855f8c4345fe4a5b507b775f54253303189ba4168be18361bc7751" => :high_sierra
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
