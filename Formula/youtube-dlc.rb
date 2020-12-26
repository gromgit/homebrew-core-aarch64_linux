class YoutubeDlc < Formula
  desc "Media downloader supporting various sites such as youtube"
  homepage "https://github.com/blackjack4494/yt-dlc"
  url "https://github.com/blackjack4494/yt-dlc/archive/2020.11.11-3.tar.gz"
  version "2020.11.11-3"
  sha256 "649f8ba9a6916ca45db0b81fbcec3485e79895cec0f29fd25ec33520ffffca84"
  license "Unlicense"
  head "https://github.com/blackjack4494/yt-dlc.git"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/v?(\d+(?:[.-]\d+)+)["' >]}i)
  end

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "4cc5bc35a4e0b9458af5f8497683ce532f8ff5051dcc23745983fc233264c548" => :big_sur
    sha256 "541fbc8f509ca8b5acc301a00cc2bdde8cb73d1c1d25e7d99bd96ac833013ded" => :catalina
    sha256 "4d24ae860520ce11d92db35174864a68cecfc66cf90e19baef498c734d0eab69" => :mojave
  end

  depends_on "make" => :build
  depends_on "pandoc" => :build
  depends_on "python@3.9"
  uses_from_macos "zip" => :build

  def install
    system "make"
    bin.install "youtube-dlc"
    bash_completion.install "youtube-dlc.bash-completion"
    zsh_completion.install "youtube-dlc.zsh"
    fish_completion.install "youtube-dlc.fish"
    man1.install "youtube-dlc.1"
  end

  test do
    # "History of homebrew-core", uploaded 3 Feb 2020
    system "#{bin}/youtube-dlc", "--simulate", "https://www.youtube.com/watch?v=pOtd1cbOP7k"
    # "homebrew", playlist last updated 3 Mar 2020
    system "#{bin}/youtube-dlc", "--simulate", "--yes-playlist", "https://www.youtube.com/watch?v=pOtd1cbOP7k&list=PLMsZ739TZDoLj9u_nob8jBKSC-mZb0Nhj"
  end
end
