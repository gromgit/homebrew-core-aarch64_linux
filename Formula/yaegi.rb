class Yaegi < Formula
  desc "Yet another elegant Go interpreter"
  homepage "https://github.com/containous/yaegi"
  url "https://github.com/containous/yaegi/archive/v0.8.3.tar.gz"
  sha256 "d40d6784a90bc435632c325e3b574ec82765e83689a56ffd169e13087f623d6f"
  head "https://github.com/containous/yaegi.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "5f9ae10bbe25c5508401d45c77d6362dcfacbdf499382ee4eb04e7533428a348" => :catalina
    sha256 "30ed411f9879c90e15a16ec5512f54f6ce67c190f9ce51ee0f00435453ec40bf" => :mojave
    sha256 "6ee17d3481a3002a329706b5412b8af0f4b2337fa5360a2b51e09af655c014fb" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-s -w", "-trimpath", "-o", bin/"yaegi", "cmd/yaegi/yaegi.go"
    prefix.install_metafiles
  end

  test do
    assert_match "4", pipe_output("#{bin}/yaegi", "3 + 1", 0)
  end
end
