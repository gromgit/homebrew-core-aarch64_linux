class GpgTui < Formula
  desc "Manage your GnuPG keys with ease! 🔐"
  homepage "https://github.com/orhun/gpg-tui"
  url "https://github.com/orhun/gpg-tui/archive/refs/tags/v0.7.3.tar.gz"
  sha256 "607523580019948f9bf9cebd9d434748ff4009b8bae07f9708310fe7f9e7fb73"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "5e1c8b7860b7b5ef3a82c268050b1e0dd960eed2e373e9c678e345dca3d0e8bf"
    sha256 cellar: :any, big_sur:       "510058554d28f876246ebb229b00f31d734a5869cdaeed301490d4a252a848e1"
    sha256 cellar: :any, catalina:      "f862458cf2f880f06553af7ff49f4300396e80ac218e3181e064cf2f74b9aedd"
    sha256 cellar: :any, mojave:        "427346a6947f514dac7823a881487fa6d35c8611811e54d6736cae4bc6f7c78f"
  end

  depends_on "rust" => :build
  depends_on "gnupg"
  depends_on "gpgme"
  depends_on "libgpg-error"
  depends_on "libxcb"

  def install
    system "cargo", "install", *std_cargo_args

    ENV["OUT_DIR"] = buildpath
    system bin/"completions"
    bash_completion.install "gpg-tui.bash"
    fish_completion.install "gpg-tui.fish"
    zsh_completion.install "_gpg-tui"

    rm_f bin/"completions"
    rm_f Dir[prefix/".crates*"]
  end

  test do
    require "pty"
    require "io/console"

    (testpath/"gpg-tui").mkdir
    r, w, pid = PTY.spawn "#{bin}/gpg-tui"
    r.winsize = [80, 43]
    sleep 1
    w.write "q"
    assert_match(/^.*<.*list.*pub.*>.*$/, r.read)
  ensure
    Process.kill("TERM", pid)
  end
end
