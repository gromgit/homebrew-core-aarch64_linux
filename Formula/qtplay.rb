class Qtplay < Formula
  desc "Play audio CDs, MP3s, and other music files"
  homepage "https://sites.google.com/site/rainbowflight2/"
  url "https://sites.google.com/site/rainbowflight2/qtplay1.3.1.tar.gz"
  sha256 "5d0d5bda455d77057a2372925a2c1da09ef82b5969ef0342e61d8b63876ed840"

  bottle do
    cellar :any_skip_relocation
    sha256 "746f199b8e6446fbc61279979baf2a2fa6e6cc024a4752583af31f65655a0627" => :el_capitan
    sha256 "0d9f00cede1034f24c971a7d29ce3f37b23e55a384d5a53c10af13487aca7122" => :yosemite
    sha256 "a49971abae8f1b99e685055b29e8fd7289837e43375b25fbc66d6081aeb9786b" => :mavericks
  end

  def install
    # Only a 32-bit binary is supported
    system ENV.cc, "qtplay.c", "-arch", "i386", "-framework", "QuickTime", "-framework", "Carbon", "-o", "qtplay"
    bin.install "qtplay"
    man1.install "qtplay.1"
  end

  test do
    system "#{bin}/qtplay", "--help"
  end
end
