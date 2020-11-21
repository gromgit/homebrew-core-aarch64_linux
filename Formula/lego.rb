class Lego < Formula
  desc "Let's Encrypt client"
  homepage "https://go-acme.github.io/lego/"
  url "https://github.com/go-acme/lego.git",
    tag:      "v4.1.2",
    revision: "721cfb5fe2d4d32043f5994e2a38473a86365802"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "e0916a9d389c78ea43c2507ba315ab3fe2b6967319dd67940a7f410de518a6b5" => :big_sur
    sha256 "246dccf11c20bf7d51cbfd3a33dcb64a024865df646cb98751d7fe74016b25eb" => :catalina
    sha256 "8026cdd3367a91bf958cabb0eae75350f9f66a597708c7eef950bb7201085476" => :mojave
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
