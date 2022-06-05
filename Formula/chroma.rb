class Chroma < Formula
  desc "General purpose syntax highlighter in pure Go"
  homepage "https://github.com/alecthomas/chroma"
  url "https://github.com/alecthomas/chroma/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "98a517ae99f48e3b54d5c8cd7473d5c544f51bee7a4be17f5175736fce37da56"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/chroma"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "6d2edd6153a88b705f28f504fd76ee8b456babf2496b4719a1eeae8938c00403"
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
