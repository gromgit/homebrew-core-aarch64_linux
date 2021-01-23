class Gosec < Formula
  desc "Golang security checker"
  homepage "https://securego.io/"
  url "https://github.com/securego/gosec/archive/v2.6.1.tar.gz"
  sha256 "2b86e4b9ecaf5c8ef61949c4091d43cf7f20e96fd411d08d72189ec20038a7c8"
  license "Apache-2.0"
  head "https://github.com/securego/gosec.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "730bfb268da4ca072d44fc01c8d3f3ba87a1293d637447d996d18c5176e83b84" => :big_sur
    sha256 "26bd589748e75b82019ae480d1f0699d6a9d01689a0afb274b1242df807061a3" => :arm64_big_sur
    sha256 "f2ab2597115da15b5310c5456a4fe363e591432bc283dd2666f1f587b8f2cde3" => :catalina
    sha256 "c0217676973c37182efc63f728471659f7c5129f413df6923b73b1e91ea744db" => :mojave
    sha256 "8b70996fcd2624ac7bec3602a5f2002935924ad6cf8bbd90a670b9764540759c" => :high_sierra
  end

  depends_on "go"

  def install
    system "go", "build", *std_go_args, "-ldflags", "-X main.version=v#{version}", "./cmd/gosec"
  end

  test do
    (testpath/"test.go").write <<~EOS
      package main

      import "fmt"

      func main() {
          username := "admin"
          var password = "f62e5bcda4fae4f82370da0c6f20697b8f8447ef"

          fmt.Println("Doing something with: ", username, password)
      }
    EOS

    output = shell_output("#{bin}/gosec ./...", 1)
    assert_match "G101 (CWE-798)", output
    assert_match "Issues: 1", output
  end
end
