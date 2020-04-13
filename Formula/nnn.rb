class Nnn < Formula
  desc "Tiny, lightning fast, feature-packed file manager"
  homepage "https://github.com/jarun/nnn"
  url "https://github.com/jarun/nnn/archive/v3.1.tar.gz"
  sha256 "d70c21b4afa30fa733ab17bb8b45291e8651f2b823fad748ffbdb3b5c3fb0489"
  head "https://github.com/jarun/nnn.git"

  bottle do
    cellar :any
    sha256 "979fef116edc32109ba25f4c572ffa7eff052104470f6deaa0d779079fbc22d4" => :catalina
    sha256 "4cc6017195bc4d11ab117b136a19634f45a7f84067a003feded706d3606a5e22" => :mojave
    sha256 "5c2fdfd7dadedd0af28195d8eb109d4fd1a6fc27016f744012e284bea3409269" => :high_sierra
  end

  depends_on "readline"

  uses_from_macos "ncurses"

  def install
    system "make", "install", "PREFIX=#{prefix}"

    bash_completion.install "misc/auto-completion/bash/nnn-completion.bash"
    zsh_completion.install "misc/auto-completion/zsh/_nnn"
    fish_completion.install "misc/auto-completion/fish/nnn.fish"
  end

  test do
    # Testing this curses app requires a pty
    require "pty"

    PTY.spawn(bin/"nnn") do |r, w, _pid|
      w.write "q"
      assert_match testpath.realpath.to_s, r.read
    end
  end
end
