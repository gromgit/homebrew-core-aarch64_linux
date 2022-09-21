class Aoeui < Formula
  desc "Lightweight text editor optimized for Dvorak and QWERTY keyboards"
  homepage "https://code.google.com/archive/p/aoeui/"
  url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/aoeui/aoeui-1.6.tgz"
  sha256 "0655c3ca945b75b1204c5f25722ac0a07e89dd44bbf33aca068e918e9ef2a825"
  license "GPL-2.0-only"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/aoeui"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "f04c4f0ad5d0e70c9ee1d983d8e812f80a078842b1d6518062dc736764109c35"
  end

  uses_from_macos "m4" => :build

  def install
    system "make", "INST_DIR=#{prefix}", "install"
  end
end
