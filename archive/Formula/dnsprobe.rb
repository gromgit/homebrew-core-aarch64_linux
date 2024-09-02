class Dnsprobe < Formula
  desc "DNS query and resolution tool"
  homepage "https://github.com/projectdiscovery/dnsprobe"
  url "https://github.com/projectdiscovery/dnsprobe/archive/v1.0.3.tar.gz"
  sha256 "ab57f348177594018cc5b5b5e808710c88e597888c6d504cb10554d60627eae1"
  license "MIT"
  head "https://github.com/projectdiscovery/dnsprobe.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/dnsprobe"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "582bb03565f8149974b7242858c47b066efd48fc3405ed1ef4ced79c77d49d5b"
  end

  # repo deprecated in favor of `projectdiscovery/dnsx`
  deprecate! date: "2020-11-13", because: :repo_archived

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    (testpath/"domains.txt").write "docs.brew.sh"
    assert_match "docs.brew.sh homebrew.github.io.",
                 shell_output("#{bin}/dnsprobe -l domains.txt -r CNAME")
  end
end
