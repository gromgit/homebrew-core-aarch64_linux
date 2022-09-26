class Flickcurl < Formula
  desc "Library for the Flickr API"
  homepage "https://librdf.org/flickcurl/"
  url "https://download.dajobe.org/flickcurl/flickcurl-1.26.tar.gz"
  sha256 "ff42a36c7c1c7d368246f6bc9b7d792ed298348e5f0f5d432e49f6803562f5a3"
  license any_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]

  livecheck do
    url :homepage
    regex(/href=.*?flickcurl[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/flickcurl"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "9b9afc78cffbd946c43a40957f59e0fa5f06b3dfd424df9925681688539658a7"
  end

  depends_on "pkg-config" => :build

  uses_from_macos "curl"
  uses_from_macos "libxml2"

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-pre-0.4.2.418-big_sur.diff"
    sha256 "83af02f2aa2b746bb7225872cab29a253264be49db0ecebb12f841562d9a2923"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/flickcurl -h 2>&1", 1)
    assert_match "flickcurl: Configuration file", output
  end
end
