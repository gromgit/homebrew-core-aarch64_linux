class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/wrangler"
  url "https://github.com/cloudflare/wrangler/archive/v1.14.1.tar.gz"
  sha256 "4c07a07e33ab48aa5c3e407c2ba0db0efd24d85422a12ccf6e9ecac8f00bcb61"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e8ca2d477cfac5305d6030912fbdf0ce25ce967aaf0fc3db77f43e93c8a57bc5"
    sha256 cellar: :any_skip_relocation, big_sur:       "146eda48afc672735af8e09d1626d93bb3fadaf85b068ea7a378916efd1fd081"
    sha256 cellar: :any_skip_relocation, catalina:      "04b4ba50e818447f0bad9910dfaa740a64d4250b14d809eb9ba88093917edd87"
    sha256 cellar: :any_skip_relocation, mojave:        "a8e01e9652a431786fe431f65d753e668b1b622d4e17a1fe7f2e799b8970886c"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("CF_API_TOKEN=AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA #{bin}/wrangler whoami 2>&1", 1)
    assert_match(/Code 9109: (?:Invalid access token|Max auth failures reached)/, output)
  end
end
