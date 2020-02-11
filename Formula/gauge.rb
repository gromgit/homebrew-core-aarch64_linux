class Gauge < Formula
  desc "Test automation tool that supports executable documentation"
  homepage "https://getgauge.io"
  url "https://github.com/getgauge/gauge/archive/v1.0.7.tar.gz"
  sha256 "017296636c857fa03aaf6a25d2497eb9456c44073225518365203f8f57a30260"
  head "https://github.com/getgauge/gauge.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "9c197ce095e57f0d5c17d38e34380e594aef73b541817639d7739f754594bbbc" => :catalina
    sha256 "209fd327d3b01a335e80b7d4b6f59ffe9ef230df2f94303291d2c130180f43d8" => :mojave
    sha256 "742e9e4c57a2e0c087101e91801a0729dc4b1654167d9a80cd6aa803085b6c43" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GOROOT"] = Formula["go"].opt_libexec
    dir = buildpath/"src/github.com/getgauge/gauge"
    dir.install buildpath.children
    ln_s buildpath/"src", dir
    cd dir do
      system "go", "run", "build/make.go"
      system "go", "run", "build/make.go", "--install", "--prefix", prefix
    end
  end

  test do
    assert_match version.to_s[0, 5], shell_output("#{bin}/gauge -v")
  end
end
