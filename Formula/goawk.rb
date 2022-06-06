class Goawk < Formula
  desc "POSIX-compliant AWK interpreter written in Go"
  homepage "https://benhoyt.com/writings/goawk/"
  url "https://github.com/benhoyt/goawk/archive/refs/tags/v1.16.0.tar.gz"
  sha256 "f610e57396cac89aaa1070ab9edfd46f09929775b58dad2ba78ed8a59e01d6a1"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/goawk"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "85297d56574fa3ec760db56dfac3434aa5fa0e18722a186cda62417361c54a85"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    output = pipe_output("#{bin}/goawk '{ gsub(/Macro/, \"Home\"); print }' -", "Macrobrew")
    assert_equal "Homebrew", output.strip
  end
end
