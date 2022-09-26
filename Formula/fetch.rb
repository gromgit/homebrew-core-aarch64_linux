class Fetch < Formula
  desc "Download assets from a commit, branch, or tag of GitHub repositories"
  homepage "https://www.gruntwork.io/"
  url "https://github.com/gruntwork-io/fetch/archive/v0.4.5.tar.gz"
  sha256 "baa14d521cf0c59668dd5e84451579f48b623e16bb4d3b2254fa3c54b504fc9b"
  license "MIT"
  head "https://github.com/gruntwork-io/fetch.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/fetch"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "53482fa335d9ee50f7a702cfefde09da24f9337ea6e0a2f2fe56f692d3a6d8a8"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.VERSION=v#{version}")
  end

  test do
    repo_url = "https://github.com/gruntwork-io/fetch"

    assert_match "Downloading release asset SHA256SUMS to SHA256SUMS",
      shell_output("#{bin}/fetch --repo=\"#{repo_url}\" --tag=\"v0.3.10\" --release-asset=\"SHA256SUMS\" . 2>&1")
  end
end
