class Visitors < Formula
  desc "Web server log analyzer"
  homepage "http://www.hping.org/visitors/"
  url "http://www.hping.org/visitors/visitors-0.7.tar.gz"
  sha256 "d2149e33ffe96b1f52b0587cff65973b0bc0b24ec43cdf072a782c1bd52148ab"

  livecheck do
    url :homepage
    regex(/href=.*?visitors[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/visitors"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "9e0eb1e07dcdcafd32eb70c60a6dfc320b03fd414b9549988c76753bd63feb61"
  end

  def install
    system "make"

    # There is no "make install", so do it manually
    bin.install "visitors"
    man1.install "visitors.1"
  end

  test do
    IO.popen("#{bin}/visitors - -o text 2>&1", "w+") do |pipe|
      pipe.puts 'a:80 1.2.3.4 - - [01/Apr/2014:14:28:00 -0400] "GET /1 HTTP/1.1" 200 9 - -'
      pipe.puts 'a:80 1.2.3.4 - - [01/Apr/2014:14:28:01 -0400] "GET /2 HTTP/1.1" 200 9 - -'
      pipe.close_write
      assert_match(/Different pages requested: 2/, pipe.read)
    end
  end
end
