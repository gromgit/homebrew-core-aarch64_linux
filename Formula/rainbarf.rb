class Rainbarf < Formula
  desc "CPU/RAM/battery stats chart bar for tmux (and GNU screen)"
  homepage "https://github.com/creaktive/rainbarf"
  url "https://github.com/creaktive/rainbarf/archive/v1.2.tar.gz"
  sha256 "0ed48afe52890ccd92c21cc9f1533ecd3b936fbff93d4a4a4d39868388671d80"

  bottle do
    cellar :any_skip_relocation
    sha256 "39b5a8eabc041a4b2123993451aa4ebe9693ab89849dd19c9fb7104a8db44aaa" => :el_capitan
    sha256 "98b92bee77eca904745cbb5538a0a9515bc4d1d41aff8d4011d542a674bd69fe" => :yosemite
    sha256 "98e96f814661e0bd2702eaeef51261ed9c6d1ad06a24f7123107ec22a6f2fc28" => :mavericks
  end

  def install
    system "pod2man", "rainbarf", "rainbarf.1"
    man1.install "rainbarf.1"
    bin.install "rainbarf"
  end

  test do
    system "#{bin}/rainbarf"
  end
end
