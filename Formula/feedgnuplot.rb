class Feedgnuplot < Formula
  desc "Tool to plot realtime and stored data from the command-line"
  homepage "https://github.com/dkogan/feedgnuplot"
  url "https://github.com/dkogan/feedgnuplot/archive/v1.54.tar.gz"
  sha256 "5549e97d53a813e87938d73339df0dc858072ae5dff388541428741c9becb512"

  bottle do
    cellar :any_skip_relocation
    sha256 "d8c2ef5f61e56fb69ae6c52517d89854997d410966e9d926e24e6d4c08d119da" => :catalina
    sha256 "eb7c2f3bb715c28eb1430bdc73d1ab29bfc806bc44809b4b3e94449aa4e4c403" => :mojave
    sha256 "0f980cf28bb61fd225c365d898d127e445abcf7da6d383f4f5b7b7e2b04c4eaa" => :high_sierra
  end

  depends_on "gnuplot"

  def install
    system "perl", "Makefile.PL", "prefix=#{prefix}"
    system "make"
    system "make", "install"

    bash_completion.install "completions/bash/feedgnuplot"
    zsh_completion.install "completions/zsh/_feedgnuplot"
  end

  test do
    pipe_output("#{bin}/feedgnuplot --terminal 'dumb 80,20' --exit", "seq 5", 0)
  end
end
