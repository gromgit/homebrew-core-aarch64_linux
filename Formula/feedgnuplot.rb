class Feedgnuplot < Formula
  desc "Tool to plot realtime and stored data from the command-line"
  homepage "https://github.com/dkogan/feedgnuplot"
  url "https://github.com/dkogan/feedgnuplot/archive/v1.56.tar.gz"
  sha256 "93943aee58f124cc21f70267fcfba48ec70a8dc112ddcba075afe074b51270bc"
  license any_of: ["GPL-1.0-or-later", "Artistic-1.0"]

  bottle do
    sha256 cellar: :any_skip_relocation, catalina:    "7d394a581a614dcc5130eac02310e58f994067b94a8dbd413c983157e3d37cc2"
    sha256 cellar: :any_skip_relocation, mojave:      "76988d6017ae6c60402ef6eb02046e4a73fbc67e64ac8f55442a661dd1689832"
    sha256 cellar: :any_skip_relocation, high_sierra: "55c59a68946e0979048dc4ef95f8746053d4b9e8c5f0d1709f781a69708051a8"
  end

  depends_on "gnuplot"

  def install
    system "perl", "Makefile.PL", "prefix=#{prefix}"
    system "make"
    system "make", "install"
    prefix.install Dir[prefix/"local/*"]

    bash_completion.install "completions/bash/feedgnuplot"
    zsh_completion.install "completions/zsh/_feedgnuplot"
  end

  test do
    pipe_output("#{bin}/feedgnuplot --terminal 'dumb 80,20' --exit", "seq 5", 0)
  end
end
