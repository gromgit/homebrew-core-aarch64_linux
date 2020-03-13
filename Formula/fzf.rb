class Fzf < Formula
  desc "Command-line fuzzy finder written in Go"
  homepage "https://github.com/junegunn/fzf"
  url "https://github.com/junegunn/fzf/archive/0.21.0-1.tar.gz"
  version "0.21.0-1"
  sha256 "f647ff8c8828a38f5fa10c9f831a5e5e58321bba1e26abdb249f1af48ffd97db"
  head "https://github.com/junegunn/fzf.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "0d51962d904b7cd680fd316cc4691b5a562ce1ae77d4dcbfd40006f91c0945d6" => :catalina
    sha256 "c523ba3a6266bb58697e27f45adbf1a01d13560c22a0302dc946d3277da53274" => :mojave
    sha256 "72b692bd10dcc27504657f6eaf40d60f60c290f2b13052d6e6ad08ecc65f9c48" => :high_sierra
  end

  depends_on "go" => :build

  uses_from_macos "ncurses"

  def install
    ENV["GOPATH"] = HOMEBREW_CACHE/"go_cache"
    system "go", "build", "-o", bin/"fzf", "-ldflags", "-X main.revision=brew"

    prefix.install "install", "uninstall"
    (prefix/"shell").install %w[bash zsh fish].map { |s| "shell/key-bindings.#{s}" }
    (prefix/"shell").install %w[bash zsh].map { |s| "shell/completion.#{s}" }
    (prefix/"plugin").install "plugin/fzf.vim"
    man1.install "man/man1/fzf.1", "man/man1/fzf-tmux.1"
    bin.install "bin/fzf-tmux"
  end

  def caveats; <<~EOS
    To install useful keybindings and fuzzy completion:
      #{opt_prefix}/install

    To use fzf in Vim, add the following line to your .vimrc:
      set rtp+=#{opt_prefix}
  EOS
  end

  test do
    (testpath/"list").write %w[hello world].join($INPUT_RECORD_SEPARATOR)
    assert_equal "world", shell_output("cat #{testpath}/list | #{bin}/fzf -f wld").chomp
  end
end
