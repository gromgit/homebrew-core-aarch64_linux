class Volta < Formula
  desc "JavaScript toolchain manager for reproducible environments"
  homepage "https://volta.sh"
  url "https://github.com/volta-cli/volta.git",
    :revision => "42caba1cc64b0e2946b9dc2db8b570fc55aef298",
    :tag      => "v0.8.3"

  bottle do
    cellar :any_skip_relocation
    sha256 "d027df0f390424da752160dc8587a2f873af9f60b19c785ed227584e21e079ea" => :catalina
    sha256 "7ab21021eed69d9a95646425b6e95fe67b1d3e65b2a7f60525496a63f037a2f0" => :mojave
    sha256 "238005d3d2d5164f237ae6c866afd76f4d5805d8f8bc813b3983745dbcf54e73" => :high_sierra
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
