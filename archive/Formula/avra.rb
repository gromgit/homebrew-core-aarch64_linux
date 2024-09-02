class Avra < Formula
  desc "Assembler for the Atmel AVR microcontroller family"
  homepage "https://github.com/Ro5bert/avra"
  url "https://github.com/Ro5bert/avra/archive/1.4.2.tar.gz"
  sha256 "cc56837be973d1a102dc6936a0b7235a1d716c0f7cd053bf77e0620577cff986"
  license "GPL-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/avra"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "090d8ab01d821bf225c7abdf6b6c6a7d5c98ceebc3a9d4d4b10370b8e506be15"
  end


  depends_on "autoconf" => :build
  depends_on "automake" => :build

  def install
    system "make", "install", "PREFIX=#{prefix}", "OS=osx"
    pkgshare.install Dir["includes/*"]
  end

  test do
    (testpath/"test.asm").write " .device attiny10\n ldi r16,0x42\n"
    output = shell_output("#{bin}/avra -l test.lst test.asm")
    assert_match "Assembly complete with no errors.", output
    assert_predicate testpath/"test.hex", :exist?
    assert_match "ldi r16,0x42", File.read("test.lst")
  end
end
