class Mkcert < Formula
  desc "Simple tool to make locally trusted development certificates"
  homepage "https://github.com/FiloSottile/mkcert"
  url "https://github.com/FiloSottile/mkcert/archive/refs/tags/v1.4.4.tar.gz"
  sha256 "32bd5519581bf0b03f53e5b22721692b99f39ab5b161dc27532c51eafa512ca9"
  license "BSD-3-Clause"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/mkcert"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "20b46dd382c63eb5dde542bdd3e15ee9c0637a9d6386c401b7a1b43883c0fcc3"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=v#{version}")
  end

  test do
    ENV["CAROOT"] = testpath
    system bin/"mkcert", "brew.test"
    assert_predicate testpath/"brew.test.pem", :exist?
    assert_predicate testpath/"brew.test-key.pem", :exist?
    output = (testpath/"brew.test.pem").read
    assert_match "-----BEGIN CERTIFICATE-----", output
    output = (testpath/"brew.test-key.pem").read
    assert_match "-----BEGIN PRIVATE KEY-----", output
  end
end
