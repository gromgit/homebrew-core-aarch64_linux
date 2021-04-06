class LeafProxy < Formula
  desc "Lightweight and fast proxy utility"
  homepage "https://github.com/eycorsican/leaf"
  url "https://github.com/eycorsican/leaf/archive/v0.2.14.tar.gz"
  sha256 "8760b74f1a9231ca736a4d533fa08ea4982f89d2781753c09cf0ce1b14658cd1"
  license "Apache-2.0"
  head "https://github.com/eycorsican/leaf.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "5cf0070ceacfd72e04d6adbd77851b1c15ec01ff79f2add28407a8452f5bb2b3"
    sha256 cellar: :any_skip_relocation, big_sur:       "d95b88877ccd9d3a77758887f0696fffa46b23ae492960a1716005b2349e4bef"
    sha256 cellar: :any_skip_relocation, catalina:      "a0ee193feb50ee14874647967eaca61de66b267265ee5035a24047ad8ebb30fa"
    sha256 cellar: :any_skip_relocation, mojave:        "8c8694440e773387ed663a650f8609aa27ec5c454166337e3f09941803292b91"
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
    output = shell_output "#{bin}/leaf -c #{testpath}/config.conf -t SS", 1

    assert_match "dispatch to outbound SS failed", output
  end
end
