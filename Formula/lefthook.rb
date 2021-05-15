class Lefthook < Formula
  desc "Fast and powerful Git hooks manager for any type of projects"
  homepage "https://github.com/evilmartians/lefthook"
  url "https://github.com/evilmartians/lefthook/archive/refs/tags/v0.7.5.tar.gz"
  sha256 "168f3b59acbbf161e46993bc6c48cbf7ba7690030c2202f5f2ea16646da3dc2c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "749d82635559b5d824a2082a2b76a3b75d5cc9158a489f03fabe309863ad0738"
    sha256 cellar: :any_skip_relocation, big_sur:       "19503e39057ed31a09b5a51f4e8bbc2cc92e8f862f075ef0e10382c39f8620f4"
    sha256 cellar: :any_skip_relocation, catalina:      "5b8e432d284149b432aca15fbf3a858902cdcb484fbd5344d3986db3769415d5"
    sha256 cellar: :any_skip_relocation, mojave:        "c973274ba4fe77de6e26c7536da50dc424d2422b873235d61336157ed4575fcd"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    system "git", "init"
    system bin/"lefthook", "install"

    assert_predicate testpath/"lefthook.yml", :exist?
    assert_match version.to_s, shell_output("#{bin}/lefthook version")
  end
end
