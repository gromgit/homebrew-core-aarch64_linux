class Murex < Formula
  desc "Bash-like shell designed for greater command-line productivity and safer scripts"
  homepage "https://murex.rocks"
  url "https://github.com/lmorg/murex/archive/v2.10.2300.tar.gz"
  sha256 "0ea18936bf9b77e0198124bb6cfb0cc1f6487c483e84aafb9063b4434e2e777d"
  license "GPL-2.0-only"
  head "https://github.com/lmorg/murex.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d34d9110dce36340f19b9d8e193f00afb2330729c9bda1bb058b7fec45c885a3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "893decd708244a8f11c5991895bd5fb2ceea10d793036437e88422937e244b89"
    sha256 cellar: :any_skip_relocation, monterey:       "b0df95e96bfa4a0c368b1b3dc66ab64a8aa88f5ac76d24a649649a35e74e68cb"
    sha256 cellar: :any_skip_relocation, big_sur:        "dd5d0a5b915a68c80814831a305225ad6fdca406a48b83e1dd1a55866108766b"
    sha256 cellar: :any_skip_relocation, catalina:       "e2dacff7211c068abffce2cde27a6e1a616c225b97276158e4503188dd573efb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "186a073b0e479ede973f2ccb5dd46709d064b5f4db71c5c6ed80c775ffe200dc"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    system "#{bin}/murex", "--run-tests"
    assert_equal "homebrew", shell_output("#{bin}/murex -c 'echo homebrew'").chomp
  end
end
