class Fzf < Formula
  desc "Command-line fuzzy finder written in Go"
  homepage "https://github.com/junegunn/fzf"
  url "https://github.com/junegunn/fzf/archive/0.27.1.tar.gz"
  sha256 "d86d879e01dee330d2fd3ef522a5bc5c2eafd31990e6869142fd300a06e4c13e"
  license "MIT"
  head "https://github.com/junegunn/fzf.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "05096291897192bd3cc19ffec92dee0ffe93db9920a4be1b8bed195944521a7c"
    sha256 cellar: :any_skip_relocation, big_sur:       "e0acd79337f89399d9fe7c7602d8b32dbf967cc915e4f658ce6ac5d091828792"
    sha256 cellar: :any_skip_relocation, catalina:      "e0acd79337f89399d9fe7c7602d8b32dbf967cc915e4f658ce6ac5d091828792"
    sha256 cellar: :any_skip_relocation, mojave:        "e0acd79337f89399d9fe7c7602d8b32dbf967cc915e4f658ce6ac5d091828792"
  end

  depends_on "go" => :build

  uses_from_macos "ncurses"

  def install
    system "go", "build", *std_go_args, "-ldflags", "-s -w -X main.version=#{version} -X main.revision=brew"

    prefix.install "install", "uninstall"
    (prefix/"shell").install %w[bash zsh fish].map { |s| "shell/key-bindings.#{s}" }
    (prefix/"shell").install %w[bash zsh].map { |s| "shell/completion.#{s}" }
    (prefix/"plugin").install "plugin/fzf.vim"
    man1.install "man/man1/fzf.1", "man/man1/fzf-tmux.1"
    bin.install "bin/fzf-tmux"
  end

  def caveats
    <<~EOS
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
