class Chroma < Formula
  desc "General purpose syntax highlighter in pure Go"
  homepage "https://github.com/alecthomas/chroma"
  url "https://github.com/alecthomas/chroma/archive/refs/tags/v2.2.0.tar.gz"
  sha256 "6870cb8c47897f2a75abaf3e6cbb160989b4e915b86fdcd9322fb17e073ccd81"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/chroma"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "371686ea2af29363dc7f468267c8ce269c4bd2bda24d8e5479c066e3dea42dc8"
  end

  depends_on "go" => :build

  def install
    cd "cmd/chroma" do
      system "go", "build", *std_go_args(ldflags: "-s -w")
    end
  end

  test do
    json_output = JSON.parse(shell_output("#{bin}/chroma --json #{test_fixtures("test.diff")}"))
    assert_equal "GenericHeading", json_output[0]["type"]
  end
end
