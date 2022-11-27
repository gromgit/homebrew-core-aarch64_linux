class Bcpp < Formula
  desc "C(++) beautifier"
  homepage "https://invisible-island.net/bcpp/"
  url "https://invisible-mirror.net/archives/bcpp/bcpp-20210108.tgz"
  sha256 "567ca0e803bfd57c41686f3b1a7df4ee4cec3c2d57ad4f8e5cda247fc5735269"
  license "MIT"

  livecheck do
    url "https://invisible-island.net/bcpp/CHANGES.html"
    regex(/id=.*?t(\d{6,8})["' >]/im)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/bcpp"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "17c4494a162b3c1aa53d7aaeb53c62d07b5b3b40d10cd2f91a907910186fcd15"
  end

  # Build succeeds with system gcc (5.4.0) but seems to segfault at runtime.
  # Unclear whether this is an issue with the compiler itself or the libc++ runtime.
  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5"

  def install
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make", "install"
    etc.install "bcpp.cfg"
  end

  test do
    (testpath/"test.txt").write <<~EOS
          test
             test
      test
            test
    EOS
    system bin/"bcpp", "test.txt", "-fnc", "#{etc}/bcpp.cfg"
    assert_predicate testpath/"test.txt.orig", :exist?
    assert_predicate testpath/"test.txt", :exist?
  end
end
