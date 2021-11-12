class Bibutils < Formula
  desc "Bibliography conversion utilities"
  homepage "https://sourceforge.net/p/bibutils/home/Bibutils/"
  url "https://downloads.sourceforge.net/project/bibutils/bibutils_7.2_src.tgz"
  sha256 "6e028aef1e8a6b3e5acef098584a7bb68708f35cfe74011b341c11fea5e4b5c3"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(%r{url=.*?/bibutils[._-]v?(\d+(?:\.\d+)+)[._-]src\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ac5a87386eb76043970aa522dd774abf6f60d807646f361a8039c64e1dc5472b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fe797d92065d5b0ef0f16511bfea5ba2567d2f877038109cb5e30f0d796a0f57"
    sha256 cellar: :any_skip_relocation, monterey:       "dab6027f372c7969b4860d6e6a8d85bafbfe5953f773f2e7185cba6db3f0dc0c"
    sha256 cellar: :any_skip_relocation, big_sur:        "a8989477b91d3423deea04a5833b83cea7eee836ad197dfb30db9ce9599788b2"
    sha256 cellar: :any_skip_relocation, catalina:       "4f3cd7ce2f12a53e6afd35f92990968e6463a674dc4082315709c295e4869bb6"
    sha256 cellar: :any_skip_relocation, mojave:         "866724d8735e42aa3c62cb4b47e8be77bb41490d23ca2d83f0096ee2b9b4e5fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bf0f79873c4ce317aed31c0c1516552e937ccddc191f951d3acf8cc3f2e9ca06"
  end

  def install
    system "./configure", "--install-dir", bin,
                          "--install-lib", lib
    system "make", "install", "CC=#{ENV.cc}"
  end

  test do
    (testpath/"test.bib").write <<~EOS
      @article{Homebrew,
          title   = {Something},
          author  = {Someone},
          journal = {Something},
          volume  = {1},
          number  = {2},
          pages   = {3--4}
      }
    EOS

    system "#{bin}/bib2xml", "test.bib"
  end
end
