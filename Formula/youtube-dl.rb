class YoutubeDl < Formula
  include Language::Python::Virtualenv

  desc "Download YouTube videos from the command-line"
  homepage "https://youtube-dl.org/"
  url "https://files.pythonhosted.org/packages/67/23/7dc9d78f9a30c0d033793aea2acfb6a4eab91932deb22baff95e3dc5c54d/youtube_dl-2021.3.2.tar.gz"
  sha256 "aeeec98827bfb1d3b53fab81ffd39ab3ea79bdbb2e5892244dcc190a99cfaf23"
  license "Unlicense"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "97cd96db16196a5e96c074812691b0201c5516ae28de05833072b4f3c41f6a56"
    sha256 cellar: :any_skip_relocation, big_sur:       "94f975d584df72685a90a0bffa3fc5a7760acd8c33ca88a030f85b60f43d308b"
    sha256 cellar: :any_skip_relocation, catalina:      "86e0556df6ded2cab2e0fa74b2ac9236eb275d1bb5acdb41a9f7eaedcb2b8585"
    sha256 cellar: :any_skip_relocation, mojave:        "b5da2505f3fe4df4d1aadb033b740f1982f37f06acb41128c3398ad9b628a19c"
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
