class Akamai < Formula
  desc "CLI toolkit for working with Akamai's APIs"
  homepage "https://github.com/akamai/cli"
  url "https://github.com/akamai/cli/archive/refs/tags/v1.4.1.tar.gz"
  sha256 "88b25f7d44cab6c964f2aac03bd266577a0355a51ad69788f7b709c1bd145f0c"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/akamai"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "4908ed06bf2de01fe05abbd9c43ad56bab0ee220c8854249fbdfa7926b91cd53"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-tags", "noautoupgrade nofirstrun", *std_go_args, "cli/main.go"
  end

  test do
    assert_match "Purge", pipe_output("#{bin}/akamai install --force purge", "n")
  end
end
