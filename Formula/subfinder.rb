class Subfinder < Formula
  desc "Subdomain discovery tool"
  homepage "https://github.com/projectdiscovery/subfinder"
  url "https://github.com/projectdiscovery/subfinder/archive/v2.5.1.tar.gz"
  sha256 "c93daf616ad3c0f60e91a2626a97c7cfcc3662735db5e6e0b1e2bd0706638fb2"
  license "MIT"
  head "https://github.com/projectdiscovery/subfinder.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/subfinder"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "2d117805794f4903b50b5005c8cfa25f1e68a6ca20d0aaaefe5608082046a9df"
  end

  depends_on "go" => :build

  def install
    cd "v2" do
      system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/subfinder"
    end
  end

  test do
    assert_match "docs.brew.sh", shell_output("#{bin}/subfinder -d brew.sh")
    assert_predicate testpath/".config/subfinder/config.yaml", :exist?
  end
end
