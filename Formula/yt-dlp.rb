class YtDlp < Formula
  desc "Fork of youtube-dl with additional features and fixes"
  homepage "https://github.com/yt-dlp/yt-dlp"
  url "https://github.com/yt-dlp/yt-dlp/archive/2021.08.10.tar.gz"
  sha256 "d847e32bc18767be2f27183f5da2ba05d0142e194e95ac6b3e69494353ee366b"
  license "Unlicense"
  head "https://github.com/yt-dlp/yt-dlp.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/v?(\d+(?:[.-]\d+)+)["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "96d6684e34d20fa121b4bad4c0706f024bb1a406ece55db3a188e0e4bd8f08c5"
    sha256 cellar: :any_skip_relocation, big_sur:       "3d5e6d8606ec77e6c992a986ed964a1d8a5b45464d59bbf2d99d7130afba3c76"
    sha256 cellar: :any_skip_relocation, catalina:      "3d5e6d8606ec77e6c992a986ed964a1d8a5b45464d59bbf2d99d7130afba3c76"
    sha256 cellar: :any_skip_relocation, mojave:        "3d5e6d8606ec77e6c992a986ed964a1d8a5b45464d59bbf2d99d7130afba3c76"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1b6e65096ceac3c5270ad48b2e5f8381317dbbbe687052f1003b55d927fc6454"
  end

  depends_on "pandoc" => :build
  depends_on "python@3.9"
  uses_from_macos "zip" => :build

  def install
    system "make </dev/null"
    bin.install "yt-dlp"
    bash_completion.install "completions/bash/yt-dlp"
    zsh_completion.install "completions/zsh/_yt-dlp"
    fish_completion.install "completions/fish/yt-dlp.fish"
    man1.install "yt-dlp.1"
  end

  test do
    # "History of homebrew-core", uploaded 3 Feb 2020
    system "#{bin}/yt-dlp", "--simulate", "https://www.youtube.com/watch?v=pOtd1cbOP7k"
    # "homebrew", playlist last updated 3 Mar 2020
    system "#{bin}/yt-dlp", "--simulate", "--yes-playlist", "https://www.youtube.com/watch?v=pOtd1cbOP7k&list=PLMsZ739TZDoLj9u_nob8jBKSC-mZb0Nhj"
  end
end
