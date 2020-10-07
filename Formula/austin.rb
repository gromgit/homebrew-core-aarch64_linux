class Austin < Formula
  desc "Python frame stack sampler for CPython"
  homepage "https://github.com/P403n1x87/austin"
  url "https://github.com/P403n1x87/austin/archive/v1.0.1.tar.gz"
  sha256 "f86804f777f2f466ddede5d530d3ca67582b2a1467d000662d81272d6e9c5639"
  license "GPL-3.0"
  revision 1
  head "https://github.com/P403n1x87/austin.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "cbf21f93a97f0f3e56c63b76f610a6294395c3a37d760b2da643f66f20c85b11" => :catalina
    sha256 "0387ff648979fee932f28c6c6def6806eb579520b93f0e4e24e8f0385a231131" => :mojave
    sha256 "25572af19bbac744c2603efa8e8b82ba220e34a3866d4907b7823ac31857beae" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "python@3.9" => :test

  def install
    system "autoreconf", "--install"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
    man1.install "debian/austin.1"
  end

  test do
    shell_output("#{bin}/austin #{Formula["python@3.9"].opt_bin}/python3 -c \"print('Test')\"", 33)
  end
end
