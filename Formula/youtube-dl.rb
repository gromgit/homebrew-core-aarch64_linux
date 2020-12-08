class YoutubeDl < Formula
  include Language::Python::Virtualenv

  desc "Download YouTube videos from the command-line"
  homepage "https://youtube-dl.org/"
  url "https://files.pythonhosted.org/packages/d6/d6/00f3930667ed2de44d2654ce0c40335d0d825907e9037502ca87f451e0bf/youtube_dl-2020.12.9.tar.gz"
  sha256 "cf32d3e106a63d1519c54a2c39aae449031dd1e18a5a443786c2feb5ab842e6b"
  license "Unlicense"

  bottle do
    cellar :any_skip_relocation
    sha256 "173c01333ebce5a7e1b8f085e2669ab11f03e907c5e3c5d9bab7375597c6fc73" => :big_sur
    sha256 "f14ac8f82a687cc3b975b78e71d98b2c550d78a104dfd893d9b537a8f0551c03" => :catalina
    sha256 "102acd46312e05a0f9db002680470c47353815425550567f82c01814c56892f6" => :mojave
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
