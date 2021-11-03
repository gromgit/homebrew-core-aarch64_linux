class Macchina < Formula
  desc "System information fetcher, with an emphasis on performance and minimalism"
  homepage "https://github.com/Macchina-CLI/macchina"
  url "https://github.com/Macchina-CLI/macchina/archive/v5.0.3.tar.gz"
  sha256 "b235cc4830948dd9f90e4400cf008c4202b50f03400f7a44beb79dc093e5be93"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d9d8386545ae5c433eccc2b543a98536070c06be198366b276239838a28833f0"
    sha256 cellar: :any_skip_relocation, big_sur:       "9a5ed294fcc7d1a079d96507e49947a570150aeccb293406764ad3c1ef7dfaa4"
    sha256 cellar: :any_skip_relocation, catalina:      "0bd95dd047a1e7ace35bf936338c38c469b41bbb9c2df709917cfc1fae40d520"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f1068511ac8980aeefb8e32080b76fb8e72d9caebe8ae7145b13592deea91bd7"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Let's check your system for errors...", shell_output("#{bin}/macchina --doctor")
  end
end
