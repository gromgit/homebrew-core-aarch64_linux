class Httpx < Formula
  desc "Fast and multi-purpose HTTP toolkit"
  homepage "https://github.com/projectdiscovery/httpx"
  url "https://github.com/projectdiscovery/httpx/archive/v1.2.3.tar.gz"
  sha256 "c0c688705fdf16c250d8de5a20737c37a7b786effe9e764fbac6be05504d9e5e"
  license "MIT"
  head "https://github.com/projectdiscovery/httpx.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "45c62881f7b7c206ece6df45e110bd092e406473ae241c0f02a2257cc47adb11"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ca6b13ca20d0b87c891b5ef4eea208fb0325a6cf2ce8e4c471b5a7d3c0fcbc9a"
    sha256 cellar: :any_skip_relocation, monterey:       "3325063e42c89d295c2a9241eb14a4be6ef6a6e9bf5fc941c109568f082618df"
    sha256 cellar: :any_skip_relocation, big_sur:        "94c5549195ff9f60279263a08e0354dffc74eaacb66063615b88f735bb77305c"
    sha256 cellar: :any_skip_relocation, catalina:       "3630c34e1ab63880c08298826e7b91e956818bd6553495eaa217179e4eb3781b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7f22342a80bac2364116fa70649d43690c89330f34cd8566b40457eaee33792c"
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
