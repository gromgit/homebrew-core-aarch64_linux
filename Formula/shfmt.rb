class Shfmt < Formula
  desc "Autoformat shell script source code"
  homepage "https://github.com/mvdan/sh"
  url "https://github.com/mvdan/sh/archive/v3.1.0.tar.gz"
  sha256 "b05b0c0fdd7dd202c1be75920d501b3735a065322f09c280db0949631e7e0d92"
  head "https://github.com/mvdan/sh.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "de4f24af10a68d1a89f8eed7cbac18aeb243a156b6ecac589172c8d51a463c7a" => :catalina
    sha256 "da56c76f78ccd8de55136f72326cf22bac6d74a1ca3b32304e8e837b3b0866a7" => :mojave
    sha256 "fecaf473648c22ee1c62b54d6ed56ee651182ce0550db35cf2f33ae954bb4ecf" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    (buildpath/"src/mvdan.cc").mkpath
    ln_sf buildpath, buildpath/"src/mvdan.cc/sh"
    system "go", "build", "-a", "-tags", "production brew", "-ldflags",
                          "-w -s -extldflags '-static' -X main.version=#{version}",
                          "-o", "#{bin}/shfmt", "./cmd/shfmt"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/shfmt  --version")

    (testpath/"test").write "\t\techo foo"
    system "#{bin}/shfmt", testpath/"test"
  end
end
