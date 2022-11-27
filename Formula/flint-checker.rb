class FlintChecker < Formula
  desc "Check your project for common sources of contributor friction"
  homepage "https://github.com/pengwynn/flint"
  url "https://github.com/pengwynn/flint/archive/v0.1.0.tar.gz"
  sha256 "ec865ec5cad191c7fc9c7c6d5007754372696a708825627383913367f3ef8b7f"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/flint-checker"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "7c88d48b75bc68174fca0ec5649519219690040672fc958c52b5d5206d4cb74b"
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "auto"
    (buildpath/"src/github.com/pengwynn").mkpath
    ln_sf buildpath, buildpath/"src/github.com/pengwynn/flint"
    system "go", "build", *std_go_args(output: bin/"flint")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/flint --version")

    shell_output("#{bin}/flint", 2)
    (testpath/"README.md").write("# Readme")
    (testpath/"CONTRIBUTING.md").write("# Contributing Guidelines")
    (testpath/"LICENSE").write("License")
    (testpath/"CHANGELOG").write("changelog")
    (testpath/"CODE_OF_CONDUCT").write("code of conduct")
    (testpath/"script").mkpath
    (testpath/"script/bootstrap").write("Bootstrap Script")
    (testpath/"script/test").write("Test Script")
    shell_output("#{bin}/flint")
  end
end
