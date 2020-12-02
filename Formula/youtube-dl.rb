class YoutubeDl < Formula
  include Language::Python::Virtualenv

  desc "Download YouTube videos from the command-line"
  homepage "https://youtube-dl.org/"
  url "https://files.pythonhosted.org/packages/fa/3c/f05e5649c81bcc5796ba913a5654a0305bc3a89982727b6fed295baddc2c/youtube_dl-2020.12.2.tar.gz"
  sha256 "bc82acb0b59b25b822fad85bef0cbe78e5754ca532e3bd6899fe06386e2b8e7c"
  license "Unlicense"

  bottle do
    cellar :any_skip_relocation
    sha256 "80cb5e1fbd2eab25218d5e0553846a8a546a7d720ebcf266fce1f1fe35dca7c0" => :big_sur
    sha256 "85fda57614d3729b1bf746ea4241b8e1d5461ac71edda102c8ef60ce437213ae" => :catalina
    sha256 "d15b8ddfb9a0e3ed0ea65fa6a348865bf8fcb6f014996d00d10f1077c1d90dc3" => :mojave
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
