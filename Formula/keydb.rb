class Keydb < Formula
  desc "Multithreaded fork of Redis"
  homepage "https://keydb.dev"
  url "https://github.com/Snapchat/KeyDB/archive/v6.3.0.tar.gz"
  sha256 "58793c1ed2f0afc81582a6216844ef9e9b1b4d3ceb8a9bbda5b34ed1b1e17e0c"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b6d9c8d5d77a71cade23c85b2258f3b0fb74e2bfd3c58ea9fd5aadfbb0ea1778"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8ae26fdb9109fc9960a31aa4ac9e290846ad22bd24f27abbe89777b2f3f915a6"
    sha256 cellar: :any_skip_relocation, monterey:       "040fe3beb451c44631ee4e6b016c3db0e28a3aafffb88813392ef32eb139aac7"
    sha256 cellar: :any_skip_relocation, big_sur:        "348803202838f745a4bb966eca19a7610f2530e72b4b61a2457d082b810c5aa6"
    sha256 cellar: :any_skip_relocation, catalina:       "355c9f6fd3854b0a45413af336a8c81f91207b1405643b8aa3f0db1f9888291c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "535b7f2c5d08ca981e8a20fdf264c0fa47c9a1410c1811b36d62dac43e29d852"
  end

  depends_on "openssl@3"
  uses_from_macos "curl"

  on_linux do
    depends_on "util-linux"
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    output = shell_output("#{bin}/keydb-server --test-memory 2")
    assert_match "Your memory passed this test", output
  end
end
