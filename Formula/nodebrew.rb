class Nodebrew < Formula
  desc "Node.js version manager"
  homepage "https://github.com/hokaccha/nodebrew"
  url "https://github.com/hokaccha/nodebrew/archive/v1.1.0.tar.gz"
  sha256 "b2046d97392ed971254bee2026cfcf8fb59225f51b566ec4b77e9355a861c8a7"
  license "MIT"
  head "https://github.com/hokaccha/nodebrew.git"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "5e9e02328f5023fe172b99cca642dc4d4fe89b82ea8d29293d6d7f8853f2a048"
  end

  def install
    bin.install "nodebrew"
    bash_completion.install "completions/bash/nodebrew-completion" => "nodebrew"
    zsh_completion.install "completions/zsh/_nodebrew"
  end

  def caveats
    <<~EOS
      You need to manually run setup_dirs to create directories required by nodebrew:
        #{opt_bin}/nodebrew setup_dirs

      Add path:
        export PATH=$HOME/.nodebrew/current/bin:$PATH

      To use Homebrew's directories rather than ~/.nodebrew add to your profile:
        export NODEBREW_ROOT=#{var}/nodebrew
    EOS
  end

  test do
    assert_match "v0.10.0", shell_output("#{bin}/nodebrew ls-remote")
  end
end
