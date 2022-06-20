class Staticcheck < Formula
  desc "State of the art linter for the Go programming language"
  homepage "https://staticcheck.io/"
  url "https://github.com/dominikh/go-tools/archive/2022.1.1.tar.gz"
  sha256 "988756d12527bf9843459a30cc6fbbf2a7d6d75e62326b0387eab6273e992543"
  license "MIT"
  head "https://github.com/dominikh/go-tools.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/staticcheck"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "e8efd5ad598b5c80ec158abc30d480b40decc3e9136e3329449f19ec8b7179a4"
  end

  depends_on "go"

  def install
    system "go", "build", *std_go_args, "./cmd/staticcheck"
  end

  test do
    (testpath/"test.go").write <<~EOS
      package main

      import "fmt"

      func main() {
        var x uint
        x = 1
        fmt.Println(x)
      }
    EOS
    json_output = JSON.parse(shell_output("#{bin}/staticcheck -f json test.go", 1))
    assert_equal json_output["code"], "S1021"
  end
end
