class Qpm < Formula
  desc "Package manager for Qt applications"
  homepage "https://www.qpm.io"
  url "https://github.com/Cutehacks/qpm.git",
      tag:      "v0.11.0",
      revision: "fc340f20ddcfe7e09f046fd22d2af582ff0cd4ef"
  license "Artistic-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/qpm"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "27bd25f4bb41c90e018cb178bce284b3b618350acaa3f54be1321e3aea18c6d2"
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "auto"
    (buildpath/"src").mkpath
    ln_s buildpath, "src/qpm.io"
    system "go", "build", "-o", "bin/qpm", "qpm.io/qpm"
    bin.install "bin/qpm"
  end

  test do
    system bin/"qpm", "install", "io.qpm.example"
    assert_predicate testpath/"qpm.json", :exist?
  end
end
