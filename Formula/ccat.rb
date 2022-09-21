class Ccat < Formula
  desc "Like cat but displays content with syntax highlighting"
  homepage "https://github.com/owenthereal/ccat"
  url "https://github.com/owenthereal/ccat/archive/v1.1.0.tar.gz"
  sha256 "b02d2c8d573f5d73595657c7854c9019d3bd2d9e6361b66ce811937ffd2bfbe1"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/ccat"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "81a96c9dbbaf3577a9fd8556ec325c1f1884228b5157ddb606b72565a2c5cd34"
  end

  depends_on "go" => :build

  conflicts_with "ccrypt", because: "both install `ccat` binaries"

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "auto"
    system "./script/build"
    bin.install "ccat"
  end

  test do
    (testpath/"test.txt").write <<~EOS
      I am a colourful cat
    EOS

    assert_match(/I am a colourful cat/, shell_output("#{bin}/ccat test.txt"))
  end
end
