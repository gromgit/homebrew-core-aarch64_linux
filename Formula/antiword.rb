class Antiword < Formula
  desc "Utility to read Word (.doc) files"
  homepage "http://www.winfield.demon.nl/"
  url "http://www.winfield.demon.nl/linux/antiword-0.37.tar.gz"
  mirror "https://fossies.org/linux/misc/old/antiword-0.37.tar.gz"
  sha256 "8e2c000fcbc6d641b0e6ff95e13c846da3ff31097801e86702124a206888f5ac"

  livecheck do
    url "http://www.winfield.demon.nl/linux/"
    regex(/href=.*?antiword[._-]v?(\d+(?:\.\d+)+)\.t[a-z]+(?:\.[a-z]+)?["' >]/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/antiword"
    sha256 aarch64_linux: "3f66b127c179c9f8614b8e05b587c9097f26896cc7b2722936516747048f2e74"
  end

  resource "testdoc.doc" do
    url "https://github.com/rsdoiel/antiword/raw/fe4b579067122a2d9d62647efb1ee7cfe3ca92bb/Docs/testdoc.doc"
    sha256 "4ea5fe94a8ff9d8cd1e21a5e233efb681f2026de48ab1ac2cbaabdb953ca25ac"
  end

  def install
    inreplace "antiword.h", "/usr/share/antiword", pkgshare

    system "make", "CC=#{ENV.cc}",
                   "LD=#{ENV.cc}",
                   "CFLAGS=#{ENV.cflags} -DNDEBUG",
                   "GLOBAL_INSTALL_DIR=#{bin}",
                   "GLOBAL_RESOURCES_DIR=#{pkgshare}"
    bin.install "antiword"
    pkgshare.install Dir["Resources/*"]
    man1.install "Docs/antiword.1"
  end

  def caveats
    <<~EOS
      You can install mapping files in ~/.antiword
    EOS
  end

  test do
    resource("testdoc.doc").stage do
      assert_match <<~EOS, shell_output("#{bin}/antiword testdoc.doc")
        This is just a small test document.


        This is just a small document to see if Antiword has been compiled
        correctly.
        The images will only show in the PostScript mode.

        [pic]

        Figure 1

        This JPEG image is the Antiword icon.

        [pic]

        Figure 2
      EOS
    end
  end
end
