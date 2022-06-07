class Id3ed < Formula
  desc "ID3 tag editor for MP3 files"
  homepage "http://code.fluffytapeworm.com/projects/id3ed"
  url "http://code.fluffytapeworm.com/projects/id3ed/id3ed-1.10.4.tar.gz"
  sha256 "56f26dfde7b6357c5ad22644c2a379f25fce82a200264b5d4ce62f2468d8431b"
  license "GPL-2.0"

  livecheck do
    url :homepage
    regex(/href=.*?id3ed[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/id3ed"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "f531244701ac3cd3646e20fe8422e26060cc99adb1d2ccd9528084b5c57eb0b1"
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--bindir=#{bin}/",
                          "--mandir=#{man1}"
    bin.mkpath
    man1.mkpath
    system "make", "install"
  end

  test do
    system "#{bin}/id3ed", "-r", "-q", test_fixtures("test.mp3")
  end
end
