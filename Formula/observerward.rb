class Observerward < Formula
  desc "Cross platform community web fingerprint identification tool"
  homepage "https://0x727.github.io/ObserverWard/"
  url "https://github.com/0x727/ObserverWard/archive/refs/tags/v2022.9.23.tar.gz"
  sha256 "08a5177bdc51d6048c877a1f958ca180e3fc05a7f3e146881fbacc2264966767"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "465d54622d706ad45bd3539fb742d005a2977d3c0cab84c1016321faa2075110"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fe9619b1520b12d04324c55ac28a0a5d6cc760c113059622ed4035d85e2362f4"
    sha256 cellar: :any_skip_relocation, monterey:       "11649c502a4c6956f8f5bd4327487cec52613809e3134f18f847b49b8a67ef68"
    sha256 cellar: :any_skip_relocation, big_sur:        "0c54cbeb963b5e927471a77c61147f5382ddc45a84972522375df40dd3af9bd6"
    sha256 cellar: :any_skip_relocation, catalina:       "70917ff381a9356f2cd02bfa334a21436f50c8c51bc94ed157f035ac91269690"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "be3faee36ba641d232ced62dc7ff8e0d127ee52dc1f67a381bfdb4b20cff1c04"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"observer_ward", "-u"
    assert_match "swagger", shell_output("#{bin}/observer_ward -t https://httpbin.org")
  end
end
