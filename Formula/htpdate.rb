class Htpdate < Formula
  desc "Synchronize time with remote web servers"
  homepage "https://www.vervest.org/htp/"
  url "https://www.vervest.org/htp/archive/c/htpdate-1.3.6.tar.gz"
  sha256 "3cdc558ec8e53ef374a42490b2f28c0b23981fa8754a6d7182044707828ad1e9"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.vervest.org/htp/?download"
    regex(/href=.*?htpdate[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f8698ebff4aab4a1bce12d6be9e0b64571b44d79751234ad47248a2f4fbca1c0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0de31a6a832cdfbb7b00039c1e31ffdf08fe87ec32c54c2d373720df70b2502a"
    sha256 cellar: :any_skip_relocation, monterey:       "4a1be18748515c708c1ac475b7f7eedd6724ff0729591fb2ab08c068e2f95ed0"
    sha256 cellar: :any_skip_relocation, big_sur:        "cb280f68392cf50ba163dafb87892b22d30529258bb0311ec39516065b204089"
    sha256 cellar: :any_skip_relocation, catalina:       "84ca480eed1c72b68b753be67a9f9e8e25fb5f2773eef70d2ce228b23d11d035"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c8363433943226e0e605ee3cf5ea0690c3aa50e6203a17a202cbfc58babd1e20"
  end

  def install
    system "make", "prefix=#{prefix}",
                   "STRIP=/usr/bin/strip",
                   "CC=#{ENV.cc}",
                   "CFLAGS=#{ENV.cflags}",
                   "install"
  end

  test do
    system "#{sbin}/htpdate", "-q", "-d", "-u", ENV["USER"], "example.org"
  end
end
