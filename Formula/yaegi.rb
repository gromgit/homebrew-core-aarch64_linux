class Yaegi < Formula
  desc "Yet another elegant Go interpreter"
  homepage "https://github.com/containous/yaegi"
  url "https://github.com/containous/yaegi/archive/v0.7.6.tar.gz"
  sha256 "e43209ed8b0d8ab560a6fb09d123189292659f93e10036c85a831dcafbf02ffd"
  head "https://github.com/containous/yaegi.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "c2bcd5711c3a6340bf60e0c2d87eec09a4a590a3334ad54df3d4df5908e59b20" => :catalina
    sha256 "2ffbbf7f5cfc0e2c70f934fac7683b6b025a4eb5397f255585c8149fecd13504" => :mojave
    sha256 "47f9fb0aabfcbbc69784d817022a038c74ae2a52b65d89a33a3863ff0d9aab2e" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-s -w", "-trimpath", "-o", bin/"yaegi", "cmd/yaegi/yaegi.go"
    prefix.install_metafiles
  end

  test do
    assert_match "4", pipe_output("#{bin}/yaegi", "3 + 1", 0)
  end
end
