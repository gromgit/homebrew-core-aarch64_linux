class Volta < Formula
  desc "JavaScript toolchain manager for reproducible environments"
  homepage "https://volta.sh"
  url "https://github.com/volta-cli/volta.git",
      tag:      "v0.9.2",
      revision: "8f9e8689a622fcda7a6b41c5a93c8b0ffe6ad1e4"
  license "BSD-2-Clause"

  bottle do
    cellar :any_skip_relocation
    sha256 "2a6e425ea344015228a4d9ce10792a8b754f1b747a65be2f9bd07ff819b2c924" => :big_sur
    sha256 "4ad0a1987c96c59b41a89c97b81b11a437176308e44672391a6776c4f5e805ca" => :catalina
    sha256 "a21224ba822d847eaa199e8d4da8dff0d2dd91e8a514f16092d0ed16aba83ada" => :mojave
    sha256 "261320ab49c1877a2f7fe0e1d6be111697bf2c52a8e5ee39256fee6875cecbdd" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system "#{bin}/volta", "install", "node@12.16.1"
    node = shell_output("#{bin}/volta which node").chomp
    assert_match "12.16.1", shell_output("#{node} --version")
  end
end
