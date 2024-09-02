class Httpx < Formula
  desc "Fast and multi-purpose HTTP toolkit"
  homepage "https://github.com/projectdiscovery/httpx"
  url "https://github.com/projectdiscovery/httpx/archive/v1.2.4.tar.gz"
  sha256 "5d95a35586c851bba43be2fb79b790ff417e58aa34ae515a79b3bd8c6f2df7e0"
  license "MIT"
  head "https://github.com/projectdiscovery/httpx.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/httpx"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "f36ce2008f082f4f878fd1a9ec788d58ede63f0dee742cd234545c81c5ca87f3"
  end

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
