class BrewPip < Formula
  desc "Install pip packages as homebrew formulae"
  homepage "https://github.com/hanxue/brew-pip"
  url "https://github.com/hanxue/brew-pip/archive/0.4.1.tar.gz"
  sha256 "9049a6db97188560404d8ecad2a7ade72a4be4338d5241097d3e3e8e215cda28"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/brew-pip"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "570853f4c40bc429d1cc89e06ea954547557b93dc96b87086403981fb05b6981"
  end

  # Repository is not maintained in 9+ years
  deprecate! date: "2022-04-16", because: :unmaintained

  def install
    bin.install "bin/brew-pip"
  end

  test do
    system "#{bin}/brew-pip", "help"
  end
end
