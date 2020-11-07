class Lego < Formula
  desc "Let's Encrypt client"
  homepage "https://go-acme.github.io/lego/"
  url "https://github.com/go-acme/lego.git",
    tag:      "v4.1.0",
    revision: "dd4f73dd6a9fc0a4764b8bd639ad1834ad9bde7b"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "e838e544055688ecde67cf875512b56bc2d8a93f758ad1c1022e851741b97ed1" => :catalina
    sha256 "105d60e54fafc554459d1e5f15611cbbb5133721d6ef3e55efbc6c12ad4c7c26" => :mojave
    sha256 "16e822839a17a738f96b37cafcb9f90bcb7666b4ae6223a12d702fa336c430ed" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-s -w -X main.version=#{version}", "-trimpath",
        "-o", bin/"lego", "cmd/lego/main.go"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lego -v")
  end
end
