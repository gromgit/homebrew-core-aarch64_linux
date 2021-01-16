class YoutubeDl < Formula
  include Language::Python::Virtualenv

  desc "Download YouTube videos from the command-line"
  homepage "https://youtube-dl.org/"
  url "https://files.pythonhosted.org/packages/3a/20/9e710f4b791157a0ce55b032a8f61fc357b0c47d237028095565de030879/youtube_dl-2021.1.16.tar.gz"
  sha256 "acf74701a31b6c3d06f9d4245a46ba8fb6c378931681177412043c6e8276fee7"
  license "Unlicense"

  bottle do
    cellar :any_skip_relocation
    sha256 "03ae8eaf8b3d6d97921e0e178a5456863d691b12cbe3c0bd136eb55405320a60" => :big_sur
    sha256 "372131c4f425596f3322d207fe2756337c502736c965bf37e5a5a3613130ab41" => :arm64_big_sur
    sha256 "61a8966c6349844c7d1b32678ad29dbecb300068476afe0f3a42b1aa6992be8f" => :catalina
    sha256 "feb60565425144139811737ff841ec64bcc6b5661e5b0ee13cb9ce6c41a3ea9b" => :mojave
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
