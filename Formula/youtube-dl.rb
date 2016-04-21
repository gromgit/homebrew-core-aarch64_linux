# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  desc "Download YouTube videos from the command-line"
  homepage "https://rg3.github.io/youtube-dl/"
  url "https://yt-dl.org/downloads/2016.04.19/youtube-dl-2016.04.19.tar.gz"
  sha256 "09ba62900703a1439659a5394d802c7b03fd3a7b35d604e94a256ae9ccd1b6a0"

  bottle do
    cellar :any_skip_relocation
    sha256 "4d8ee1e90051ccebbacc11f6ce80655f0db9e8512837ca249be7da93225ec84b" => :el_capitan
    sha256 "053e5cf31dd4be6eff52065cbc2e1d2e01fd6d44822c5abe01cbe6a14ba80389" => :yosemite
    sha256 "8acf00eab26e915c206591dd3abe160864bea06d96ef116db43b9bdc54a720b1" => :mavericks
  end

  head do
    url "https://github.com/rg3/youtube-dl.git"
    depends_on "pandoc" => :build
  end

  depends_on "rtmpdump" => :optional

  def install
    system "make", "PREFIX=#{prefix}"
    bin.install "youtube-dl"
    man1.install "youtube-dl.1"
    bash_completion.install "youtube-dl.bash-completion"
    zsh_completion.install "youtube-dl.zsh" => "_youtube-dl"
    fish_completion.install "youtube-dl.fish"
  end

  def caveats
    "To use post-processing options, `brew install ffmpeg` or `brew install libav`."
  end

  test do
    system "#{bin}/youtube-dl", "--simulate", "https://www.youtube.com/watch?v=he2a4xK8ctk"
    system "#{bin}/youtube-dl", "--simulate", "--yes-playlist", "https://www.youtube.com/watch?v=AEhULv4ruL4&list=PLZdCLR02grLrl5ie970A24kvti21hGiOf"
  end
end
