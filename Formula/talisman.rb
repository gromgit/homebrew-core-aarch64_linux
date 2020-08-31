class Talisman < Formula
  desc "Tool to detect and prevent secrets from getting checked in"
  homepage "https://thoughtworks.github.io/talisman/"
  url "https://github.com/thoughtworks/talisman/archive/v1.8.0.tar.gz"
  sha256 "12dbf3b314ae0ca0f0b66ce2da229e7e5d1a7ae1ae2f233630ed4381cc3aa074"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "8758511aeed8d27bcaa43e9bd9ec26c590a9fc37521928e3fa51e83c9b428437" => :catalina
    sha256 "415556d7b5452882edd12d6960064dba3817f96813a10647c72b7b3d9c47bd0a" => :mojave
    sha256 "bf9faf2467cc4471ab2ff610c7b846263396f571e4f99d44e33716753f1af39b" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-ldflags", "-X main.Version=#{version}"
  end

  test do
    system "git", "init", "."
    assert_match "talisman scan report", shell_output(bin/"talisman --scan")
  end
end
