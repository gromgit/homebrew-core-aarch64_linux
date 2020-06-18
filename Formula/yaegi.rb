class Yaegi < Formula
  desc "Yet another elegant Go interpreter"
  homepage "https://github.com/containous/yaegi"
  url "https://github.com/containous/yaegi/archive/v0.8.8.tar.gz"
  sha256 "5f74283fc7edaeb4316c0f1449998085d1be8a30cd59cc3d865082e2d14eb1c1"
  head "https://github.com/containous/yaegi.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "89db7f444ec54b05e4d8fbbd0c466bdf61bece9a24912b1914e9aa8b5d0a6b52" => :catalina
    sha256 "3257fa04545bf7062cd2a2e0253b81ecda483bedc1700d0d2cf47a073a3e74ec" => :mojave
    sha256 "cb07199825d7ab1248e39c6faf182b5dbbad545d8d06fd590c1aeda76119d1ab" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "cmd/yaegi/yaegi.go"
    prefix.install_metafiles
  end

  test do
    assert_match "4", pipe_output("#{bin}/yaegi", "println(3 + 1)", 0)
  end
end
