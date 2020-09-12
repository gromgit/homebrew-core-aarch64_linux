class Rcm < Formula
  desc "RC file (dotfile) management"
  homepage "https://thoughtbot.github.io/rcm/rcm.7.html"
  url "https://thoughtbot.github.io/rcm/dist/rcm-1.3.4.tar.gz"
  sha256 "9b11ae37449cf4d234ec6d1348479bfed3253daba11f7e9e774059865b66c24a"
  license "BSD-3-Clause"

  bottle do
    cellar :any_skip_relocation
    sha256 "3fdc7266d9faa6015ef560254f036cc355445ee12861cb17a1c0bf5cc218b368" => :catalina
    sha256 "3fdc7266d9faa6015ef560254f036cc355445ee12861cb17a1c0bf5cc218b368" => :mojave
    sha256 "3fdc7266d9faa6015ef560254f036cc355445ee12861cb17a1c0bf5cc218b368" => :high_sierra
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/".gitconfig").write <<~EOS
      [user]
      	name = Test User
      	email = test@test.com
    EOS
    assert_match /[Moving|Linking].../x, shell_output("#{bin}/mkrc -v ~/.gitconfig")
  end
end
