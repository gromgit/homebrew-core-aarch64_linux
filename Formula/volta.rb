class Volta < Formula
  desc "JavaScript toolchain manager for reproducible environments"
  homepage "https://volta.sh"
  url "https://github.com/volta-cli/volta.git",
      tag:      "v0.8.5",
      revision: "5159d0ba44e8a7f0f1a99b04d37eca525d739ce8"

  bottle do
    cellar :any_skip_relocation
    sha256 "5ecc961cef2a4ed63edbef650d788eaa2e72da77da54e1a901290fb86d856527" => :catalina
    sha256 "de3173337350d4094b2306f301a24143181c4e55de4047d6fb12470a1129cb64" => :mojave
    sha256 "65ed8998da0ff1de7a6183a904e82c8c5f9235de662c89d7e01c65898ad9213b" => :high_sierra
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
