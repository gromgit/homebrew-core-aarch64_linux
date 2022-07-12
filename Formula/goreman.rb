class Goreman < Formula
  desc "Foreman clone written in Go"
  homepage "https://github.com/mattn/goreman"
  url "https://github.com/mattn/goreman/archive/v0.3.13.tar.gz"
  sha256 "dfc20682714626c69db2fde9ce48432e7116f267488a123b79d72f6dabcca7a3"
  license "MIT"
  head "https://github.com/mattn/goreman.git", branch: "master"

  livecheck do
    url :homepage
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b835de9ad6465257f2e83d72e32066640e21d550af4d2a7db0a20d024ec4659c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2f5c838a8c0d0622ca7dafec485ace3d0161eee628dd14a4e82c95fbc6f4cfb3"
    sha256 cellar: :any_skip_relocation, monterey:       "a210952b6b9f43b17e4bc346016933baa67042d3684a4559b75ebbd9eb4673fe"
    sha256 cellar: :any_skip_relocation, big_sur:        "2e8706a404fa519b75b6d3c1b7644cc1938d312ecc8771dd80610e1fbd83dc8d"
    sha256 cellar: :any_skip_relocation, catalina:       "fa55372eb815aca1025b6055806ce017369850852621d0d2ad7d233ff51af317"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "df2f3b5165bb0635f982d8d06573ced7b9451d8bc8253cf3de25cff2ab5fe215"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-s -w", "-trimpath", "-o", bin/"goreman"
  end

  test do
    (testpath/"Procfile").write "web: echo 'hello' > goreman-homebrew-test.out"
    system bin/"goreman", "start"
    assert_predicate testpath/"goreman-homebrew-test.out", :exist?
    assert_match "hello", (testpath/"goreman-homebrew-test.out").read
  end
end
