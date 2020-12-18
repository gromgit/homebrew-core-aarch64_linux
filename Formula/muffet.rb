class Muffet < Formula
  desc "Fast website link checker in Go"
  homepage "https://github.com/raviqqe/muffet"
  url "https://github.com/raviqqe/muffet/archive/v2.3.1.tar.gz"
  sha256 "83aa39d35c95cb836c1b6adb6e178625cde80ef97cf4a7a2339c62dce10a4229"
  license "MIT"
  head "https://github.com/raviqqe/muffet.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "fbf4fe5c9e0422c2f032428ec4af6579e8b9bc1589d015ca9b6dbe83fa5773be" => :big_sur
    sha256 "b98ea175fa41b49e6106ad5bede8ca34038c5c474fdb9d6a1587c4b2dba1cdb7" => :catalina
    sha256 "abc9c60df720e0799f8952cf285c6b1c3c9937d9fb9240d7201b1e6812476dbe" => :mojave
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    assert_match "failed to fetch root page: lookup does.not.exist: no such host",
        shell_output("#{bin}/muffet https://does.not.exist 2>&1", 1)

    system bin/"muffet", "https://httpbin.org/"
  end
end
