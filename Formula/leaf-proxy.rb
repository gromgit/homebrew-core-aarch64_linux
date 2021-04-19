class LeafProxy < Formula
  desc "Lightweight and fast proxy utility"
  homepage "https://github.com/eycorsican/leaf"
  url "https://github.com/eycorsican/leaf/archive/v0.3.0.tar.gz"
  sha256 "72cc8e6ba62016ab9ae9272dd4aadc2d00e0067387ab3ddb71e415b4603d82d9"
  license "Apache-2.0"
  head "https://github.com/eycorsican/leaf.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "507056ec8a14e7098cb43b68b2523bd4f15daf4ca1669ab9aa7a3875e8d4585e"
    sha256 cellar: :any_skip_relocation, big_sur:       "6439b4489d77a1d1e7b7c74d07e0e4554fc53d7cda2a41faa6750fa2a873be36"
    sha256 cellar: :any_skip_relocation, catalina:      "d5be20daf2e2f7ca57fa16cb584958f3cb4f49c82ed3b6a7d2e0eeeb277a59ed"
    sha256 cellar: :any_skip_relocation, mojave:        "5746028d3690b7c32f3444f66b06f64518793719a850851d6a5e1fb0a7d506af"
  end

  depends_on "rust" => :build

  conflicts_with "leaf", because: "both install a `leaf` binary"

  resource "lwip" do
    url "https://github.com/eycorsican/lwip-leaf.git",
        revision: "86632e2747c926a75d32be8bd9af059aa38ae75e"
  end

  def install
    (buildpath/"leaf/src/proxy/tun/netstack/lwip").install resource("lwip")

    cd "leaf-bin" do
      system "cargo", "install", *std_cargo_args
    end
  end

  test do
    (testpath/"config.conf").write <<~EOS
      [General]
      dns-server = 8.8.8.8

      [Proxy]
      SS = ss, 127.0.0.1, #{free_port}, encrypt-method=chacha20-ietf-poly1305, password=123456
    EOS
    output = shell_output "#{bin}/leaf -c #{testpath}/config.conf -t SS"

    assert_match "dispatch to outbound SS failed", output
  end
end
