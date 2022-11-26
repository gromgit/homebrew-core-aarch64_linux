class Muffet < Formula
  desc "Fast website link checker in Go"
  homepage "https://github.com/raviqqe/muffet"
  url "https://github.com/raviqqe/muffet/archive/v2.6.2.tar.gz"
  sha256 "d079cf94f791a93f0976bb9aa4296b0f3df27d379e3a2054b8c6a50e193bc6d2"
  license "MIT"
  head "https://github.com/raviqqe/muffet.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "397feee05639034b937542fe808de0c4a82cddb7e7b6cdf177c67d8d257cfdcb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ca593882662c0ddbd75fdc3ac173e8e1443cd3ded92b082b271078b9638b221a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a4f7692e22960e489ce3c303ddc58ed3042a613a5009793769bc8df4f635c204"
    sha256 cellar: :any_skip_relocation, ventura:        "1c95f993354c7c20f80321b4c5c5531795500e3e4a48f52958e0d2130a96dfdf"
    sha256 cellar: :any_skip_relocation, monterey:       "d94463479a35add6f9017cd6195add5d7f770460fbc7affb88cf4cb65b5eda34"
    sha256 cellar: :any_skip_relocation, big_sur:        "be38d809c1d492133b7dae92ad6cf6a6c88db65020840e493de0655011b28eac"
    sha256 cellar: :any_skip_relocation, catalina:       "1e7b4be591c708ee6478eba3dc6c344f7e08bc22d0a43eefda4e8cf418eaa785"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7fcdad605b1bf8a3b642cfb0b51a9716a77a2cd210408fec8b714cb1b47777fc"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match(/failed to fetch root page: lookup does\.not\.exist.*: no such host/,
                 shell_output("#{bin}/muffet https://does.not.exist 2>&1", 1))

    assert_match "https://httpbin.org/",
                 shell_output("#{bin}/muffet https://httpbin.org 2>&1", 1)
  end
end
