class Iproute2mac < Formula
  include Language::Python::Shebang

  desc "CLI wrapper for basic network utilities on macOS - ip command"
  homepage "https://github.com/brona/iproute2mac"
  url "https://github.com/brona/iproute2mac/releases/download/v1.4.1/iproute2mac-1.4.1.tar.gz"
  sha256 "f85558ea41a128ad5fcf30ae04ae272d4414b1cf6c8be06bb116ee41178cfaa1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "2ea180af8a15eace187d17e2f95a84e417445e5175646f6f61b9931633ddf264"
  end

  depends_on :macos
  depends_on "python@3.10"

  def install
    bin.install "src/ip.py" => "ip"
    rewrite_shebang detected_python_shebang, bin/"ip"
  end

  test do
    system "#{bin}/ip", "route"
    system "#{bin}/ip", "address"
    system "#{bin}/ip", "neigh"
  end
end
