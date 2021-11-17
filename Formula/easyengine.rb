class Easyengine < Formula
  desc "Command-line control panel to manage WordPress sites"
  homepage "https://easyengine.io/"
  url "https://github.com/EasyEngine/easyengine/releases/download/v4.4.3/easyengine.phar"
  sha256 "f4297cc2377dfb25bf9384de5870a9944d48d78147186cec8a1f74560c77ee8f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "36d313e1a8d24304f290f409839e6f6df4f277022b31a928bb4ba7b9982c2267"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "36d313e1a8d24304f290f409839e6f6df4f277022b31a928bb4ba7b9982c2267"
    sha256 cellar: :any_skip_relocation, monterey:       "72889626f5591bd8ff17c85c027ee0cb1a8559586b18d8f7e23edd2efd259d90"
    sha256 cellar: :any_skip_relocation, big_sur:        "72889626f5591bd8ff17c85c027ee0cb1a8559586b18d8f7e23edd2efd259d90"
    sha256 cellar: :any_skip_relocation, catalina:       "72889626f5591bd8ff17c85c027ee0cb1a8559586b18d8f7e23edd2efd259d90"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "36d313e1a8d24304f290f409839e6f6df4f277022b31a928bb4ba7b9982c2267"
  end

  depends_on "dnsmasq"
  depends_on "php"

  # Keg-relocation breaks the formula when it replaces `/usr/local` with a non-default prefix
  on_macos do
    pour_bottle? only_if: :default_prefix if Hardware::CPU.intel?
  end

  def install
    bin.install "easyengine.phar" => "ee"
  end

  test do
    return if OS.linux? # requires `sudo`

    system bin/"ee", "config", "set", "locale", "hi_IN"
    output = shell_output("#{bin}/ee config get locale")
    assert_match "hi_IN", output

    output = shell_output("#{bin}/ee cli info")
    assert_match OS.kernel_name, output
  end
end
