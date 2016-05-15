class Buku < Formula
  desc "Command-line bookmark manager"
  homepage "https://github.com/jarun/Buku"
  url "https://github.com/jarun/Buku/archive/v2.0.tar.gz"
  sha256 "78b98be8f000812dcc945c0aa9ca4fa56322659c095250d4787c21bfd6383897"

  bottle do
    cellar :any_skip_relocation
    sha256 "dbd8fa932bfa207a4a30c4b3541ab850aa0b003e634651737458f0444cd45775" => :el_capitan
    sha256 "c463659c95a3fa76ccdfc345cdc105e814bb00a2ad2b104d5a5ed683a72f0a6d" => :yosemite
    sha256 "24eff66c1db880ec5ce58329d4b7c0b8d2a3c000bbe74cce75209cea2a4f008a" => :mavericks
  end

  depends_on :python3

  def install
    system "make", "install", "PREFIX=#{prefix}"
    bash_completion.install "auto-completion/bash/buku-completion.bash"
    fish_completion.install "auto-completion/fish/buku.fish"
    zsh_completion.install "auto-completion/zsh/_buku"
  end

  test do
    ENV["XDG_DATA_HOME"] = "#{testpath}/.local/share"
    system "#{bin}/buku", "-a", "https://github.com/Homebrew/homebrew"
    assert_match %r{https://github.com/Homebrew/homebrew}, shell_output("#{bin}/buku -s github </dev/null")
  end
end
