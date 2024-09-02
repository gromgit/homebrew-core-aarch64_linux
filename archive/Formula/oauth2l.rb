class Oauth2l < Formula
  desc "Simple CLI for interacting with Google oauth tokens"
  homepage "https://github.com/google/oauth2l"
  url "https://github.com/google/oauth2l/archive/v1.2.2.tar.gz"
  sha256 "6bee262a59669be86e578190f4a7ce6f7b18d5082bd647de82c4a11257a91e83"
  license "Apache-2.0"
  head "https://github.com/google/oauth2l.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/oauth2l"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "14cd9621c19f9bc6a74ddefe2250cba5e2337c5c26be474c12e401c1f41d7d58"
  end

  depends_on "go" => :build

  def install
    ENV["GO111MODULE"] = "on"

    system "go", "build", "-o", "oauth2l"
    bin.install "oauth2l"
  end

  test do
    assert_match "Invalid Value",
      shell_output("#{bin}/oauth2l info abcd1234")
  end
end
