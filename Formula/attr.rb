class Attr < Formula
  desc "Manipulate filesystem extended attributes"
  homepage "https://savannah.nongnu.org/projects/attr"
  url "https://download.savannah.nongnu.org/releases/attr/attr-2.5.1.tar.gz"
  mirror "https://mirror.csclub.uwaterloo.ca/nongnu/attr/attr-2.5.1.tar.gz"
  sha256 "bae1c6949b258a0d68001367ce0c741cebdacdd3b62965d17e5eb23cd78adaf8"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://download.savannah.nongnu.org/releases/attr/"
    regex(/href=.*?attr[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/attr"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "9c4f7b816ca3233c8494889514d397fe79f008bc345d7c52fa306cee0ee14778"
  end

  depends_on "gettext" => :build
  depends_on :linux

  def install
    system "./configure",
           "--disable-debug",
           "--disable-dependency-tracking",
           "--disable-silent-rules",
           "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.txt").write("Hello World!\n")
    system bin/"attr", "-s", "name", "test.txt"
    assert_match 'Attribute "name" has a 0 byte value for test.txt',
                 shell_output(bin/"attr -l test.txt")
  end
end
