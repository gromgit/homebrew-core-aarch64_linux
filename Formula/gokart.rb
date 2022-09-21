class Gokart < Formula
  desc "Static code analysis for securing Go code"
  homepage "https://github.com/praetorian-inc/gokart"
  url "https://github.com/praetorian-inc/gokart/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "ac73f90d274851ac00e2f3fb269a493ea9b4c06eb8d6d1db0ae953bf85129ad6"
  license "Apache-2.0"
  head "https://github.com/praetorian-inc/gokart.git", branch: "main"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/gokart"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "3e1597e7030111794528e104686f51c7c6f8959c683522e5262f80da21e8296c"
  end

  depends_on "go" => [:build, :test]

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    mkdir "brewtest" do
      system "go", "mod", "init", "brewtest"
      (testpath/"brewtest/main.go").write <<~EOS
        package main

        func main() {}
      EOS
    end

    assert_match "GoKart found 0 potentially vulnerable functions",
      shell_output("#{bin}/gokart scan brewtest")

    assert_match version.to_s, shell_output("#{bin}/gokart version")
  end
end
