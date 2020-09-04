class Oil < Formula
  desc "Bash-compatible Unix shell with more consistent syntax and semantics"
  homepage "https://www.oilshell.org/"
  url "https://www.oilshell.org/download/oil-0.8.0.tar.gz"
  sha256 "0ca934741aea5a86dceeb5febd61563f7d7fbd49f0c55dc0fdf6e71b8c87a590"
  license "Apache-2.0"
  head "https://github.com/oilshell/oil.git"

  bottle do
    sha256 "abcca1e8d09418c37353e4e3dd4d402ef0b88ae5a62145505a8f0a1013ebab98" => :catalina
    sha256 "1092e415a1068d6ec386bb35d2db622f99b9ad494170dc8a481b21fc994dd6da" => :mojave
    sha256 "5d4a42d6a676077d188149e33b9faf4c31dfd36f06cbe3496839b9b6e5928344" => :high_sierra
  end

  def install
    # Disable hardcoded HAVE_EPOLL, unsupported in macOS
    inreplace "Python-2.7.13/pyconfig.h", /^(#define HAVE_EPOLL .*)$/, '/* \1 */'
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "./install"
  end

  test do
    assert_equal pipe_output("#{bin}/osh -c 'pwd'").strip, testpath.to_s
  end
end
