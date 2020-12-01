class Gopls < Formula
  desc "Language server for the Go language"
  homepage "https://github.com/golang/tools/tree/master/gopls"
  url "https://github.com/golang/tools/archive/gopls/v0.5.4.tar.gz"
  sha256 "0a93330f0ac894ea90183e2ba87ed076bef29c5767d8fb57dc928116a0b7e5e9"
  license "BSD-3-Clause"

  bottle do
    cellar :any_skip_relocation
    sha256 "95cd968334a8a6241bb2acd424c1d77c2f58d071262e0a81959e77e8af03e89f" => :big_sur
    sha256 "b54631dfb3f05d793b9d49709afcb720275fe3bf68e5f636d2192081db7dced2" => :catalina
    sha256 "46a478aabd95d7121cef40ea6ca53a70957262df969b101b3164187ab8679970" => :mojave
  end

  depends_on "go" => :build

  def install
    cd "gopls" do
      system "go", "build", *std_go_args
    end
  end

  test do
    output = shell_output("#{bin}/gopls api-json")
    output = JSON.parse(output)

    assert_equal "gopls.generate", output["Commands"][0]["Command"]
    assert_equal "false", output["Options"]["Debugging"][0]["Default"]
  end
end
