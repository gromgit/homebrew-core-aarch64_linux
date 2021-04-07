class YoutubeDl < Formula
  include Language::Python::Virtualenv

  desc "Download YouTube videos from the command-line"
  homepage "https://youtube-dl.org/"
  url "https://files.pythonhosted.org/packages/14/0c/c2ffe08208f9a9c428850c3df2b13079c7e49a1b09cb2fafce5b87c9b32c/youtube_dl-2021.4.7.tar.gz"
  sha256 "34a034d9b2062e428710d4cd6365db7a64cd388e51a3f9ab74058179c95d8654"
  license "Unlicense"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a6f0f586f8037d94cfabef7bd0a1cb6c065843fdf4536949282e62cc4b450628"
    sha256 cellar: :any_skip_relocation, big_sur:       "cee95665d851e0c65b2d4d4800aeb4f2853f84b55ce104be92ece6269ece9c60"
    sha256 cellar: :any_skip_relocation, catalina:      "56c0bce967feb4e82ab4a46256b9eb9ca0e5668bcaa48722299b0731c204144b"
    sha256 cellar: :any_skip_relocation, mojave:        "b92bff029f9e87f23da0b9be57e97582afb041977152023c01b08560334e0233"
  end

  depends_on "python@3.9"

  def install
    virtualenv_install_with_resources
    man1.install_symlink libexec/"share/man/man1/youtube-dl.1" => "youtube-dl.1"
    bash_completion.install libexec/"etc/bash_completion.d/youtube-dl.bash-completion"
    fish_completion.install libexec/"etc/fish/completions/youtube-dl.fish"
  end

  test do
    # commit history of homebrew-core repo
    system "#{bin}/youtube-dl", "--simulate", "https://www.youtube.com/watch?v=pOtd1cbOP7k"
    # homebrew playlist
    system "#{bin}/youtube-dl", "--simulate", "--yes-playlist", "https://www.youtube.com/watch?v=pOtd1cbOP7k&list=PLMsZ739TZDoLj9u_nob8jBKSC-mZb0Nhj"
  end
end
