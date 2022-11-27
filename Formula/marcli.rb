class Marcli < Formula
  desc "Parse MARC (ISO 2709) files"
  homepage "https://github.com/hectorcorrea/marcli"
  url "https://github.com/hectorcorrea/marcli/archive/refs/tags/1.0.1.tar.gz"
  sha256 "abea9ae6a7cd2d6874ac71d0aa429b9eab367daa4f301161a0671f85608216cf"
  license "MIT"
  head "https://github.com/hectorcorrea/marcli.git", branch: "main"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/marcli"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "a51dc3cde204e6d3ad6d73ddf4b18b1dfb6de8f7e18333a6d7b0667a7e88d5db"
  end

  depends_on "go" => :build

  resource "testdata" do
    url "https://raw.githubusercontent.com/hectorcorrea/marcli/5434a2f85c6f03771f92ad9f0d5af5241f3385a6/data/test_1a.mrc"
    sha256 "7359455ae04b1619f3879fe39eb22ad4187fb3550510f71cb4f27693f60cf386"
  end

  def install
    cd "cmd/marcli" do
      system "go", "build", *std_go_args
    end
  end

  test do
    resource("testdata").stage do
      assert_equal "=650  \\0$aCoal$xAnalysis.\r\n=650  \\0$aCoal$xSampling.\r\n\r\n",
      shell_output("#{bin}/marcli -file test_1a.mrc -fields 650")
    end
  end
end
