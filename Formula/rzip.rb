class Rzip < Formula
  desc "File compression tool (like gzip or bzip2)"
  homepage "https://rzip.samba.org/"
  url "https://rzip.samba.org/ftp/rzip/rzip-2.1.tar.gz"
  sha256 "4bb96f4d58ccf16749ed3f836957ce97dbcff3e3ee5fd50266229a48f89815b7"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://rzip.samba.org/ftp/rzip/"
    regex(/href=.*?rzip[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/rzip"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "682fb96af1ca8f101a8cb614049f520d488892084f765dcbcca3f61d8957899b"
  end

  uses_from_macos "bzip2"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"

    system "make", "install", "INSTALL_MAN=#{man}"

    bin.install_symlink "rzip" => "runzip"
    man1.install_symlink "rzip.1" => "runzip.1"
  end

  test do
    path = testpath/"data.txt"
    original_contents = "." * 1000
    path.write original_contents

    # compress: data.txt -> data.txt.rz
    system bin/"rzip", path
    refute_predicate path, :exist?

    # decompress: data.txt.rz -> data.txt
    system bin/"rzip", "-d", "#{path}.rz"
    assert_equal original_contents, path.read
  end
end
