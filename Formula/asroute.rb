class Asroute < Formula
  desc "CLI to interpret traceroute -a output to show AS names traversed"
  homepage "https://github.com/stevenpack/asroute"
  url "https://github.com/stevenpack/asroute/archive/v0.1.0.tar.gz"
  sha256 "dfbf910966cdfacf18ba200b83791628ebd1b5fa89fdfa69b989e0cb05b3ca37"
  license "MIT"
  head "https://github.com/stevenpack/asroute.git"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    bin.install "target/release/asroute"
  end

  test do
    system "echo '[AS13335]' | asroute"
  end
end
