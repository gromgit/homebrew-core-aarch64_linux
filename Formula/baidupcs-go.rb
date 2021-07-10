class BaidupcsGo < Formula
  desc "Terminal utility for Baidu Network Disk"
  homepage "https://github.com/qjfoidnh/BaiduPCS-Go"
  url "https://github.com/qjfoidnh/BaiduPCS-Go/archive/v3.8.1.tar.gz"
  sha256 "265f14e110e836195d230fcea26a27c440c1ae710d9a2fd9d664a603a89fd5c9"
  license "Apache-2.0"
  head "https://github.com/qjfoidnh/BaiduPCS-Go.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "44c0d9f421ac131574538bc0c2d5f7828a0df65a351bcb6c35adfa65f15d821c"
    sha256 cellar: :any_skip_relocation, big_sur:       "57ade07be37404c68a016fed277677e09259f75efcc88b90c26ca2027977a8c0"
    sha256 cellar: :any_skip_relocation, catalina:      "80e4dfe983b5d5afeaa6c3706813965b56633d957efc050f9f6c6559bf82c232"
    sha256 cellar: :any_skip_relocation, mojave:        "3cfda0f5181e860ac54a09ca3401e19f51b6bc57ea725bd96c73442f640bb594"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0ca7064321bcb68769e1714a222dc30dda5d71410ac990af2a95f253bfc648d3"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    system bin/"baidupcs-go", "run", "touch", "test.txt"
    assert_predicate testpath/"test.txt", :exist?
  end
end
